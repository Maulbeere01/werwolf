package com.werewolf.logic.service;

import com.werewolf.logic.model.GameState;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Testet den GameStateService.
 * Prüft In-Memory Speicherung und Abruf von GameStates.
 */
class GameStateServiceTest {

    private GameStateService service;

    @BeforeEach
    void setUp() {
        service = new GameStateService();
    }

    /**
     * Prüft, dass ein GameState korrekt gespeichert und anschließend
     * wieder über die Lobby-ID abgerufen werden kann.
     */
    @Test
    void shouldSaveAndRetrieveGameState() {

        // Ob ein GameState korrekt gespeichert
        // und wieder abgerufen werden kann.
        GameState state = new GameState();
        state.lobbyCode = "ABCD";
        service.save("ABCD", state);

        GameState loaded = service.get("ABCD");

        assertNotNull(loaded);
        assertEquals("ABCD", loaded.lobbyCode);
    }

    /**
     * Prüft, dass bei einer unbekannten Lobby-ID
     * null zurückgegeben wird.
     */
    @Test
    void shouldReturnNullIfLobbyDoesNotExist() {

        // Ob bei unbekannter Lobby null zurückgegeben wird.
        GameState result = service.get("UNKNOWN");

        assertNull(result);
    }
}