package com.werewolf.integration;

import com.werewolf.grpc.GameAction;
import com.werewolf.grpc.HunterAction;
import com.werewolf.grpc.Phase;
import com.werewolf.grpc.SeerAction;
import com.werewolf.logic.engine.AbilityExecutor;
import com.werewolf.logic.engine.GameEngine;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.service.GameStateService;
import com.werewolf.logic.service.LobbySubscriptionService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

/**
 * Integrationstests für den GameFlow.
 * Prüft Zusammenspiel zwischen GameEngine, GameStateService und AbilityExecutor.
 */
public class GameFlowIntegrationTest {

    private GameEngine gameEngine;
    private AbilityExecutor abilityExecutor;
    private GameStateService gameStateService;
    private LobbySubscriptionService subscriptionService;

    @BeforeEach
    void setUp() {
        abilityExecutor = mock(AbilityExecutor.class);
        gameStateService = mock(GameStateService.class);
        subscriptionService = mock(LobbySubscriptionService.class);

        gameEngine = new GameEngine(abilityExecutor, gameStateService);
    }


    /**
     * Prüft, dass die GameEngine den GameState lädt/erstellt
     * und die Action korrekt an den AbilityExecutor weiterleitet.
     */
    @Test
    void gameEngine_shouldCreateStateAndUseDefaultPhase() {

        when(gameStateService.getOrCreate("ABCD"))
                .thenReturn(new GameState());

        GameAction action = GameAction.newBuilder()
                .setSeer(SeerAction.newBuilder().setTargetId("wolf1"))
                .build();

        gameEngine.handleAction("ABCD", action);

        verify(gameStateService).getOrCreate("ABCD");
        verify(abilityExecutor).execute(eq("ABCD"), eq(action), any());
    }

    /**
     * Prüft, dass Player-Aktionen korrekt an den AbilityExecutor weitergeleitet werden.
     * Fokus: richtige Weitergabe von Lobby, Action und Phase.
     */
    @Test
    void shouldForwardPlayerActionToAbilityExecutor() {

        GameState state = new GameState();
        state.phase = Phase.NIGHT_SEER;

        when(gameStateService.getOrCreate("ABCD")).thenReturn(state);

        GameAction action = GameAction.newBuilder()
                .setSeer(SeerAction.newBuilder().setTargetId("p1"))
                .build();

        gameEngine.handleAction("ABCD", action);

        verify(abilityExecutor).execute("ABCD", action, Phase.NIGHT_SEER);
    }

    /**
     * Prüft, ob ein GameState erstellt wird, wenn keiner existiert.
     */
    @Test
    void shouldCreateGameStateIfMissing() {

        when(gameStateService.getOrCreate("ABCD"))
                .thenReturn(new GameState());

        GameAction action = GameAction.newBuilder()
                .setSeer(SeerAction.newBuilder().setTargetId("p1"))
                .build();

        gameEngine.handleAction("ABCD", action);

        verify(gameStateService).getOrCreate("ABCD");
    }

    /**
     * Prüft, dass AbilityExecutor immer die aktuelle Phase verwendet.
     */
    @Test
    void shouldUseCurrentPhaseFromGameState() {

        GameState state = new GameState();
        state.phase = Phase.HUNTER_REVENGE;

        when(gameStateService.getOrCreate("ABCD")).thenReturn(state);

        GameAction action = GameAction.newBuilder()
                .setHunter(HunterAction.newBuilder().setTargetId("p2"))
                .build();

        gameEngine.handleAction("ABCD", action);

        verify(abilityExecutor).execute("ABCD", action, Phase.HUNTER_REVENGE);
    }
}
