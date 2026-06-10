import 'dart:async';

import 'package:flutter/material.dart';
import 'package:werwolf/auth/auth_state.dart';
import 'package:werwolf/controllers/game_stream_controller.dart';
import 'package:werwolf/generated/werwolf.pb.dart';
import 'package:werwolf/screens/personal_death_screen.dart';
import 'package:werwolf/utils/role_display.dart';

/// Wraps a game screen and, the moment this player dies, replaces it with the
/// personal [TodScreen]. Death is latched: once dead the player stays on the
/// death screen for the rest of the game (they no longer take part).
class DeathGate extends StatefulWidget {
  final GameStreamController controller;
  final Widget child;

  const DeathGate({
    super.key,
    required this.controller,
    required this.child,
  });

  @override
  State<DeathGate> createState() => _DeathGateState();
}

class _DeathGateState extends State<DeathGate> {
  // How long the result that killed the player stays visible before the
  // personal death screen takes over.
  static const Duration _revealDelay = Duration(seconds: 5);

  // null until the death screen is actually shown; holds the role + cause
  // captured at the moment of death (later updates clear the announcement).
  _Death? _death;

  // Captured once death is detected, before the reveal delay elapses.
  _Death? _pending;
  Timer? _revealTimer;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_check);
    _check();
  }

  @override
  void dispose() {
    _revealTimer?.cancel();
    widget.controller.removeListener(_check);
    super.dispose();
  }

  void _check() {
    if (_death != null || _pending != null) return; // already dying/dead
    final update = widget.controller.currentUpdate;
    final self = AuthState.userId ?? '';

    PlayerStatus? me;
    for (final p in update.players) {
      if (p.id == self) {
        me = p;
        break;
      }
    }
    if (me == null || me.isAlive) return;

    // Snapshot role + cause now, since the announcement is cleared on the next
    // phase.
    final role = me.role != Role.ROLE_UNSPECIFIED ? me.role : update.yourRole;
    _pending = _Death(role: roleName(role), cause: _deathCause(update, self));

    final isVoteDeath =
        update.hasAnnouncement() && update.announcement.hasVoteResult();
    if (isVoteDeath) {
      if (mounted) {
        setState(() => _death = _pending);
      } else {
        _death = _pending;
      }
      return;
    }
    _revealTimer = Timer(_revealDelay, () {
      if (!mounted) return;
      setState(() {
        _death = _pending;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final death = _death;
    if (death != null) {
      return TodScreen(exRolle: death.role, todesUrsache: death.cause);
    }
    return widget.child;
  }
}

class _Death {
  final String role;
  final String cause;
  const _Death({required this.role, required this.cause});
}

// Best-effort death cause, read from the announcement that named this player at
// the moment they died.
String _deathCause(GameUpdate update, String selfId) {
  if (update.hasAnnouncement()) {
    final a = update.announcement;
    if (a.hasNightDeath()) {
      for (final d in a.nightDeath.deaths) {
        if (d.playerId == selfId) return _causeText(d.cause);
      }
    }
    if (a.hasVoteResult() &&
        !a.voteResult.tied &&
        a.voteResult.eliminatedPlayerId == selfId) {
      return 'Vom Dorf gehängt';
    }
  }
  return 'Aus dem Spiel ausgeschieden';
}

String _causeText(EliminationCause cause) => switch (cause) {
      EliminationCause.KILLED_BY_WEREWOLVES => 'Von den Werwölfen getötet',
      EliminationCause.KILLED_BY_WITCH => 'Von der Hexe vergiftet',
      EliminationCause.VOTED_OUT => 'Vom Dorf gehängt',
      EliminationCause.CAUSE_HUNTER_REVENGE => 'Vom Jäger erschossen',
      _ => 'Gestorben',
    };
