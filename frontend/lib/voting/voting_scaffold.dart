import 'package:flutter/material.dart';

/// Shared full-screen layout for the night ability screens so the werewolf,
/// seer and witch screens look consistent.
class VotingScaffold extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;

  final Widget? footer;

  const VotingScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.85),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'BagelFatOne',
                  fontSize: 34,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(children: children),
                ),
              ),
              if (footer != null) ...[
                const SizedBox(height: 12),
                footer!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A selectable player row used inside the voting screens.
///
/// [voteCount] shows a red badge on the row indicating how many werewolves have
/// committed to this target (a counter is shown when more than one).
class VotingPlayerTile extends StatelessWidget {
  final String name;
  final bool selected;
  final VoidCallback? onTap;
  final int voteCount;
  final Color voteBadgeColor;

  const VotingPlayerTile({
    super.key,
    required this.name,
    required this.selected,
    this.onTap,
    this.voteCount = 0,
    this.voteBadgeColor = Colors.redAccent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: selected ? Colors.white : Colors.white12,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: CircleAvatar(
            backgroundColor: selected ? Colors.black12 : Colors.white24,
            child: Text(
              name.isEmpty ? '?' : name[0].toUpperCase(),
              style: TextStyle(
                color: selected ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            name,
            style: TextStyle(
              color: selected ? Colors.black : Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: _buildTrailing(),
        ),
      ),
    );
  }

  Widget? _buildTrailing() {
    final hasBadge = voteCount > 0;
    if (!hasBadge && !selected) return null;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasBadge) _voteBadge(voteCount),
        if (selected)
          Padding(
            padding: EdgeInsets.only(left: hasBadge ? 8 : 0),
            child: const Icon(Icons.check_circle, color: Colors.black),
          ),
      ],
    );
  }

  Widget _voteBadge(int count) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: voteBadgeColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: count > 1
          ? Text(
              '$count',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
    );
  }
}

/// Primary confirm button used at the bottom of the voting screens.
class VotingConfirmButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onPressed;

  const VotingConfirmButton({
    super.key,
    required this.label,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: enabled ? onPressed : null,
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
