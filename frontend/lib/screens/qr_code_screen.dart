import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:werwolf/screens/intro.dart';
import 'package:werwolf/services/grpc_handler.dart';
import 'package:werwolf/screens/home_screen.dart';
import 'package:werwolf/auth/auth_state.dart';
import 'package:werwolf/auth/session_store.dart';
import 'package:werwolf/controllers/game_stream_controller.dart';
import 'package:werwolf/utils/game_assets.dart';
import 'package:werwolf/generated/werwolf.pb.dart';
import 'package:werwolf/widgets/connection_status.dart';

class QRCodeScreen extends StatefulWidget {
  final String lobbyCode;

  final int requiredPlayers;

  const QRCodeScreen({
    super.key,
    required this.lobbyCode,
    this.requiredPlayers = 0,
  });

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

  bool _precached = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_precached) {
      _precached = true;
      precacheGameAssets(context);
    }
  }

  // navigate to the intro as soon as the server signals the game has started.
  // TODO: the intro currently stays forever; once the intro timer exists and
  // the backend waits for it, advance from here to the next screen.
  Future<void> _onUpdate() async {
    final phase = _controller.currentUpdate.currentPhase;
    if (phase == Phase.PHASE_UNSPECIFIED || phase == Phase.LOBBY) return;

    _controller.removeListener(_onUpdate);
    if (!mounted) return;

    // make sure the backgrounds are decoded before we show the intro
    await precacheGameAssets(context);
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => Intro(
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
      final grpc = await GrpcHandler.instance();
      final request = StartGameRequest()..lobbyCode = widget.lobbyCode;
      await grpc.gameClient.startGame(request);
      debugPrint('[INPUT] startGame request sent successfully');
    } catch (e) {
      debugPrint('[START GAME] Error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Spiel kann noch nicht gestartet werden.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConnectionStatusScope(
      controller: _controller,
      child: ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final players = _controller.currentUpdate.players;
        final isHost = players.any(
          (p) => p.id == AuthState.userId && p.isHost,
        );
        // enough players if the configured count is reached
        final enoughPlayers = widget.requiredPlayers <= 0 ||
            players.length >= widget.requiredPlayers;
        final canStart = isHost && enoughPlayers;
        final missing = widget.requiredPlayers - players.length;

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
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
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
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

                  // waiting hint shown to the host until the lobby is full
                  if (isHost && !enoughPlayers)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        missing == 1
                            ? "Warte auf noch 1 Spieler..."
                            : "Warte auf noch $missing Spieler...",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ),

                  // START BUTTON
                  SizedBox(
                    width: 220,
                    child: ElevatedButton(
                      onPressed: canStart ? _startGame : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.9),
                        foregroundColor: Colors.black,
                        disabledBackgroundColor: Colors.white.withOpacity(0.3),
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
      ),
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
