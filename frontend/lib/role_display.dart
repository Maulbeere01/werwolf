import 'package:werwolf/generated/werwolf.pb.dart';

String roleName(Role role) => switch (role) {
      Role.WEREWOLF => 'Werwolf',
      Role.VILLAGER => 'Dorfbewohner',
      Role.SEER => 'Seherin',
      Role.WITCH => 'Hexe',
      Role.FOX => 'Fuchs',
      Role.VILLAGE_IDIOT => 'Dorftrottel',
      Role.HUNTER => 'Jäger',
      _ => 'Unbekannt',
    };

String winningTeamName(Role team) => team == Role.WEREWOLF ? 'Werwölfe' : 'Dorf';

/// The winning team carried by a GAME_END update, from either the dedicated
/// field or the GameEnd announcement.
Role winningTeamOf(GameUpdate update) {
  if (update.winningTeam != Role.ROLE_UNSPECIFIED) return update.winningTeam;
  if (update.hasAnnouncement() && update.announcement.hasGameEnd()) {
    return update.announcement.gameEnd.winningTeam;
  }
  return Role.ROLE_UNSPECIFIED;
}
