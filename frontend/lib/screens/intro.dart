import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:werwolf/screens/night_start.dart';
import 'package:werwolf/screens/rules.dart';
import 'package:werwolf/controllers/game_stream_controller.dart';
import 'package:werwolf/utils/game_assets.dart';
import 'package:werwolf/generated/werwolf.pb.dart';
import 'package:werwolf/utils/role_display.dart';
import 'package:werwolf/screens/settings_view.dart';
import 'package:werwolf/widgets/connection_status.dart';
import 'package:werwolf/widgets/role_reveal_card.dart';

class Intro extends StatefulWidget {
  final String lobbyCode;
  final GameUpdate initialUpdate;

  const Intro({
    super.key,
    required this.lobbyCode,
    required this.initialUpdate,
  });

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  late final GameStreamController _controller;

  // A black cover that hides the first-frame background pop-in (the GPU still
  // has to upload the large textures on first paint, which precaching can't
  // avoid). It holds for a moment, then fades out to reveal the ready scene.
  double _coverOpacity = 1.0;
  Timer? _coverTimer;
  static const Duration _coverHold = Duration(milliseconds: 200);
  static const Duration _coverFade = Duration(seconds: 6);

  @override
  void initState() {
    super.initState();
    _controller = GameStreamController(
      lobbyCode: widget.lobbyCode,
      seed: widget.initialUpdate,
    );
    _controller.addListener(_onUpdate);

    // hold black briefly so the backgrounds are painted/uploaded, then fade out
    _coverTimer = Timer(_coverHold, () {
      if (mounted) setState(() => _coverOpacity = 0.0);
    });
  }

  bool _precached = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_precached) {
      _precached = true;
      precacheGameAssets(context);
    }
  }

  // The game starts in NIGHT_START (the intro). Once the backend advances the
  // phase (after ~10s), the night has begun -> switch to the night screen.
  void _onUpdate() {
    final phase = _controller.currentUpdate.currentPhase;
    if (phase == Phase.PHASE_UNSPECIFIED ||
        phase == Phase.LOBBY ||
        phase == Phase.NIGHT_START) {
      return;
    }

    _controller.removeListener(_onUpdate);
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => NightStart(
          lobbyCode: widget.lobbyCode,
          initialUpdate: _controller.currentUpdate,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _coverTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConnectionStatusScope(
      controller: _controller,
      child: Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
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
        actions: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const EinstellungenView(),
                    ),
                  );
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.white60,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/settings.svg',
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      body: Stack(
        children: [

          Container(color: Colors.black),

          Positioned(
      // Tweak these values to match the hole's position
            top: MediaQuery.of(context).size.height * 0.0,
            left: MediaQuery.of(context).size.width * 0.00 - (MediaQuery.of(context).size.width * 2) / 2,
            child: Image.asset(
              'assets/BG/Sky Spin.png',
              width: MediaQuery.of(context).size.width * 3,   // tweak this
              height: MediaQuery.of(context).size.width * 3,  // keep equal to width (circle)
              fit: BoxFit.cover,
            ),
          ),

          // 1. Background image fills the entire screen
          SizedBox.expand(
            child: Image.asset(
              'assets/BG/day FG.png',
              fit: BoxFit.cover,
            )
          ),

          // 2. Content on top
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 120),

                const Text(
                  "In einem weit entfernten Dorf...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'BagelFatOne',
                    fontSize: 40,
                    color: Color.fromARGB(255, 51, 50, 94),
                  ),
                ),

                const SizedBox(height: 320),

                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const Rules(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                  child: Text(
                    "Regeln ansehen",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.7),
                          offset: const Offset(1, 1),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),

          Positioned(
            left: 16,
            bottom: 16,
            child: RoleRevealCard(role: selfRoleOf(_controller.currentUpdate)),
          ),

          // black cover that fades out, hiding the first-frame background load
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedOpacity(
                opacity: _coverOpacity,
                duration: _coverFade,
                // slow at the start, accelerating towards the end
                curve: Curves.easeIn,
                child: const ColoredBox(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
