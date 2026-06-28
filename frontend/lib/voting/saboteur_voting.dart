import 'package:flutter/material.dart';
import 'package:werwolf/generated/werwolf.pb.dart';
import 'package:werwolf/voting/voting_scaffold.dart';

/// The saboteur picks one player who has to sit out the coming day entirely:
/// no discussion, no vote. There is no reveal: once submitted the night moves
/// straight on (the backend advances immediately).
class SaboteurVoting extends StatefulWidget {
  final List<PlayerStatus> targets;
  final int? secondsLeft;
  final void Function(String targetId) onSabotage;

  const SaboteurVoting({
    super.key,
    required this.targets,
    required this.onSabotage,
    this.secondsLeft,
  });

  @override
  State<SaboteurVoting> createState() => _SaboteurVotingState();
}

class _SaboteurVotingState extends State<SaboteurVoting> {
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    final subtitle = StringBuffer(
      'Wähle einen Spieler, der morgen aussetzen muss',
    );
    if (widget.secondsLeft != null) {
      subtitle.write('  •  ${widget.secondsLeft}s');
    }

    return VotingScaffold(
      title: 'Saboteur',
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
          label: 'Sabotieren',
          enabled: _selectedId != null,
          onPressed: () => widget.onSabotage(_selectedId!),
        ),
      ],
    );
  }
}
