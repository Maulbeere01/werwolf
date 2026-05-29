import 'package:flutter/material.dart';
import 'package:werwolf/widgets/spieleranzeige.dart';

class Warteraum extends StatelessWidget {
  const Warteraum({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        title: const Text(
          'Warteraum',
          style: TextStyle(
              color: Colors.white, 
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),

            const Text(
              'Mitspieler',
              style: TextStyle(
                fontSize: 36,
                fontFamily: "BagelFatOne",
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 30),

            const Expanded(
              child: SingleChildScrollView(
                child: Spieleranzeige(),
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                '[Spieler] wird das Spiel starten',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}