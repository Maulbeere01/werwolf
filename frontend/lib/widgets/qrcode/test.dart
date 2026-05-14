import 'package:flutter/material.dart';
import 'package:werwolf/widgets/qrcode/qr_code_container.dart';

class test extends StatelessWidget {
  const test({super.key});

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
        child: QRCodeContainer(width: 300, height: 300)
      ),
    );
  }
}
