import 'package:flutter/material.dart';

class CreateJoinView extends StatelessWidget {
  const CreateJoinView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,

        leading: IconButton(
          icon: const Icon(Icons.person_add_rounded),
          onPressed: () {
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Such-Aktion
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Hauptinhalt'),
      ),
    );
  }
}
