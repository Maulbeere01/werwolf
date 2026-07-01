import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:werwolf/screens/day_start.dart';
import 'package:werwolf/screens/rules.dart';
import 'package:werwolf/auth/auth_state.dart';
import 'package:werwolf/controllers/game_view_controller.dart';
import 'package:werwolf/controllers/game_stream_controller.dart';
import 'package:werwolf/utils/game_assets.dart';
import 'package:werwolf/generated/werwolf.pb.dart';
import 'package:werwolf/utils/role_display.dart';
import 'package:werwolf/screens/settings_view.dart';
import 'package:werwolf/voting/witch_voting.dart';
import 'package:werwolf/voting/seer_voting.dart';
import 'package:werwolf/voting/fox_voting.dart';
import 'package:werwolf/voting/saboteur_voting.dart';
import 'package:werwolf/voting/cupid_voting.dart';
import 'package:werwolf/voting/werewolf_voting.dart';
import 'package:werwolf/widgets/connection_status.dart';
import 'package:werwolf/widgets/death_gate.dart';
import 'package:werwolf/widgets/role_reveal_card.dart';
import 'package:werwolf/narration/narration_service.dart';
import 'package:werwolf/narration/narration_mute_button.dart';
import 'package:werwolf/lobby/leave_lobby.dart';

class NightStart extends StatefulWidget {
  final String lobbyCode;
  final GameUpdate initialUpdate;

  const NightStart({
    super.key,
    required this.lobbyCode,
    required this.initialUpdate,
  });

  @override
  State<NightStart> createState() => _NightStartState();
}

class _NightStartState extends State<NightStart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final GameStreamController _stream;

  // The phase for which this player has already submitted their action, so we
  // don't show the voting screen again after acting.
  Phase? _actedPhase;

  // Last known player list. Private updates (e.g. the seer reveal) omit the
  // player list, so we keep the most recent one to resolve names.
  List<PlayerStatus> _lastPlayers = const [];

  // ticks once a second so the phase_ends_at countdown stays live
  Timer? _ticker;

  // hand off to the day screen only once
  bool _navigatedToDay = false;

  // Keep the night on screen this much longer after the backend flips to a day
  // phase, so the last role's "close your eyes" narration plays out before the
  // day UI appears (the day-break line then lands right as we switch). Tune here.
  static const Duration _nightToDayHold = Duration(seconds: 5);
  Timer? _dayNavTimer;

  // A night phase's action UI is held back until the role's wake-up line is
  // actually narrated (NarrationService.narratedActionPhase), so it appears in
  // sync with the voice rather than the instant the backend changes phase.
  // Safety net: if the narration never cues (e.g. audio failed, or a phase is
  // misconfigured shorter than its narration), the UI is shown anyway once the
  // phase has only this many seconds left, so the player can still act. Anchored
  // to phase_ends_at (not phase start) so it never fires during normal, possibly
  // delayed, narration regardless of how the voice-line timing is tuned.
  static const int _gateFallbackSecondsLeft = 15;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..forward();

    _stream = GameStreamController(
      lobbyCode: widget.lobbyCode,
      seed: widget.initialUpdate,
    );
    _stream.addListener(_onPhase);
    NarrationService.instance.attach(_stream);
    // reveal a role's action UI the moment its wake-up line is narrated
    NarrationService.instance.narratedActionPhase.addListener(_onGate);

    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  bool _precached = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_precached) {
      _precached = true;
      precacheGameAssets(context);
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _dayNavTimer?.cancel();
    _stream.removeListener(_onPhase);
    NarrationService.instance.narratedActionPhase.removeListener(_onGate);
    NarrationService.instance.detach(_stream);
    _controller.dispose();
    _stream.dispose();
    super.dispose();
  }

  // Re-render when the narration unlocks a role's action UI.
  void _onGate() {
    if (mounted) setState(() {});
  }

  // Once the night is over the backend moves the game into the day phases or
  // straight to GAME_END if the night kill already decided it. Either way we hand
  // over to the day screen, so the night->day animation plays first; the day
  // screen then shows the result or (on GAME_END) the end screen once the
  // animation has finished.
  void _onPhase() {
    final phase = _stream.currentUpdate.currentPhase;

    if (_navigatedToDay) return;
    final isGameEnd = phase == Phase.GAME_END;
    if (!_isDayPhase(phase) && !isGameEnd) return;

    _navigatedToDay = true;

    void goToDay() {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => DayStart(
            lobbyCode: widget.lobbyCode,
            initialUpdate: _stream.currentUpdate,
          ),
        ),
      );
    }

    // On a normal day break, linger on the night a few seconds so the last
    // role's "close your eyes" finishes first. A game ending at night skips the
    // hold (it goes straight to the result/end screen).
    if (isGameEnd) {
      goToDay();
    } else {
      _dayNavTimer = Timer(_nightToDayHold, goToDay);
    }
  }

  static bool _isDayPhase(Phase phase) =>
      phase == Phase.DAY_RESULT ||
      phase == Phase.DAY_DISCUSSION ||
      phase == Phase.DAY_VOTING ||
      phase == Phase.HUNTER_REVENGE;

  // Remaining seconds in the current phase, or null when no deadline is set.
  int? _secondsLeft(GameUpdate update) {
    if (!update.hasPhaseEndsAt()) return null;
    final secs = update.phaseEndsAt
        .toDateTime()
        .difference(DateTime.now().toUtc())
        .inSeconds;
    return secs < 0 ? 0 : secs;
  }

  // How many OTHER werewolves have committed to each target (live). Only wolves
  // ever receive these fields from the backend, so this is empty for everyone
  // else. The player's own vote is intentionally excluded here: it is shown as
  // the committed checkmark on their chosen tile, not as a second red dot.
  Map<String, int> _wolfVoteCounts(List<PlayerStatus> players) {
    final self = AuthState.userId ?? '';
    final counts = <String, int>{};
    for (final p in players) {
      if (p.id == self) continue; // own vote -> checkmark, not a red dot
      if (p.hasVoted && p.votedForTargetId.isNotEmpty) {
        counts.update(p.votedForTargetId, (v) => v + 1, ifAbsent: () => 1);
      }
    }
    return counts;
  }

  // This player's own committed werewolf target, or '' if not yet voted.
  String _ownVotedTarget(List<PlayerStatus> players) {
    final self = AuthState.userId ?? '';
    for (final p in players) {
      if (p.id == self && p.hasVoted) return p.votedForTargetId;
    }
    return '';
  }

  Future<void> _submit(GameAction action, Phase phase) async {
    final ok = await GameViewController.performAction(action);
    if (!mounted) return;
    if (ok) {
      setState(() => _actedPhase = phase);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aktion fehlgeschlagen')),
      );
    }
  }

  // Returns the role voting screen when it is this player's turn, the result/
  // waiting screen after they acted, or null to show the plain night view.
  Widget? _buildActionOverlay(GameUpdate update) {
    if (update.players.isNotEmpty) {
      _lastPlayers = update.players.toList();
    }
    final players = _lastPlayers;
    final phase = update.currentPhase;
    final acted = _actedPhase == phase;

    // The seer's reveal appears right after acting and is NOT gated by the intro
    // delay; it stays until the backend advances the phase (~5s grace). The
    // result is only ever present post-action during the seer phase, so showing
    // it whenever present is safe (and survives a reconnect).
    if (update.hasYourResults() && update.yourResults.hasSeerReveal()) {
      return SeherVoting(
        targets: const [],
        players: players,
        reveal: update.yourResults.seerReveal,
        onInspect: (_) {},
      );
    }

    // The fox's reveal, like the seer's, appears right after acting and stays
    // until the backend advances the phase (~5s grace). It is only ever present
    // during the fox phase, so showing it whenever present is safe.
    if (update.hasYourResults() && update.yourResults.hasFoxReveal()) {
      return FuchsVoting(
        targets: const [],
        reveal: update.yourResults.foxReveal,
        onInspect: (_) {},
      );
    }



    final narratedNow =
        NarrationService.instance.narratedActionPhase.value == phase;
    final secondsLeft = _secondsLeft(update);
    final phaseRunningOut =
        secondsLeft != null && secondsLeft <= _gateFallbackSecondsLeft;
    if (!narratedNow && !phaseRunningOut) {
      return null;
    }

    // Werewolf voting stays on screen for the whole phase (even after voting) so
    // the wolf keeps seeing the live tally; the vote locks once committed.
    if (update.hasOpenPrompt() &&
        update.openPrompt.whichPrompt() == ActionPrompt_Prompt.werewolf) {
      final ownVote = _ownVotedTarget(players);
      return WerwolfVoting(
        targets: _resolveTargets(players, update.openPrompt.werewolf.candidateIds),
        voteCounts: _wolfVoteCounts(players),
        committedTargetId: ownVote.isNotEmpty ? ownVote : null,
        locked: acted || ownVote.isNotEmpty,
        secondsLeft: _secondsLeft(update),
        onVote: (id) => _submit(
          GameAction(lobbyCode: widget.lobbyCode, vote: VoteAction(targetId: id)),
          phase,
        ),
      );
    }

    if (update.hasOpenPrompt() && !acted) {
      final prompt = update.openPrompt;
      switch (prompt.whichPrompt()) {
        case ActionPrompt_Prompt.seer:
          return SeherVoting(
            targets: _resolveTargets(players, prompt.seer.candidateIds),
            players: players,
            secondsLeft: _secondsLeft(update),
            onInspect: (id) => _submit(
              GameAction(lobbyCode: widget.lobbyCode, seer: SeerAction(targetId: id)),
              phase,
            ),
          );
        case ActionPrompt_Prompt.witch:
          final w = prompt.witch;
          return HexeVoting(
            attackedPlayerId: w.attackedPlayerId,
            hasHealPotion: w.hasHealPotion,
            hasPoisonPotion: w.hasPoisonPotion,
            players: players,
            selfId: AuthState.userId ?? '',
            secondsLeft: _secondsLeft(update),
            onSubmit: (heal, poisonId) => _submit(
              GameAction(
                lobbyCode: widget.lobbyCode,
                witch: WitchAction(
                  healTarget: heal,
                  poisonTargetId: poisonId ?? '',
                ),
              ),
              phase,
            ),
          );
        case ActionPrompt_Prompt.fox:
          return FuchsVoting(
            targets: _resolveTargets(players, prompt.fox.candidateIds),
            secondsLeft: _secondsLeft(update),
            onInspect: (ids) => _submit(
              GameAction(
                lobbyCode: widget.lobbyCode,
                fox: FoxAction(targetIds: ids),
              ),
              phase,
            ),
          );
        case ActionPrompt_Prompt.saboteur:
          return SaboteurVoting(
            targets: _resolveTargets(players, prompt.saboteur.candidateIds),
            secondsLeft: _secondsLeft(update),
            onSabotage: (id) => _submit(
              GameAction(
                lobbyCode: widget.lobbyCode,
                saboteur: SaboteurAction(targetId: id),
              ),
              phase,
            ),
          );
        case ActionPrompt_Prompt.cupid:
          return AmorVoting(
            targets: _resolveTargets(players, prompt.cupid.candidateIds),
            secondsLeft: _secondsLeft(update),
            onPair: (a, b) => _submit(
              GameAction(
                lobbyCode: widget.lobbyCode,
                cupid: CupidAction(player1Id: a, player2Id: b),
              ),
              phase,
            ),
          );
        default:
          return null; // hunter not handled on this screen yet
      }
    }

    // already acted (e.g. the witch) or nothing to do -> plain night scene
    return null;
  }

  // Resolves a player's display name from an id using the latest player list.
  String _nameOf(List<PlayerStatus> players, String id) {
    for (final p in players) {
      if (p.id == id) return p.name;
    }
    return id;
  }

  // Players that may be targeted. Uses the server-provided candidate list when
  // present, otherwise falls back to every living player except this one.
  List<PlayerStatus> _resolveTargets(
    List<PlayerStatus> players,
    List<String> candidateIds,
  ) {
    if (candidateIds.isNotEmpty) {
      return players.where((p) => candidateIds.contains(p.id)).toList();
    }
    final self = AuthState.userId ?? '';
    return players.where((p) => p.isAlive && p.id != self).toList();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) confirmAndLeaveLobby(context);
      },
      child: ConnectionStatusScope(
      controller: _stream,
      child: DeathGate(
        controller: _stream,
        child: Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 80,
        leading: Align(
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () => confirmAndLeaveLobby(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white60,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/back.svg',
                  width: 20,
                  height: 20,
                ),
              ),
            ),
          ),
        ),
        actions: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const EinstellungenView(),
                    ),
                  );
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.white60,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/settings.svg',
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      body: ListenableBuilder(
        listenable: _stream,
        builder: (context, _) {
          final update = _stream.currentUpdate;
          final overlay = _buildActionOverlay(update);

          return Stack(
            children: [
              Container(color: Colors.black),

              Positioned(
                top: MediaQuery.of(context).size.height * 0.0,
                left:
                    MediaQuery.of(context).size.width * 0.00 -
                    (MediaQuery.of(context).size.width * 2) / 2,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.rotate(
                      // 180° = pi radians
                      angle: _controller.value * 3.1415926535,
                      child: child,
                    );
                  },
                  child: Image.asset(
                    'assets/BG/Sky Spin.png',
                    width: MediaQuery.of(context).size.width * 3,
                    height: MediaQuery.of(context).size.width * 3,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox.expand(
                child: Image.asset('assets/BG/day FG.png', fit: BoxFit.cover),
              ),

              FadeTransition(
                opacity: _controller,
                child: SizedBox.expand(
                  child: Image.asset('assets/BG/night FG.png', fit: BoxFit.cover),
                ),
              ),

              // 2. Content on top
              SafeArea(
                child: Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FadeTransition(
                            opacity: Tween<double>(
                              begin: 1.0,
                              end: 0.0,
                            ).animate(_controller),
                            child: const Text(
                              "Die Nacht bricht ein",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'BagelFatOne',
                                fontSize: 36,
                                color: Color.fromARGB(255, 51, 50, 94),
                              ),
                            ),
                          ),

                          const SizedBox(height: 350),

                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => const Rules(),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
                                ),
                              );
                            },
                            child: Text(
                              "Regeln ansehen",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.7),
                                    offset: const Offset(1, 1),
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                    // role card: drag towards the centre to reveal your role;
                    // it appears fixed in the middle while held and vanishes the
                    // moment the finger is lifted.
                    Positioned(
                      left: 16,
                      bottom: 16,
                      child: RoleRevealCard(
                        role: selfRoleOf(update),
                        partnerName: update.loverPartnerId.isNotEmpty
                            ? _nameOf(_lastPlayers, update.loverPartnerId)
                            : null,
                      ),
                    ),
                  ],
                ),
              ),

              // role action screen, shown on top when it is this player's turn
              if (overlay != null) Positioned.fill(child: overlay),

              // narration mute toggle, kept on top so it stays reachable
              const SafeArea(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: NarrationMuteButton(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      ),
      ),
      ),
    );
  }
}
