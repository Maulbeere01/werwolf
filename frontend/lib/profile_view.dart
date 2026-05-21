import 'package:flutter/material.dart';

class ProfilView extends StatelessWidget {
  const ProfilView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color backgroundColor = theme.colorScheme.onSecondaryContainer;
    final Color primaryColor = theme.primaryColor;
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Profilbild
              Center(
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: cardColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              //XP Bar
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        height: 28,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(
                          '400 / 600 EXP',
                          style: TextStyle(
                            color: textColor.withOpacity(0.6),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              //Quadrate
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (index) {
                  return Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 36),

              //Überschrift
              Text(
                'Challenges',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 24),

              // 5. Challenges Liste
              _buildChallengeRow(
                title: 'Gewinne 3 Spiele',
                expText: '+200 EXP',
                progress: 0.75,
                primaryColor: primaryColor,
                cardColor: cardColor,
                textColor: textColor,
              ),
              const SizedBox(height: 16),
              _buildChallengeRow(
                title: 'Sei 2 mal Werwolf',
                expText: '+200 EXP',
                progress: 0.6,
                primaryColor: primaryColor,
                cardColor: cardColor,
                textColor: textColor,
              ),
              const SizedBox(height: 16),
              _buildChallengeRow(
                title: 'Erstelle ein Spiel',
                expText: '+200 EXP',
                progress: 0.0,
                primaryColor: primaryColor,
                cardColor: cardColor,
                textColor: textColor,
                isLocked: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChallengeRow({
    required String title,
    required String expText,
    required double progress,
    required Color primaryColor,
    required Color cardColor,
    required Color textColor,
    bool isLocked = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
        Container(
          width: 140,
          height: 36,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(100),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  if (progress > 0)
                    Container(
                      width: constraints.maxWidth * progress,
                      height: constraints.maxHeight,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  Center(
                    child: Text(
                      expText,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isLocked
                            ? textColor.withOpacity(0.4)
                            : (progress > 0.4 ? Colors.white : textColor),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}