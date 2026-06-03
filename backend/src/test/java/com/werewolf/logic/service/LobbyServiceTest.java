package com.werewolf.logic.service;

import com.werewolf.logic.model.Lobby;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Testet den LobbyService.
 * Prüft In-Memory Speicherung und Abruf von Lobbies.
 */
class LobbyServiceTest {

    private LobbyService lobbyService;

    @BeforeEach
    void setUp() {
        lobbyService = new LobbyService();
    }

    /**
     * Prüft, dass eine Lobby korrekt gespeichert und anschließend
     * über den LobbyCode wieder abgerufen werden kann.
     */
    @Test
    void shouldSaveAndRetrieveLobby() {

        // Ob eine Lobby korrekt gespeichert und wieder geladen wird.
        Lobby lobby = new Lobby();
        lobby.lobbyCode = "ABC123";

        lobbyService.createLobby(lobby);

        Lobby result = lobbyService.getLobby("ABC123");

        assertNotNull(result);
        assertEquals("ABC123", result.lobbyCode);
    }

    /**
     * Prüft, dass bei einem unbekannten LobbyCode
     * null zurückgegeben wird.
     */
    @Test
    void shouldReturnNullForUnknownLobby() {

        // Ob bei unbekanntem Code null zurückgegeben wird.
        Lobby result = lobbyService.getLobby("UNKNOWN");
        assertNull(result);
    }

    /**
     * Prüft, dass eine bestehende Lobby mit gleichem Code
     * durch eine neue Instanz überschrieben wird.
     */
    @Test
    void shouldOverwriteLobbyIfSameCode() {

        // Ob eine Lobby mit gleichem Code überschrieben wird.
        Lobby lobby1 = new Lobby();
        lobby1.lobbyCode = "ABC123";

        Lobby lobby2 = new Lobby();
        lobby2.lobbyCode = "ABC123";

        lobbyService.createLobby(lobby1);
        lobbyService.createLobby(lobby2);

        Lobby result = lobbyService.getLobby("ABC123");

        assertEquals(lobby2, result);
    }
}