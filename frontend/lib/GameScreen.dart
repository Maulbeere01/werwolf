import 'package:flutter/material.dart';
import 'package:werwolf/controller/game_stream_controller.dart';
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
  late final GameStreamController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GameStreamController(
      lobbyCode: widget.lobbyCode,
      seed: widget.initialUpdate,
    );
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
        final update = _controller.currentUpdate;
        final interactive = !_controller.isReconnecting;

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
          body: Stack(
            children: [
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(update),
                    // displayText replaces announcement — show when non-empty
                    if (update.displayText.isNotEmpty)
                      _buildAnnouncementBanner(update.displayText),
                    Expanded(child: _buildPlayerList(update)),
                    // abilityActive replaces openPrompt
                    if (update.abilityActive)
                      _buildPrompt(update, interactive),
                  ],
                ),
              ),
              if (_controller.isReconnecting) _buildReconnectBadge(context),
            ],
          ),
        );
      },
    );
  }

  // Phase name + role chip (role comes from PlayerStatus, not GameUpdate)
  Widget _buildHeader(GameUpdate update) {
    // Find the local player's role from the players list if privateInfo has it,
    // or derive from abilityActive + phase for now.
    // For a proper role display you'll need to add yourRole to the proto.
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _phaseLabel(update.currentPhase),
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'BagelFatOne',
              fontSize: 28,
            ),
          ),
          // privateInfo carries role/seer-result text from the server
          if (update.privateInfo.isNotEmpty) ...[
            const SizedBox(height: 6),
            _buildPrivateInfoChip(update.privateInfo),
          ],
        ],
      ),
    );
  }

  Widget _buildPrivateInfoChip(String info) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        info,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
    );
  }

  Widget _buildAnnouncementBanner(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.4)),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  Widget _buildPlayerList(GameUpdate update) {
    final players = update.players;
    if (players.isEmpty) {
      return const Center(
        child: Text('Keine Spieler', style: TextStyle(color: Colors.white38)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      itemCount: players.length,
      itemBuilder: (_, i) => _buildPlayerRow(players[i], update.currentPhase),
    );
  }

  Widget _buildPlayerRow(PlayerStatus p, Phase phase) {
    final alive = p.isAlive;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(
            alive ? Icons.person_rounded : Icons.person_off_rounded,
            color: alive ? Colors.white : Colors.white30,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              p.name,
              style: TextStyle(
                color: alive ? Colors.white : Colors.white30,
                fontSize: 16,
                decoration: alive ? null : TextDecoration.lineThrough,
                decorationColor: Colors.white30,
              ),
            ),
          ),
          if (p.isHost)
            const Padding(
              padding: EdgeInsets.only(left: 6),
              child: Icon(Icons.star_rounded, color: Colors.amber, size: 16),
            ),
          if (phase == Phase.DAY_VOTING && p.hasVoted)
            const Padding(
              padding: EdgeInsets.only(left: 6),
              child: Icon(Icons.check_rounded, color: Colors.white54, size: 16),
            ),
        ],
      ),
    );
  }

  // Shown when abilityActive == true; phase tells us which role's turn it is
  Widget _buildPrompt(GameUpdate update, bool interactive) {
    final (title, hint) = switch (update.currentPhase) {
      Phase.NIGHT_WEREWOLVES => ('Angreifen', 'Wählt ein Opfer'),
      Phase.NIGHT_SEER       => ('Untersuchen', 'Wählt einen Spieler'),
      Phase.NIGHT_WITCH      => ('Zaubern', 'Heile oder vergifte'),
      Phase.NIGHT_FOX        => ('Spüren', 'Prüft drei Spieler'),
      Phase.HUNTER_REVENGE   => ('Rächen', 'Erschiesst einen Spieler'),
      Phase.DAY_VOTING       => ('Abstimmen', 'Wählt einen Spieler aus'),
      _                      => ('Aktion', ''),
    };

    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hint.isNotEmpty) ...[
            Text(hint, style: const TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 12),
          ],
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              // TODO: wire up phase-specific target selection and GameAction RPC
              onPressed: interactive ? () {} : null,
              child: Text(title),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReconnectBadge(BuildContext context) {
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
            Text('Verbindung...', style: TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  String _phaseLabel(Phase phase) => switch (phase) {
    Phase.LOBBY            => 'Warte auf Spielstart...',
    Phase.NIGHT_START      => 'Nacht beginnt',
    Phase.NIGHT_WEREWOLVES => 'Werwölfe erwachen',
    Phase.NIGHT_SEER       => 'Seher',
    Phase.NIGHT_WITCH      => 'Hexe',
    Phase.NIGHT_FOX        => 'Fuchs',
    Phase.DAY_RESULT       => 'Morgen',
    Phase.DAY_DISCUSSION   => 'Diskussion',
    Phase.DAY_VOTING       => 'Abstimmung',
    Phase.HUNTER_REVENGE   => 'Jäger',
    Phase.GAME_END         => 'Spiel vorbei',
    _                      => 'Unbekannte Phase',
  };

  String _playerName(String id) {
    for (final p in _controller.currentUpdate.players) {
      if (p.id == id) return p.name;
    }
    return id;
  }
}