package com.werewolf.logic.engine;

import com.werewolf.grpc.GameAction;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.mockito.Mockito.*;

/**
 * Testet den GameEngine.
 * Prüft, ob Aktionen korrekt an den AbilityExecutor weitergeleitet werden.
 */
class GameEngineTest {

    private AbilityExecutor abilityExecutor;
    private GameEngine gameEngine;

    @BeforeEach
    void setUp() {

        // Mock für AbilityExecutor erstellen
        abilityExecutor = mock(AbilityExecutor.class);

        // GameEngine mit Mock erstellen
        gameEngine = new GameEngine(abilityExecutor);
    }

    @Test
    void shouldForwardActionToAbilityExecutor() {

        // Ob handleAction die Action korrekt an den AbilityExecutor weiterleitet.
        GameAction action = GameAction.newBuilder().build();

        gameEngine.handleAction("ABCD", action);

        // Prüfen ob execute genau 1x aufgerufen wurde
        verify(abilityExecutor, times(1))
                .execute("ABCD", action);
    }
}