import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'landing_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

//Bildschirmorientierung wird festgelegt
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Werwolf',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00008B),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Silent Village'),
    );
  }
}