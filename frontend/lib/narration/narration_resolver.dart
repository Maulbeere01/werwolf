import 'package:werwolf/generated/werwolf.pb.dart';
import 'package:werwolf/narration/narration_cues.dart';
import 'package:werwolf/utils/role_display.dart';

/// Pure mapping from game state to the voice lines that should play.
///
/// Everything here is side-effect free so it can be unit-tested without audio.
/// The [NarrationController] owns the "what changed since last time" state and
/// calls into these functions; it never decides *which* line plays itself.

/// Night phases in which a single role acts. After one of these ends we play
/// [VoiceLine.closeEyes] ("Schließe deine Augen") before the next wake-up.
bool isNightActionPhase(Phase phase) =>
    phase == Phase.NIGHT_CUPID ||
    phase == Phase.NIGHT_WEREWOLVES ||
    phase == Phase.NIGHT_SEER ||
    phase == Phase.NIGHT_WITCH ||
    phase == Phase.NIGHT_FOX ||
    phase == Phase.NIGHT_SABOTEUR;

/// Every night phase, including the NIGHT_START intro. Used to decide the
/// day<->night transition lines (schlafen / aufwachen).
bool isNightPhase(Phase phase) =>
    phase == Phase.NIGHT_START || isNightActionPhase(phase);

/// Lines to play when the phase changes from [prev] to [next].
///
/// Order: first "close your eyes" for the role whose turn just ended, then the
/// day/night transition ("it becomes day/night"), then the wake-up for the new
/// role (or the day-discussion cue). NIGHT_START (the intro) is deliberately
/// silent here ,the Intro screen drives intro1/intro2 itself, since the cards
/// are revealed between the two halves.
List<VoiceLine> phaseEnterLines(Phase prev, Phase next) {
  if (next == prev) return const <VoiceLine>[];
  final lines = <VoiceLine>[];

  // the role whose phase just ended falls back asleep
  if (isNightActionPhase(prev)) lines.add(VoiceLine.closeEyes);

  // day breaks once the night's last role is done
  if (next == Phase.DAY_RESULT && isNightPhase(prev)) {
    lines.add(VoiceLine.aufwachen);
  }
  // night falls when leaving the day for the first night phase of the cycle
  if (isNightPhase(next) && next != Phase.NIGHT_START && !isNightPhase(prev)) {
    lines.add(VoiceLine.schlafen);
  }

  final roleLine = switch (next) {
    Phase.NIGHT_CUPID => VoiceLine.cupid,
    Phase.NIGHT_WEREWOLVES => VoiceLine.werewolves,
    Phase.NIGHT_SEER => VoiceLine.seer,
    Phase.NIGHT_WITCH => VoiceLine.witch,
    Phase.NIGHT_FOX => VoiceLine.fox,
    Phase.NIGHT_SABOTEUR => VoiceLine.saboteur,
    Phase.DAY_DISCUSSION => VoiceLine.discuss,
    _ => null,
  };
  if (roleLine != null) lines.add(roleLine);

  return lines;
}

/// The night action phase a wake-up line belongs to, or null for any line that
/// is not a role's wake-up. Lets the night screen reveal that role's action UI
/// in sync with its narration (when the line actually plays) instead of the
/// instant the backend changes phase, which can be well before the line
Phase? actionPhaseForLine(VoiceLine line) => switch (line) {
      VoiceLine.cupid => Phase.NIGHT_CUPID,
      VoiceLine.werewolves => Phase.NIGHT_WEREWOLVES,
      VoiceLine.seer => Phase.NIGHT_SEER,
      VoiceLine.witch => Phase.NIGHT_WITCH,
      VoiceLine.fox => Phase.NIGHT_FOX,
      VoiceLine.saboteur => Phase.NIGHT_SABOTEUR,
      _ => null,
    };

/// Lines for a public announcement (night outcome or day-vote result).
///
/// The victim-count line is layered with a heartbreak line when a lover died of
/// grief
List<VoiceLine> announcementLines(PublicAnnouncement a) {
  switch (a.whichEvent()) {
    case PublicAnnouncement_Event.nightDeath:
      final deaths = a.nightDeath.deaths;
      final lines = <VoiceLine>[];
      final count = deaths.length;
      if (count == 1) {
        lines.add(VoiceLine.victims1);
      } else if (count == 2) {
        lines.add(VoiceLine.victims2);
      } else if (count >= 3) {
        lines.add(VoiceLine.victims3);
      }
      if (deaths.any((d) => d.cause == EliminationCause.CAUSE_HEARTBREAK)) {
        lines.add(VoiceLine.loverDeath);
      }
      return lines;
    case PublicAnnouncement_Event.noDeath:
      return <VoiceLine>[VoiceLine.allSurvived];
    case PublicAnnouncement_Event.voteResult:
      // tie / no lynch -> "the village is unsure"; a real lynch has no line
      return a.voteResult.tied
          ? <VoiceLine>[VoiceLine.villageTied]
          : const <VoiceLine>[];
    case PublicAnnouncement_Event.hunterShot:
      return <VoiceLine>[VoiceLine.hunterDeath];
    case PublicAnnouncement_Event.gameEnd:
      // the win line is resolved by gameEndLines from the snapshot's team field
      return const <VoiceLine>[];
    default:
      return const <VoiceLine>[];
  }
}

/// A stable signature for an announcement, so the controller can tell a genuinely
/// new announcement from the same snapshot being re-delivered (the stream resends
/// snapshots and reconnects replay the latest one).
String announcementSignature(PublicAnnouncement a) {
  switch (a.whichEvent()) {
    case PublicAnnouncement_Event.nightDeath:
      final ids = a.nightDeath.deaths
          .map((d) => '${d.playerId}/${d.cause.value}')
          .join(',');
      return 'night:$ids';
    case PublicAnnouncement_Event.noDeath:
      return 'noDeath';
    case PublicAnnouncement_Event.voteResult:
      final v = a.voteResult;
      return 'vote:${v.tied}:${v.eliminatedPlayerId}:${v.alsoDiedIds.join(',')}';
    case PublicAnnouncement_Event.hunterShot:
      return 'hunter:${a.hunterShot.shooterId}->${a.hunterShot.targetId}';
    case PublicAnnouncement_Event.gameEnd:
      return 'gameEnd:${a.gameEnd.winningTeam.value}';
    default:
      return 'none';
  }
}

/// The win line for a GAME_END snapshot.
///
/// The backend currently only ever reports a VILLAGER or WEREWOLF win; a lovers'
/// victory (VoiceLine.loverWin)
List<VoiceLine> gameEndLines(GameUpdate update) {
  final team = winningTeamOf(update);
  if (team == Role.WEREWOLF) return <VoiceLine>[VoiceLine.werewolfWin];
  if (team == Role.VILLAGER) return <VoiceLine>[VoiceLine.villageWin];
  return const <VoiceLine>[];
}
