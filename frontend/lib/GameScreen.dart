import 'dart:async';

import 'package:flutter/material.dart';
import 'package:werwolf/GrpcHandler.dart';
import 'package:werwolf/generated/werwolf.pb.dart';

class GameScreen extends StatefulWidget {
  final String lobbyCode;
  final GameUpdate initialUpdate;

  const GameScreen({
    super.key,
    required this.lobbyCode,
    required this.initialUpdate,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  StreamSubscription<GameUpdate>? _subscription;
  late GameUpdate _currentUpdate;

  @override
  void initState() {
    super.initState();
    _currentUpdate = widget.initialUpdate;
    _subscribe();
  }

  Future<void> _subscribe() async {
    final grpc = await GrpcHandler.create();
    final request = SubscribeRequest()..lobbyCode = widget.lobbyCode;
    final stream = grpc.gameClient.subscribeToGame(request);

    _subscription = stream.listen(
      (update) {
        debugPrint('[GAME STREAM] Phase update: ${update.currentPhase.name} lobby ${widget.lobbyCode}');
        if (mounted) setState(() => _currentUpdate = update);
      },
      onError: (e) => debugPrint('[GAME STREAM] Error: $e'),
      onDone: () => debugPrint('[GAME STREAM] Stream closed lobby ${widget.lobbyCode}'),
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: switch (_currentUpdate.currentPhase) {
            Phase.LOBBY            => _phaseWidget('Warte auf Spielstart...'),
            Phase.NIGHT_START      => _phaseWidget('Nachtstart'),
            Phase.NIGHT_WEREWOLVES => _phaseWidget('Werwölfe erwachen'),
            Phase.NIGHT_SEER       => _phaseWidget('Seher'),
            Phase.NIGHT_WITCH      => _phaseWidget('Hexe.'),
            Phase.NIGHT_FOX        => _phaseWidget('Fuchs.'),
            Phase.DAY_RESULT       => _phaseWidget('Morgen'),
            Phase.DAY_DISCUSSION   => _phaseWidget('Diskussion'),
            Phase.DAY_VOTING       => _phaseWidget('Abstimmung'),
            Phase.HUNTER_REVENGE   => _phaseWidget('Jäger'),
            Phase.GAME_END         => _phaseWidget('Spiel vorbei'),
            _                      => _phaseWidget('Unbekannte Phase'),
          },
        ),
      ),
    );
  }

  Widget _phaseWidget(String label) {
    return Text(
      label,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontFamily: 'BagelFatOne',
        fontSize: 28,
      ),
    );
  }
}
