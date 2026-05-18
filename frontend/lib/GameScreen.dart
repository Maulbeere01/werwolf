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
  // stream / reconnect statea

  StreamSubscription<GameUpdate>? _subscription;
  late GameUpdate _currentUpdate;

  bool _disposed = false;
  int _retryCount = 0;
  bool _skipDelay = false;

  bool _showReconnecting = false;
  Timer? _feedbackTimer;

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

  void _triggerReconnect() {
    _skipDelay = true;
    _retryCount = 0;
    _feedbackTimer?.cancel();
    if (_showReconnecting && mounted) {
      setState(() => _showReconnecting = false);
    } else {
      _showReconnecting = false;
    }
    _subscription?.cancel();
    _subscription = null;
    if (!(_streamCompleter?.isCompleted ?? true)) _streamCompleter!.complete();
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

      _retryCount++;
      final delay = Duration(seconds: (1 << (_retryCount - 1)).clamp(1, 30));
      debugPrint('[GAME STREAM] Retry $_retryCount in ${delay.inSeconds}s');

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

  //rendering
  @override
  Widget build(BuildContext context) {
    final update = _currentUpdate;
    final interactive = !_showReconnecting;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(update),
                if (update.hasAnnouncement()) _buildAnnouncement(update),
                if (update.hasPause() && update.pause.isPaused)
                  _buildPauseBanner(update.pause),
                Expanded(child: _buildPlayerList(update)),
                if (update.hasOpenPrompt()) _buildPrompt(update, interactive),
              ],
            ),
          ),
          if (_showReconnecting) _buildReconnectBadge(context),
        ],
      ),
    );
  }

  // Phase name + role chip
  Widget _buildHeader(GameUpdate update) {
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
          if (update.yourRole != Role.ROLE_UNSPECIFIED) ...[
            const SizedBox(height: 6),
            _buildRoleChip(update.yourRole),
          ],
        ],
      ),
    );
  }

  Widget _buildRoleChip(Role role) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Du bist: ${_roleLabel(role)}',
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
    );
  }

  // Yellow card for night deaths, vote results, etc.
  Widget _buildAnnouncement(GameUpdate update) {
    final text = _announcementText(update.announcement);
    if (text.isEmpty) return const SizedBox.shrink();

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

  Widget _buildPauseBanner(PauseState pause) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.pause_circle_outline, color: Colors.white70, size: 16),
          const SizedBox(width: 6),
          Text(
            'Pausiert  ${pause.voteCount}/${pause.votesNeeded}',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
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

  // Action card shown when the server sends an openPrompt for this player.
  // Each branch is a stub — add target-selection UI here per phase.
  Widget _buildPrompt(GameUpdate update, bool interactive) {
    final prompt = update.openPrompt;
    final (title, hint) = switch (prompt.whichPrompt()) {
      ActionPrompt_Prompt.werewolf => ('Angreifen', 'Wählt ein Opfer'),
      ActionPrompt_Prompt.seer     => ('Untersuchen', 'Wählt einen Spieler'),
      ActionPrompt_Prompt.witch    => ('Zaubern', 'Heile oder vergifte'),
      ActionPrompt_Prompt.fox      => ('Spüren', 'Prüft drei Spieler'),
      ActionPrompt_Prompt.hunter   => ('Rächen', 'Erschiesst einen Spieler'),
      _                            => ('Aktion', ''),
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
            Text(
              hint,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 12),
          ],
          SizedBox(
            width: double.infinity,
            child: FilledButton(
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
            Text(
              'Verbindung...',
              style: TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  // ── helpers ─────────────────────────────────────────────────────────────────

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

  String _roleLabel(Role role) => switch (role) {
    Role.WEREWOLF       => 'Werwolf',
    Role.VILLAGER       => 'Dorfbewohner',
    Role.SEER           => 'Seher',
    Role.WITCH          => 'Hexe',
    Role.FOX            => 'Fuchs',
    Role.VILLAGE_IDIOT  => 'Dorftrottel',
    Role.HUNTER         => 'Jäger',
    _                   => 'Unbekannt',
  };

  String _announcementText(PublicAnnouncement a) {
    if (a.hasNightDeath()) {
      final name = _playerName(a.nightDeath.playerId);
      final cause = switch (a.nightDeath.cause) {
        EliminationCause.KILLED_BY_WEREWOLVES => 'von den Werwölfen getötet',
        EliminationCause.KILLED_BY_WITCH      => 'von der Hexe vergiftet',
        EliminationCause.VOTED_OUT            => 'rausgewählt',
        EliminationCause.CAUSE_HUNTER_REVENGE => 'vom Jäger erschossen',
        _                                     => 'ausgeschieden',
      };
      return '$name wurde $cause.';
    }
    if (a.hasNoDeath()) return 'Heute Nacht ist niemand gestorben.';
    if (a.hasVoteResult()) {
      if (a.voteResult.tied) return 'Unentschieden niemand scheidet aus.';
      return '${_playerName(a.voteResult.eliminatedPlayerId)} scheidet aus.';
    }
    if (a.hasHunterShot()) {
      return '${_playerName(a.hunterShot.shooterId)} '
          'erschiesst ${_playerName(a.hunterShot.targetId)}.';
    }
    if (a.hasGameEnd()) {
      return a.gameEnd.winningTeam == Role.WEREWOLF
          ? 'Die Werwölfe gewinnen!'
          : 'Das Dorf gewinnt!';
    }
    return '';
  }

  String _playerName(String id) {
    for (final p in _currentUpdate.players) {
      if (p.id == id) return p.name;
    }
    return id;
  }
}
