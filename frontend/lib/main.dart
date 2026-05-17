import 'package:flutter/material.dart';
import 'package:werwolf/LoginView.dart';
import 'package:werwolf/RegistrationView.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    //TODO debugShowCheckedModeBanner entfernen
    debugShowCheckedModeBanner: false;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00008B),
          brightness: Brightness.light,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Werwolf Hauptmenü'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late final AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();

    audioPlayer.setReleaseMode(ReleaseMode.loop);
    audioPlayer.play(AssetSource('hintergrund.mp3'));
  }

  @override
  void dispose() {
    audioPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(200, 50),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const Registrationview(),
                      ),
                    );
                  },
                  child: const Text("Registrieren"),
                ),
              ),
              const SizedBox(height: 14),
              Center(
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
                  },
                  child: const Text("Login"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}