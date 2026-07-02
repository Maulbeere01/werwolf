import 'package:flutter/material.dart';
import 'package:werwolf/auth/session_store.dart';
import 'package:werwolf/narration/narration_service.dart';
import 'package:werwolf/screens/home_screen.dart';

/// Ask the player to confirm leaving the current lobby, then leave for good.
///
/// "Leaving" is two things:
///  1. We drop the persisted lobby code ([SessionStore.clearLobbyCode]). The
///     auto-reconnect on next launch is driven purely by that stored code (see
///     [Homescreen]); without it the app stays on the home screen.
///  2. We return to a fresh home screen, clearing the whole game stack. Disposing
///     the game screens cancels their SubscribeToGame streams, and the backend's
///     onCancel handler unsubscribes the player
Future<void> confirmAndLeaveLobby(BuildContext context) async {
  final leave = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Lobby verlassen?'),
      content: const Text('Willst du die Lobby wirklich verlassen?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text('Verlassen'),
        ),
      ],
    ),
  );

  if (leave != true || !context.mounted) return;

  // Silence any line in progress and drop the queue/music immediately, so the
  // narration can't keep playing (current line or already-queued lines) after we
  // leave. The gRPC stream is cancelled separately when the game screens dispose.
  NarrationService.instance.reset();

  await SessionStore.clearLobbyCode();
  if (!context.mounted) return;

  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const Homescreen()),
    (route) => false,
  );
}
