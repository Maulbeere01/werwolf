# Frontend Setup Guide

Flutter-App (Client) fuer Werwolf. Kommuniziert per gRPC mit dem [Backend](../backend/README.md).

## Voraussetzungen
* Flutter SDK (stable channel, aktuell getestet mit 3.41.x / Dart 3.11.5)
* Ein laufendes Backend (siehe `backend/README.md`) oder Zugriff auf die Prod-Instanz

Mit `flutter doctor` pruefen, welche Plattformen lokal einsatzbereit sind. Unterstuetzt werden aktuell **Linux Desktop** und **Android**.

## Setup

### 1. Dependencies installieren
```bash
cd frontend
flutter pub get
```

### 2. Server-Adresse konfigurieren
Die App laedt die Verbindungsdaten zur Laufzeit aus einer JSON-Datei unter `assets/`:

* `assets/config.json` wird im normalen (Dev-)Build verwendet.
* `assets/config.prod.json` wird verwendet, wenn mit `--dart-define=APP_ENV=prod` gebaut/gestartet wird (zeigt auf die Prod-Instanz).

Fuer lokale Entwicklung `assets/config.json` auf dein Backend anpassen:
```json
{
  "server_ip": "127.0.0.1",
  "server_port": 9090,
  "use_tls": false
}
```
`server_ip` muss von dem Geraet aus erreichbar sein, auf dem die App laeuft, bei einem Android-Geraet/Emulator also ggf. die LAN-IP des Rechners statt `127.0.0.1` (siehe `lib/services/grpc_handler.dart`).

**Achtung:** `assets/config.json` ist versioniert Aenderungen fuer den eigenen Rechner nicht committen (`git update-index --skip-worktree assets/config.json` kann das lokal unterdruecken).

### 3. gRPC-Code generieren (nur bei Proto-Aenderungen)
Der generierte Code liegt bereits unter `lib/generated/` im Repo, ist eingecheckt und muss fuer den normalen Setup-Flow nicht neu erzeugt werden. Nur noetig, wenn sich `proto/werwolf.proto` geaendert hat. Dafuer werden `protoc` und `protoc-gen-dart` (`dart pub global activate protoc_plugin`) vorausgesetzt:
```bash
# im Repo-Root ausfuehren
./generate_dart_protos.sh
```

### 4. App starten
```bash
cd frontend
flutter run -d linux      # Linux Desktop
flutter run -d <device-id>  # Android-Geraet/Emulator, siehe `flutter devices`
```
Fuer die Prod-Konfiguration zusaetzlich `--dart-define=APP_ENV=prod` anhaengen.

## Entwicklung

### Mehrere Clients gleichzeitig testen (Linux)
`scripts/run_clients.sh` baut die Linux-Debug-Bundle einmal und startet davon beliebig viele isolierte Instanzen (eigenes `run`-Verzeichnis pro Client, optional Auto-Login):
```bash
./scripts/run_clients.sh 4                 # 4 Instanzen, Dev-Config, Auto-Login test1..test4
./scripts/run_clients.sh 4 --skip-build     # ohne erneut zu bauen
./scripts/run_clients.sh 4 --prod           # gegen Prod-Backend
./scripts/run_clients.sh 4 --no-login
./scripts/run_clients.sh 2 --size=400x860
```

Standardmaessig loggt das Skript die Instanzen automatisch ein. Dafuer muessen vorher im Backend passende User angelegt sein, benannt nach dem Schema test1, test2 usw. (Praefix `test` plus Instanznummer), mit dem Passwort 1234567890, jeweils passend zur Anzahl der gestarteten Clients.

### Icons
App-Icons werden aus `assets/PNGs/icon.png` generiert:
```bash
flutter pub run flutter_launcher_icons
```

## Troubleshooting

* **`Unable to load asset` / Config nicht gefunden:** `flutter pub get` erneut ausfuehren, damit Assets aus der `pubspec.yaml` eingebunden werden.
* **gRPC `UNAVAILABLE` / Verbindung schlaegt fehl:** Backend laeuft nicht oder `server_ip`/`server_port` in `assets/config.json` stimmt nicht (siehe oben). Bei WSL2 ggf. Firewall/Portproxy pruefen.
