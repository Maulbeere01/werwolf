import 'package:flutter/material.dart';
import 'package:werwolf/widgets/counter_with_plus_minus.dart';
import 'package:werwolf/widgets/slider_container.dart';

class CreateGameView extends StatelessWidget {
  const CreateGameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Spiel erstellen",
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Theme.of(context).colorScheme.onPrimary,
          onPressed: (){
            Navigator.pop(context);
          }
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
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 50),

            SliderContainer(
              titel: "Maximale Anzahl an Werwölfen",
              max: 10.0,
              min: 0.0,
            ),

            SliderContainer(
              titel: "Anzahl der [Rolle]",
              max: 10.0,
              min: 0.0,
            ),

            CounterWithPlusMinus(
                titel: "Diskussionszeit pro Runde",
              max: 60,
              min: 2,
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.only(bottom: 60.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                onPressed: () {
                  // Hier deine Action, z.B. Navigator.pop(context);
                },
                child: const Text(
                  "Spiel Erstellen",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
