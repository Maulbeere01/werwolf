import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:werwolf/Rules.dart';
import 'package:werwolf/settings_veiw.dart';

class Intro extends StatelessWidget {
  const Intro({super.key});

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
                child: SvgPicture.asset(
                  'assets/icons/back.svg',
                  width: 20,
                  height: 20,
                ),
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
                    MaterialPageRoute(
                      builder: (context) => const EinstellungenView(),
                    ),
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
                    child: SvgPicture.asset(
                      'assets/icons/settings.svg',
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      body: Stack(
        children: [

          Container(color: Colors.black),

          Positioned(
      // Tweak these values to match the hole's position
            top: MediaQuery.of(context).size.height * 0.0,
            left: MediaQuery.of(context).size.width * 0.00 - (MediaQuery.of(context).size.width * 2) / 2,
            child: Image.asset(
              'assets/BG/Sky Spin.png',
              width: MediaQuery.of(context).size.width * 3,   // tweak this
              height: MediaQuery.of(context).size.width * 3,  // keep equal to width (circle)
              fit: BoxFit.cover,
            ),
          ),

          // 1. Background image fills the entire screen
          SizedBox.expand(
            child: Image.asset(
              'assets/BG/day FG.png',
              fit: BoxFit.cover,
            )
          ),

          // 2. Content on top
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 120),

                const Text(
                  "In einem weit entfernten Dorf...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'BagelFatOne',
                    fontSize: 40,
                    color: Color.fromARGB(255, 51, 50, 94),
                  ),
                ),

                const SizedBox(height: 320),

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

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}