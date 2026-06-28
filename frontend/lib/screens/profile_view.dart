import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:werwolf/widgets/progress_bar.dart';
import 'package:werwolf/widgets/profile_picker.dart';

class ProfilView extends StatefulWidget {
  const ProfilView({super.key});

  @override
  State<ProfilView> createState() => _ProfilViewState();
}

class _ProfilViewState extends State<ProfilView> {
  String? _imagePath;
  final List<String> _assetPfps = const [
    'assets/PFP/wolf_pfp.png',
    'assets/PFP/seher_pfp.png',
    'assets/PFP/sabateur_png.png',
    'assets/PFP/jäger_pfp.png',
    'assets/PFP/hexe_png.png',
    'assets/PFP/fuchs_pfp.png',
    'assets/PFP/dorfbewohner_pfp.png',
    'assets/PFP/armor_pfp.png',
  ];

  Future<void> _waehleProfilbild() async {
    // Show options: Kamera or Auswahl aus mitgelieferten Profilbildern
    final choice = await showModalBottomSheet<String?>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Kamera'),
            onTap: () => Navigator.of(context).pop('camera'),
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text('Profilbild wählen'),
            onTap: () => Navigator.of(context).pop('assets'),
          ),
          ListTile(
            leading: const Icon(Icons.close),
            title: const Text('Abbrechen'),
            onTap: () => Navigator.of(context).pop(null),
          ),
        ],
      ),
    );

    if (choice == null) return;

    if (choice == 'camera') {
      final ImagePicker picker = ImagePicker();
      try {
        final XFile? foto = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 80,
        );

        if (foto != null) {
          setState(() {
            _imagePath = foto.path;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Fehler beim Laden des Bildes: $e')),
          );
        }
      }
    } else if (choice == 'assets') {
      await _pickFromAssets();
    }
  }

  Future<void> _pickFromAssets() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => ProfilePicker(assets: _assetPfps),
    );

    if (selected != null) {
      setState(() {
        _imagePath = selected;
      });
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
                          image: _imagePath != null
                              ? DecorationImage(
                                  image: _imagePath!.startsWith('assets/')
                                      ? AssetImage(_imagePath!) as ImageProvider
                                      : FileImage(File(_imagePath!)),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _imagePath == null
                            ? Icon(Icons.person, size: 70, color: textColor.withOpacity(0.3))
                            : null,
                      ),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: theme.primaryColor,
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
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