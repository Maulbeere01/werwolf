import 'package:flutter/material.dart';
import 'package:werwolf/generated/werwolf.pb.dart';
import 'package:werwolf/voting/voting_scaffold.dart';

/// Werewolves pick a victim. [targets] are the players that may be attacked.
///
/// The vote is committed: once this wolf has voted ([committedTargetId] is set,
/// or [locked] is true) the choice can no longer be changed and stays
/// highlighted. [voteCounts] maps a target id to how many wolves have committed
/// to it, shown as a live red badge. [secondsLeft] drives a countdown.
class WerwolfVoting extends StatefulWidget {
  final List<PlayerStatus> targets;
  final Map<String, int> voteCounts;
  final String? committedTargetId;
  final bool locked;
  final int? secondsLeft;
  final void Function(String targetId) onVote;

  const WerwolfVoting({
    super.key,
    required this.targets,
    required this.onVote,
    this.voteCounts = const {},
    this.committedTargetId,
    this.locked = false,
    this.secondsLeft,
  });

  @override
  State<WerwolfVoting> createState() => _WerwolfVotingState();
}

class _WerwolfVotingState extends State<WerwolfVoting> {
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    final locked = widget.locked || widget.committedTargetId != null;
    final highlightId = widget.committedTargetId ?? _selectedId;

    final subtitle = StringBuffer(locked ? 'Opfer bestätigt' : 'Wählt euer Opfer');
    if (widget.secondsLeft != null) {
      subtitle.write('  •  ${widget.secondsLeft}s');
    }

    return VotingScaffold(
      title: 'Werwölfe',
      subtitle: subtitle.toString(),
      children: [
        for (final p in widget.targets)
          VotingPlayerTile(
            name: p.name,
            selected: highlightId == p.id,
            voteCount: widget.voteCounts[p.id] ?? 0,
            onTap: locked ? null : () => setState(() => _selectedId = p.id),
          ),
        const SizedBox(height: 24),
        VotingConfirmButton(
          label: locked ? 'Bestätigt' : 'Angreifen',
          enabled: !locked && _selectedId != null,
          onPressed: () => widget.onVote(_selectedId!),
        ),
      ],
    );
  }
}
