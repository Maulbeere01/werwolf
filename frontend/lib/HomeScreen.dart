import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:werwolf/Rules.dart';
import 'package:werwolf/CreateGame.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

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
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.white60,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/back.svg',
                width: 20,
                height: 20,
              ),
            ),
          ),
        ),

        actions: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.white60,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/settings.svg',
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      body: Stack(
        children: [
          // Hintergrundbild
          SizedBox.expand(
            child: Image.asset(
              'assets/BG/day.png',
              fit: BoxFit.cover,
            ),
          ),

          // Inhalt
          SafeArea(
            child: Column(
              children: [
                // 1. Titel Bereich
                const SizedBox(height: 40),
                Text(
                  "Silent Village",
                  style: TextStyle(
                    fontFamily: 'BagelFatOne',
                    fontSize: 56,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.7),
                        offset: const Offset(1, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),

                // 2. Flexibler Platzhalter, der alles nach unten drückt
                // Ersetze Spacer() durch SizedBox(height: 200), wenn du eine feste Position willst
                SizedBox(height: 380),

                // 3. Button Bereich
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) => CreateGame(),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.9),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text("Spiel erstellen"),
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.9),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text("Spiel beitreten"),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                GestureDetector(
                  //onTap: () {},
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
                      //decoration: TextDecoration.underline,
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

                // Abstand zum ganz unteren Rand
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );

  }
}