# Todo-Liste: Minimale spielbare Runde

Zielrollen: **Werwolf, Dorfbewohner, Seher, Hexe**

- [ ] In `performAction` sicherstellen, dass der Aufrufer im Spiel ist, noch lebt und die zur Phase passende Rolle hat
- [ ] Hexe: echtes Werwolf-Opfer sehen, heilen und vergiften können
- [ ] Bei `DAY_RESULT` die Spieler in `deadPlayers` auf `alive = false` setzen und die Liste leeren
- [ ] Tages-Abstimmung (`DAY_VOTING`): Stimmen sammeln, auswerten und den meistgewählten Spieler eliminieren
- [ ] Phasen ohne lebenden Rollenträger überspringen?
- [ ]  Nach jeder Phase checken, ob alle Wölfe tot sind (Sieg Dorf) oder die Wölfe in der Überzahl sind (Sieg Wölfe) und das Spiel bei `GAME_END` stoppen.# Todo-Liste: Minimale spielbare Runde
