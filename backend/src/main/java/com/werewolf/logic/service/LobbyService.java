package com.werewolf.logic.service;

import com.werewolf.logic.model.Lobby;
import org.springframework.stereotype.Service;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Verwaltet Lobbys im Speicher (In-Memory Storage).
 * Zuständig für das Speichern und Abrufen von Lobby-Objekten.
 */
@Service
public class LobbyService {

    private final ConcurrentHashMap<String, Lobby> lobbies = new ConcurrentHashMap<>();

    /**
     * Speichert eine neue Lobby im Speicher.
     * Überschreibt eine bestehende Lobby mit gleichem Code.
     */
    public Lobby createLobby(Lobby lobby) {
        lobbies.put(lobby.lobbyCode, lobby);
        return lobby;
    }

    /**
     * Gibt eine Lobby anhand ihres Lobby-Codes zurück.
     * Liefert null, wenn keine Lobby existiert.
     */
    public Lobby getLobby(String code) {
        return lobbies.get(code);
    }
}