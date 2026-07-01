import 'package:flutter/material.dart';
import 'package:werwolf/screens/intro.dart';
import 'package:werwolf/auth/session_store.dart';
import 'package:werwolf/controllers/game_stream_controller.dart';
import 'package:werwolf/utils/game_assets.dart';
import 'package:werwolf/generated/werwolf.pb.dart';
import 'package:werwolf/widgets/player_display.dart';

class Warteraum extends StatefulWidget {
  final String lobbyCode;

  const Warteraum({super.key, required this.lobbyCode});

  @override
  State<Warteraum> createState() => _WarteraumState();
}

class _WarteraumState extends State<Warteraum> {
  late final GameStreamController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GameStreamController(lobbyCode: widget.lobbyCode);
    _controller.addListener(_onUpdate);
  }

  // Warm the game image cache while players wait in the lobby, so the intro and
  // the night/day screens render with their backgrounds already in place
  // instead of flashing black when the game starts.
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
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18),
              onPressed: _leaveLobby,
            ),
          ),
        ),
        title: const Text(
          'Warteraum',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            final players = _controller.currentUpdate.players;
            final host = players.where((p) => p.isHost);
            final hostName = host.isEmpty ? null : host.first.name;

            return Column(
              children: [
                const SizedBox(height: 40),

                const Text(
                  'Mitspieler',
                  style: TextStyle(
                    fontSize: 36,
                    fontFamily: "BagelFatOne",
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 30),

                Expanded(
                  child: Spieleranzeige(players: players),
                ),

                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    hostName == null
                        ? 'Warte auf den Spielstart...'
                        : '$hostName wird das Spiel starten',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}