import 'package:flutter/material.dart';
import 'package:werwolf/generated/werwolf.pb.dart';

/// A single player row shown in a lobby's player list: avatar (or initial
/// fallback), name, and a host star. Shared by the host's lobby view
/// (qr_code_screen.dart) and the joining players' waiting room
/// (player_display.dart) so both look identical.
class PlayerTile extends StatelessWidget {
  final PlayerStatus player;

  const PlayerTile({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    final avatar = player.avatar;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white24,
            backgroundImage: avatar.isNotEmpty ? AssetImage('assets/PFP/$avatar') : null,
            child: avatar.isEmpty
                ? Text(
                    player.name.isNotEmpty ? player.name[0].toUpperCase() : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              player.name,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          if (player.isHost) const Icon(Icons.star, color: Colors.amber, size: 18),
        ],
      ),
    );
  }
}
