import 'package:flutter/widgets.dart';

/// Image assets used by the in-game screens (Intro, NightStart, DayStart and the
/// role card).
const List<String> kGameImageAssets = <String>[
  'assets/BG/Sky Spin.png',
  'assets/BG/day FG.png',
  'assets/BG/night FG.png',
  'assets/PNGs/villager.png',
];

/// Warms the image cache for every in-game asset. Safe to call repeatedly: once
/// an image is cached the call returns almost immediately. Awaiting it before
/// navigating into the game guarantees the backgrounds are decoded before the
/// game screens appear.
Future<void> precacheGameAssets(BuildContext context) async {
  for (final path in kGameImageAssets) {
    if (!context.mounted) return;
    try {
      await precacheImage(AssetImage(path), context);
    } catch (_) {
      // ignore: a missing/broken asset must not block the game from starting
    }
  }
}
