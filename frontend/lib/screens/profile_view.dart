import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:werwolf/services/grpc_handler.dart';
import 'package:werwolf/generated/werwolf.pb.dart';
import 'package:werwolf/widgets/progress_bar.dart';
import 'package:werwolf/widgets/profile_picker.dart';

class ProfilView extends StatefulWidget {
  const ProfilView({super.key});

  @override
  State<ProfilView> createState() => _ProfilViewState();
}

class _ProfilViewState extends State<ProfilView> {
  // Filenames must match the VALID_AVATARS whitelist in the backend's
  // UserServiceImpl; the server rejects anything else.
  static const List<String> _avatarFilenames = [
    'wolf_pfp.png',
    'seher_pfp.png',
    'sabateur_png.png',
    'jäger_pfp.png',
    'hexe_png.png',
    'fuchs_pfp.png',
    'dorfbewohner_pfp.png',
    'armor_pfp.png',
  ];

  String? _avatar;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final grpc = await GrpcHandler.instance();
      final profile = await grpc.userClient.getProfile(ProfileRequest());
      if (mounted && profile.avatar.isNotEmpty) {
        setState(() {
          _avatar = profile.avatar;
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print('[PROFILE] load skipped: $e');
    }
  }

  Future<void> _waehleProfilbild() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => ProfilePicker(
        assets: _avatarFilenames.map((f) => 'assets/PFP/$f').toList(),
      ),
    );

    if (selected == null) return;

    final filename = selected.split('/').last;
    setState(() {
      _avatar = filename;
    });

    try {
      final grpc = await GrpcHandler.instance();
      await grpc.userClient.updateAvatar(UpdateAvatarRequest(avatar: filename));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Speichern des Profilbilds: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color backgroundColor = theme.colorScheme.onPrimaryContainer;
    final Color cardColor = theme.cardColor;
    final Color textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
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
              decoration: BoxDecoration(
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

        title: Text(
          'Profil',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profilbild
              Center(
                child: GestureDetector(
                  onTap: _waehleProfilbild,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: cardColor,
                          shape: BoxShape.circle,
                          image: _avatar != null
                              ? DecorationImage(
                                  image: AssetImage('assets/PFP/$_avatar'),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _avatar == null
                            ? Icon(Icons.person, size: 70, color: textColor.withOpacity(0.3))
                            : null,
                      ),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: theme.primaryColor,
                        child: const Icon(Icons.edit, color: Colors.white, size: 18),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              SpieleProgressBar(aktuelleSpielNummer: 1, gesamtSpiele: 3, starteAnimation: false),
              const SizedBox(height: 20),

              const Text(
                "Challenges",
                style: TextStyle(
                    fontFamily: 'BagelFatOne',
                    color: Colors.white,
                    fontSize: 40
                ),
              ),
              const Divider(),
              const SizedBox(height: 20),

              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Platzhalter",
                          style: TextStyle( color: Colors.white, fontSize: 18),
                        ),
                        const SizedBox(width: 16),
                        Expanded(child: SpieleProgressBar(aktuelleSpielNummer: 2, gesamtSpiele: 3, starteAnimation: true)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Text(
                          "Platzhalter",
                          style: TextStyle( color: Colors.white, fontSize: 18),
                        ),
                        const SizedBox(width: 16),
                        Expanded(child: SpieleProgressBar(aktuelleSpielNummer: 2, gesamtSpiele: 3, starteAnimation: true)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Text(
                          "Platzhalter",
                          style: TextStyle( color: Colors.white, fontSize: 18),
                        ),
                        const SizedBox(width: 16),
                        Expanded(child: SpieleProgressBar(aktuelleSpielNummer: 2, gesamtSpiele: 3, starteAnimation: true)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Text(
                          "Platzhalter",
                          style: TextStyle( color: Colors.white, fontSize: 18),
                        ),
                        const SizedBox(width: 16),
                        Expanded(child: SpieleProgressBar(aktuelleSpielNummer: 2, gesamtSpiele: 3, starteAnimation: true)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Text(
                          "Platzhalter",
                          style: TextStyle( color: Colors.white, fontSize: 18),
                        ),
                        const SizedBox(width: 16),
                        Expanded(child: SpieleProgressBar(aktuelleSpielNummer: 2, gesamtSpiele: 3, starteAnimation: true)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

            
            ],
          ),
        ),
      ),
    );
  }
}