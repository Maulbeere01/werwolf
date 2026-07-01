import 'package:audioplayers/audioplayers.dart';
import 'package:werwolf/narration/audio_session.dart';

/// App-wide looping background music.
///
/// A singleton: started once, it keeps playing quietly under the narration for
/// the whole game. Muting is a pause/resume (cheap, no pipeline rebuild)
class BackgroundMusic {
  BackgroundMusic._();
  static final BackgroundMusic instance = BackgroundMusic._();

  /// Quiet background level so the music sits well under the voice lines. Bump
  /// this up for louder music, down for softer. (0.0 = silent, 1.0 = full)
  static const double _volume = 0.2;

  // Built lazily: constructing an AudioPlayer fires a native create() call, so
  // we avoid even that off mobile (see AudioSession). It is only ever reached
  // from inside AudioSession.run, which no-ops when audio is unsupported.
  AudioPlayer? _playerInstance;
  AudioPlayer get _player => _playerInstance ??= AudioPlayer();

  bool _started = false;
  bool _muted = false;

  /// Start the loop once (no-op if already running or audio is unavailable).
  Future<void> start() async {
    if (_started || AudioSession.disabled) return;
    _started = true;
    await AudioSession.run(() async {
      await _player.setAudioContext(kMixAudioContext);
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.play(AssetSource('hintergrund.mp3'), volume: _volume);
    });
  }

  /// Mute by PAUSING the loop and resume to unmute. No setVolume involved, so the
  /// level never drifts.
  Future<void> setMuted(bool muted) async {
    if (_muted == muted) return;
    _muted = muted;
    if (!_started) return;
    await AudioSession.run(() => muted ? _player.pause() : _player.resume());
  }

  /// Stop the loop entirely. Only used when leaving the game.
  Future<void> stop() async {
    if (!_started) return;
    _started = false;
    await AudioSession.run(() => _player.stop());
  }
}
