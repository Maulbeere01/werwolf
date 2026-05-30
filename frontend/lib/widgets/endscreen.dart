import 'dart:async';
import 'package:flutter/material.dart';
import 'package:werwolf/widgets/progressbar.dart';

class Endscreen extends StatefulWidget {
  final int aktuelleSpielNummer;
  final int gesamtSpiele;

  const Endscreen({
    super.key,
    required this.aktuelleSpielNummer,
    required this.gesamtSpiele,
  });

  @override
  State<Endscreen> createState() => _EndscreenState();
}

class _EndscreenState extends State<Endscreen> {
  Timer? _startTimer;
  String gewinnerRolle = "Werwölfe";

  Alignment _textAlignment = Alignment.center;
  bool _zeigeDetails = false;

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
  }

  @override
  void dispose() {
    _startTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
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
                  "Die $gewinnerRolle \n hat/haben gewonnen",
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
                      SpieleProgressBar(
                        aktuelleSpielNummer: widget.aktuelleSpielNummer,
                        gesamtSpiele: widget.gesamtSpiele,
                        starteAnimation: _zeigeDetails,
                      ),

                      const SizedBox(height: 50),

                      const Text(
                        "Challenges",
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
                      Row(
                        children: [
                          const Text(
                            "Gewinne 3 Spiele",
                            style: TextStyle(
                                fontFamily: 'BagelFatOne',
                                color: Colors.white,
                                fontSize: 20
                            ),
                          ),
                          const SizedBox(width: 70),
                          Expanded(
                              child: SpieleProgressBar(aktuelleSpielNummer: 2, gesamtSpiele: 3, starteAnimation: _zeigeDetails,)
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          const Text(
                            "Gewinne 3 Spiele",
                            style: TextStyle(
                                fontFamily: 'BagelFatOne',
                                color: Colors.white,
                                fontSize: 20
                            ),
                          ),
                          const SizedBox(width: 70),
                          Expanded(
                              child: SpieleProgressBar(aktuelleSpielNummer: 2, gesamtSpiele: 3,starteAnimation: _zeigeDetails,)
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          const Text(
                            "Gewinne 3 Spiele",
                            style: TextStyle(
                                fontFamily: 'BagelFatOne',
                                color: Colors.white,
                                fontSize: 20
                            ),
                          ),
                          const SizedBox(width: 70),
                          Expanded(
                              child: SpieleProgressBar(aktuelleSpielNummer: 2, gesamtSpiele: 3,starteAnimation: _zeigeDetails,)
                          ),
                        ],
                      ),

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
                                onPressed: () {},
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
                                onPressed: () {},
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
    );
  }
}