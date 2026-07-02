/// Every narratable voice line in the game. This enum plus [kVoiceLines] is the
/// single place to add, swap or retime a line: the resolver
/// (narration_resolver.dart) only ever refers to these symbols, never to raw
/// asset paths.
enum VoiceLine {
  // intro (played on the Intro screen, see NarrationController.playIntro)
  intro1,
  intro2,

  // day <-> night transitions
  schlafen, // "Schließt eure Augen, die Nacht bricht ein"
  aufwachen, // "Öffnet eure Augen, es wird Tag"

  // role wake-ups (one per night action phase)
  cupid,
  seer,
  werewolves,
  witch,
  fox,
  saboteur,
  closeEyes, // "Schließe deine Augen" – played after each role's turn

  // night result announcements
  victims1,
  victims2,
  victims3,
  allSurvived,
  loverDeath, // a lover died of heartbreak
  hunterDeath, // the hunter took someone with him

  // day announcements
  villageTied, // the day vote ended without a lynch
  discuss, // "Diskutiert, was das Dorf jetzt unternehmen wird"

  // game end
  villageWin,
  werewolfWin,
  loverWin,
}

/// A single voice line: the asset to play and roughly how long it runs.
///
/// [lengthSeconds] is informational it documents how long the line takes so
/// the backend phase durations (GameLoopService.PHASE_DURATIONS) can be tuned to
/// be at least this long, so a line is never cut off when the phase advances.
class NarrationCue {
  const NarrationCue(this.asset, this.lengthSeconds);

  /// Path passed to audioplayers' AssetSource: relative to `assets/`, so it
  /// carries no leading `assets/` (matches the existing `hintergrund.mp3` use).
  final String asset;

  /// Approximate length of the recording in seconds.
  final double lengthSeconds;
}

const String _base = 'mp3/voice_lines/Werwolf_Voicelines_';

/// The manifest: maps every [VoiceLine] to its recording. Swap a file or retime
/// a line here
const Map<VoiceLine, NarrationCue> kVoiceLines = <VoiceLine, NarrationCue>{
  VoiceLine.intro1: NarrationCue('${_base}Intro_1.mp3', 88),
  VoiceLine.intro2: NarrationCue('${_base}Intro_2.mp3', 15),
  VoiceLine.schlafen: NarrationCue('${_base}Schlafen.mp3', 10),
  VoiceLine.aufwachen: NarrationCue('${_base}Aufwachen.mp3', 10),
  VoiceLine.cupid: NarrationCue('${_base}Liebespaar_Amor.mp3', 14),
  VoiceLine.seer: NarrationCue('${_base}Liebespaar_Seher.mp3', 11),
  VoiceLine.werewolves: NarrationCue('${_base}Werwoelfe.mp3', 9),
  VoiceLine.witch: NarrationCue('${_base}Hexe.mp3', 10),
  VoiceLine.fox: NarrationCue('${_base}Fuchs.mp3', 11),
  VoiceLine.saboteur: NarrationCue('${_base}Saboteur.mp3', 11),
  VoiceLine.closeEyes: NarrationCue('${_base}Augen_schliessen.mp3', 4),
  VoiceLine.victims1: NarrationCue('${_base}Opfer_1.mp3', 5),
  VoiceLine.victims2: NarrationCue('${_base}Opfer_2.mp3', 5),
  VoiceLine.victims3: NarrationCue('${_base}Opfer_3.mp3', 5),
  VoiceLine.allSurvived: NarrationCue('${_base}Alle_leben.mp3', 5),
  VoiceLine.loverDeath: NarrationCue('${_base}Tod_der_Liebenden.mp3', 12),
  VoiceLine.hunterDeath: NarrationCue('${_base}Tod_des_Jaegers.mp3', 12),
  VoiceLine.villageTied: NarrationCue('${_base}Dorf_uneinig.mp3', 10),
  VoiceLine.discuss: NarrationCue('${_base}Dorf_diskutieren.mp3', 7),
  VoiceLine.villageWin: NarrationCue('${_base}Happyend.mp3', 12),
  VoiceLine.werewolfWin: NarrationCue('${_base}Werwoelfe_Sieg.mp3', 9),
  VoiceLine.loverWin: NarrationCue('${_base}Liebespaar_Sieg.mp3', 13),
};

NarrationCue? cueFor(VoiceLine line) => kVoiceLines[line];
