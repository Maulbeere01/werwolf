package com.werewolf.logic.service;

import com.werewolf.logic.model.Lobby;
import com.werewolf.logic.model.Player;
import com.werewolf.grpc.LobbySettings;
import java.util.UUID;


public class LobbyManager {

    private final LobbyService lobbyService;

    public LobbyManager(LobbyService lobbyService) {
        this.lobbyService = lobbyService;
    }

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

    private String generateCode() {
        return UUID.randomUUID().toString().substring(0, 6).toUpperCase();
    }
}