import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:werwolf/controller/GameViewController.dart';
import 'package:werwolf/generated/werwolf.pb.dart';
import 'QRCodeScreen.dart';

class CreateGame extends StatefulWidget {
  const CreateGame({super.key});

  @override
  State<CreateGame> createState() => _CreateGameState();
}

class _CreateGameState extends State<CreateGame> {
  double numberOfWolfs = 1;
  double numberOfRole = 1;
  double _numberOfPlayers = 1;
  int _discussionLength = 30;

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
          

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 0),

                  const SizedBox(height: 60),

                  _buildSliderSection(
                    label: "Anzahl der Werwölfe",
                    value: numberOfWolfs,
                    onChanged: (value) {
                      setState(() {
                        numberOfWolfs = value;
                      });
                    },
                  ),

                  const SizedBox(height: 50),

                  _buildSliderSection(
                    label: "Anzahl der [Rolle]",
                    value: numberOfRole,
                    onChanged: (value) {
                      setState(() {
                        numberOfRole = value;
                      });
                    },
                  ),

                  const SizedBox(height: 50),
                  _buildDiscussionLengthSelector(),

                  const Spacer(),

                  // Continue Button
                  Center(
                    child: SizedBox(
                      width: 160,
                      child: ElevatedButton(
                        onPressed: () async {
                          final settings = LobbySettings()
                            ..maxPlayers = _numberOfPlayers.toInt()
                            ..discussionTimeSeconds = _discussionLength
                            ..roles.addAll([
                              RoleCount()
                                ..role = Role.WEREWOLF
                                ..count = numberOfWolfs.toInt(),
                              RoleCount()
                                ..role = Role.SEER
                                ..count = numberOfRole.toInt(),
                            ]);

                          final lobbyCode = await GameViewController.createLobby(settings);

                          if (!mounted) return;

                          if (lobbyCode != null) {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) => QRCodeScreen(lobbyCode: lobbyCode),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Failed to create lobby. Please try again.'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.9),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "Weiter",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildDiscussionLengthSelector() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const Text(
        "Diskussionslänge",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      const SizedBox(height: 12),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$_discussionLength Sekunden",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),

          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Row(
              children: [
                // MINUS BUTTON
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_discussionLength > 10) {
                        _discussionLength -= 10;
                      }
                    });
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    child: const Icon(Icons.remove, size: 18),
                  ),
                ),

                Container(
                  width: 1,
                  height: 20,
                  color: Colors.grey,
                ),

                // PLUS BUTTON
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _discussionLength += 10;
                    });
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    child: const Icon(Icons.add, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}

  Widget _buildSliderSection({
    required String label,
    required double value,
    double max = 5,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                value.toInt().toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.black87,
              inactiveTrackColor: Colors.grey.shade300,
              thumbColor: Colors.white,
              overlayColor: Colors.black.withOpacity(0.1),
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 12,
                elevation: 4,
              ),
              trackHeight: 6,
            ),
            child: Slider(
              value: value,
              min: 1,
              max: max < 1 ? 1 : max,
              divisions: (max - 1).toInt() > 0 ? (max - 1).toInt() : 1,
              onChanged: onChanged,
            ),
          ),
          // Dot indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              max.toInt(),
              (index) => Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index < value
                      ? Colors.black54
                      : Colors.grey.shade400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}