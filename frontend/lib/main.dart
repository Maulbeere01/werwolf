import 'dart:io';

import 'package:flutter/material.dart';
import 'package:werwolf/LoginView.dart';
import 'package:werwolf/RegistrationView.dart';
import 'package:werwolf/HomeScreen.dart';
import 'package:werwolf/auth/auth_state.dart';
import 'package:werwolf/auth/session_store.dart';
import 'package:werwolf/controller/LoginViewController.dart';
import 'package:audioplayers/audioplayers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // The in-game backgrounds are large, which
  // overflows the image cache's 100 MB default and gets one evicted right after
  // it was precached. Raise
  // the limit so all of them stay resident once warmed.
  PaintingBinding.instance.imageCache.maximumSizeBytes = 1024 * 1024 * 300;

  await SessionStore.load();
  await _maybeAutoLogin();
  runApp(const MyApp());
}

/// Dev: when WERWOLF_AUTOLOGIN_USER / WERWOLF_AUTOLOGIN_PASS are
/// present in the environment (see scripts/run_clients.sh), sign in
/// automatically so several test clients can be launched already logged in.
/// Has no effect during normal use when those variables are unset.
Future<void> _maybeAutoLogin() async {
  final user = Platform.environment['WERWOLF_AUTOLOGIN_USER'];
  final pass = Platform.environment['WERWOLF_AUTOLOGIN_PASS'];
  if (user == null || user.isEmpty || pass == null || pass.isEmpty) return;

  try {
    // Drop any session inherited from the shared secure storage so we always
    // end up as exactly this user (or logged out if the login fails).
    AuthState.token = null;
    AuthState.userId = null;
    AuthState.lobbyCode = null;
    final ok = await LoginViewController.loginUser(user, pass);
    // ignore: avoid_print
    print('[AUTOLOGIN] user=$user success=$ok');
  } catch (e) {
    // Never let auto-login block app startup.
    // ignore: avoid_print
    print('[AUTOLOGIN] user=$user failed: $e');
  }
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
      home: AuthState.token != null
          ? const Homescreen()
          : const MyHomePage(title: 'Werwolf Hauptmenü'),
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