import 'package:flutter/material.dart';
import 'package:werwolf/voting/voting_scaffold.dart';

/// Full-screen notice shown to the player the saboteur silenced: for this whole
/// day they take no part in the discussion or the vote. Purely informational,
/// the enforcement happens server-side (their day vote is discarded).
class SabotageNotice extends StatelessWidget {
  final int? secondsLeft;

  const SabotageNotice({super.key, this.secondsLeft});

  @override
  Widget build(BuildContext context) {
    final subtitle = StringBuffer('Du wurdest sabotiert');
    if (secondsLeft != null) {
      subtitle.write('  •  ${secondsLeft}s');
    }

    return VotingScaffold(
      title: 'Sabotiert',
      subtitle: subtitle.toString(),
      children: const [
        SizedBox(height: 60),
        Icon(Icons.block, color: Colors.redAccent, size: 84),
        SizedBox(height: 28),
        Text(
          'Du bist für diesen Tag sabotiert.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Du darfst dich nicht an der Diskussion beteiligen und nicht abstimmen.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ],
    );
  }
}
