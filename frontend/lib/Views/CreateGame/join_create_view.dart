import 'package:flutter/material.dart';
import 'package:werwolf/widgets/qrcode/test.dart';
import 'create_game_view.dart';
import 'join_view.dart';

class JoinCreateView extends StatelessWidget {
  const JoinCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        leading: IconButton(
          icon: const Icon(Icons.person),
          color: Theme.of(context).colorScheme.onPrimary,
          onPressed: () {
            // Menü-Aktion
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            color: Theme.of(context).colorScheme.onPrimary,
            onPressed: () {
            },
          ),
        ],
      ),
      body: Center(
        child: Stack(
          children: [
            Container(
              color: Colors.grey,
            ),

            Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                SizedBox(
                  height: 20,
                ),

                Text("Silent Village",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 50,
                    fontFamily: "Bagel"
                  ),
                ),

                SizedBox(
                  height: 400,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CreateGameView(),
                            ),
                          );
                        },
                        child: Text("Spiel Erstellen")
                    ),

                    SizedBox(
                      width: 30,
                    ),
                    
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => JoinView(),
                            ),
                          );
                        },
                        child: Text("Spiel beitreten"))
                  ],
                ),

                SizedBox(
                  height: 20,
                ),

                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => test(),
                          ),
                      );
                    },

                    child: Text("Regeln Ansehen"))
              ],
            ),
            )
          ],
        ),
      ),
    );
  }
}
