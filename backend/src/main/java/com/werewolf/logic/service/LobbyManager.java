package com.werewolf.logic.service;

import com.werewolf.logic.model.Lobby;
import com.werewolf.logic.model.Player;
import com.werewolf.grpc.LobbySettings;
import com.werewolf.persistence.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class LobbyManager {

    private final LobbyService lobbyService;
    private final UserRepository userRepository;

    public Lobby createLobby(String hostId, String hostName, LobbySettings settings) {

        Lobby lobby = new Lobby();

        lobby.lobbyCode = generateCode();
        lobby.hostId = hostId;
        lobby.settings = settings;

        Player host = new Player();
        host.id = hostId;
        host.name = hostName;
        host.avatar = avatarOf(hostId);

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
        player.avatar = avatarOf(userId);

        lobby.players.add(player);
        return lobby;
    }

    // Looked up once, at join time, rather than on every game update: a player's
    // avatar rarely changes mid-game and this keeps the hot broadcast path
    // (GameUpdateFactory, ticking on every phase/action) free of DB access.
    private String avatarOf(String userId) {
        return userRepository.findById(Long.valueOf(userId))
                .map(user -> user.getAvatar())
                .orElse(null);
    }

    public Lobby getLobby(String code) {
        return lobbyService.getLobby(code);
    }

    private String generateCode() {
        return UUID.randomUUID().toString().substring(0, 6).toUpperCase();
    }
}