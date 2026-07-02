import 'package:flutter/material.dart';
import 'package:werwolf/generated/werwolf.pb.dart';
import 'package:werwolf/voting/voting_scaffold.dart';

/// Shown to the hunter the moment they die (night or day): they pick one living
/// player to drag into death with them.
class HunterVoting extends StatefulWidget {
  final List<PlayerStatus> targets;
  final int? secondsLeft;
  final void Function(String targetId) onShoot;

  const HunterVoting({
    super.key,
    required this.targets,
    required this.onShoot,
    this.secondsLeft,
  });

  @override
  State<HunterVoting> createState() => _HunterVotingState();
}

class _HunterVotingState extends State<HunterVoting> {
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    final subtitle = StringBuffer('Du stirbst: Reiß wen mit in den Tod');
    if (widget.secondsLeft != null) {
      subtitle.write('  •  ${widget.secondsLeft}s');
    }

    return VotingScaffold(
      title: 'Jäger',
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
          label: 'Erschießen',
          enabled: _selectedId != null,
          onPressed: () => widget.onShoot(_selectedId!),
        ),
      ],
    );
  }
}
