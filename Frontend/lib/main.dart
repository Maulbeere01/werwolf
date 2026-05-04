import 'package:flutter/material.dart';
import 'package:werwolf/LoginView.dart';
import 'RegistrationView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF00008B),
            brightness: Brightness.light,
          ),
        ),
      home: const MyHomePage(title: 'Werwolf Hauptmenü'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [


          Column(
            //zentriert Buttons
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // Spiel erstellen Button
              Center( //Zentriert Buttons Horizontal
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(200, 50),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegistrationScreen(), // Hier die Zielklasse eintragen
                      ),
                    );
                  },
                  child: const Text("Registrieren"), //Const benutzen sonst wird jedes mal neu erstellt
                ),
              ),

              const SizedBox(height: 14), // Platz zwischen den Buttons

              // Spiel erstellen Button
              Center( //Zentriert Buttons Horizontal
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(200, 50),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginView(),
                      ),
                    );
                  }, // Hier fehlte die schließende Klammer für onPressed
                  child: const Text("Login"),
                ),
              )
            ],
          ),
        ],
      ),


    );
  }
}