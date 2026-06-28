import 'package:werwolf/auth/auth_state.dart';
import 'package:werwolf/generated/werwolf.pb.dart';

/// The role card artwork for a role. The witch has no dedicated card yet, so it
/// borrows the Armor card as a placeholder; roles without their own card fall
/// back to the villager card.
String roleCardAsset(Role role) => switch (role) {
      Role.SEER => 'assets/PNGs/Seher.png',
      Role.WEREWOLF => 'assets/PNGs/wolf.png',
      Role.WITCH => 'assets/PNGs/Hexe.png',
      Role.FOX => 'assets/PNGs/Fuchs.png',
      Role.SABOTEUR => 'assets/PNGs/sabateur.png',
      Role.CUPID => 'assets/PNGs/Armor.png',
      _ => 'assets/PNGs/villager.png',
    };

/// This player's own role from a snapshot: the dedicated your_role field if set,
/// otherwise their entry in the player list. ROLE_UNSPECIFIED when unknown.
Role selfRoleOf(GameUpdate update) {
  if (update.yourRole != Role.ROLE_UNSPECIFIED) return update.yourRole;
  final self = AuthState.userId ?? '';
  for (final p in update.players) {
    if (p.id == self) return p.role;
  }
  return Role.ROLE_UNSPECIFIED;
}

String roleName(Role role) => switch (role) {
      Role.WEREWOLF => 'Werwolf',
      Role.VILLAGER => 'Dorfbewohner',
      Role.SEER => 'Seherin',
      Role.WITCH => 'Hexe',
      Role.FOX => 'Fuchs',
      Role.VILLAGE_IDIOT => 'Dorftrottel',
      Role.HUNTER => 'Jäger',
      Role.SABOTEUR => 'Saboteur',
      Role.CUPID => 'Amor',
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
