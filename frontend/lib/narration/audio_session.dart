import 'dart:io' show Platform;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Audio context that lets the looping background music and the voice narration
/// play at the SAME time. By default audioplayers requests audio focus on every
final AudioContext kMixAudioContext = AudioContext(
  android: AudioContextAndroid(
    isSpeakerphoneOn: false,
    stayAwake: false,
    contentType: AndroidContentType.music,
    usageType: AndroidUsageType.media,
    audioFocus: AndroidAudioFocus.none,
  ),
  iOS: AudioContextIOS(
    category: AVAudioSessionCategory.playback,
    options: const {AVAudioSessionOptions.mixWithOthers},
  ),
);

/// Whether to attempt audio on desktop builds (Linux/macOS/Windows), not just on
/// phones.
const bool kEnableDesktopAudio = true;

/// Session-wide guard around every audio call.
///
/// Audio is attempted on mobile always, and on desktop when [kEnableDesktopAudio]
/// is set. The first failure disables audio for the rest of the session so a
/// one-off backend hiccup can't keep hanging.
class AudioSession {
  AudioSession._();

  static final bool _supported = !kIsWeb &&
      (Platform.isAndroid || Platform.isIOS || kEnableDesktopAudio);

  static bool _failed = false;

  /// True when no further audio calls should be made (unsupported platform or a
  /// prior failure).
  static bool get disabled => !_supported || _failed;

  static const Duration _timeout = Duration(seconds: 3);

  /// Run an audio call. Returns true on success, false if audio is (now)
  /// disabled. The first failure or timeout disables audio for good.
  static Future<bool> run(Future<void> Function() action) async {
    if (disabled) return false;
    try {
      await action().timeout(_timeout);
      return true;
    } catch (e) {
      _failed = true;
      debugPrint('[AUDIO] disabled for this session: $e');
      return false;
    }
  }
}
