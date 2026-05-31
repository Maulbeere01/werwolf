package com.werewolf.logic.engine;

import com.werewolf.grpc.GameAction;
import com.werewolf.grpc.Phase;
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
        abilityExecutor = mock(AbilityExecutor.class);
        gameEngine = new GameEngine(abilityExecutor);
    }

    @Test
    void shouldForwardActionToAbilityExecutor() {
        GameAction action = GameAction.newBuilder().build();

        gameEngine.handleAction("ABCD", "user1", action, Phase.NIGHT_SEER);

        verify(abilityExecutor, times(1)).execute("ABCD", "user1", action, Phase.NIGHT_SEER);
    }
}