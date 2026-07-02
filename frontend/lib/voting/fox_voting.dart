import 'package:flutter/material.dart';
import 'package:werwolf/generated/werwolf.pb.dart';
import 'package:werwolf/voting/voting_scaffold.dart';

class FuchsVoting extends StatefulWidget {
  final List<PlayerStatus> targets;
  final FoxReveal? reveal;
  final int? secondsLeft;
  final void Function(List<String> targetIds) onInspect;

  /// peek at exactly three players at once.
  static const int requiredTargets = 3;

  const FuchsVoting({
    super.key,
    required this.targets,
    required this.onInspect,
    this.reveal,
    this.secondsLeft,
  });

  @override
  State<FuchsVoting> createState() => _FuchsVotingState();
}

class _FuchsVotingState extends State<FuchsVoting> {
  final Set<String> _selectedIds = {};

  void _toggle(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else if (_selectedIds.length < FuchsVoting.requiredTargets) {
        _selectedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final reveal = widget.reveal;
    if (reveal != null) {
      return VotingScaffold(
        title: 'Fuchs',
        subtitle: 'Deine Witterung',
        children: [
          const SizedBox(height: 40),
          Icon(
            reveal.anyWerewolfFound ? Icons.pets : Icons.spa,
            color: reveal.anyWerewolfFound
                ? Colors.redAccent
                : Colors.lightGreenAccent,
            size: 72,
          ),
          const SizedBox(height: 24),
          Text(
            reveal.anyWerewolfFound
                ? 'Du witterst einen Werwolf unter ihnen!'
                : 'Keiner von ihnen ist ein Werwolf.\nDu verlierst deine Witterung.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 22),
          ),
        ],
      );
    }

    final subtitle = StringBuffer(
      'Wähle genau ${FuchsVoting.requiredTargets} Spieler '
      '(${_selectedIds.length}/${FuchsVoting.requiredTargets})',
    );
    if (widget.secondsLeft != null) {
      subtitle.write('  •  ${widget.secondsLeft}s');
    }

    return VotingScaffold(
      title: 'Fuchs',
      subtitle: subtitle.toString(),
      children: [
        for (final p in widget.targets)
          VotingPlayerTile(
            name: p.name,
            selected: _selectedIds.contains(p.id),
            onTap: () => _toggle(p.id),
          ),
        const SizedBox(height: 24),
        VotingConfirmButton(
          label: 'Wittern',
          enabled: _selectedIds.length == FuchsVoting.requiredTargets,
          onPressed: () => widget.onInspect(_selectedIds.toList()),
        ),
      ],
    );
  }
}
