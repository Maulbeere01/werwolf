import 'package:flutter/material.dart';
import 'package:werwolf/generated/werwolf.pb.dart';
import 'package:werwolf/screens/intro.dart';
import 'package:werwolf/screens/night_start.dart';
import 'package:werwolf/screens/day_start.dart';
import 'package:werwolf/widgets/card.dart' as werwolf_card;
import 'package:werwolf/screens/home_screen.dart';
import 'package:werwolf/screens/settings_view.dart';
import 'package:werwolf/screens/night_start.dart';
import 'package:werwolf/screens/no_server_connection.dart';
import 'package:werwolf/screens/vote_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: DayStart(lobbyCode: '', initialUpdate: GameUpdate()),
      //home: NightStart(lobbyCode: '', initialUpdate: GameUpdate()),
      //home: Intro(lobbyCode: '', initialUpdate: GameUpdate()),
      home: WahlergebnisScreen(),
    ),
  );
}