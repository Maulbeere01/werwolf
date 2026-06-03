import 'package:flutter/material.dart';
import 'package:werwolf/controller/game_stream_controller.dart';
import 'package:werwolf/no_server_connection.dart';

/// Wraps a game screen and surfaces the stream's connection state on top of it:
///   - >= 3 s down  -> a small "reconnecting" spinner in the bottom-right corner
///   - >= 10 s down -> the full-screen [NoServerConnection] overlay
///
/// The wrapped [child] stays mounted underneath at all times, so its state (and
/// the live game updates) survive a short outage without being rebuilt.
class ConnectionStatusScope extends StatelessWidget {
  final GameStreamController controller;
  final Widget child;

  const ConnectionStatusScope({
    super.key,
    required this.controller,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      child: child,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned.fill(child: child!),
            if (controller.isConnectionLost)
              Positioned.fill(
                child: NoServerConnection(onRetry: controller.retryNow),
              )
            else if (controller.isReconnecting)
              const Positioned(
                right: 12,
                bottom: 12,
                child: _ReconnectingBadge(),
              ),
          ],
        );
      },
    );
  }
}

class _ReconnectingBadge extends StatelessWidget {
  const _ReconnectingBadge();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 10),
              Text(
                'Verbinde…',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
