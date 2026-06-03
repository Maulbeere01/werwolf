import 'dart:async';

import 'package:flutter/material.dart';
import 'package:werwolf/GrpcHandler.dart';
import 'package:werwolf/auth/session_store.dart';
import 'package:werwolf/generated/werwolf.pb.dart';

/// Owns the SubscribeToGame stream for one lobby.
///
/// Reconnects automatically: while the stream is down it retries roughly once a
/// second and exposes two escalating connection signals:
///   isReconnecting   => true after 3 s down  => wire to a small spinner
///   isConnectionLost => true after 10 s down => wire to the full "no server screen
///
/// consumers only need three fields:
///   currentUpdate    => latest snapshot from the server
///   isReconnecting   => connection has been down for >= 3 s
///   isConnectionLost => connection has been down for >= 10 s

class GameStreamController extends ChangeNotifier with WidgetsBindingObserver {
  GameStreamController({required this.lobbyCode, GameUpdate? seed})
      : currentUpdate = seed ?? GameUpdate() {
    WidgetsBinding.instance.addObserver(this);
    _subscribeLoop();
  }

  final String lobbyCode;

  /// Latest update received from the server
  GameUpdate currentUpdate;

  /// true once the stream has been down for >= 3 s (small reconnect spinner)
  bool isReconnecting = false;

  /// true once the stream has been down for >= 10 s (full no-connection screen)
  bool isConnectionLost = false;

  // how often we retry while down, and how long until each connection signal
  static const Duration _retryInterval = Duration(seconds: 1);
  static const Duration _reconnectingAfter = Duration(seconds: 3);
  static const Duration _connectionLostAfter = Duration(seconds: 10);

  // private reconnect state
  bool _disposed = false;
  Timer? _reconnectingTimer;
  Timer? _connectionLostTimer;
  StreamSubscription<GameUpdate>? _subscription;
  Completer<void>? _streamCompleter;
  Completer<void>? _wakeUpCompleter;

  // lifecycle
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Only wake the reconnect loop when the stream is actually down (we are
    // sitting in the retry wait, so _subscription is null). On desktop, merely
    // focusing a window fires `resumed`; tearing a healthy stream down on every
    // window click would resubscribe constantly and clobber live state (e.g. the
    // werewolf vote tally) with a fresh snapshot.
    if (state == AppLifecycleState.resumed && _subscription == null) {
      _wakeReconnect();
    }
  }

  /// Retry the connection immediately instead of waiting out the retry interval.
  /// Safe to call from UI (e.g. the "try again" button on the no-server screen).
  void retryNow() => _wakeReconnect();

  // Skip the current retry wait without touching the down-timers, so a manual
  // retry / app resume during an outage reconnects right away.
  void _wakeReconnect() {
    _subscription?.cancel();
    _subscription = null;
    if (!(_streamCompleter?.isCompleted ?? true)) _streamCompleter!.complete();
    if (!(_wakeUpCompleter?.isCompleted ?? true)) _wakeUpCompleter!.complete();
  }

  // The stream is down: start the escalating connection signals if they aren't
  // already running. Using ??= keeps them measuring from the first failure
  // instead of restarting on every retry attempt.
  void _startDownTimers() {
    _reconnectingTimer ??= Timer(_reconnectingAfter, () {
      if (_disposed || isReconnecting) return;
      isReconnecting = true;
      notifyListeners();
    });
    _connectionLostTimer ??= Timer(_connectionLostAfter, () {
      if (_disposed || isConnectionLost) return;
      isConnectionLost = true;
      notifyListeners();
    });
  }

  // A message arrived => we are connected again. Cancel the timers and clear the
  // signals (notifying only when something actually changed).
  void _clearDownState() {
    if (_reconnectingTimer == null &&
        _connectionLostTimer == null &&
        !isReconnecting &&
        !isConnectionLost) {
      return; // already in the connected state
    }
    _reconnectingTimer?.cancel();
    _reconnectingTimer = null;
    _connectionLostTimer?.cancel();
    _connectionLostTimer = null;
    final changed = isReconnecting || isConnectionLost;
    isReconnecting = false;
    isConnectionLost = false;
    if (changed) notifyListeners();
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

      // stream is down: keep the connection signals running and retry shortly
      _startDownTimers();
      debugPrint('[STREAM] Retry in ${_retryInterval.inSeconds}s ($lobbyCode)');

      _wakeUpCompleter = Completer<void>();
      await Future.any([
        Future.delayed(_retryInterval),
        _wakeUpCompleter!.future,
      ]);
      _wakeUpCompleter = null;
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
        // any message means we're connected: clear the reconnect signals
        _clearDownState();
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
    _reconnectingTimer?.cancel();
    _connectionLostTimer?.cancel();
    _subscription?.cancel();
    super.dispose();
  }
}
