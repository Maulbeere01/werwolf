import 'package:flutter/material.dart';

class SpieleProgressBar extends StatelessWidget {
  final int aktuelleSpielNummer;
  final int gesamtSpiele;
  final bool starteAnimation;

  const SpieleProgressBar({
    super.key,
    required this.aktuelleSpielNummer,
    required this.gesamtSpiele,
    required this.starteAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final double targetProgress = (aktuelleSpielNummer / gesamtSpiele).clamp(0.0, 1.0);

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (starteAnimation)
              TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  begin: 0.0,
                  end: targetProgress,
                ),
                duration: const Duration(milliseconds: 2000),
                curve: Curves.easeOutCubic,
                builder: (BuildContext context, double value, Widget? child) {
                  return LinearProgressIndicator(
                    value: value,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                    minHeight: 50,
                    borderRadius: BorderRadius.circular(26),
                  );
                },
              )
            else
              LinearProgressIndicator(
                value: targetProgress,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                minHeight: 50,
                borderRadius: BorderRadius.circular(26),
              ),
            Text(
              "Spiel $aktuelleSpielNummer von $gesamtSpiele",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: 'BagelFatOne',
              ),
            ),
          ],
        ),
      ),
    );
  }
}