import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:werwolf/services/grpc_handler.dart';
import 'package:werwolf/generated/werwolf.pb.dart';
import 'package:werwolf/widgets/progress_bar.dart';
import 'package:werwolf/widgets/profile_picker.dart';
import 'package:werwolf/utils/stats_display.dart';

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
  UserProfile? _profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final grpc = await GrpcHandler.instance();
      final profile = await grpc.userClient.getProfile(ProfileRequest());
      if (mounted) {
        setState(() {
          _profile = profile;
          if (profile.avatar.isNotEmpty) _avatar = profile.avatar;
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

  // The cap doubles every time the score reaches it (10 -> 20 -> 40 -> ...),
  // so this never maxes out no matter how high the score climbs.
  Widget _statProgressRow(String label, int score) {
    final cap = progressCapFor(score);
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: SpieleProgressBar(
            aktuelleSpielNummer: score,
            gesamtSpiele: cap,
            starteAnimation: true,
          ),
        ),
      ],
    );
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
          _profile?.username ?? 'Profil',
          style: const TextStyle(
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

              SpieleProgressBar(
                aktuelleSpielNummer: (_profile?.gamesPlayed ?? 0) - (_profile?.gamesLost ?? 0),
                gesamtSpiele: _profile != null && _profile!.gamesPlayed > 0 ? _profile!.gamesPlayed : 1,
                starteAnimation: true,
                label: "${winRatePercent(_profile?.gamesPlayed ?? 0, _profile?.gamesLost ?? 0).toStringAsFixed(2)} % Winrate",
              ),
              const SizedBox(height: 20),

              const Text(
                "Statistik",
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
                    _statProgressRow("Spiele gespielt", _profile?.gamesPlayed ?? 0),
                    const SizedBox(height: 20),
                    _statProgressRow("Werwolf-Siege", _profile?.gamesWonWerewolf ?? 0),
                    const SizedBox(height: 20),
                    _statProgressRow("Dorfbewohner-Siege", _profile?.gamesWonVillager ?? 0),
                    const SizedBox(height: 20),
                    _statProgressRow("Spiele verloren", _profile?.gamesLost ?? 0),
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