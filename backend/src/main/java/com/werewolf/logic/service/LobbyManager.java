package com.werewolf.logic.service;

import com.werewolf.logic.model.Lobby;
import com.werewolf.logic.model.Player;
import com.werewolf.grpc.LobbySettings;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class LobbyManager {

    private final LobbyService lobbyService;

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

        // reject once the configured player cap is reached
        int maxPlayers = lobby.settings != null ? lobby.settings.getMaxPlayers() : 0;
        if (maxPlayers > 0 && lobby.players.size() >= maxPlayers) {
            throw new IllegalStateException("Lobby is full");
        }

        Player player = new Player();
        player.id = userId;
        player.name = username;

        lobby.players.add(player);
        return lobby;
    }

    public Lobby getLobby(String code) {
        return lobbyService.getLobby(code);
    }

    private String generateCode() {
        return UUID.randomUUID().toString().substring(0, 6).toUpperCase();
    }
}