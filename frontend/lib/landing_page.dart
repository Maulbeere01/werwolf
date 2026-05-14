import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:werwolf/Views/CreateGame/join_create_view.dart';
import 'package:werwolf/Views/loginRegister/registration_view.dart';

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
    _playBackgroundMusic();
  }

  Future<void> _playBackgroundMusic() async {
    await audioPlayer.setReleaseMode(ReleaseMode.loop);
    await audioPlayer.play(AssetSource('hintergrund.mp3'));
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontFamily: "Bagel",
                    fontSize: 40
                  ),
                ),
                const SizedBox(height: 300),

                _buildMenuButton(
                    context,
                    label: "Registrieren",
                    target: const Registrationview()
                ),

                const SizedBox(height: 14),

                _buildMenuButton(
                    context,
                    label: "Login",
                    target: const JoinCreateView()
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, {required String label, required Widget target}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(200, 50),
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => target),
        );
      },
      child: Text(label),
    );
  }
}