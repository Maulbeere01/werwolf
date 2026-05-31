import 'package:flutter/material.dart';
import 'package:werwolf/generated/werwolf.pb.dart';
import 'package:werwolf/voting/voting_scaffold.dart';

/// Werewolves pick a victim. [targets] are the players that may be attacked.
class WerwolfVoting extends StatefulWidget {
  final List<PlayerStatus> targets;
  final void Function(String targetId) onVote;

  const WerwolfVoting({
    super.key,
    required this.targets,
    required this.onVote,
  });

  @override
  State<WerwolfVoting> createState() => _WerwolfVotingState();
}

class _WerwolfVotingState extends State<WerwolfVoting> {
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    return VotingScaffold(
      title: 'Werwölfe',
      subtitle: 'Wählt euer Opfer',
      children: [
        for (final p in widget.targets)
          VotingPlayerTile(
            name: p.name,
            selected: _selectedId == p.id,
            onTap: () => setState(() => _selectedId = p.id),
          ),
        const SizedBox(height: 24),
        VotingConfirmButton(
          label: 'Angreifen',
          enabled: _selectedId != null,
          onPressed: () => widget.onVote(_selectedId!),
        ),
      ],
    );
  }
}
