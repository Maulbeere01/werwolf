# Disconnect Handling

## Wie es aktuell funktioniert

Der Client kommuniziert über einen dauerhaften gRPC-Server-Stream (`SubscribeToGame`). Der gesamte Disconnect-Mechanismus hängt an diesem Stream.

### Disconnect erkennen

In `GameServiceImp.subscribeToGame()` wird beim Öffnen des Streams ein `onCancel`-Handler registriert:

```java
serverObserver.setOnCancelHandler(() ->
        lobbySubscriptionService.unsubscribe(lobbyCode, userId, responseObserver));
```

gRPC feuert diesen Handler automatisch, wenn die Verbindung abbricht, egal ob der Client die App schließt, in den Hintergrund geht oder die Verbindung verliert. `unsubscribe()` entfernt den Stream-Observer aus der internen Map in `LobbySubscriptionService`. Ab diesem Moment bekommt der Spieler keine Updates mehr.

### Was beim Disconnect passiert

- Der Spieler bleibt vollständig im Spiel: sein `Player`-Objekt in `GameState.players` und in `Lobby.players` bleibt unverändert
- Der Phasen-Timer läuft weiter
- Andere Spieler sehen den Disconnect nicht (kein Status-Flag im `PlayerStatus`)
- Wenn der Backend-Loop versucht, ein Update an den getrennten Spieler zu senden (`sendTo`), schlägt der Aufruf still fehl , `LobbySubscriptionService.send()` fängt die Exception und loggt eine Warnung

### Reconnect

Der Client verbindet sich durch einen erneuten Aufruf von `SubscribeToGame`. Als erste Nachricht sendet der Server einen vollständigen personalisierten Snapshot:

- Falls das Spiel schon gestartet ist: aktueller `GameState` (Phase, Spielerliste, eigene Rolle, offener Prompt, Phase-Timer)
- Falls das Spiel noch in der Lobby ist: aktueller Lobby-Zustand

Der Spieler ist danach wieder vollständig synchron, unabhängig davon wie lange er getrennt war.

---

### Offene Fragen
Sollte das Spiel pausieren wenn wer disconnected?

Sollte ab einer Zeit X an Disconnect ein Spieler aus dem Spiel entfernt werden => Spieler eliminieren?
Ansonsten stimmt dieser nicht ab oder wir implementieren wenn kein Vote oder Aktion stattfindet wählt das backend eine Sache zufällig.

Ansonsten kann man per
Disconnect rausfinden welche Rolle der Spieler ist => Kein Werwolf Kill => Spieler muss Werwolf sein