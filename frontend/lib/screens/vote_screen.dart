import 'dart:async';
import 'package:flutter/material.dart';

class WahlergebnisScreen extends StatefulWidget {
  /// Name of the hanged player, or null when the vote was tied / nobody was
  /// voted out.
  final String? spielerName;

  /// Revealed role of the hanged player (shown only when [spielerName] is set).
  final String? rolle;

  /// A lover who died of heartbreak together with the hanged player, if any.
  final String? partnerName;

  /// Revealed role of that lover (shown only when [partnerName] is set).
  final String? partnerRolle;

  const WahlergebnisScreen({
    super.key,
    this.spielerName,
    this.rolle,
    this.partnerName,
    this.partnerRolle,
  });

  @override
  State<WahlergebnisScreen> createState() => _WahlergebnisScreenState();
}

class _WahlergebnisScreenState extends State<WahlergebnisScreen> {
  Timer? _startTimer;
  Timer? _autoCloseTimer;
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

    // the game continues automatically: after 5s we leave the result screen so
    // the next night can begin
    _autoCloseTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) Navigator.of(context).maybePop();
    });
  }

  @override
  void dispose() {
    _startTimer?.cancel();
    _autoCloseTimer?.cancel();
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
                    fontSize: 56,
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
                            if (widget.spielerName != null) ...[
                              Text(
                                widget.spielerName!.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontFamily: "BagelFatOne",
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Wurde vom Dorf gehängt.",
                                style: TextStyle(color: Colors.white70, fontSize: 18),
                              ),
                              if (widget.rolle != null) ...[
                                const Divider(height: 32, color: Colors.white12),
                                const Text(
                                  "Das Opfer war:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white38,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.rolle!.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontFamily: "BagelFatOne",
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                              if (widget.partnerName != null) ...[
                                const Divider(height: 32, color: Colors.white12),
                                const Icon(
                                  Icons.favorite,
                                  size: 28,
                                  color: Colors.pinkAccent,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.partnerName!.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontFamily: "BagelFatOne",
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.partnerRolle != null
                                      ? "starb aus Liebeskummer · ${widget.partnerRolle!}"
                                      : "starb aus Liebeskummer",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 18),
                                ),
                              ],
                            ] else ...[
                              const Text(
                                "Das Dorf konnte sich nicht einigen.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Niemand wurde gehängt.",
                                style: TextStyle(color: Colors.white70, fontSize: 18),
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      Text(
                        widget.spielerName != null
                            ? "Ein schweres Schweigen legt sich über das Dorf. \n\n Ein neues Opfer wurde gefunden"
                            : "Ein schweres Schweigen legt sich über das Dorf. \n\n Die Nacht bricht herein...",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                      ),

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