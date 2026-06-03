package com.werewolf.logic.service;

import com.werewolf.logic.model.GameState;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class GameStateService {

    private final Map<String, GameState> states = new HashMap<>();

    /**
     * Speichert den aktuellen GameState einer Lobby im Speicher.
     */
    public void save(String lobbyCode, GameState state) {
        states.put(lobbyCode, state);
    }

    /**
     * Gibt den GameState einer Lobby zurück.
     * Liefert null, wenn keine Lobby existiert.
     */
    public GameState get(String lobbyCode) {
        return states.get(lobbyCode);
    }

    /**
     * Holt den GameState einer Lobby oder erstellt einen neuen,
     * falls noch keiner existiert.
     */
    public GameState getOrCreate(String lobbyCode) {
        return states.computeIfAbsent(lobbyCode, k -> new GameState());
    }

    /**
     * Löscht den GameState einer Lobby aus dem Speicher.
     */
    public void delete(String lobbyCode) {
        states.remove(lobbyCode);
    }
}