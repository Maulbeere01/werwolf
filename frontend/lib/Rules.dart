import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:werwolf/settings_veiw.dart';

class Rules extends StatelessWidget {
  const Rules({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
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
          
          // Inhalt
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Text(
                  "Regeln",
                  style: TextStyle(
                    fontFamily: 'BagelFatOne',
                    fontSize: 56,
                    color: Colors.white,
              
                  ),
                ),
                
                const SizedBox(height: 20),

                // PLATZHALTER FÜR REGELTEXT
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                    padding: const EdgeInsets.all(20),
                    
                    child: SingleChildScrollView( // Macht den Text scrollbar
                      child: Text(
                        "Hier stehen die Regeln von Silent Village:\n\n"
                        "1. Jeder Spieler erhält eine geheime Rolle.\n"
                        "2. Nachts wachen die Werwölfe auf und wählen ein Opfer.\n"
                        "3. Tagsüber diskutiert das Dorf, wer ein Werwolf sein könnte.\n"
                        "4. Ziel der Dorfbewohner: Alle Werwölfe eliminieren.\n"
                        "5. Ziel der Werwölfe: Das Dorf übernehmen.\n\n"
                        "Viel Erfolg beim Überleben!",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 18,
                          height: 1.5,
                        ),
                      ),
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