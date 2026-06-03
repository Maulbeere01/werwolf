import 'package:flutter/material.dart';
import 'package:werwolf/generated/werwolf.pb.dart';
import 'package:werwolf/voting/voting_scaffold.dart';

class HexeVoting extends StatefulWidget {
  final String attackedPlayerId;
  final bool hasHealPotion;
  final bool hasPoisonPotion;
  final List<PlayerStatus> players;
  final String selfId;
  final int? secondsLeft;
  final void Function(bool heal, String? poisonTargetId) onSubmit;

  const HexeVoting({
    super.key,
    required this.attackedPlayerId,
    required this.hasHealPotion,
    required this.hasPoisonPotion,
    required this.players,
    required this.selfId,
    required this.onSubmit,
    this.secondsLeft,
  });

  @override
  State<HexeVoting> createState() => _HexeVotingState();
}

class _HexeVotingState extends State<HexeVoting> {
  bool _heal = false;
  String? _poisonId;

  String _nameOf(String id) {
    for (final p in widget.players) {
      if (p.id == id) return p.name;
    }
    return id;
  }

  @override
  Widget build(BuildContext context) {
    final hasVictim = widget.attackedPlayerId.isNotEmpty;
    final canHeal = widget.hasHealPotion && hasVictim;
    final selfIsVictim = widget.attackedPlayerId == widget.selfId;

    final poisonTargets = widget.players
        .where((p) => p.isAlive && p.id != widget.selfId)
        .toList();

    final subtitle = StringBuffer('Heiltrank und Gifttrank: Nutze sie weise!');
    if (widget.secondsLeft != null) {
      subtitle.write('  •  ${widget.secondsLeft}s');
    }

    return VotingScaffold(
      title: 'Hexe',
      subtitle: subtitle.toString(),
      footer: VotingConfirmButton(
        label: 'Fertig',
        enabled: true,
        onPressed: () => widget.onSubmit(
          canHeal && _heal,
          _poisonId,
        ),
      ),
      children: [
        // The witch always sees who the werewolves attacked tonight, even when
        // her heal potion is already used up, so she can see whether she herself
        // is the victim and decide to take revenge with the poison.
        _SectionLabel('Opfer dieser Nacht'),
        if (!hasVictim)
          const _InfoText('Heute Nacht wurde niemand angegriffen.')
        else
          _InfoText(selfIsVictim
              ? 'Du wurdest von den Werwölfen angegriffen!'
              : '${_nameOf(widget.attackedPlayerId)} wurde von den Werwölfen angegriffen.'),

        const SizedBox(height: 16),

        // Healing section
        _SectionLabel('Heiltrank'),
        if (!widget.hasHealPotion)
          const _InfoText('Du hast deinen Heiltrank bereits verbraucht.')
        else if (!hasVictim)
          const _InfoText('Heute Nacht wurde niemand angegriffen.')
        else
          _HealCard(
            victimName: selfIsVictim ? 'Du' : _nameOf(widget.attackedPlayerId),
            isSelf: selfIsVictim,
            healing: _heal,
            onChanged: (v) => setState(() => _heal = v),
          ),

        const SizedBox(height: 16),

        // Poison section
        _SectionLabel('Gifttrank'),
        if (!widget.hasPoisonPotion)
          const _InfoText('Du hast deinen Gifttrank bereits verbraucht.')
        else
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 260),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: [
                for (final p in poisonTargets)
                  VotingPlayerTile(
                    name: p.name,
                    selected: _poisonId == p.id,
                    // tapping the selected one again clears the poison choice
                    onTap: () => setState(
                      () => _poisonId = _poisonId == p.id ? null : p.id,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _InfoText extends StatelessWidget {
  final String text;
  const _InfoText(this.text);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white54, fontSize: 14),
        ),
      ),
    );
  }
}

class _HealCard extends StatelessWidget {
  final String victimName;
  final bool isSelf;
  final bool healing;
  final ValueChanged<bool> onChanged;

  const _HealCard({
    required this.victimName,
    required this.isSelf,
    required this.healing,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final title = isSelf ? 'Du stirbst! Willst du dich retten?' : '$victimName retten';
    final subtitle = isSelf
        ? 'Du wurdest von den Werwölfen angegriffen'
        : '$victimName wurde von den Werwölfen angegriffen';
    final activeColor = isSelf ? Colors.amber : Colors.lightGreenAccent;

    return Material(
      color: healing ? activeColor.withOpacity(0.85) : Colors.white12,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: SwitchListTile(
        value: healing,
        onChanged: onChanged,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(
          title,
          style: TextStyle(
            color: healing ? Colors.black : (isSelf ? Colors.amberAccent : Colors.white),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: healing ? Colors.black54 : Colors.white54,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
