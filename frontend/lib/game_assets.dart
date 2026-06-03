import 'package:flutter/widgets.dart';

/// Image assets used by the in-game screens (Intro, NightStart, DayStart and the
/// role card). They are decoded ahead of time so the day/night screens and the
/// role reveal don't flash black while an image is still loading on first
/// display. Keep this in sync with the role artwork in [roleCardAsset].
const List<String> kGameImageAssets = <String>[
  // backgrounds
  'assets/BG/Sky Spin.png',
  'assets/BG/day FG.png',
  'assets/BG/night FG.png',
  'assets/PNGs/villager.png',
  'assets/PNGs/wolf.png',
  'assets/PNGs/Seher.png',
  'assets/PNGs/Armor.png',
  'assets/PNGs/Backside.png',
];

/// Warms the image cache for every in-game asset, loading them in parallel to
/// keep the wait at game start short. Safe to call repeatedly: once an image is
/// cached the call returns almost immediately.
Future<void> precacheGameAssets(BuildContext context) async {
  if (!context.mounted) return;
  await Future.wait(
    kGameImageAssets.map(
      (path) => precacheImage(AssetImage(path), context).catchError((_) {}),
    ),
  );
}
