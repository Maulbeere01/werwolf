import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeScreen extends StatefulWidget {
  final int maxPlayers;
  final int numberOfPlayers;

  const QRCodeScreen({
    super.key,
    required this.maxPlayers,
    required this.numberOfPlayers,
  });

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  String _gameCode = '';

  @override
  void initState() {
    super.initState();
    _gameCode = _generateGameCode();
  }

  String _generateGameCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(6, (index) {
      final randomIndex =
          DateTime.now().millisecondsSinceEpoch % chars.length;
      return chars[(randomIndex + index * 7) % chars.length];
    }).join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
      extendBodyBehindAppBar: true,
      appBar: AppBar(

        centerTitle: true,

        title: const Text(
          "Spiel erstellen",
          style: TextStyle(
            fontFamily: 'BagelFatOne',
            fontSize: 28,
            color: Colors.white,
          ),
        ),

        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 80,
        leading: Align(
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white60,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/back.svg',
                  width: 20,
                  height: 20,
                ),
              ),
            ),
          ),
        ),
      ),
      
    body: Stack(
      children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // QR CODE
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: QrImageView(
                      data: 'silentvillage://join?code=$_gameCode',
                      version: QrVersions.auto,
                      size: 150,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // GAME CODE
                Column(
                  children: [
                    
                    // const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        
                      ),
                      child: Text(
                        _gameCode,
                        style: TextStyle(
                          fontFamily: 'BagelFatOne',
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                          fontSize: 28,
                          letterSpacing: 6,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // PLAYER LIST
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Beigetretene Spieler",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Expanded(
                          child: ListView(
                            children: const [
                              _PlayerTile(name: "Max"),
                              _PlayerTile(name: "Anna"),
                              _PlayerTile(name: "Tom"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // START BUTTON
                SizedBox(
                  width: 220,
                  child: ElevatedButton(
                    onPressed: () {

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.9),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      "Spiel starten",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    ),
    );
  }
}

class _PlayerTile extends StatelessWidget {
  final String name;

  const _PlayerTile({
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white24,
            child: Text(
              name[0],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 14),

          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}