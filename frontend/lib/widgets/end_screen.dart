import 'dart:async';
import 'package:flutter/material.dart';
import 'package:werwolf/auth/session_store.dart';
import 'package:werwolf/generated/werwolf.pb.dart';
import 'package:werwolf/narration/narration_service.dart';
import 'package:werwolf/screens/create_game.dart';
import 'package:werwolf/screens/home_screen.dart';
import 'package:werwolf/services/grpc_handler.dart';
import 'package:werwolf/utils/stats_display.dart';
import 'package:werwolf/widgets/progress_bar.dart';

class Endscreen extends StatefulWidget {
  /// Full result sentence, e.g. "Die Werwölfe haben gewonnen" or "Das Dorf hat
  /// gewonnen" (see winningTeamSentence).
  final String gewinner;

  const Endscreen({
    super.key,
    this.gewinner = "Die Werwölfe haben gewonnen",
  });

  @override
  State<Endscreen> createState() => _EndscreenState();
}

class _EndscreenState extends State<Endscreen> {
  Timer? _startTimer;

  Alignment _textAlignment = Alignment.center;
  bool _zeigeDetails = false;
  UserProfile? _profile;

  @override
  void initState() {
    super.initState();

    _startTimer = Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _textAlignment = const Alignment(0, -0.75);
        });
      }
    });

    _loadProfile();
  }

  // The backend persists the game result before broadcasting the GAME_END
  // snapshot that lands us on this screen, so this already reflects the
  // just-finished round.
  Future<void> _loadProfile() async {
    try {
      final grpc = await GrpcHandler.instance();
      final profile = await grpc.userClient.getProfile(ProfileRequest());
      if (mounted) {
        setState(() {
          _profile = profile;
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print('[ENDSCREEN] profile load skipped: $e');
    }
  }

  @override
  void dispose() {
    _startTimer?.cancel();
    super.dispose();
  }

  Future<void> _leaveTo(WidgetBuilder builder) async {
    NarrationService.instance.reset();
    await SessionStore.clearLobbyCode();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: builder),
      (route) => false,
    );
  }

  // The cap doubles every time the score reaches it (10 -> 20 -> 40 -> ...),
  // so this never maxes out no matter how high the score climbs.
  Widget _statProgressRow(String label, int score) {
    final cap = progressCapFor(score);
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
                fontFamily: 'BagelFatOne', color: Colors.white, fontSize: 18),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: SpieleProgressBar(
            aktuelleSpielNummer: score,
            gesamtSpiele: cap,
            starteAnimation: _zeigeDetails,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _leaveTo((_) => const Homescreen());
      },
      child: Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: theme.colorScheme.onPrimaryContainer,
        ),
        child: Stack(
          children: [

            // Gewinner Text
            AnimatedAlign(
              alignment: _textAlignment,
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeInOutCubic,
              onEnd: () {
                setState(() {
                  _zeigeDetails = true;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  widget.gewinner,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: "BagelFatOne",
                    fontSize: 40,
                  ),
                ),
              ),
            ),

            // Unterer Teil
            AnimatedOpacity(
              opacity: _zeigeDetails ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 600),
              child: Align(
                alignment: const Alignment(0, 0.4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Statistik",
                        style: TextStyle(
                            fontFamily: 'BagelFatOne',
                            color: Colors.white,
                            fontSize: 30
                        ),
                      ),

                      const Divider(),

                      SizedBox(
                        height: 20,
                      ),
                      _statProgressRow("Spiele gespielt", _profile?.gamesPlayed ?? 0),
                      const SizedBox(height: 20),
                      _statProgressRow("Werwolf-Siege", _profile?.gamesWonWerewolf ?? 0),
                      const SizedBox(height: 20),
                      _statProgressRow("Dorfbewohner-Siege", _profile?.gamesWonVillager ?? 0),
                      const SizedBox(height: 20),
                      _statProgressRow("Spiele verloren", _profile?.gamesLost ?? 0),

                      SizedBox(
                        height: 60,
                      ),

                      SizedBox(
                        width: 400,
                        child: Row(
                          spacing: 20,
                          children: [

                            Expanded(
                              child: ElevatedButton(
                                onPressed: () =>
                                    _leaveTo((_) => const Homescreen()),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: const Text(
                                  "Beenden",
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: 'BagelFatOne',
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),

                            Expanded(
                              child: ElevatedButton(
                                onPressed: () =>
                                    _leaveTo((_) => const CreateGame()),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: const Text(
                                  "Neues Spiel",
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: 'BagelFatOne',
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}