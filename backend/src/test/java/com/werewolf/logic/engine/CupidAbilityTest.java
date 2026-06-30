package com.werewolf.logic.engine;

import com.werewolf.grpc.CupidAction;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.service.GameLoopService;
import com.werewolf.logic.service.GameStateService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.*;

/**
 * Testet die CupidAbility.
 *
 * Prüft, dass:
 * - zwei Spieler korrekt als Liebespaar im GameState gespeichert werden
 * - die GameLoop nach Ausführung sofort fortgesetzt wird
 * - keine weiteren Nebenwirkungen im State entstehen
 */
class CupidAbilityTest {

    private GameStateService stateService;
    private GameLoopService gameLoopService;

    private CupidAbility cupidAbility;

    @BeforeEach
    void setUp() {
        stateService = mock(GameStateService.class);
        gameLoopService = mock(GameLoopService.class);

        cupidAbility = new CupidAbility(stateService, gameLoopService);
    }

    @Test
    void shouldSetLoversAndAdvanceGame() {
        GameState state = new GameState();

        when(stateService.get("ABCD")).thenReturn(state);

        CupidAction action = CupidAction.newBuilder()
                .setPlayer1Id("p1")
                .setPlayer2Id("p2")
                .build();

        cupidAbility.execute("ABCD", action);

        assertEquals("p1", state.loverA);
        assertEquals("p2", state.loverB);

        verify(gameLoopService, times(1)).advanceNow("ABCD");
    }
}