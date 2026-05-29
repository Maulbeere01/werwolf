import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:werwolf/Card.dart' as card_overlay;
import 'package:werwolf/Rules.dart';

class NightStart extends StatefulWidget {
  const NightStart({super.key});

  @override
  State<NightStart> createState() => _NightStartState();
}

class _NightStartState extends State<NightStart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _cardIsOverDropZone = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        ],
      ),

      body: Stack(
        children: [
          Container(color: Colors.black),

          Positioned(
            top: MediaQuery.of(context).size.height * 0.0,
            left:
                MediaQuery.of(context).size.width * 0.00 -
                (MediaQuery.of(context).size.width * 2) / 2,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  // 180° = pi radians
                  angle: _controller.value * 3.1415926535,
                  child: child,
                );
              },
              child: Image.asset(
                'assets/BG/Sky Spin.png',
                width: MediaQuery.of(context).size.width * 3,
                height: MediaQuery.of(context).size.width * 3,
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox.expand(
            child: Image.asset('assets/BG/day FG.png', fit: BoxFit.cover),
          ),

          FadeTransition(
            opacity: _controller,
            child: SizedBox.expand(
              child: Image.asset('assets/BG/night FG.png', fit: BoxFit.cover),
            ),
          ),

          // 2. Content on top
          SafeArea(
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FadeTransition(
                        opacity: Tween<double>(
                          begin: 1.0,
                          end: 0.0,
                        ).animate(_controller),
                        child: const Text(
                          "Die Nacht bricht ein",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'BagelFatOne',
                            fontSize: 40,
                            color: Color.fromARGB(255, 51, 50, 94),
                          ),
                        ),
                      ),

                      const SizedBox(height: 350),

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
                  bottom: 86,
                  child: Draggable<String>(
                    data: 'open-card',
                    feedback: _buildCardPreview(),
                    childWhenDragging: const SizedBox.shrink(),
                    onDragStarted: () =>
                        setState(() => _cardIsOverDropZone = false),
                    child: _buildCardCorner(),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 140,
                  bottom: 140,
                  child: DragTarget<String>(
                    builder: (context, candidateData, rejectedData) {
                      final isActive =
                          candidateData.isNotEmpty || _cardIsOverDropZone;

                      return Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 160,
                          height: 220,
                          decoration: BoxDecoration(
                            color: isActive
                                ? Colors.white.withOpacity(0.18)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: isActive
                                  ? Colors.white70
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              isActive
                                  ? 'Karte ablegen'
                                  : 'Ziehe die Karte hierhin',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.6),
                                    offset: const Offset(1, 1),
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    onWillAcceptWithDetails: (details) {
                      setState(() => _cardIsOverDropZone = true);
                      return details.data == 'open-card';
                    },
                    onLeave: (_) => setState(() => _cardIsOverDropZone = false),
                    onAcceptWithDetails: (_) {
                      setState(() => _cardIsOverDropZone = false);
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (dialogContext) => const card_overlay.Card(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardCorner() {
    // Use the same size and border radius as the full card overlay
    const double cardWidth = 340;
    const double cardHeight = 500;
    const double borderRadius = 28;
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: cardWidth / 2.2,
        height: cardHeight / 2.2,
        child: Stack(
          children: [
            Positioned(
              left: -(cardWidth / 2.2) + 40,
              top: -(cardHeight / 2.2) + 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: Container(
                  width: cardWidth,
                  height: cardHeight,
                  color: Colors.white,
                  // You can add a placeholder image here later
                  // child: Image.asset('assets/PNGs/card_back.png'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardPreview() {
    return Material(
      color: Colors.transparent,
      child: Transform.rotate(angle: -0.12, child: _buildCardCorner()),
    );
  }
}


