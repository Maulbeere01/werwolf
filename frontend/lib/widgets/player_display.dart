import 'package:flutter/material.dart';
import 'package:werwolf/generated/werwolf.pb.dart';
import 'package:werwolf/widgets/player_tile.dart';

/// The "Mitspieler" box in the waiting room, styled to match the host's lobby
/// card (qr_code_screen.dart): a bounded, rounded translucent box that scrolls
/// its own player list instead of letting it overflow the screen.
class Spieleranzeige extends StatelessWidget {
  final List<PlayerStatus> players;

  const Spieleranzeige({super.key, this.players = const []});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(24),
        ),
        child: players.isEmpty
            ? const Center(
                child: Text(
                  "Warte auf Spieler...",
                  style: TextStyle(color: Colors.white54, fontSize: 16),
                ),
              )
            : ListView.builder(
                itemCount: players.length,
                itemBuilder: (_, i) => PlayerTile(player: players[i]),
              ),
      ),
    );
  }
}
