import 'package:flutter/material.dart';

class NoServerConnection extends StatelessWidget {
  const NoServerConnection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
         color: theme.colorScheme.onPrimaryContainer,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                  child: const Icon(
                    Icons.wifi_off_rounded,
                    size: 100,
                    color: Colors.redAccent, // Neon-Rot
                  ),
                ),
                const SizedBox(height: 40),
                // Fette, moderne Headline
                const Text(
                  "Verbindung verloren!",
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    letterSpacing: 1.2,
                    fontFamily: 'BagelFatOne',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  "Wir konnten keine Verbindung zum Server herstellen. Überprüfe dein Internet oder versuch es gleich noch mal.",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Starker Kontrast
                      foregroundColor: theme.colorScheme.onPrimaryContainer,
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16), // Abgerundete Ecken
                      ),
                    ),
                    onPressed: () {
                      // TODO Logik reinballern
                    },
                    icon: const Icon(Icons.refresh_rounded, size: 22),
                    label: const Text(
                      "Erneut versuchen",
                      style: TextStyle(
                        fontSize: 20,
                        letterSpacing: 0.5,
                        fontFamily: 'BagelFatOne',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}