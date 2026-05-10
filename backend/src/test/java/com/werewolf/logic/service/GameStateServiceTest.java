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

    @Test
    void shouldSaveAndRetrieveGameState() {

        // Testet:
        // Ob ein GameState korrekt gespeichert
        // und wieder abgerufen werden kann.

        GameState state = new GameState();
        state.lobbyCode = "ABCD";

        service.save(state);

        GameState loaded = service.get("ABCD");

        assertNotNull(loaded);
        assertEquals("ABCD", loaded.lobbyCode);
    }

    @Test
    void shouldReturnNullIfLobbyDoesNotExist() {

        // Testet:
        // Ob bei unbekannter Lobby null zurückgegeben wird.

        GameState result = service.get("UNKNOWN");

        assertNull(result);
    }
}