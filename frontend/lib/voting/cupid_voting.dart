import 'package:flutter/material.dart';
import 'package:werwolf/generated/werwolf.pb.dart';
import 'package:werwolf/voting/voting_scaffold.dart';

/// Amor (cupid) wakes only on the first night and picks exactly two players to
/// fall in love. If one of them dies, the other dies of heartbreak. There is no
/// reveal for cupid itself: once paired the night moves on
class AmorVoting extends StatefulWidget {
  final List<PlayerStatus> targets;
  final int? secondsLeft;
  final void Function(String firstId, String secondId) onPair;

  /// cupid always pairs exactly this many players
  static const int requiredLovers = 2;

  const AmorVoting({
    super.key,
    required this.targets,
    required this.onPair,
    this.secondsLeft,
  });

  @override
  State<AmorVoting> createState() => _AmorVotingState();
}

class _AmorVotingState extends State<AmorVoting> {
  final List<String> _selectedIds = [];

  void _toggle(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else if (_selectedIds.length < AmorVoting.requiredLovers) {
        _selectedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final subtitle = StringBuffer(
      'Wähle ${AmorVoting.requiredLovers} Verliebte '
      '(${_selectedIds.length}/${AmorVoting.requiredLovers})',
    );
    if (widget.secondsLeft != null) {
      subtitle.write('  •  ${widget.secondsLeft}s');
    }

    return VotingScaffold(
      title: 'Amor',
      subtitle: subtitle.toString(),
      children: [
        for (final p in widget.targets)
          VotingPlayerTile(
            name: p.name,
            selected: _selectedIds.contains(p.id),
            voteCount: 0,
            voteBadgeColor: Colors.pinkAccent,
            onTap: () => _toggle(p.id),
          ),
        const SizedBox(height: 24),
        VotingConfirmButton(
          label: 'Verkuppeln',
          enabled: _selectedIds.length == AmorVoting.requiredLovers,
          onPressed: () => widget.onPair(_selectedIds[0], _selectedIds[1]),
        ),
      ],
    );
  }
}
