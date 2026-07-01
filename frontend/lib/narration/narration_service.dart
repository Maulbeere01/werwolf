import 'dart:async';
import 'dart:collection';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:werwolf/auth/auth_state.dart';
import 'package:werwolf/controllers/game_stream_controller.dart';
import 'package:werwolf/generated/werwolf.pb.dart';
import 'package:werwolf/narration/audio_session.dart';
import 'package:werwolf/narration/background_music.dart';
import 'package:werwolf/narration/narration_cues.dart';
import 'package:werwolf/narration/narration_mute.dart';
import 'package:werwolf/narration/narration_resolver.dart';

/// Silence inserted before a roles wakeup so players can react between
const Duration kEventGap = Duration(seconds: 5);

/// Shorter pause before lines that play while everyone is awake
const Duration kDayEventGap = Duration(seconds: 1);

/// Longer pause between the intro story (intro1) and its "go to sleep" outro
const Duration kIntroCardGap = Duration(seconds: 50);

/// Extra breathing room afgter the intro outro (intro2) and before the first role
const Duration kAfterIntroGap = Duration(seconds: 5);

/// Extra lead silence before the narration that follows a day-vote LYNCH. A tie
/// has the villageTied line to cover the ~6s vote-result reveal screen, but a real
/// lynch has no voice line in the script, so without this the next transition line
/// (schlafen for the coming night, or the win line at game end) would play over
/// that reveal screen. Stacks on the line's normal day gap (kDayEventGap).
const Duration kVoteRevealHold = Duration(seconds: 5);

/// How long into a roles wake-up line its action UI appears
const Duration kActionRevealDelay = Duration(seconds: 6);

/// A queued line plus the silence to hold before playing it
class _QueuedLine {
  const _QueuedLine(this.line, this.gapBefore);
  final VoiceLine line;
  final Duration gapBefore;
}

/// Plays the game's voice lines, fed by whichever screen's game stream is
/// currently active.
///
/// It is a singleton with its own [AudioPlayer] so a single voice runs across
/// screen changes (Intro -> Night -> Day) without overlapping players, and its
/// dedup state (last narrated phase / announcement) carries over too: the next
/// screen seeds its stream with the same snapshot, which is then recognised as
/// "already narrated" instead of replayed.
///
/// Screens call [attach] in initState and [detach] in dispose. Output is gated
/// by [NarrationMute]: a muted device still advances through the queue (so
/// unmuting mid-game never replays a backlog) but emits no sound
class NarrationService {
  NarrationService._() {
    // react to the mute toggle: silence music + cut any line in progress on
    // mute, restore on unmute
    NarrationMute.instance.muted.addListener(_onMuteChanged);
  }
  static final NarrationService instance = NarrationService._();

  // Built lazily: constructing an AudioPlayer fires a native create() call, so
  // off mobile (where audio is disabled) no player is ever created. Only reached
  // after the AudioSession.disabled check / from inside AudioSession.run.
  AudioPlayer? _playerInstance;
  AudioPlayer get _player {
    final existing = _playerInstance;
    if (existing != null) return existing;
    final created = AudioPlayer();
    // Mix with the background music instead of grabbing audio focus (which would
    // pause the music on every line)
    unawaited(AudioSession.run(() => created.setAudioContext(kMixAudioContext)));
    created.onPlayerComplete.listen((_) => _playNext());
    return _playerInstance = created;
  }

  final Queue<_QueuedLine> _queue = Queue<_QueuedLine>();

  GameStreamController? _stream;

  // dedup state, deliberately persisted across attach/detach for the whole game
  Phase _lastPhase = Phase.PHASE_UNSPECIFIED;
  String? _lastAnnouncementSig;
  bool _gameEndNarrated = false;
  bool _hostResolved = false;

  // Set once the game reaches GAME_END. Keeps the background music (and any queued
  // win line) running through the end screen even after the last game screen
  // detaches, instead of stopping it the moment the stream goes away. It is only
  // torn down explicitly when the player leaves the end screen (reset()).
  bool _gameEnding = false;

  // Bumped by reset() so a _playNext that is currently waiting out a gap aborts
  // instead of starting the next line after the player has left the game.
  int _generation = 0;

  /// The night action phase whose wake-up line is currently being narrated.
  /// Screens watch this to reveal a role's action UI in sync with its voice line
  /// (when it actually plays) rather than the instant the backend changes phase.
  /// Stays PHASE_UNSPECIFIED until the first role wakes. See night_start.dart.
  final ValueNotifier<Phase> narratedActionPhase =
      ValueNotifier<Phase>(Phase.PHASE_UNSPECIFIED);

  /// Listen to the given stream, taking over from any previous one. Picks up the
  /// stream's current snapshot immediately so a freshly attached screen narrates
  /// anything new in its seed.
  void attach(GameStreamController stream) {
    if (identical(_stream, stream)) return;
    _stream?.removeListener(_onUpdate);
    _stream = stream;
    stream.addListener(_onUpdate);
    _onUpdate();
    _syncMusic();
  }

  /// Stop listening to [stream], unless we have already moved on to a newer one
  /// (attach detaches the previous stream itself). Leaving the game this way
  /// stops the background music.
  void detach(GameStreamController stream) {
    if (!identical(_stream, stream)) return;
    stream.removeListener(_onUpdate);
    _stream = null;
    _syncMusic();
  }

  /// Hard stop when the player quits the lobby: silence whatever line is playing,
  /// drop the entire queue and the music, and clear the dedup/action state so a
  /// later game starts clean. Unlike [detach] (which only stops listening and
  /// keeps the queue draining), this halts audio immediately, so a line in
  /// progress or already queued from a late update can't keep narrating after the
  /// player has left. Bumping [_generation] aborts any _playNext mid-gap.
  void reset() {
    _generation++;
    _stream?.removeListener(_onUpdate);
    _stream = null;
    _queue.clear();
    if (_playerInstance != null) {
      AudioSession.run(() => _playerInstance!.stop());
    }
    BackgroundMusic.instance.stop();
    narratedActionPhase.value = Phase.PHASE_UNSPECIFIED;
    _lastPhase = Phase.PHASE_UNSPECIFIED;
    _lastAnnouncementSig = null;
    _gameEndNarrated = false;
    _gameEnding = false;
    _hostResolved = false;
  }

  // Muting only changes the voice player's VOLUME; it never clears the queue or
  // skips lines. That keeps every device playing the same lines at the same time,
  // so unmuting reveals whatever is currently playing, in sync with the others.
  void _onMuteChanged() {
    final muted = NarrationMute.instance.muted.value;
    AudioSession.run(() => _player.setVolume(muted ? 0 : 1));
    _syncMusic();
  }

  // Background music only plays while we are in a game (a stream is attached) AND
  // this device is unmuted, so a table of phones doesn't all blast the loop:
  // only the host (unmuted by default) hears it. Muting just silences the loop
  // (volume 0); the player is stopped only when leaving the game.
  void _syncMusic() {
    // Once the game is over we deliberately keep the loop playing under the end
    // screen even though no stream is attached anymore; it is stopped in reset()
    // when the player finally leaves. Otherwise no stream means we left the game.
    if (_stream == null && !_gameEnding) {
      BackgroundMusic.instance.stop();
      return;
    }
    final muted = NarrationMute.instance.muted.value;
    BackgroundMusic.instance.setMuted(muted);
    if (!muted) BackgroundMusic.instance.start();
  }

  /// Narrate the intro explicitly. The Intro screen drives this (rather than the
  /// phase resolver) because the player reveals their card between the two
  /// halves, so the second line is held until the screen asks for it.
  void playIntro() => _enqueue(<VoiceLine>[VoiceLine.intro1]);

  void playIntroOutro() => _enqueue(<VoiceLine>[VoiceLine.intro2]);

  void _onUpdate() {
    final update = _stream?.currentUpdate;
    if (update == null) return;
    _resolveHost(update);

    final enterLines = <VoiceLine>[];
    var extraLeadGap = Duration.zero;

    if (update.currentPhase != _lastPhase) {
      // A new night is beginning: we are entering a night phase from outside the
      // night (the intro, or the day). No role is awake yet, so clear any stale
      // action cue, otherwise the first role's UI would unlock immediately when
      // its phase happens to match the cue left over from a previous night (e.g.
      // the same first role wakes again), skipping the wait for its wake-up line.
      if (isNightPhase(update.currentPhase) && !isNightPhase(_lastPhase)) {
        narratedActionPhase.value = Phase.PHASE_UNSPECIFIED;
      }
      // Leaving the intro (NIGHT_START, where intro2 played): hold a beat longer
      // before the first role's wake-up so the night doesn't start abruptly.
      if (_lastPhase == Phase.NIGHT_START) extraLeadGap = kAfterIntroGap;
      // A day vote that LYNCHED someone carries a vote-result reveal screen but no
      // voice line (unlike a tie, which has villageTied). Hold the following
      // narration so schlafen / the win line doesn't play over that reveal screen.
      if (_isRealLynch(update)) extraLeadGap = kVoteRevealHold;
      enterLines.addAll(phaseEnterLines(_lastPhase, update.currentPhase));
      _lastPhase = update.currentPhase;
    }

    final announceLines = <VoiceLine>[];
    if (update.hasAnnouncement()) {
      final sig = announcementSignature(update.announcement);
      if (sig != _lastAnnouncementSig) {
        _lastAnnouncementSig = sig;
        announceLines.addAll(announcementLines(update.announcement));
      }
    }

    // Order matters when a phase change carries an announcement (the backend
    // sends the result and the next phase in one snapshot). Almost every
    // announcement is the RESULT of the phase that just ended (the day-vote
    // outcome before nightfall, the hunter's revenge shot before the discussion)
    // and must be narrated BEFORE the cue for the new phase (schlafen + wake-up,
    // or the discussion cue). The one exception is the morning reveal (DAY_RESULT):
    // there the scene-setting lines (close eyes / day breaks) lead and only THEN
    // come the night's victims. So the transition leads only into DAY_RESULT; the
    // announcement leads everywhere else.
    final lines = <VoiceLine>[];
    final transitionLeads = update.currentPhase == Phase.DAY_RESULT;
    if (transitionLeads) {
      lines
        ..addAll(enterLines)
        ..addAll(announceLines);
    } else {
      lines
        ..addAll(announceLines)
        ..addAll(enterLines);
    }

    if (update.currentPhase == Phase.GAME_END) {
      // Keep the audio alive through the end screen (see _gameEnding / _syncMusic).
      _gameEnding = true;
      if (!_gameEndNarrated) {
        _gameEndNarrated = true;
        lines.addAll(gameEndLines(update));
      }
    }

    if (lines.isNotEmpty) _enqueue(lines, extraLeadGap: extraLeadGap);
  }

  // Whether this update carries a day-vote result where a real player was lynched
  // (as opposed to a tie / nobody). Such a result has no voice line in the script
  // but still triggers the ~6s vote-result reveal screen, so the narration that
  // follows it needs an extra lead gap (see kVoteRevealHold).
  bool _isRealLynch(GameUpdate update) {
    if (!update.hasAnnouncement()) return false;
    final a = update.announcement;
    if (!a.hasVoteResult()) return false;
    return !a.voteResult.tied && a.voteResult.eliminatedPlayerId.isNotEmpty;
  }

  // The first snapshot that carries the player list tells us who the host is, so
  // we can set this device's default mute state. Night snapshots may omit the
  // list, hence "resolve once, from whichever update has it".
  void _resolveHost(GameUpdate update) {
    if (_hostResolved) return;
    final self = AuthState.userId ?? '';
    for (final p in update.players) {
      if (p.isHost) {
        _hostResolved = true;
        NarrationMute.instance.applyHostDefault(isHost: p.id == self);
        return;
      }
    }
  }

  // [extraLeadGap] is added to the silence before the FIRST line of this batch
  // only, on top of its normal per-line gap. Used to stretch the pause after the
  // intro before the first role wakes (see kAfterIntroGap).
  void _enqueue(List<VoiceLine> lines, {Duration extraLeadGap = Duration.zero}) {
    final wasIdle = _queue.isEmpty;
    var isFirst = true;
    for (final line in lines) {
      final gap = _gapBefore(line) + (isFirst ? extraLeadGap : Duration.zero);
      _queue.add(_QueuedLine(line, gap));
      isFirst = false;
    }
    if (wasIdle) _playNext();
  }

  // How long to stay silent before a given line. Only the night role wake-ups
  // get the full kEventGap (so the previous role can close their eyes first); the
  // intro outro waits out the card-viewing pause; everything else plays with eyes
  // open and only needs a short beat (kDayEventGap).
  Duration _gapBefore(VoiceLine line) => switch (line) {
        VoiceLine.intro1 => kEventGap,
        VoiceLine.intro2 => kIntroCardGap,
        VoiceLine.cupid ||
        VoiceLine.werewolves ||
        VoiceLine.seer ||
        VoiceLine.witch ||
        VoiceLine.fox ||
        VoiceLine.saboteur =>
          kEventGap,
        _ => kDayEventGap,
      };

  Future<void> _playNext() async {
    if (_queue.isEmpty) return;

    final item = _queue.removeFirst();
    final gen = _generation; // reset() bumps this to abort us if we leave mid-line
    // If this line is a role's wake-up, it unlocks that role's action UI; the
    // value is published the moment the line STARTS (after its gap, below) so the
    // screen appears in sync with the voice. In the no-audio paths there is no
    // gap to wait, so we publish it right away to keep the UI from stalling.
    final cuePhase = actionPhaseForLine(item.line);

    // Every device plays every line so they stay in lockstep, driven by the same
    // stream events. Muting does NOT skip lines (that would desync the devices);
    // it only silences playback via the volume below. We only drain without sound
    // when the audio backend is unavailable, so a broken backend can't stall.
    if (AudioSession.disabled) {
      if (cuePhase != null) narratedActionPhase.value = cuePhase;
      scheduleMicrotask(_playNext);
      return;
    }

    final cue = cueFor(item.line);
    if (cue == null) {
      if (cuePhase != null) narratedActionPhase.value = cuePhase;
      scheduleMicrotask(_playNext);
      return;
    }

    // hold the inter-event pause, then re-check the backend in case it dropped
    if (item.gapBefore > Duration.zero) {
      await Future.delayed(item.gapBefore);
      if (AudioSession.disabled) {
        if (cuePhase != null) narratedActionPhase.value = cuePhase;
        scheduleMicrotask(_playNext);
        return;
      }
    }

    // left the game (reset) while waiting out the gap: don't start a new line
    if (gen != _generation) return;

    // Reveal this role's action UI a few seconds INTO its wake-up line, so the
    // screen appears while the narrator is mid-sentence ("die Werwölfe wachen
    // auf...") rather than before a word is spoken. Fire-and-forget: it must not
    // hold up the queue. The phase still matches when it fires (role phases far
    // outlast kActionRevealDelay), and the gate ignores it if the phase moved on.
    if (cuePhase != null) {
      Future.delayed(kActionRevealDelay, () {
        if (gen == _generation) narratedActionPhase.value = cuePhase;
      });
    }

    // Play at the current mute volume: a muted device still plays the line (so
    // onPlayerComplete advances the queue in sync with everyone else) but at
    // volume 0. play() completes when playback STARTS; onPlayerComplete then
    // advances the queue when the line finishes.
    final volume = NarrationMute.instance.muted.value ? 0.0 : 1.0;
    final ok = await AudioSession.run(
      () => _player.play(AssetSource(cue.asset), volume: volume),
    );
    if (!ok) scheduleMicrotask(_playNext);
  }
}
