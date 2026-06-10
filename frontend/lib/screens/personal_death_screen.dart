import 'package:flutter/material.dart';
import 'package:werwolf/screens/rules.dart';
import 'package:werwolf/screens/settings_view.dart';

class TodScreen extends StatelessWidget {
  final String exRolle;
  final String todesUrsache;

  const TodScreen({
    super.key,
    required this.exRolle,
    required this.todesUrsache,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white12,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white12,
              child: IconButton(
                icon: const Icon(Icons.settings, color: Colors.white, size: 18),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EinstellungenView()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 40),

              const Text(
                'Du bist tot',
                style: TextStyle(
                  fontSize: 36,
                  fontFamily: "BagelFatOne",
                  color: Colors.redAccent,
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  "Dein Lebenslicht ist erloschen...",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white60,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 30),

              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Container(
                        padding: const EdgeInsets.all(24.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.15),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                                Icons.hourglass_empty_rounded,
                                size: 64,
                                color: Colors.white60
                            ),
                            const SizedBox(height: 20),

                            const Text(
                              "DEINE ROLLE WAR:",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white38,
                                letterSpacing: 1.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),

                            Text(
                              exRolle.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 26,
                                fontFamily: "BagelFatOne",
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),

                            const Text(
                              "TODESURSACHE:",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white38,
                                letterSpacing: 1.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),

                            Text(
                              todesUrsache,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.redAccent,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),

                            const Text(
                              "Du bist leider gestorben. Du darfst das Spiel weiter mitverfolgen, aber keinerlei Hinweise mehr geben oder mitdiskutieren!",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white60,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 100.0,),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Rules()),
                    );
                  },
                  child: Text(
                    "Regeln ansehen",
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 32.0,),
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white10,
                    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                  ),
                  child: const Text(
                    "Home",
                    style: TextStyle(
                      fontFamily: 'BagelFatOne',
                      color: Colors.white,
                      fontSize: 20,
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