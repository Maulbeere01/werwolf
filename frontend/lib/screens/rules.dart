import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:werwolf/screens/settings_view.dart';

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

        // leadingWidth: 80,

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
                // const SizedBox(height: 40),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Ziel des Spiels",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "In Werwolf treten zwei Fraktionen gegeneinander an:\n\n"
                            "die Dorfbewohner und die Werwölfe.\n\n"
                            "Während die Dorfbewohner versuchen, alle Werwölfe zu entlarven und auszuschalten, versuchen die Werwölfe,\n"
                            "unentdeckt zu bleiben und die Kontrolle über das Dorf zu übernehmen.\n\n"
                            "Zusätzlich können bestimmte Spezialrollen eigene Ziele oder besondere Fähigkeiten besitzen.\n",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 18,
                              height: 1.5,
                            ),
                          ),
                          Text(
                            "Spielablauf - Nachtphase",
                            textAlign: TextAlign.center, //TODO Text zentrieren
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Während der Nacht schließen alle Spieler ihre Augen. Anschließend werden die Rollen mit Nachtfähigkeiten nacheinander aktiviert.\n\n"
                            "In der ersten Nacht bestimmt Amor zwei Spieler, die fortan als Liebespaar verbunden sind. Stirbt einer der beiden, folgt der andere ihm sofort in den Tod.\n\n"
                            "Anschließend erwachen die Werwölfe und wählen gemeinsam ein Opfer aus. Die Seherin darf jede Nacht einen Mitspieler auswählen, um dessen wahre Rolle zu erfahren. Der Fuchs untersucht jede Nacht einen Spieler sowie dessen direkte Nachbarn. Befindet sich unter diesen Spielern mindestens ein Werwolf, darf der Fuchs auch in der folgenden Nacht erneut suchen. Findet er jedoch ausschließlich unschuldige Spieler, verliert er seine Fähigkeit dauerhaft.\n\n"
                            "Die Hexe erfährt, welches Opfer die Werwölfe gewählt haben. Sie besitzt einen Heiltrank, mit dem sie dieses Opfer retten kann, sowie einen Todestrank, mit dem sie einen beliebigen Spieler töten kann. Beide Tränke können im gesamten Spiel jeweils nur einmal eingesetzt werden. Der Saboteur wählt jede Nacht einen Spieler aus, der am folgenden Tag weder sprechen, abstimmen noch seine Fähigkeit einsetzen darf und am Ende des Tages stirbt.\n\n"
                            ,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 18,
                              height: 1.5,
                            ),
                          ),
                          Text(
                            "Spielablauf - Tagphase",
                            textAlign: TextAlign.center, //TODO Text zentrieren
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Zu Beginn des Tages werden die Ereignisse der vergangenen Nacht bekanntgegeben."
                            "Anschließend diskutieren alle noch lebenden Spieler miteinander, tauschen Verdächtigungen aus und versuchen herauszufinden, wer zu den Werwölfen gehört.\n\n"
                            "Nach Ablauf der Diskussionsphase stimmen alle lebenden Spieler über einen Verdächtigen ab.\n\n"
                            "Der Spieler mit den meisten Stimmen wird aus dem Spiel ausgeschlossen.\n\n"
                            "Danach beginnt die nächste Nacht.\n\n"
                            ,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 18,
                              height: 1.5,
                            ),
                          ),
                          Text(
                            "Spielende",
                            textAlign: TextAlign.center, //TODO Text zentrieren
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Das Spiel endet, sobald eine Siegbedingung erfüllt wurde:\n\n"
                            "Die Dorfbewohner gewinnen, wenn alle Werwölfe ausgeschaltet wurden.\n\n"
                            "Die Werwölfe gewinnen, wenn sie die gleiche Anzahl an lebenden Dorfbewohnern haben wie die Werwölfe selbst.\n\n"
                            ,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 18,
                              height: 1.5,
                            ),
                          ),
                        ],
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