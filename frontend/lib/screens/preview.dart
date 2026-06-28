import 'package:flutter/material.dart';
import 'package:werwolf/screens/intro.dart';
import 'package:werwolf/screens/night_start.dart';
import 'package:werwolf/screens/day_start.dart';
import 'package:werwolf/widgets/card.dart' as werwolf_card;
import 'package:werwolf/screens/home_screen.dart';
import 'package:werwolf/screens/settings_view.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const EinstellungenView(),
    ),
  );
}