package com.werewolf.logic.service;

import com.werewolf.logic.model.GameState;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Verwaltet den In-Memory-Zustand aller laufenden Spiele.
 * Speichert und liefert GameState-Objekte pro Lobby.
 */
public class GameStateService {

    private final ConcurrentHashMap<String, GameState> games = new ConcurrentHashMap<>();

    public GameState get(String lobbyCode) {
        return games.get(lobbyCode);
    }

    public void save(GameState state) {
        games.put(state.lobbyCode, state);
    }
}