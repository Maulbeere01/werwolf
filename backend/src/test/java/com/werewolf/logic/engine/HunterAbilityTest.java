package com.werewolf.logic.engine;

import com.werewolf.grpc.HunterAction;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.model.Player;
import com.werewolf.logic.service.GameLoopService;
import com.werewolf.logic.service.GameStateService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.mockito.Mockito.*;

/**
 * Testet die HunterAbility.
 * Der Jäger merkt sich sein Ziel (hunterShotTargetId) und stößt die Auflösung an;
 * der eigentliche Tod wird erst beim Ende von HUNTER_REVENGE angewendet.
 */
class HunterAbilityTest {

    private GameStateService stateService;
    private GameLoopService gameLoopService;
    private HunterAbility hunterAbility;

    @BeforeEach
    void setUp() {
        stateService = mock(GameStateService.class);
        gameLoopService = mock(GameLoopService.class);
        hunterAbility = new HunterAbility(stateService, gameLoopService);
    }

    @Test
    void shouldRecordTargetAndAdvanceWhenRevengePending() {
        GameState state = new GameState();
        state.pendingHunterId = "hunter1"; // a hunter owes a revenge shot

        Player target = new Player();
        target.id = "player1";
        target.alive = true;
        state.players.put("player1", target);

        when(stateService.get("ABCD")).thenReturn(state);

        HunterAction action = HunterAction.newBuilder().setTargetId("player1").build();
        hunterAbility.execute("ABCD", action);

        assertEquals("player1", state.hunterShotTargetId);
        verify(gameLoopService, times(1)).advanceNow("ABCD");
    }

    @Test
    void shouldIgnoreShotWhenNoRevengePending() {
        GameState state = new GameState(); // pendingHunterId == null

        Player target = new Player();
        target.id = "player1";
        target.alive = true;
        state.players.put("player1", target);

        when(stateService.get("ABCD")).thenReturn(state);

        HunterAction action = HunterAction.newBuilder().setTargetId("player1").build();
        hunterAbility.execute("ABCD", action);

        assertNull(state.hunterShotTargetId);
        verify(gameLoopService, never()).advanceNow(anyString());
    }
}
