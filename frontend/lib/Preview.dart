import 'package:flutter/material.dart';
import 'package:werwolf/Intro.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Intro(),
      ),
    ),
  );
}