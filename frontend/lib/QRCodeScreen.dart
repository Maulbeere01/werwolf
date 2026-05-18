import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:werwolf/GameScreen.dart';
import 'package:werwolf/GrpcHandler.dart';
import 'package:werwolf/HomeScreen.dart';
import 'package:werwolf/auth/auth_state.dart';
import 'package:werwolf/auth/session_store.dart';
import 'package:werwolf/controller/game_stream_controller.dart';
import 'package:werwolf/generated/werwolf.pb.dart';

class QRCodeScreen extends StatefulWidget {
  final String lobbyCode;

  const QRCodeScreen({super.key, required this.lobbyCode});

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  late final GameStreamController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GameStreamController(lobbyCode: widget.lobbyCode);
    _controller.addListener(_onUpdate);
  }

  // navigate to GameScreen as soon as the server signals the game has started
  void _onUpdate() {
    final phase = _controller.currentUpdate.currentPhase;
    if (phase == Phase.PHASE_UNSPECIFIED || phase == Phase.LOBBY) return;

    _controller.removeListener(_onUpdate);
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => GameScreen(
          lobbyCode: widget.lobbyCode,
          initialUpdate: _controller.currentUpdate,
        ),
      ),
    );
  }

  Future<void> _leaveLobby() async {
    await SessionStore.clearLobbyCode();
    if (!mounted) return;
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const Homescreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }
  }

  Future<void> _startGame() async {
    debugPrint('[INPUT] Start button pressed: lobby ${widget.lobbyCode}');
    try {
      final grpc = await GrpcHandler.create();
      final request = StartGameRequest()..lobbyCode = widget.lobbyCode;
      await grpc.gameClient.startGame(request);
      debugPrint('[INPUT] startGame request sent successfully');
    } catch (e) {
      debugPrint('[START GAME] Error: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final players = _controller.currentUpdate.players;
        final isHost = players.any(
          (p) => p.id == AuthState.userId && p.isHost,
        );

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'Spiel erstellen',
              style: TextStyle(
                fontFamily: 'BagelFatOne',
                fontSize: 28,
                color: Colors.white,
              ),
            ),
            toolbarHeight: 80,
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            leadingWidth: 80,
            leading: Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: _leaveLobby,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.white60,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/back.svg',
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // QR CODE
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: QrImageView(
                      data: 'silentvillage://join?code=${widget.lobbyCode}',
                      version: QrVersions.auto,
                      size: 150,
                      backgroundColor: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // LOBBY CODE
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.lobbyCode,
                      style: TextStyle(
                        fontFamily: 'BagelFatOne',
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                        fontSize: 28,
                        letterSpacing: 6,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // PLAYER LIST
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Beigetretene Spieler (${players.length})",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: players.isEmpty
                                ? const Center(
                                    child: Text(
                                      "Warte auf Spieler...",
                                      style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: players.length,
                                    itemBuilder: (_, i) => _PlayerTile(
                                      name: players[i].name,
                                      isHost: players[i].isHost,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // START BUTTON
                  SizedBox(
                    width: 220,
                    child: ElevatedButton(
                      onPressed: isHost ? _startGame : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.9),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Spiel starten",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PlayerTile extends StatelessWidget {
  final String name;
  final bool isHost;

  const _PlayerTile({required this.name, required this.isHost});

  @override
  Widget build(BuildContext context) {
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
            child: Text(
              name[0].toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          if (isHost) const Icon(Icons.star, color: Colors.amber, size: 18),
        ],
      ),
    );
  }
}
