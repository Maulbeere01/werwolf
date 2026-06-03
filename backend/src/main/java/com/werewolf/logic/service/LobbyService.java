package com.werewolf.logic.service;

import com.werewolf.logic.model.Lobby;
import org.springframework.stereotype.Service;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class LobbyService {

    private final ConcurrentHashMap<String, Lobby> lobbies = new ConcurrentHashMap<>();

    public Lobby createLobby(Lobby lobby) {
        lobbies.put(lobby.lobbyCode, lobby);
        return lobby;
    }

    public Lobby getLobby(String code) {
        return lobbies.get(code);
    }
}