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
  //
  // Must stay strictly greater than NightStart's _nightToDayHold (5s): a
  // night death is detected while DeathGate is still mounted on the (about to
  // be replaced) night screen, racing this timer against the night screen's
  // own navigation to DayStart. If this timer won that race, the death screen
  // would flash on the old night screen and then get replaced by the day
  // result reveal when DayStart takes over - only to flip back to the death
  // screen a few seconds later on a fresh DeathGate. Keeping this delay above
  // the hold means the night screen always navigates away first, so the
  // reveal only ever plays out once, cleanly, on the day screen.
  static const Duration _revealDelay = Duration(seconds: 7);

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
    if (_death != null) return; // already showing the death screen
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

    // Capture role + cause at the moment of death, since the announcement that
    // named us is cleared on the next phase. Captured once (??=), so a hunter
    // who dies and only later takes their revenge still shows the right cause.
    final role = me.role != Role.ROLE_UNSPECIFIED ? me.role : update.yourRole;
    _pending ??= _Death(role: roleName(role), cause: _deathCause(update, self));

    // A just-killed hunter still owes a revenge shot: keep them on the game
    // screen (which shows the revenge picker) instead of latching the death
    // screen. Once they have shot, this flag clears and the death screen takes
    // over on the next snapshot.
    if (update.youMustTakeRevenge) return;

    if (_revealTimer != null) return; // reveal already scheduled

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
    if (a.hasVoteResult() && a.voteResult.alsoDiedIds.contains(selfId)) {
      return 'Aus Liebeskummer gestorben';
    }
    if (a.hasHunterShot() && a.hunterShot.targetId == selfId) {
      return 'Vom Jäger erschossen';
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
