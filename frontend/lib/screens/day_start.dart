import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:werwolf/screens/night_start.dart';
import 'package:werwolf/screens/rules.dart';
import 'package:werwolf/auth/auth_state.dart';
import 'package:werwolf/controllers/game_view_controller.dart';
import 'package:werwolf/controllers/game_stream_controller.dart';
import 'package:werwolf/utils/game_assets.dart';
import 'package:werwolf/generated/werwolf.pb.dart';
import 'package:werwolf/utils/role_display.dart';
import 'package:werwolf/screens/settings_view.dart';
import 'package:werwolf/screens/vote_screen.dart';
import 'package:werwolf/voting/village_voting.dart';
import 'package:werwolf/voting/hunter_voting.dart';
import 'package:werwolf/widgets/connection_status.dart';
import 'package:werwolf/widgets/death_gate.dart';
import 'package:werwolf/widgets/end_screen.dart';
import 'package:werwolf/widgets/role_reveal_card.dart';
import 'package:werwolf/widgets/sabotage_notice.dart';

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

  // set once this (dead) hunter has fired their revenge shot, so the picker
  // disappears immediately instead of lingering until the next snapshot
  bool _hunterShot = false;

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
      phase == Phase.NIGHT_CUPID ||
      phase == Phase.NIGHT_WEREWOLVES ||
      phase == Phase.NIGHT_SEER ||
      phase == Phase.NIGHT_WITCH ||
      phase == Phase.NIGHT_FOX ||
      phase == Phase.NIGHT_SABOTEUR;

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

      // if the game ended on a day vote, reveal the lynch result first (the
      if (update.hasAnnouncement() && update.announcement.hasVoteResult()) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                _voteResultScreen(update.announcement.voteResult),
          ),
        );
        if (!mounted) return;
        _goToEndscreen(update);
      } else {
        // werewolves won via a night kill: we arrive here straight from the
        // night, so wait for the night->day animation to finish first
        _goToEndscreenAfterAnimation(update);
      }
      return;
    }

    if (_isNightPhase(phase)) {
      _leaving = true;
      _stream.removeListener(_onTransition);

      final self = AuthState.userId ?? '';
      final selfDead = _selfIsDead(update);

      // Show the day-vote result reveal (auto-closes after 5s) to living players
      // and to the player who was just lynched. A player who died earlier stays
      // on their death screen and is not interrupted by it.
      final hasVote = update.hasAnnouncement() && update.announcement.hasVoteResult();
      // the lynched player and a lover who died of heartbreak with them both see
      // the result reveal before their own death screen
      final vr = hasVote ? update.announcement.voteResult : null;
      final showReveal = vr != null &&
          (!selfDead ||
              vr.eliminatedPlayerId == self ||
              vr.alsoDiedIds.contains(self));
      if (showReveal) {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => _voteResultScreen(vr)),
        );
      }

      if (!mounted) return;

      // A player who was just lynched does not follow the village into the
      // night: they stay on this screen so the DeathGate shows their personal
      // death screen right after the "X ist tot" vote reveal.
      if (selfDead) return;

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

  bool _selfIsDead(GameUpdate update) {
    final self = AuthState.userId ?? '';
    for (final p in update.players) {
      if (p.id == self) return !p.isAlive;
    }
    return false;
  }

  void _goToEndscreen(GameUpdate update) {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => Endscreen(gewinner: winningTeamName(winningTeamOf(update))),
      ),
    );
  }

  void _goToEndscreenAfterAnimation(GameUpdate update) {
    if (_controller.status == AnimationStatus.completed) {
      _goToEndscreen(update);
    } else {
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) _goToEndscreen(update);
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
      final lynched = _playerName(a.voteResult.eliminatedPlayerId);
      if (a.voteResult.alsoDiedIds.isEmpty) return '$lynched scheidet aus.';
      // a lover was lynched and their partner died of heartbreak
      final partners =
          a.voteResult.alsoDiedIds.map(_playerName).join(', ');
      return '$lynched scheidet aus. $partners stirbt aus Liebeskummer.';
    }
    if (a.hasHunterShot()) {
      return '${_playerName(a.hunterShot.shooterId)} (Jäger) reißt '
          '${_playerName(a.hunterShot.targetId)} mit in den Tod.';
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

  // The day-vote result reveal: the lynched player (with their role, revealed on
  // death) and, if a lover was lynched, the partner who died of heartbreak.
  WahlergebnisScreen _voteResultScreen(VoteResultEvent vr) {
    final eliminated = (vr.tied || vr.eliminatedPlayerId.isEmpty)
        ? null
        : _playerOf(vr.eliminatedPlayerId);
    final partner =
        vr.alsoDiedIds.isNotEmpty ? _playerOf(vr.alsoDiedIds.first) : null;
    return WahlergebnisScreen(
      spielerName: eliminated?.name,
      rolle: eliminated != null ? roleName(eliminated.role) : null,
      partnerName: partner?.name,
      partnerRolle: partner != null ? roleName(partner.role) : null,
    );
  }

  // The day vote screen, shown to every living player during DAY_VOTING. It
  // stays up for the whole phase (even after voting) so the live tally keeps
  // updating; the vote locks once committed. Null outside the vote phase and for
  // dead players, who no longer take part.
  Widget? _buildVoteOverlay(GameUpdate update) {
    if (update.currentPhase != Phase.DAY_VOTING) return null;
    // the sabotaged player takes no part in the vote (see _buildSabotageOverlay)
    if (update.youAreSabotaged) return null;

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

  // The hunter's revenge picker, shown to the (dead) hunter during HUNTER_REVENGE.
  // The DeathGate keeps them on this screen (you_must_take_revenge) until they
  // shoot; afterwards the death screen takes over.
  Widget? _buildHunterOverlay(GameUpdate update) {
    if (update.currentPhase != Phase.HUNTER_REVENGE) return null;
    if (_hunterShot) return null;
    if (!update.hasOpenPrompt() ||
        update.openPrompt.whichPrompt() != ActionPrompt_Prompt.hunter) {
      return null;
    }
    final targets = update.players.where((p) => p.isAlive).toList();
    return HunterVoting(
      targets: targets,
      secondsLeft: _secondsLeft(update),
      onShoot: _submitHunterShot,
    );
  }

  Future<void> _submitHunterShot(String targetId) async {
    final ok = await GameViewController.performAction(
      GameAction(
        lobbyCode: widget.lobbyCode,
        hunter: HunterAction(targetId: targetId),
      ),
    );
    if (!mounted) return;
    if (ok) {
      setState(() => _hunterShot = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Schuss fehlgeschlagen')),
      );
    }
  }

  // The sabotaged player sits out the whole day: during the discussion and the
  // vote they see the sabotage notice instead of the normal day UI. A dead
  // player is handled by the DeathGate and never reaches here.
  Widget? _buildSabotageOverlay(GameUpdate update) {
    if (!update.youAreSabotaged) return null;
    final phase = update.currentPhase;
    if (phase != Phase.DAY_DISCUSSION && phase != Phase.DAY_VOTING) return null;
    return SabotageNotice(secondsLeft: _secondsLeft(update));
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
          final sabotageOverlay = _buildSabotageOverlay(update);
          final hunterOverlay = _buildHunterOverlay(update);

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
                    Positioned(
                      left: 16,
                      bottom: 16,
                      child: RoleRevealCard(
                        role: selfRoleOf(update),
                        partnerName: update.loverPartnerId.isNotEmpty
                            ? _playerName(update.loverPartnerId)
                            : null,
                      ),
                    ),
                  ],
                ),
              ),

              // day vote screen, shown on top during DAY_VOTING
              if (voteOverlay != null) Positioned.fill(child: voteOverlay),

              // sabotage notice, shown on top for the silenced player all day
              if (sabotageOverlay != null)
                Positioned.fill(child: sabotageOverlay),

              // hunter revenge picker, shown to the dead hunter during HUNTER_REVENGE
              if (hunterOverlay != null)
                Positioned.fill(child: hunterOverlay),
            ],
          );
        },
      ),
      ),
      ),
    );
  }
}
