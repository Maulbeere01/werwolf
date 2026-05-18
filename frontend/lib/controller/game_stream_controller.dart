import 'dart:async';

import 'package:flutter/material.dart';
import 'package:werwolf/GrpcHandler.dart';
import 'package:werwolf/auth/session_store.dart';
import 'package:werwolf/generated/werwolf.pb.dart';

/// Owns the SubscribeToGame stream for one lobby
///
/// Handles reconnect with exponential backoff, foreground resume resubscription
/// and the 3 second grace period before surfacing a connection indicator
///
/// consumers only need two fields:
///   currentUpdate => latest snapshot from the server
///   isReconnecting => true when the connection is down (after 3 s)

class GameStreamController extends ChangeNotifier with WidgetsBindingObserver {
  GameStreamController({required this.lobbyCode, GameUpdate? seed})
      : currentUpdate = seed ?? GameUpdate() {
    WidgetsBinding.instance.addObserver(this);
    _subscribeLoop();
  }

  final String lobbyCode;

  /// Latest update received from the server
  GameUpdate currentUpdate;

  /// true when the stream has been down for more than 3 seconds
  /// Wire this to UI components to disable actions or show a indicator
  bool isReconnecting = false;

  // private reconnect state
  bool _disposed = false;
  int _retryCount = 0;
  Timer? _feedbackTimer;
  StreamSubscription<GameUpdate>? _subscription;
  Completer<void>? _streamCompleter;
  Completer<void>? _wakeUpCompleter;

  // lifecycle
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _forceReconnect();
  }

  void _forceReconnect() {
    _retryCount = 0;
    _feedbackTimer?.cancel();
    if (isReconnecting) {
      isReconnecting = false;
      notifyListeners();
    }
    _subscription?.cancel();
    _subscription = null;
    if (!(_streamCompleter?.isCompleted ?? true)) _streamCompleter!.complete();
    if (!(_wakeUpCompleter?.isCompleted ?? true)) _wakeUpCompleter!.complete();
  }

  // stream loop
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
      if (currentUpdate.currentPhase == Phase.GAME_END) break;

      _retryCount++;
      final delay = Duration(seconds: (1 << (_retryCount - 1)).clamp(1, 30));
      debugPrint('[STREAM] Retry $_retryCount in ${delay.inSeconds}s ($lobbyCode)');

      _feedbackTimer?.cancel();
      _feedbackTimer = Timer(const Duration(seconds: 3), () {
        if (!_disposed) {
          isReconnecting = true;
          notifyListeners();
        }
      });

      _wakeUpCompleter = Completer<void>();
      await Future.any([Future.delayed(delay), _wakeUpCompleter!.future]);
      _wakeUpCompleter = null;
      _feedbackTimer?.cancel();
    }
  }

  Future<void> _connect() async {
    final completer = Completer<void>();
    _streamCompleter = completer;

    final grpc = await GrpcHandler.create();
    if (_disposed || completer.isCompleted) return;

    final request = SubscribeRequest()..lobbyCode = lobbyCode;
    _subscription = grpc.gameClient.subscribeToGame(request).listen(
      (update) {
        // reset reconnect state and deliver update in a single notification
        if (_retryCount > 0 || isReconnecting) {
          _retryCount = 0;
          _feedbackTimer?.cancel();
          isReconnecting = false;
        }
        debugPrint('[STREAM] ${update.currentPhase.name} ($lobbyCode)');
        if (update.currentPhase == Phase.GAME_END) SessionStore.clearLobbyCode();
        currentUpdate = update;
        if (!_disposed) notifyListeners();
      },
      onError: (Object e) {
        debugPrint('[STREAM] Error: $e');
        if (!completer.isCompleted) completer.completeError(e);
      },
      onDone: () {
        debugPrint('[STREAM] Closed ($lobbyCode)');
        if (!completer.isCompleted) completer.complete();
      },
      cancelOnError: true,
    );

    return completer.future;
  }

  // cleanup
  @override
  void dispose() {
    _disposed = true;
    WidgetsBinding.instance.removeObserver(this);
    _feedbackTimer?.cancel();
    _subscription?.cancel();
    super.dispose();
  }
}
