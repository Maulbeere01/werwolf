import 'package:flutter/material.dart';
import 'package:werwolf/screens/intro.dart';
import 'package:werwolf/screens/night_start.dart';
import 'package:werwolf/screens/day_start.dart';
import 'package:werwolf/widgets/card.dart' as werwolf_card;

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: DayStart(),
      ),
    ),
  );
}