import 'package:flutter/material.dart';
import 'package:werwolf/Intro.dart';
import 'package:werwolf/NightStart.dart';
import 'package:werwolf/DayStart.dart';
import 'package:werwolf/Card.dart' as werwolf_card;

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