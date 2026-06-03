 import 'package:flutter/material.dart';
import 'package:werwolf/generated/werwolf.pb.dart';
import 'package:werwolf/voting/slide_to_confirm.dart';
import 'package:werwolf/voting/voting_scaffold.dart';

/// The village day vote: every living player picks who should be hanged, or nobody.
///
/// [targets] are the players that may be voted for (living players except self).
/// [voteCounts] maps a target id to how many OTHER players voted for it (shown
/// as a yellow badge). [committedTargetId] is this player's own committed choice:
/// null = not voted yet, '' = nobody, otherwise a player id. The vote is
/// committed via a slide button: pick a player (or no one) and slide to confirm.
/// [secondsLeft] drives the countdown. [onVote] commits a choice (pass '' for
/// nobody).
class DorfVoting extends StatefulWidget {
  static const String skip = ''; // empty target id == vote for nobody

  final List<PlayerStatus> targets;
  final Map<String, int> voteCounts;
  final String? committedTargetId;
  final bool locked;
  final int? secondsLeft;
  final void Function(String targetId) onVote;

  const DorfVoting({
    super.key,
    required this.targets,
    required this.onVote,
    this.voteCounts = const {},
    this.committedTargetId,
    this.locked = false,
    this.secondsLeft,
  });

  @override
  State<DorfVoting> createState() => _DorfVotingState();
}

class _DorfVotingState extends State<DorfVoting> {
  // null = nothing picked yet (slide confirms "nobody"); otherwise a player id
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    final locked = widget.locked || widget.committedTargetId != null;
    final highlightId = widget.committedTargetId ?? _selectedId;

    final subtitle = StringBuffer(locked ? 'Stimme abgegeben' : 'Wen soll das Dorf hängen?');
    if (widget.secondsLeft != null) {
      subtitle.write('  •  ${widget.secondsLeft}s');
    }

    // slide button label: defaults to "Niemanden wählen", switches to a short
    // "Wählen" once a player is picked (the name is omitted to avoid overflow).
    final picked = locked ? (widget.committedTargetId ?? _selectedId) : _selectedId;
    final bool hasPick = picked != null && picked != DorfVoting.skip;
    final String label;
    if (!hasPick) {
      label = locked ? 'Niemanden gewählt' : 'Niemanden wählen';
    } else {
      label = locked ? 'Gewählt' : 'Wählen';
    }

    return VotingScaffold(
      title: 'Abstimmung',
      subtitle: subtitle.toString(),
      children: [
        for (final p in widget.targets)
          VotingPlayerTile(
            name: p.name,
            selected: highlightId == p.id,
            voteCount: widget.voteCounts[p.id] ?? 0,
            voteBadgeColor: Colors.amber,
            // tap again to deselect -> back to "nobody"
            onTap: locked
                ? null
                : () => setState(
                    () => _selectedId = _selectedId == p.id ? null : p.id),
          ),
        const SizedBox(height: 24),
        SlideToConfirm(
          label: label,
          enabled: !locked,
          completed: locked,
          onConfirm: () => widget.onVote(_selectedId ?? DorfVoting.skip),
        ),
      ],
    );
  }
}
