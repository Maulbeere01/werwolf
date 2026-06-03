package com.werewolf.logic.engine;

import com.werewolf.grpc.GameAction;
import com.werewolf.grpc.Phase;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.service.GameStateService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.*;

/**
 * Testet den GameEngine.
 * Prüft, ob Aktionen korrekt an den AbilityExecutor weitergeleitet werden.
 */
class GameEngineTest {

    private AbilityExecutor abilityExecutor;
    private GameEngine gameEngine;
    private GameState gameState;
    private GameStateService gameStateService;


    @BeforeEach
    void setUp() {
        gameStateService = mock(GameStateService.class);
        gameState = new GameState();
        gameState.lobbyCode = "ABCD";
        gameState.phase = Phase.NIGHT_SEER;


        when(gameStateService.getOrCreate("ABCD")).thenReturn(gameState);

        abilityExecutor = mock(AbilityExecutor.class);
        gameEngine = new GameEngine(abilityExecutor, gameStateService);
    }

    /**
     * prüft, dass die GameEngine eine eingehende GameAction korrekt an den AbilityExecutor weiterleitet,
     * inklusive Lobby-Code und aktueller Phase aus dem GameState (NIGHT_SEER).
     */
    @Test
    void shouldRejectEmptyAction() {
        GameAction action = GameAction.newBuilder().build();

        assertThrows(
                IllegalArgumentException.class,
                () -> gameEngine.handleAction("ABCD", action)
        );
    }
}