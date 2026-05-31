import 'dart:async';
import 'package:flutter/material.dart';

class WahlergebnisScreen extends StatefulWidget {
  final String spielerName;
  final int erhalteneStimmen;

  const WahlergebnisScreen({
    super.key,
    required this.spielerName,
    required this.erhalteneStimmen,
  });

  @override
  State<WahlergebnisScreen> createState() => _WahlergebnisScreenState();
}

class _WahlergebnisScreenState extends State<WahlergebnisScreen> {
  Timer? _startTimer;
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
                  "Das Volk hat\nentschieden!",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: "BagelFatOne",
                    fontSize: 40,
                  ),
                ),
              ),
            ),

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

                      Container(
                        padding: const EdgeInsets.all(24.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.25),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.gavel_rounded,
                              size: 48,
                              color: Colors.white60,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              widget.spielerName.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 32,
                                fontFamily: "BagelFatOne",
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Wurde mit ${widget.erhalteneStimmen} Stimmen gehängt.",
                              style: const TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                            const Divider(height: 32, color: Colors.white12),

                            const Text(
                              "Das hat Opfer war:",
                              style: TextStyle(fontSize: 12, color: Colors.white38, letterSpacing: 1.2),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "ROLLE?",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: "BagelFatOne",
                                color: Colors.white38,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        "Ein schweres Schweigen legt sich über das Dorf. \n Ein neues Opfer wurde gefunden",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                        ),
                      ),

                      const SizedBox(height: 60),

                      SizedBox(
                        width: 400,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            "Fortsetzen",
                            maxLines: 1,
                            style: TextStyle(
                              fontFamily: 'BagelFatOne',
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
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