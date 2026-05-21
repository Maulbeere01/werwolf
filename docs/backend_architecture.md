# Architektur

Die externe Kommunikation läuft vollständig über gRPC-Schnittstellen. Da Werwolf ein synchrones Spiel ist, wird die Datenbank nur für persistente Nutzerdaten verwendet. Die gesamte Spiellogik läuft zustandsbehaftet im Arbeitsspeicher des Servers.

## Nutzerverwaltung und Authentifizierung
Die Registrierung und der Login werden über den `UserServiceImpl` abgewickelt. Passwörter werden niemals im Klartext verarbeitet, sondern direkt mit einem BCrypt-Hash in der Datenbank gespeichert.

Das Backend arbeitet mit einer stateless Authentifizierung. Bei einem erfolgreichen Login erstellt der `JwtService` ein JSON Web Token (JWT), das standardmäßig 7 Tage gültig ist. Der Client muss dieses Token bei allen geschützten gRPC-Anfragen im `authorization`-Header mitsenden.

Der `JwtServerInterceptor` fängt jede eingehende gRPC-Anfrage ab (außer Login und Registrierung). Er validiert die kryptografische Signatur des Tokens. Ist die Signatur korrekt, extrahiert der Interceptor die `userId` und den `username` und speichert diese im `AuthContext`. Auf diese Weise wissen die nachfolgenden Services exakt, welcher verifizierte Nutzer die Methode aufruft, ohne eine Datenbankabfrage auszuführen.

## Lobbys und Spielzustand
Aktive Spiele erfordern sehr schnelle Lese- und Schreibzugriffe. Daher werden Lobbys und aktive Spiele nicht in der Datenbank gespeichert, sondern liegen in einer `ConcurrentHashMap` im Arbeitsspeicher. Diese Struktur verhindert Dateninkonsistenzen bei parallelen Anfragen.

* **Lobby:** Der `LobbyManager` verwaltet die Lobbys vor Spielbeginn. Hier werden die Spieler gesammelt und die Einstellungen definiert.
* **GameState:** Startet der Host das Spiel, generiert das System ein `GameState`-Objekt. Dieses Objekt hält den kompletten Status der aktuellen Runde. Dazu gehören die vergebenen Rollen, die aktuelle Phase und spezifische Zwischenstände, wie die Liste der `deadPlayers`. In diese Liste werden nachts die Opfer der Werwölfe eingetragen. Am Tag (`DAY_RESULT`) wird diese Liste verarbeitet und die entsprechenden Spieler werden endgültig auf `alive = false` gesetzt. Verwaltet werden diese Statusobjekte durch den `GameStateService`.

## Game Loop
Der zeitliche Ablauf des Spiels wird serverseitig durch den `GameLoopService` vorangetrieben. Er nutzt einen `ScheduledExecutorService`, um den Wechsel der Spielphasen zeitgesteuert abzuwickeln.

Das Spiel durchläuft eine fest definierte Sequenz an Phasen (`PHASE_SEQUENCE`), wie `NIGHT_WEREWOLVES`, `NIGHT_SEER` oder `DAY_VOTING`. Tritt das Spiel in eine neue Phase ein, berechnet der Service das Ende der Phase (`phaseEndsAt`) und plant den nächsten Durchlauf. Direkt beim Phasenwechsel prüft die Methode `onEnter`, welche Rollen jetzt aktiv werden müssen. Der Service erstellt daraufhin rollenspezische Aufforderungen (`ActionPrompt`) und sendet diese gezielt an die entsprechenden Spieler.

## Spieleraktionen
Führt ein Spieler in seinem Client eine Aktion aus, empfängt die Methode `GameServiceImp.performAction` den Request. Bevor eine Aktion verarbeitet wird, prüft das Backend über die `PHASE_ACTION_MAP`, ob die gewünschte Aktion in der aktuellen Spielphase überhaupt zulässig ist.

Ist die Aktion legitim, wird sie an den `AbilityExecutor` übergeben. Dieser liest den genauen Aktionstyp aus (z.B. `WitchAction`) und ruft die entsprechende Logikklasse auf.
* Die `WerewolfAbility` fügt das gewählte Opfer zur `deadPlayers`-Liste im `GameState` hinzu.
* Die `WitchAbility` kann diese Liste modifizieren und ein Opfer wieder entfernen, falls der Heiltrank eingesetzt wird.

Nach der Ausführung speichert der Service den aktualisierten `GameState` ab.

## Kommunikation
Alle Clients müssen über Änderungen im Spielverlauf sofort informiert werden. Dies geschieht über langlebige gRPC-Streams. Wenn ein Spieler einer Lobby beitritt, ruft er `subscribeToGame` auf. Der `LobbySubscriptionService` speichert die Verbindung (`StreamObserver`) dieses Spielers ab.

Der Versand von Daten erfolgt über zwei getrennte Wege:
1. **Öffentliche Updates:** Die Methode `broadcast` iteriert über alle offenen Verbindungen einer Lobby und sendet den aktuellen Status an alle Spieler. Dies wird bei allgemeinen Phasenwechseln genutzt.
2. **Private Updates:** Die Methode `sendTo` adressiert exakt einen spezifischen `StreamObserver` über die `userId`. Das ist zwingend erforderlich, um geheime Informationen zu übermitteln, etwa wenn der Seher sein Untersuchungsergebnis erhält (`SeerReveal`) oder die Hexe nachts geweckt wird.

Da gRPC-Streams nicht threadsicher sind und von unterschiedlichen Quellen (Nutzeranfragen und dem automatischen `GameLoopService`) angesprochen werden, ist der Sendevorgang im `LobbySubscriptionService` mit einem `synchronized`-Block auf dem Observer abgesichert.