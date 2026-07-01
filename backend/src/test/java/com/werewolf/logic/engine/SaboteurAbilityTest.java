package com.werewolf.logic.engine;

import com.werewolf.grpc.SaboteurAction;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.service.GameLoopService;
import com.werewolf.logic.service.GameStateService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.*;

/**
 * Testet die SaboteurAbility.
 *
 * Prüft, dass:
 * - ein Zielspieler korrekt im GameState als sabotiert markiert wird
 * - die Sabotage-Information im State gespeichert bleibt
 * - die GameLoop nach der Aktion sofort fortgesetzt wird
 */
class SaboteurAbilityTest {

    private GameStateService stateService;
    private GameLoopService gameLoopService;

    private SaboteurAbility saboteurAbility;

    @BeforeEach
    void setUp() {
        stateService = mock(GameStateService.class);
        gameLoopService = mock(GameLoopService.class);

        saboteurAbility = new SaboteurAbility(stateService, gameLoopService);
    }

    @Test
    void shouldMarkPlayerAsSabotagedAndAdvance() {
        GameState state = new GameState();

        when(stateService.get("ABCD")).thenReturn(state);

        SaboteurAction action = SaboteurAction.newBuilder()
                .setTargetId("p1")
                .build();

        saboteurAbility.execute("ABCD", action);

        assertEquals("p1", state.sabotagedPlayerId);

        verify(gameLoopService, times(1)).advanceNow("ABCD");
    }
}