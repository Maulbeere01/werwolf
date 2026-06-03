package com.werewolf.logic.service;

import com.werewolf.logic.model.Lobby;
import com.werewolf.logic.model.Player;
import com.werewolf.grpc.LobbySettings;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.UUID;

/**
 * Erstellt und verwaltet Lobbys im Spiel.
 * Kümmert sich um Erstellen, Beitreten und Abrufen von Lobbys.
 */
@Service
@RequiredArgsConstructor
public class LobbyManager {

    private final LobbyService lobbyService;

    /**
     * Erstellt eine neue Lobby inklusive Host-Spieler und initialen Einstellungen.
     * Generiert außerdem einen eindeutigen Lobby-Code.
     */
    public Lobby createLobby(String hostId, String hostName, LobbySettings settings) {

        Lobby lobby = new Lobby();

        lobby.lobbyCode = generateCode();
        lobby.hostId = hostId;
        lobby.settings = settings;

        Player host = new Player();
        host.id = hostId;
        host.name = hostName;

        lobby.players.add(host);

        return lobbyService.createLobby(lobby);
    }

    /**
     * Lässt einen Spieler einer bestehenden Lobby beitreten.
     * Prüft dabei:
     * - ob die Lobby existiert
     * - ob der Spieler bereits drin ist
     * - ob das Spiel bereits gestartet wurde
     */
    public Lobby joinLobby(String userId, String username, String lobbyCode) {

        Lobby lobby = lobbyService.getLobby(lobbyCode);
        if (lobby == null) {
            throw new IllegalArgumentException("Lobby not found: " + lobbyCode);
        }

        boolean alreadyIn = lobby.players.stream().anyMatch(p -> p.id.equals(userId));
        if (alreadyIn) {
            return lobby;
        }

        if (lobby.started) {
            throw new IllegalStateException("Cannot join a game that has already started");
        }

        Player player = new Player();
        player.id = userId;
        player.name = username;

        lobby.players.add(player);
        return lobby;
    }

    /**
     * Gibt eine Lobby anhand ihres Codes zurück.
     */
    public Lobby getLobby(String code) {
        return lobbyService.getLobby(code);
    }

    /**
     * Generiert einen zufälligen 6-stelligen Lobby-Code.
     */
    private String generateCode() {
        return UUID.randomUUID().toString().substring(0, 6).toUpperCase();
    }
}