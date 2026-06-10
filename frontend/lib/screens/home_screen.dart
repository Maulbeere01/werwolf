import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:werwolf/screens/rules.dart';
import 'package:werwolf/screens/create_game.dart';
import 'package:werwolf/screens/qr_code_screen.dart';
import 'package:werwolf/auth/auth_state.dart';
import 'package:werwolf/controllers/game_view_controller.dart';
import 'package:werwolf/lobby/waiting_room.dart';
import 'package:werwolf/screens/profile_view.dart';
import 'package:werwolf/screens/settings_view.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final code = AuthState.lobbyCode;
    if (code != null) {
      // Navigate after the first frame so the widget tree is fully built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => QRCodeScreen(lobbyCode: code),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _showJoinDialog() async {
    _codeController.clear();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        String? errorText;
        bool loading = false;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Spiel beitreten'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _codeController,
                    autofocus: true,
                    textCapitalization: TextCapitalization.characters,
                    maxLength: 6,
                    decoration: InputDecoration(
                      labelText: 'Lobby-Code',
                      hintText: 'z. B. A1B2C3',
                      errorText: errorText,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: loading ? null : () => Navigator.of(dialogContext).pop(),
                  child: const Text('Abbrechen'),
                ),
                FilledButton(
                  onPressed: loading
                      ? null
                      : () async {
                          final code = _codeController.text.trim().toUpperCase();
                          if (code.length != 6) {
                            setDialogState(() => errorText = 'Der Code muss 6 Zeichen lang sein.');
                            return;
                          }

                          setDialogState(() {
                            loading = true;
                            errorText = null;
                          });

                          final lobbyCode = await GameViewController.joinLobby(code);

                          if (!context.mounted) return;

                          if (lobbyCode != null) {
                            Navigator.of(dialogContext).pop();
                            if (!mounted) return;
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) => Warteraum(lobbyCode: lobbyCode),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );
                          } else {
                            setDialogState(() {
                              loading = false;
                              errorText = 'Lobby nicht gefunden. Bitte Code prüfen.';
                            });
                          }
                        },
                  child: loading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Beitreten'),
                ),
              ],
            );
          },
        );
      },
    );
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
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ProfilView(),
              ),
            ),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white60,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/user.svg',
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
          SizedBox.expand(
            child: Image.asset(
              'assets/BG/day.png',
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Text(
                  "Silent Village",
                  style: TextStyle(
                    fontFamily: 'BagelFatOne',
                    fontSize: 56,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.7),
                        offset: const Offset(1, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 380),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) => CreateGame(),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.9),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text("Spiel erstellen"),
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: ElevatedButton(
                          onPressed: _showJoinDialog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.9),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text("Spiel beitreten"),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

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

                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
