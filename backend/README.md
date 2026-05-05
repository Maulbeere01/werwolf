# Backend Setup Guide
     
## Voraussetzungen
* Java 21
* Maven
* Docker & Docker Compose

## Setup

### 1. Umgebungsvariablen (.env)
1. Kopiere die Datei `backend/.env.example` und benenne sie in `.env` um. (Sie muss im Ordner `backend/` liegen).
2. Fuelle die Werte (DB_ROOT_PASSWORD, DB_PASSWORD, etc.) aus.

### 2. Datenbank mit Docker starten
Wir nutzen Docker Compose fuer die Datenbank-Umgebung.
1. Starte die Datenbank im `backend/`-Ordner:
   `docker-compose up -d`
2. Die Datei `werwolf.sql` wird beim ersten Start automatisch importiert.
3. Die DB ist auf deinem Host unter Port 42069 erreichbar.

### 3. Backend starten

#### gRPC Generierung
```bash
cd backend
mvn clean compile
```
Die generierten Dateien liegen unter `target/generated-sources/protobuf/`.

#### Ausfuehrung (Terminal)
```bash
cd backend
mvn spring-boot:run
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
Fuer Integrationstests werden Testcontainers genutzt. Dabei wird automatisch ein temporaerer MySQL-Container gestartet. Befehl: `mvn test` oder ueber die Intelij UI.

## Fehlerbehebung (Troubleshooting)

* **Access Denied / ${DB_USER} Fehler:** Die Umgebungsvariablen wurden nicht geladen. Pruefe, ob dein Working Directory (siehe Punkt 3) wirklich auf dem `backend/` Ordner steht.
* **JDBCConnectionException:** Der DB-Container laeuft nicht. Pruefe den Status mit `docker ps`.