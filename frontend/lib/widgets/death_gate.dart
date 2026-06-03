import 'package:flutter/material.dart';
import 'package:werwolf/auth/auth_state.dart';
import 'package:werwolf/controller/game_stream_controller.dart';
import 'package:werwolf/generated/werwolf.pb.dart';
import 'package:werwolf/personal_todscreen.dart';
import 'package:werwolf/role_display.dart';

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
  // null while alive; set once with the role + cause captured at the moment of
  // death (later updates clear the announcement, so we snapshot it here).
  _Death? _death;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_check);
    _check();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_check);
    super.dispose();
  }

  void _check() {
    if (_death != null) return; // already dead, nothing changes
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

    final role = me.role != Role.ROLE_UNSPECIFIED ? me.role : update.yourRole;
    if (!mounted) {
      _death = _Death(role: roleName(role), cause: _deathCause(update, self));
      return;
    }
    setState(() {
      _death = _Death(role: roleName(role), cause: _deathCause(update, self));
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
    if (a.hasNightDeath() && a.nightDeath.playerId == selfId) {
      return _causeText(a.nightDeath.cause);
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
