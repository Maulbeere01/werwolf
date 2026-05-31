import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:werwolf/Rules.dart';
import 'package:werwolf/controller/game_stream_controller.dart';
import 'package:werwolf/generated/werwolf.pb.dart';
import 'package:werwolf/settings_veiw.dart';
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

    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
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
      return '${_playerName(a.nightDeath.playerId)} wurde in der Nacht getötet.';
    }
    if (a.hasNoDeath()) return 'Heute Nacht ist niemand gestorben.';
    if (a.hasVoteResult()) {
      if (a.voteResult.tied) return 'Unentschieden — niemand scheidet aus.';
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
            ],
          );
        },
      ),
    );
  }
}
