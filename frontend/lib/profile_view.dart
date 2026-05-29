import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:werwolf/widgets/progressbar.dart';

class ProfilView extends StatefulWidget {
  const ProfilView({super.key});

  @override
  State<ProfilView> createState() => _ProfilViewState();
}

class _ProfilViewState extends State<ProfilView> {
  String? _imagePath;

  Future<void> _waehleProfilbild() async {
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: cardColor,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 18),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        title: Text(
          'Profil',
          style: TextStyle(
            color: textColor,
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
                            image: FileImage(File(_imagePath!)),
                            fit: BoxFit.cover,
                          )
                              : null,
                        ),
                        child: _imagePath == null
                            ? Icon(Icons.person, size: 70, color: textColor.withValues(alpha: 0.3))
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
              const SizedBox(height: 20),

              SpieleProgressBar(aktuelleSpielNummer: 1, gesamtSpiele: 3, starteAnimation: false),
              const SizedBox(height: 20),

              //Erfolge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (index) {
                  return Container(
                    width: 65, 
                    height: 65,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),

              const Text(
                "Challenges",
                style: TextStyle(
                    fontFamily: 'BagelFatOne',
                    color: Colors.white,
                    fontSize: 26
                ),
              ),
              const Divider(),
              const SizedBox(height: 8),

              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Gewinne 3 Spiele",
                          style: TextStyle(fontFamily: 'BagelFatOne', color: Colors.white, fontSize: 18),
                        ),
                        const SizedBox(width: 16),
                        Expanded(child: SpieleProgressBar(aktuelleSpielNummer: 2, gesamtSpiele: 3, starteAnimation: true)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text(
                          "Gewinne 3 Spiele",
                          style: TextStyle(fontFamily: 'BagelFatOne', color: Colors.white, fontSize: 18),
                        ),
                        const SizedBox(width: 16),
                        Expanded(child: SpieleProgressBar(aktuelleSpielNummer: 2, gesamtSpiele: 3, starteAnimation: true)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text(
                          "Gewinne 3 Spiele",
                          style: TextStyle(fontFamily: 'BagelFatOne', color: Colors.white, fontSize: 18),
                        ),
                        const SizedBox(width: 16),
                        Expanded(child: SpieleProgressBar(aktuelleSpielNummer: 2, gesamtSpiele: 3, starteAnimation: true)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: 400,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    "Beenden",
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'BagelFatOne',
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}