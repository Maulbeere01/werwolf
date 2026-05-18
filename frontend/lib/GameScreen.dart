import 'dart:async';

import 'package:flutter/material.dart';
import 'package:werwolf/GrpcHandler.dart';
import 'package:werwolf/auth/session_store.dart';
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

  bool _disposed = false;
  int _retryCount = 0;

  bool _showReconnecting = false;
  Timer? _feedbackTimer;

  @override
  void initState() {
    super.initState();
    _currentUpdate = widget.initialUpdate;
    _subscribeLoop();
  }

  // connects and drives the stream to completion (normal close or error)
  // The completer bridges the callback based listener to the async loop
  Future<void> _connect() async {
    final grpc = await GrpcHandler.create();
    final request = SubscribeRequest()..lobbyCode = widget.lobbyCode;
    final completer = Completer<void>();

    _subscription = grpc.gameClient.subscribeToGame(request).listen(
      (update) {
        _onConnected();
        debugPrint('[GAME STREAM] ${update.currentPhase.name} lobby ${widget.lobbyCode}');
        if (update.currentPhase == Phase.GAME_END) {
          SessionStore.clearLobbyCode();
        }
        if (mounted) setState(() => _currentUpdate = update);
      },
      onError: (Object e) {
        debugPrint('[GAME STREAM] Error: $e');
        if (!completer.isCompleted) completer.completeError(e);
      },
      onDone: () {
        debugPrint('[GAME STREAM] Stream closed lobby ${widget.lobbyCode}');
        if (!completer.isCompleted) completer.complete();
      },
      cancelOnError: true,
    );

    return completer.future;
  }

  Future<void> _subscribeLoop() async {
    while (!_disposed) {
      try {
        await _connect();
      } catch (e) {
        // logged in onError above
      } finally {
        _subscription?.cancel();
        _subscription = null;
      }

      if (_disposed) break;
      if (_currentUpdate.currentPhase == Phase.GAME_END) break;

      // exponential backoff max 30 sec
      _retryCount++;
      final delay = Duration(seconds: (1 << (_retryCount - 1)).clamp(1, 30));
      debugPrint('[GAME STREAM] Retry $_retryCount in ${delay.inSeconds}s');

      // show indicator only after 3 s of waiting so fast reconnects are invisible
      _feedbackTimer?.cancel();
      _feedbackTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) setState(() => _showReconnecting = true);
      });

      await Future.delayed(delay);
      _feedbackTimer?.cancel();
    }
  }

  // called on the first successful update after a disconnect
  void _onConnected() {
    if (_retryCount == 0 && !_showReconnecting) return;
    _retryCount = 0;
    _feedbackTimer?.cancel();
    if (_showReconnecting && mounted) {
      setState(() => _showReconnecting = false);
    } else {
      _showReconnecting = false;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _feedbackTimer?.cancel();
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
      body: Stack(
        children: [
          Center(
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
          if (_showReconnecting) _reconnectBadge(context),
        ],
      ),
    );
  }

  Widget _reconnectBadge(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      right: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(strokeWidth: 1.5, color: Colors.white70),
            ),
            SizedBox(width: 6),
            Text(
              'Verbindung...',
              style: TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ],
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
