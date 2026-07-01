import 'package:flutter/foundation.dart';

/// Whether THIS device's narration audio is silenced.
///
/// The host narrates aloud, so the host's device defaults to unmuted; everyone
/// else starts muted but can unmute (the bottom-right speaker button) as a
/// fallback if the host drops out or their phone dies. The choice lives for the
/// app session (a singleton in memory), so it survives screen changes and stream
/// reconnects.
class NarrationMute {
  NarrationMute._();
  static final NarrationMute instance = NarrationMute._();

  /// Listen to drive the speaker button's icon. Muted by default until the host
  /// is known.
  final ValueNotifier<bool> muted = ValueNotifier<bool>(true);

  bool _defaultApplied = false;

  /// Apply the host-based default exactly once. A later snapshot (or a manual
  /// toggle the player already made) never overrides it.
  void applyHostDefault({required bool isHost}) {
    if (_defaultApplied) return;
    _defaultApplied = true;
    muted.value = !isHost;
  }

  void toggle() => muted.value = !muted.value;
}
