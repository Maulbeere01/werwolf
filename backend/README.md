# Backend Setup Guide

## Voraussetzungen
* Java 21
* Docker & Docker Compose

## Setup

### 1. Umgebungsvariablen (.env)
1. Kopiere die Datei `backend/.env.example` und benenne sie in `.env` um. (Sie muss im Ordner `backend/` liegen).
2. Fuelle die Werte (DB_ROOT_PASSWORD, DB_PASSWORD, etc.) aus.

### 2. Datenbank mit Docker starten
Wir nutzen Docker Compose fuer die Datenbank-Umgebung.
1. Starte die Datenbank im `backend/`-Ordner:
   `docker-compose up -d`
2. Die Datei werwolf.sql (liegt unter src/main/resources/db/) wird beim ersten Start automatisch importiert.
3. Die DB ist unter Port 42069 erreichbar.

### 3. Backend starten

#### gRPC Generierung
**Mac/Linux/WSL:**
```bash
cd backend
./mvnw clean compile
```
**Windows PowerShell:**
```powershell
cd backend
./mvnw clean compile
```
**Windows CMD:**
```cmd
cd backend
mvnw.cmd clean compile
```
Die generierten Dateien liegen unter `target/generated-sources/protobuf/`.

#### Ausfuehrung (Terminal)
**Mac/Linux/WSL:**
```bash
cd backend
./mvnw spring-boot:run
```
**Windows PowerShell:**
```powershell
cd backend
.\mvnw spring-boot:run
```
**Windows CMD:**
```cmd
cd backend
mvnw.cmd spring-boot:run
```

#### Oder einfach ueber die Intelij UI:

1. Run Configurations -> Edit Configurations....
2. Ueber das + ein neues Spring Boot Setup hinzufuegen.
3. Pfad auf den Unterordner `.../werwolf/backend` setzen und **BackendApplication** auswaehlen.
4. Speichern und starten.

## Entwicklung und Wartung

### Datenbank-Schema aendern
Es wird `spring.jpa.hibernate.ddl-auto=validate` genutzt.

* Aenderungen an Java-Entities muessen manuell im SQL-Schema nachgezogen werden.
* Um das Schema komplett neu aufzubauen (Volume loeschen):
```bash
  docker-compose down -v
  docker-compose up -d
```

### Tests ausfuehren
Fuer Integrationstests werden Testcontainers genutzt. Dabei wird automatisch ein temporaerer MySQL-Container gestartet.

**Mac/Linux/WSL:** `./mvnw test`

**Windows PowerShell:** `.\mvnw test`

**Windows CMD:** `mvnw.cmd test`

Oder ueber die Intelij UI.

## Troubleshooting

* **Access Denied / ${DB_USER} Fehler:** Die Umgebungsvariablen wurden nicht geladen.
  Bei Ausfuehrung ueber IntelliJ: Pruefe ob das Working Directory in der Run Configuration
  auf `.../werwolf/backend` gesetzt ist.
* **JDBCConnectionException:** Der DB-Container laeuft nicht. Pruefe den Status mit `docker ps`.
* **Permission Denied (Mac/Linux):** `./mvnw` ist nicht ausfuehrbar. Beheben mit: `chmod +x mvnw`