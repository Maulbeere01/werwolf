import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:werwolf/Rules.dart';

class DayStart extends StatefulWidget {
  const DayStart({super.key});

  @override
  State<DayStart> createState() => _DayStartState();
}

class _DayStartState extends State<DayStart>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _timerController;
  static const double halfTurn = 3.1415926535;

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
            left: MediaQuery.of(context).size.width * 0.00 -
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
            child: Image.asset(
              'assets/BG/day FG.png',
              fit: BoxFit.cover,
            ),
          ),

          FadeTransition(
            opacity: Tween<double>(
              begin: 1.0,
              end: 0.0,
            ).animate(_controller),
            child: SizedBox.expand(
              child: Image.asset(
                'assets/BG/night FG.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. Content on top
          SafeArea(
            child: SizedBox(
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
                                  backgroundColor: Colors.white.withOpacity(0.3),
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
          ),
        ],
      ),
    );
  }
}