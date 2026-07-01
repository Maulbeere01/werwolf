import 'package:flutter/material.dart';

class ProfilePicker extends StatelessWidget {
  final List<String> assets;
  const ProfilePicker({super.key, required this.assets});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: double.maxFinite,
        height: 420,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Profilbild wählen',
                style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontSize: 24, fontWeight: FontWeight.bold) ??
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: assets.length,
                itemBuilder: (context, index) {
                  final asset = assets[index];
                  return GestureDetector(
                    onTap: () => Navigator.of(context).pop(asset),
                    child: ClipOval(
                      child: Image.asset(asset, fit: BoxFit.cover),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Abbrechen',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18) ?? const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
