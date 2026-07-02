import 'package:flutter/material.dart';
import 'package:werwolf/generated/werwolf.pb.dart';
import 'package:werwolf/voting/voting_scaffold.dart';

class SeherVoting extends StatefulWidget {
  final List<PlayerStatus> targets;
  final List<PlayerStatus> players;
  final SeerReveal? reveal;
  final int? secondsLeft;
  final void Function(String targetId) onInspect;

  const SeherVoting({
    super.key,
    required this.targets,
    required this.players,
    required this.onInspect,
    this.reveal,
    this.secondsLeft,
  });

  @override
  State<SeherVoting> createState() => _SeherVotingState();
}

class _SeherVotingState extends State<SeherVoting> {
  String? _selectedId;

  String _nameOf(String id) {
    for (final p in widget.players) {
      if (p.id == id) return p.name;
    }
    return id;
  }

  @override
  Widget build(BuildContext context) {
    final reveal = widget.reveal;
    if (reveal != null) {
      final name = _nameOf(reveal.targetId);
      return VotingScaffold(
        title: 'Seherin',
        subtitle: 'Deine Vision',
        children: [
          const SizedBox(height: 40),
          Icon(
            reveal.isWerewolf ? Icons.dark_mode : Icons.shield_moon,
            color: reveal.isWerewolf ? Colors.redAccent : Colors.lightGreenAccent,
            size: 72,
          ),
          const SizedBox(height: 24),
          Text(
            reveal.isWerewolf
                ? '$name ist ein Werwolf!'
                : '$name ist kein Werwolf.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 22),
          ),
        ],
      );
    }

    final subtitle = StringBuffer('Wähle einen Spieler, den du prüfen willst');
    if (widget.secondsLeft != null) {
      subtitle.write('  •  ${widget.secondsLeft}s');
    }

    return VotingScaffold(
      title: 'Seherin',
      subtitle: subtitle.toString(),
      children: [
        for (final p in widget.targets)
          VotingPlayerTile(
            name: p.name,
            selected: _selectedId == p.id,
            onTap: () => setState(() => _selectedId = p.id),
          ),
        const SizedBox(height: 24),
        VotingConfirmButton(
          label: 'Untersuchen',
          enabled: _selectedId != null,
          onPressed: () => widget.onInspect(_selectedId!),
        ),
      ],
    );
  }
}
