import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:werwolf/Card.dart' as card_overlay;
import 'package:werwolf/Rules.dart';

class DayStart extends StatefulWidget {
  const DayStart({super.key});

  @override
  State<DayStart> createState() => _DayStartState();
}

class _DayStartState extends State<DayStart> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _timerController;
  static const double halfTurn = 3.1415926535;
  bool _cardIsOverDropZone = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..forward();

    _timerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    _timerController.dispose();
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
                  angle: halfTurn + _controller.value * halfTurn,
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
            opacity: Tween<double>(begin: 1.0, end: 0.0).animate(_controller),
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
                    children: [
                      const SizedBox(height: 80),

                      const Text(
                        "Der Tag beginnt",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'BagelFatOne',
                          fontSize: 40,
                          color: Color.fromARGB(255, 61, 72, 99),
                        ),
                      ),

                      const Spacer(flex: 2),

                      // TIMER SECTION (Sekunden übrig...)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: SizedBox(
                                height: 30,
                                child: AnimatedBuilder(
                                  animation: _timerController,
                                  builder: (context, child) {
                                    return LinearProgressIndicator(
                                      value: 1.0 - _timerController.value,
                                      backgroundColor: Colors.white.withOpacity(
                                        0.3,
                                      ),
                                      valueColor: const AlwaysStoppedAnimation(
                                        Color.fromARGB(255, 61, 72, 99),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            AnimatedBuilder(
                              animation: _timerController,
                              builder: (context, child) {
                                final secondsLeft =
                                    ((1 - _timerController.value) * 40).ceil();

                                return Text(
                                  "$secondsLeft Sekunden übrig...",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.7),
                                        offset: const Offset(1, 1),
                                        blurRadius: 3,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      const Spacer(flex: 2),

                      // BOTTOM ACTION (Rules stays independent)
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

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Draggable<String>(
                    data: 'open-card',
                    feedback: _buildCardPreview(),
                    childWhenDragging: const SizedBox.shrink(),
                    onDragStarted: () =>
                        setState(() => _cardIsOverDropZone = false),
                    child: Transform.translate(
                      offset: const Offset(-80, 100),
                      child: Transform.rotate(
                        angle: 0.1,
                        child: _buildCardCorner(),
                      ),
                    ),
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
                                  : '',
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

  Widget _buildCardCorner({
    double scale = 1 / 2.2,
    double angle = 0,
    Offset offset = Offset.zero,
  }) {
    const double cardWidth = 340;
    const double cardHeight = 500;
    const double borderRadius = 28;
    return Material(
      color: Colors.transparent,
      child: Transform.translate(
        offset: offset,
        child: Transform.rotate(
          angle: angle,
          child: Container(
            width: cardWidth * scale,
            height: cardHeight * scale,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  offset: const Offset(0, 6),
                  blurRadius: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardPreview() {
    return Material(
      color: Colors.transparent,
      child: _buildCardCorner(
        scale: 0.45,
        angle: 0.01,
        offset: const Offset(-80, 100),
      ),
    );
  }
}


