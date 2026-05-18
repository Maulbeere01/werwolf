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

class _GameScreenState extends State<GameScreen> with WidgetsBindingObserver {
  StreamSubscription<GameUpdate>? _subscription;
  late GameUpdate _currentUpdate;

  bool _disposed = false;
  int _retryCount = 0;
  // set by _triggerReconnect so the next loop iteration skips the backoff
  bool _skipDelay = false;

  bool _showReconnecting = false;
  Timer? _feedbackTimer;

  // lets _triggerReconnect interrupt either waiting point in the loop:
  // the live stream (_streamCompleter) or the backoff sleep (_wakeUpCompleter)
  Completer<void>? _streamCompleter;
  Completer<void>? _wakeUpCompleter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _currentUpdate = widget.initialUpdate;
    _subscribeLoop();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _triggerReconnect();
    }
  }

  // called on foreground resume. Cancels the current stream (or backoff sleep),
  // resets retry state, and lets the loop reconnect immediately
  void _triggerReconnect() {
    _skipDelay = true;
    _retryCount = 0;
    _feedbackTimer?.cancel();
    if (_showReconnecting && mounted) {
      setState(() => _showReconnecting = false);
    } else {
      _showReconnecting = false;
    }

    // Cancel the active subscription; its onDone/onError will complete
    // _streamCompleter, or we complete it ourselves if the sub isn't up yet.
    _subscription?.cancel();
    _subscription = null;
    if (!(_streamCompleter?.isCompleted ?? true)) _streamCompleter!.complete();

    // also wake the loop if it is sleeping in the backoff delay.
    if (!(_wakeUpCompleter?.isCompleted ?? true)) _wakeUpCompleter!.complete();
  }

  Future<void> _connect() async {
    final completer = Completer<void>();
    _streamCompleter = completer;

    final grpc = await GrpcHandler.create();
    if (_disposed || completer.isCompleted) return;

    final request = SubscribeRequest()..lobbyCode = widget.lobbyCode;
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
      } catch (_) {
      } finally {
        _subscription?.cancel();
        _subscription = null;
        _streamCompleter = null;
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

      _wakeUpCompleter = Completer<void>();
      await Future.any([Future.delayed(delay), _wakeUpCompleter!.future]);
      _wakeUpCompleter = null;
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
    WidgetsBinding.instance.removeObserver(this);
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
