import 'package:flutter/material.dart';

class Spieleranzeige extends StatefulWidget {
  /// Names of the players currently in the lobby.
  final List<String> players;

  const Spieleranzeige({super.key, this.players = const []});

  @override
  State<Spieleranzeige> createState() => _SpieleranzeigeState();
}

class _SpieleranzeigeState extends State<Spieleranzeige> {
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final List<String> _players = widget.players;
    // Padding sorgt für den Abstand nach links und rechts, den der Container vorher hatte
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: Material(
        elevation: 0,
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        clipBehavior: Clip.antiAlias, // Sorgt dafür, dass die Auswahlfarbe nicht über die runden Eckensteht
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _players.length,
            itemBuilder: (context, index) {
              final isSelected = index == _selectedIndex;

              return Column(
                children: [
                  ListTile(
                    selected: isSelected,
                    selectedTileColor: Colors.grey.shade300,
                    onTap: () {
                      setState(() {
                        _selectedIndex = isSelected ? -1 : index;
                      });
                    },
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                    leading: CircleAvatar(
                      radius: 24,
                    ),
                    title: Text(
                      _players[index],
                      style: TextStyle(
                        fontSize: 18,
                        color: isSelected ? Colors.black: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (index < _players.length - 1)
                    const Padding(
                      padding: EdgeInsets.only(left: 88.0, right: 20.0),
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFE0E0E0),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}