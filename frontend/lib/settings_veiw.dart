import 'package:flutter/material.dart';
import 'package:werwolf/controller/LoginViewController.dart';
import 'package:werwolf/main.dart';

class EinstellungenView extends StatelessWidget {
  const EinstellungenView({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Abmelden'),
        content: const Text('Möchtest du dich wirklich abmelden?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Abmelden'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    await LoginViewController.logout();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const MyHomePage(title: 'Werwolf Hauptmenü'),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {

    final colorScheme = Theme.of(context).colorScheme;

    // Hintergrund und Textfarben passend zu deinem Theme
    final Color backgroundColor = colorScheme.surface;
    final Color textColor = colorScheme.onSurface;
    final Color dividerColor = colorScheme.outlineVariant;

    final List<String> einstellungenOptionen = [
      'Sprache',
      'Konto',
      'Nutzungsbedingungen',
      'Datenschutzerklärung',
      'Impressum',
      'Ausloggen',
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: colorScheme.surfaceContainerHighest,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 18),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        title: Text(
          'Einstellungen',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.only(top: 24.0),
          itemCount: einstellungenOptionen.length,
          separatorBuilder: (context, index) => Divider(
            color: dividerColor,
            height: 1,
            indent: 24,
          ),
          itemBuilder: (context, index) {
            final option = einstellungenOptionen[index];

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              title: Text(
                option,
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onTap: () {
                if (option == 'Ausloggen') {
                  _confirmLogout(context);
                  return;
                }
                print('$option geklickt');
              },
            );
          },
        ),
      ),
    );
  }
}