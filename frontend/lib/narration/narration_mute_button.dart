import 'package:flutter/material.dart';
import 'package:werwolf/narration/narration_mute.dart';

/// Small speaker toggle shown bottom-right of the game screens.
///
/// Non-host devices start muted (no music, no voice lines); tapping unmutes so
/// another player can take over the narration if the host drops out.
class NarrationMuteButton extends StatelessWidget {
  const NarrationMuteButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: NarrationMute.instance.muted,
      builder: (context, muted, _) {
        return GestureDetector(
          onTap: NarrationMute.instance.toggle,
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.white60,
              shape: BoxShape.circle,
            ),
            child: Icon(
              muted ? Icons.volume_off : Icons.volume_up,
              size: 22,
              color: Colors.black54,
            ),
          ),
        );
      },
    );
  }
}
