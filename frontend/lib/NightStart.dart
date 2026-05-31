import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:werwolf/Card.dart' as card_overlay;
import 'package:werwolf/Rules.dart';
import 'package:werwolf/auth/auth_state.dart';
import 'package:werwolf/controller/GameViewController.dart';
import 'package:werwolf/controller/game_stream_controller.dart';
import 'package:werwolf/generated/werwolf.pb.dart';
import 'package:werwolf/settings_veiw.dart';
import 'package:werwolf/voting/hexe_voting.dart';
import 'package:werwolf/voting/seher_voting.dart';
import 'package:werwolf/voting/werwolf_voting.dart';

class NightStart extends StatefulWidget {
  final String lobbyCode;
  final GameUpdate initialUpdate;

  const NightStart({
    super.key,
    required this.lobbyCode,
    required this.initialUpdate,
  });

  @override
  State<NightStart> createState() => _NightStartState();
}

class _NightStartState extends State<NightStart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final GameStreamController _stream;
  bool _cardIsOverDropZone = false;

  // The phase for which this player has already submitted their action, so we
  // don't show the voting screen again after acting.
  Phase? _actedPhase;

  // Last known player list. Private updates (e.g. the seer reveal) omit the
  // player list, so we keep the most recent one to resolve names.
  List<PlayerStatus> _lastPlayers = const [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..forward();

    _stream = GameStreamController(
      lobbyCode: widget.lobbyCode,
      seed: widget.initialUpdate,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _stream.dispose();
    super.dispose();
  }

  Future<void> _submit(GameAction action, Phase phase) async {
    final ok = await GameViewController.performAction(action);
    if (!mounted) return;
    if (ok) {
      setState(() => _actedPhase = phase);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aktion fehlgeschlagen')),
      );
    }
  }

  // Returns the role voting screen when it is this player's turn, the result/
  // waiting screen after they acted, or null to show the plain night view.
  Widget? _buildActionOverlay(GameUpdate update) {
    if (update.players.isNotEmpty) {
      _lastPlayers = update.players.toList();
    }
    final players = _lastPlayers;
    final phase = update.currentPhase;
    final acted = _actedPhase == phase;

    if (update.hasOpenPrompt() && !acted) {
      final prompt = update.openPrompt;
      switch (prompt.whichPrompt()) {
        case ActionPrompt_Prompt.werewolf:
          return WerwolfVoting(
            targets: _resolveTargets(players, prompt.werewolf.candidateIds),
            onVote: (id) => _submit(
              GameAction(lobbyCode: widget.lobbyCode, vote: VoteAction(targetId: id)),
              phase,
            ),
          );
        case ActionPrompt_Prompt.seer:
          return SeherVoting(
            targets: _resolveTargets(players, prompt.seer.candidateIds),
            players: players,
            onInspect: (id) => _submit(
              GameAction(lobbyCode: widget.lobbyCode, seer: SeerAction(targetId: id)),
              phase,
            ),
          );
        case ActionPrompt_Prompt.witch:
          final w = prompt.witch;
          return HexeVoting(
            attackedPlayerId: w.attackedPlayerId,
            hasHealPotion: w.hasHealPotion,
            hasPoisonPotion: w.hasPoisonPotion,
            players: players,
            selfId: AuthState.userId ?? '',
            onSubmit: (heal, poisonId) => _submit(
              GameAction(
                lobbyCode: widget.lobbyCode,
                witch: WitchAction(
                  healTarget: heal,
                  poisonTargetId: poisonId ?? '',
                ),
              ),
              phase,
            ),
          );
        default:
          return null; // fox / hunter not handled on this screen yet
      }
    }

    if (acted) {
      // the seer gets to see the verdict; everyone else just waits
      if (update.hasYourResults() && update.yourResults.hasSeerReveal()) {
        return SeherVoting(
          targets: const [],
          players: players,
          reveal: update.yourResults.seerReveal,
          onInspect: (_) {},
        );
      }
      return _waitingOverlay();
    }

    return null;
  }

  // Players that may be targeted. Uses the server-provided candidate list when
  // present, otherwise falls back to every living player except this one.
  List<PlayerStatus> _resolveTargets(
    List<PlayerStatus> players,
    List<String> candidateIds,
  ) {
    if (candidateIds.isNotEmpty) {
      return players.where((p) => candidateIds.contains(p.id)).toList();
    }
    final self = AuthState.userId ?? '';
    return players.where((p) => p.isAlive && p.id != self).toList();
  }

  Widget _waitingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.85),
      child: const Center(
        child: Text(
          'Aktion übermittelt.\nWarte auf die anderen...',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, fontSize: 18),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 80,
        leading: Align(
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
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
        actions: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const EinstellungenView(),
                    ),
                  );
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.white60,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/settings.svg',
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      body: ListenableBuilder(
        listenable: _stream,
        builder: (context, _) {
          final update = _stream.currentUpdate;
          final overlay = _buildActionOverlay(update);

          return Stack(
            children: [
              Container(color: Colors.black),

              Positioned(
                top: MediaQuery.of(context).size.height * 0.0,
                left:
                    MediaQuery.of(context).size.width * 0.00 -
                    (MediaQuery.of(context).size.width * 2) / 2,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.rotate(
                      // 180° = pi radians
                      angle: _controller.value * 3.1415926535,
                      child: child,
                    );
                  },
                  child: Image.asset(
                    'assets/BG/Sky Spin.png',
                    width: MediaQuery.of(context).size.width * 3,
                    height: MediaQuery.of(context).size.width * 3,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox.expand(
                child: Image.asset('assets/BG/day FG.png', fit: BoxFit.cover),
              ),

              FadeTransition(
                opacity: _controller,
                child: SizedBox.expand(
                  child: Image.asset('assets/BG/night FG.png', fit: BoxFit.cover),
                ),
              ),

              // 2. Content on top
              SafeArea(
                child: Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FadeTransition(
                            opacity: Tween<double>(
                              begin: 1.0,
                              end: 0.0,
                            ).animate(_controller),
                            child: const Text(
                              "Die Nacht bricht ein",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'BagelFatOne',
                                fontSize: 36,
                                color: Color.fromARGB(255, 51, 50, 94),
                              ),
                            ),
                          ),

                          const SizedBox(height: 350),

                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => const Rules(),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
                                ),
                              );
                            },
                            child: Text(
                              "Regeln ansehen",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.7),
                                    offset: const Offset(1, 1),
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 16,
                      bottom: 16,
                      child: Draggable<String>(
                        data: 'open-card',
                        feedback: _buildCardPreview(),
                        childWhenDragging: const SizedBox.shrink(),
                        onDragStarted: () =>
                            setState(() => _cardIsOverDropZone = false),
                        child: Transform.translate(
                          offset: const Offset(-80, 100),
                          child: Transform.rotate(
                            angle: 0.1,
                            child: _buildCardCorner(),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 140,
                      bottom: 140,
                      child: DragTarget<String>(
                        builder: (context, candidateData, rejectedData) {
                          final isActive =
                              candidateData.isNotEmpty || _cardIsOverDropZone;

                          return Center(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              width: 160,
                              height: 220,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? Colors.white.withOpacity(0.18)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: isActive
                                      ? Colors.white70
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  isActive ? 'Karte ablegen' : '',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.6),
                                        offset: const Offset(1, 1),
                                        blurRadius: 3,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        onWillAcceptWithDetails: (details) {
                          setState(() => _cardIsOverDropZone = true);
                          return details.data == 'open-card';
                        },
                        onLeave: (_) =>
                            setState(() => _cardIsOverDropZone = false),
                        onAcceptWithDetails: (_) {
                          setState(() => _cardIsOverDropZone = false);
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (dialogContext) => const card_overlay.Card(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // role action screen, shown on top when it is this player's turn
              if (overlay != null) Positioned.fill(child: overlay),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCardCorner({
    double scale = 1 / 2.2,
    double angle = 0,
    Offset offset = Offset.zero,
  }) {
    const double cardWidth = 340;
    const double cardHeight = 500;
    return Material(
      color: Colors.transparent,
      child: Transform.translate(
        offset: offset,
        child: Transform.rotate(
          angle: angle,
          child: Container(
            width: cardWidth * scale,
            height: cardHeight * scale,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  offset: const Offset(0, 6),
                  blurRadius: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardPreview() {
    return Material(
      color: Colors.transparent,
      child: _buildCardCorner(
        scale: 0.45,
        angle: 0.01,
        offset: const Offset(-80, 100),
      ),
    );
  }
}
