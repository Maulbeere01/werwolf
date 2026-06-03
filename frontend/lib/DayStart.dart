import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:werwolf/NightStart.dart';
import 'package:werwolf/Rules.dart';
import 'package:werwolf/auth/auth_state.dart';
import 'package:werwolf/controller/GameViewController.dart';
import 'package:werwolf/controller/game_stream_controller.dart';
import 'package:werwolf/game_assets.dart';
import 'package:werwolf/generated/werwolf.pb.dart';
import 'package:werwolf/role_display.dart';
import 'package:werwolf/settings_veiw.dart';
import 'package:werwolf/wahlScreen.dart';
import 'package:werwolf/voting/dorf_voting.dart';
import 'package:werwolf/widgets/connection_status.dart';
import 'package:werwolf/widgets/death_gate.dart';
import 'package:werwolf/widgets/endscreen.dart';
import 'package:werwolf/widgets/role_reveal_card.dart';

class DayStart extends StatefulWidget {
  final String lobbyCode;
  final GameUpdate initialUpdate;

  const DayStart({
    super.key,
    required this.lobbyCode,
    required this.initialUpdate,
  });

  @override
  State<DayStart> createState() => _DayStartState();
}

class _DayStartState extends State<DayStart> with SingleTickerProviderStateMixin {
  late final AnimationController _controller; // night -> day transition
  late final GameStreamController _stream;
  static const double halfTurn = 3.1415926535;

  // ticks once a second so the phase_ends_at countdown stays live
  Timer? _ticker;

  // the phase for which this player has already cast their day vote, so we show
  // the waiting screen instead of the vote screen after they voted
  Phase? _votedPhase;

  // set once we start navigating away from the day screen (to night or end)
  bool _leaving = false;

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
    _stream.addListener(_onTransition);

    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
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

  static bool _isNightPhase(Phase phase) =>
      phase == Phase.NIGHT_START ||
      phase == Phase.NIGHT_WEREWOLVES ||
      phase == Phase.NIGHT_SEER ||
      phase == Phase.NIGHT_WITCH ||
      phase == Phase.NIGHT_FOX;

  // Drives the transitions out of the day screen:
  //  - GAME_END  -> the end screen (a win condition was met)
  //  - next night -> first show the day-vote result reveal for 5s (so the animation plays), then hand over to the night screen
  Future<void> _onTransition() async {
    if (_leaving) return;
    final update = _stream.currentUpdate;
    if (update.players.isEmpty) return;
    final phase = update.currentPhase;

    if (phase == Phase.GAME_END) {
      _leaving = true;
      _stream.removeListener(_onTransition);
      // when the werewolves win via a night kill we arrive here straight from the
      // night, so wait for the night->day animation to finish before the end
      // screen; if it already played (e.g. game ended by a day vote), go now
      _goToEndscreenAfterAnimation(update);
      return;
    }

    if (_isNightPhase(phase)) {
      _leaving = true;
      _stream.removeListener(_onTransition);

      // the day vote result reveal auto-closes after 5s
      if (update.hasAnnouncement() && update.announcement.hasVoteResult()) {
        final vr = update.announcement.voteResult;
        final eliminated = (vr.tied || vr.eliminatedPlayerId.isEmpty)
            ? null
            : _playerOf(vr.eliminatedPlayerId);
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => WahlergebnisScreen(
              spielerName: eliminated?.name,
              // the role is revealed on death
              rolle: eliminated != null ? roleName(eliminated.role) : null,
            ),
          ),
        );
      }

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => NightStart(
            lobbyCode: widget.lobbyCode,
            initialUpdate: _stream.currentUpdate,
          ),
        ),
      );
    }
  }

  void _goToEndscreenAfterAnimation(GameUpdate update) {
    void go() {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => Endscreen(gewinner: winningTeamName(winningTeamOf(update))),
        ),
      );
    }

    if (_controller.status == AnimationStatus.completed) {
      go();
    } else {
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) go();
      });
    }
  }

  @override
  void dispose() {
    _stream.removeListener(_onTransition);
    _ticker?.cancel();
    _controller.dispose();
    _stream.dispose();
    super.dispose();
  }

  int? _secondsLeft(GameUpdate update) {
    if (!update.hasPhaseEndsAt()) return null;
    final secs = update.phaseEndsAt
        .toDateTime()
        .difference(DateTime.now().toUtc())
        .inSeconds;
    return secs < 0 ? 0 : secs;
  }

  String _phaseTitle(Phase phase) => switch (phase) {
        Phase.DAY_RESULT => 'Der Tag beginnt',
        Phase.DAY_DISCUSSION => 'Diskussion',
        Phase.DAY_VOTING => 'Abstimmung',
        Phase.HUNTER_REVENGE => 'Der Jäger',
        Phase.GAME_END => 'Spiel vorbei',
        _ => 'Der Tag beginnt',
      };

  String _announcementText(PublicAnnouncement a) {
    if (a.hasNightDeath()) {
      final names =
          a.nightDeath.deaths.map((d) => _playerName(d.playerId)).toList();
      if (names.isEmpty) return 'Heute Nacht ist niemand gestorben.';
      if (names.length == 1) {
        return '${names.first} wurde in der Nacht getötet.';
      }
      final last = names.removeLast();
      return '${names.join(', ')} und $last wurden in der Nacht getötet.';
    }
    if (a.hasNoDeath()) return 'Heute Nacht ist niemand gestorben.';
    if (a.hasVoteResult()) {
      if (a.voteResult.tied) return 'Unentschieden: niemand scheidet aus.';
      return '${_playerName(a.voteResult.eliminatedPlayerId)} scheidet aus.';
    }
    if (a.hasGameEnd()) {
      return a.gameEnd.winningTeam == Role.WEREWOLF
          ? 'Die Werwölfe gewinnen!'
          : 'Das Dorf gewinnt!';
    }
    return '';
  }

  String _playerName(String id) {
    for (final p in _stream.currentUpdate.players) {
      if (p.id == id) return p.name;
    }
    return id;
  }

  PlayerStatus? _playerOf(String id) {
    for (final p in _stream.currentUpdate.players) {
      if (p.id == id) return p;
    }
    return null;
  }

  // The day vote screen, shown to every living player during DAY_VOTING. It
  // stays up for the whole phase (even after voting) so the live tally keeps
  // updating; the vote locks once committed. Null outside the vote phase and for
  // dead players, who no longer take part.
  Widget? _buildVoteOverlay(GameUpdate update) {
    if (update.currentPhase != Phase.DAY_VOTING) return null;

    final self = AuthState.userId ?? '';
    final players = update.players;
    final selfAlive = players.any((p) => p.id == self && p.isAlive);
    if (!selfAlive) return null;

    final ownVote = _ownDayVote(players); // null = not voted, '' = skip, id = target
    // you may also vote for yourself; your own tile then shows the yellow tally
    // of how many others voted for you
    final targets = players.where((p) => p.isAlive).toList();
    return DorfVoting(
      targets: targets,
      voteCounts: _dayVoteCounts(players),
      committedTargetId: ownVote,
      locked: ownVote != null || _votedPhase == Phase.DAY_VOTING,
      secondsLeft: _secondsLeft(update),
      onVote: _submitVote,
    );
  }

  // How many OTHER players voted for each target (live, public). Own vote is
  // excluded (it shows as the committed checkmark, not a yellow dot), as are
  // abstentions (empty target).
  Map<String, int> _dayVoteCounts(List<PlayerStatus> players) {
    final self = AuthState.userId ?? '';
    final counts = <String, int>{};
    for (final p in players) {
      if (p.id == self) continue;
      if (p.hasVoted && p.votedForTargetId.isNotEmpty) {
        counts.update(p.votedForTargetId, (v) => v + 1, ifAbsent: () => 1);
      }
    }
    return counts;
  }

  // This player's own day vote: null if not voted, '' if abstained, else target.
  String? _ownDayVote(List<PlayerStatus> players) {
    final self = AuthState.userId ?? '';
    for (final p in players) {
      if (p.id == self) return p.hasVoted ? p.votedForTargetId : null;
    }
    return null;
  }

  Future<void> _submitVote(String targetId) async {
    final ok = await GameViewController.performAction(
      GameAction(
        lobbyCode: widget.lobbyCode,
        vote: VoteAction(targetId: targetId),
      ),
    );
    if (!mounted) return;
    if (ok) {
      setState(() => _votedPhase = Phase.DAY_VOTING);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Abstimmung fehlgeschlagen')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConnectionStatusScope(
      controller: _stream,
      child: DeathGate(
        controller: _stream,
        child: Scaffold(
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
                child: SvgPicture.asset('assets/icons/back.svg', width: 20, height: 20),
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
                    MaterialPageRoute(builder: (context) => const EinstellungenView()),
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
                    child: SvgPicture.asset('assets/icons/settings.svg', width: 20, height: 20),
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
          final secondsLeft = _secondsLeft(update);
          final announcement =
              update.hasAnnouncement() ? _announcementText(update.announcement) : '';
          final voteOverlay = _buildVoteOverlay(update);

          return Stack(
            children: [
              Container(color: Colors.black),

              // spinning sky as the night rolls over into day
              Positioned(
                top: MediaQuery.of(context).size.height * 0.0,
                left: MediaQuery.of(context).size.width * 0.00 -
                    (MediaQuery.of(context).size.width * 2) / 2,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: halfTurn + _controller.value * halfTurn,
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

              // night foreground fades out, revealing the day
              FadeTransition(
                opacity: Tween<double>(begin: 1.0, end: 0.0).animate(_controller),
                child: SizedBox.expand(
                  child: Image.asset('assets/BG/night FG.png', fit: BoxFit.cover),
                ),
              ),

              SafeArea(
                child: Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          const SizedBox(height: 80),

                          Text(
                            _phaseTitle(update.currentPhase),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'BagelFatOne',
                              fontSize: 40,
                              color: Color.fromARGB(255, 61, 72, 99),
                            ),
                          ),

                          if (announcement.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32),
                              child: Text(
                                announcement,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
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
                          ],

                          const Spacer(flex: 2),

                          if (secondsLeft != null)
                            Text(
                              '$secondsLeft Sekunden übrig...',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 20,
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

                          const Spacer(flex: 2),

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
                    const Positioned(
                      left: 16,
                      bottom: 16,
                      child: RoleRevealCard(),
                    ),
                  ],
                ),
              ),

              // day vote screen, shown on top during DAY_VOTING
              if (voteOverlay != null) Positioned.fill(child: voteOverlay),
            ],
          );
        },
      ),
      ),
      ),
    );
  }
}
