package com.werewolf.logic.service;

import com.werewolf.logic.model.Lobby;
import java.util.concurrent.ConcurrentHashMap;


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