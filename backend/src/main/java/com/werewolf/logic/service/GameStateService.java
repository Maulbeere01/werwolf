package com.werewolf.logic.service;

import com.werewolf.logic.model.GameState;
import org.springframework.stereotype.Service;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Verwaltet den In-Memory-Zustand aller laufenden Spiele.
 * Speichert und liefert GameState-Objekte pro Lobby.
 */
@Service
public class GameStateService {

    private final ConcurrentHashMap<String, GameState> games = new ConcurrentHashMap<>();

    public GameState get(String lobbyCode) {
        return games.get(lobbyCode);
    }

    public void save(GameState state) {
        games.put(state.lobbyCode, state);
    }
}