import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:werwolf/DayStart.dart';
import 'package:werwolf/Rules.dart';
import 'package:werwolf/auth/auth_state.dart';
import 'package:werwolf/controller/GameViewController.dart';
import 'package:werwolf/controller/game_stream_controller.dart';
import 'package:werwolf/generated/werwolf.pb.dart';
import 'package:werwolf/settings_veiw.dart';
import 'package:werwolf/voting/hexe_voting.dart';
import 'package:werwolf/voting/seher_voting.dart';
import 'package:werwolf/voting/werwolf_voting.dart';
import 'package:werwolf/widgets/role_reveal_card.dart';

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

  // The phase for which this player has already submitted their action, so we
  // don't show the voting screen again after acting.
  Phase? _actedPhase;

  // Last known player list. Private updates (e.g. the seer reveal) omit the
  // player list, so we keep the most recent one to resolve names.
  List<PlayerStatus> _lastPlayers = const [];

  // ticks once a second so the phase_ends_at countdown stays live
  Timer? _ticker;

  // hand off to the day screen only once
  bool _navigatedToDay = false;

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
    _stream.addListener(_onPhase);

    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _stream.removeListener(_onPhase);
    _controller.dispose();
    _stream.dispose();
    super.dispose();
  }

  // Once the night is over, the backend moves the game into the day phases.
  // Hand the stream over to the day screen (which re-subscribes for the lobby).
  void _onPhase() {
    if (_navigatedToDay) return;
    if (!_isDayPhase(_stream.currentUpdate.currentPhase)) return;

    _navigatedToDay = true;
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => DayStart(
          lobbyCode: widget.lobbyCode,
          initialUpdate: _stream.currentUpdate,
        ),
      ),
    );
  }

  static bool _isDayPhase(Phase phase) =>
      phase == Phase.DAY_RESULT ||
      phase == Phase.DAY_DISCUSSION ||
      phase == Phase.DAY_VOTING ||
      phase == Phase.HUNTER_REVENGE ||
      phase == Phase.GAME_END;

  // Remaining seconds in the current phase, or null when no deadline is set.
  int? _secondsLeft(GameUpdate update) {
    if (!update.hasPhaseEndsAt()) return null;
    final secs = update.phaseEndsAt
        .toDateTime()
        .difference(DateTime.now().toUtc())
        .inSeconds;
    return secs < 0 ? 0 : secs;
  }

  // How many werewolves have committed to each target (live). Only wolves ever
  // receive these fields from the backend, so this is empty for everyone else.
  Map<String, int> _wolfVoteCounts(List<PlayerStatus> players) {
    final counts = <String, int>{};
    for (final p in players) {
      if (p.hasVoted && p.votedForTargetId.isNotEmpty) {
        counts.update(p.votedForTargetId, (v) => v + 1, ifAbsent: () => 1);
      }
    }
    return counts;
  }

  // This player's own committed werewolf target, or '' if not yet voted.
  String _ownVotedTarget(List<PlayerStatus> players) {
    final self = AuthState.userId ?? '';
    for (final p in players) {
      if (p.id == self && p.hasVoted) return p.votedForTargetId;
    }
    return '';
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

    // Werewolf voting stays on screen for the whole phase (even after voting) so
    // the wolf keeps seeing the live tally; the vote locks once committed.
    if (update.hasOpenPrompt() &&
        update.openPrompt.whichPrompt() == ActionPrompt_Prompt.werewolf) {
      final ownVote = _ownVotedTarget(players);
      return WerwolfVoting(
        targets: _resolveTargets(players, update.openPrompt.werewolf.candidateIds),
        voteCounts: _wolfVoteCounts(players),
        committedTargetId: ownVote.isNotEmpty ? ownVote : null,
        locked: acted || ownVote.isNotEmpty,
        secondsLeft: _secondsLeft(update),
        onVote: (id) => _submit(
          GameAction(lobbyCode: widget.lobbyCode, vote: VoteAction(targetId: id)),
          phase,
        ),
      );
    }

    if (update.hasOpenPrompt() && !acted) {
      final prompt = update.openPrompt;
      switch (prompt.whichPrompt()) {
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
                    // role card: drag towards the centre to reveal your role;
                    // it appears fixed in the middle while held and vanishes the
                    // moment the finger is lifted.
                    const Positioned(
                      left: 16,
                      bottom: 16,
                      child: RoleRevealCard(),
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
}
