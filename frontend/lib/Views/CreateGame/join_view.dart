import 'package:flutter/material.dart';
import 'package:werwolf/widgets/form_field.dart';
import 'package:werwolf/widgets/qrcode/camera_container.dart';
import 'package:werwolf/widgets/qrcode/floating_container.dart';

class JoinView extends StatelessWidget {
  const JoinView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Spiel beitreten",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          )
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Theme.of(context).colorScheme.onPrimary,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Stack(
          children: [
            //Hintergrundbild
            Container(
              color: Colors.grey,
            ),

            Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              CameraContainer(
                  width: 300,
                  height: 300,
              ),

              SizedBox(
                height: 30,
              ),

              FloatingContainer(
                width: 300,
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CodeTextfield(
                    hint: "Raumcode",
                    controller: null,
                  ),
                ),
              )
            ],
            )
            )
        ]
      )
    )
    );
  }
}
