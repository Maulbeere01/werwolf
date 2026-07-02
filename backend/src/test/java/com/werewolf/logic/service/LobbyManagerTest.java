package com.werewolf.logic.service;

import com.werewolf.grpc.LobbySettings;
import com.werewolf.logic.model.Lobby;
import com.werewolf.logic.model.Player;
import com.werewolf.persistence.entity.UserEntity;
import com.werewolf.persistence.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

import java.util.ArrayList;

/**
 * Testet den LobbyManager.
 * Prüft Erstellung einer Lobby inkl. Host und Weitergabe an Service.
 */
class LobbyManagerTest {

    private LobbyService lobbyService;
    private UserRepository userRepository;
    private LobbyManager lobbyManager;

    @BeforeEach
    void setUp() {

        // Mock für LobbyService
        lobbyService = mock(LobbyService.class);

        // Service gibt Lobby zurück, die er bekommt
        when(lobbyService.createLobby(any())).thenAnswer(i -> i.getArgument(0));

        // player ids are always numeric (the user's DB id, see AuthContext); the
        // mock's default Optional.empty() is fine here, we're not testing avatars
        userRepository = mock(UserRepository.class);

        lobbyManager = new LobbyManager(lobbyService, userRepository);
    }

    @Test
    void shouldCreateLobbyWithHost() {

        // Ob eine Lobby korrekt erstellt wird
        // inklusive Host und Settings
        LobbySettings settings = LobbySettings.newBuilder()
                .setMaxPlayers(8)
                .build();
        Lobby result = lobbyManager.createLobby(
                "123",
                "Max",
                settings
        );

        // Lobby existiert
        assertNotNull(result);

        // Code wurde generiert
        assertNotNull(result.lobbyCode);
        assertEquals(6, result.lobbyCode.length());

        // Host gesetzt
        assertEquals("123", result.hostId);

        // Host ist in Player-Liste
        assertEquals(1, result.players.size());
        assertEquals("123", result.players.get(0).id);
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

        lobbyManager.createLobby("1", "Tom", settings);

        verify(lobbyService, times(1)).createLobby(any(Lobby.class));
    }

    @Test
    void shouldAllowReturningPlayerToRejoinStartedGame() {
        Lobby lobby = new Lobby();
        lobby.lobbyCode = "AAAA11";
        lobby.started = true;
        Player existing = new Player();
        existing.id = "1";
        lobby.players = new ArrayList<>();
        lobby.players.add(existing);

        when(lobbyService.getLobby("AAAA11")).thenReturn(lobby);

        Lobby result = lobbyManager.joinLobby("1", "Anna", "AAAA11");

        assertSame(lobby, result);
        assertEquals(1, result.players.size());
    }

    @Test
    void shouldRejectStrangerFromStartedGame() {
        Lobby lobby = new Lobby();
        lobby.lobbyCode = "BBBB22";
        lobby.started = true;
        lobby.players = new ArrayList<>();

        when(lobbyService.getLobby("BBBB22")).thenReturn(lobby);

        assertThrows(IllegalStateException.class,
                () -> lobbyManager.joinLobby("999", "Bobb", "BBBB22"));
    }

    @Test
    void shouldLookUpAvatarFromUserRepository_whenHostCreatesLobby() {
        UserEntity user = new UserEntity();
        user.setAvatar("wolf_pfp.png");
        when(userRepository.findById(123L)).thenReturn(Optional.of(user));

        Lobby result = lobbyManager.createLobby("123", "Max", LobbySettings.newBuilder().build());

        assertEquals("wolf_pfp.png", result.players.get(0).avatar);
    }

    @Test
    void shouldLeaveAvatarNull_whenUserHasNoneSet() {
        Lobby result = lobbyManager.createLobby("123", "Max", LobbySettings.newBuilder().build());

        assertNull(result.players.get(0).avatar);
    }
}