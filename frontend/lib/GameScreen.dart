import 'package:flutter/material.dart';
import 'package:werwolf/generated/werwolf.pb.dart';

class GameScreen extends StatelessWidget {
  final String lobbyCode;
  final GameUpdate initialUpdate;

  const GameScreen({
    super.key,
    required this.lobbyCode,
    required this.initialUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
      body: Center(
        child: Text(
          'Phase: ${initialUpdate.currentPhase.name}',
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'BagelFatOne',
            fontSize: 28,
          ),
        ),
      ),
    );
  }
}
