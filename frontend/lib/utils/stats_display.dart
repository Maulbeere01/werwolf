/// The cap a stat-progress-bar fills towards: starts at 10 and doubles once
/// the score exceeds it, giving an endless (never-maxed-out) bar. The score
/// itself is the only thing persisted; the cap is always recomputed from it
/// (here, on every build), so it can never go stale across app restarts.
int progressCapFor(int score) {
  int cap = 10;
  while (cap < score) {
    cap *= 2;
  }
  return cap;
}

/// Win rate in percent (0-100), based on games played vs. lost. 0 when no
/// games have been played yet (avoids a division by zero).
double winRatePercent(int gamesPlayed, int gamesLost) {
  if (gamesPlayed <= 0) return 0.0;
  final won = gamesPlayed - gamesLost;
  return won / gamesPlayed * 100;
}
