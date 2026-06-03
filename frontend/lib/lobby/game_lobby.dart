import 'package:flutter/material.dart';
import 'package:werwolf/Rules.dart';
import 'package:werwolf/widgets/spieleranzeige.dart';

import '../settings_veiw.dart';

class GameLobby extends StatelessWidget {
  const GameLobby({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // 1. Der Button ganz LINKS
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.settings, color: Colors.black, size: 18),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>  EinstellungenView()
                    ),
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
              'Rollenname',
              style: TextStyle(
                fontSize: 36,
                fontFamily: "BagelFatOne",
                color: Colors.white,
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                "Hier kommt eine ganz tolle Beschreibung hin, je nachdem welche Rolle",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 30),

            const Expanded(
              child: SingleChildScrollView(
                child: Spieleranzeige(
                  players: [
                    'Host_User',
                    'Spieler_2',
                    'Spieler_3',
                    'Spieler_4',
                    'Spieler_5',
                    'Spieler_6',
                  ],
                ),
              ),
            ),

            Padding(
                padding: const EdgeInsets.only(bottom: 100.0,),
             child :TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>  Rules()
                    ),
                  );
                },
                child:  Text("Regeln ansehen",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                  )
            ),
      ),


            Padding(
              padding: const EdgeInsets.only(bottom: 32.0,),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 60,vertical: 20),
                ),
                child: const Text(
                  "Weiter",
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
        ),
      ),
    );
  }
}