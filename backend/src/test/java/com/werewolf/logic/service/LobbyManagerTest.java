package com.werewolf.logic.service;

import com.werewolf.grpc.LobbySettings;
import com.werewolf.logic.model.Lobby;
import com.werewolf.logic.model.Player;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

/**
 * Testet den LobbyManager.
 * Prüft Erstellung einer Lobby inkl. Host und Weitergabe an Service.
 */
class LobbyManagerTest {

    private LobbyService lobbyService;
    private LobbyManager lobbyManager;

    @BeforeEach
    void setUp() {

        // Mock für LobbyService
        lobbyService = mock(LobbyService.class);

        // Service gibt Lobby zurück, die er bekommt
        when(lobbyService.createLobby(any())).thenAnswer(i -> i.getArgument(0));

        lobbyManager = new LobbyManager(lobbyService);
    }

    @Test
    void shouldCreateLobbyWithHost() {

        // Ob eine Lobby korrekt erstellt wird
        // inklusive Host und Settings
        LobbySettings settings = LobbySettings.newBuilder()
                .setMaxPlayers(8)
                .build();
        Lobby result = lobbyManager.createLobby(
                "host123",
                "Max",
                settings
        );

        // Lobby existiert
        assertNotNull(result);

        // Code wurde generiert
        assertNotNull(result.lobbyCode);
        assertEquals(6, result.lobbyCode.length());

        // Host gesetzt
        assertEquals("host123", result.hostId);

        // Host ist in Player-Liste
        assertEquals(1, result.players.size());
        assertEquals("host123", result.players.get(0).id);
        assertEquals("Max", result.players.get(0).name);

        // Settings übernommen
        assertEquals(8, result.settings.getMaxPlayers());
    }

    @Test
    void shouldCallLobbyService() {

        // Ob LobbyManager den LobbyService wirklich benutzt
        LobbySettings settings = LobbySettings.newBuilder()
                .setMaxPlayers(5)
                .build();

        lobbyManager.createLobby("host1", "Tom", settings);

        verify(lobbyService, times(1)).createLobby(any(Lobby.class));
    }
}