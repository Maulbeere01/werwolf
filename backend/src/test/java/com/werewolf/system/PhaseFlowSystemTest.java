package com.werewolf.system;

import com.werewolf.grpc.*;
import com.werewolf.logic.engine.*;
import com.werewolf.logic.model.*;
import com.werewolf.logic.service.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

/**
 * SYSTEMTEST:
 * Testet den kompletten GameFlow
 */
class PhaseFlowSystemTest {

    private GameStateService gameStateService;
    private AbilityExecutor abilityExecutor;
    private GameEngine gameEngine;

    @BeforeEach
    void setUp() {
        gameStateService = new GameStateService(); // REAL

        abilityExecutor = new AbilityExecutor(
                new WerewolfAbility(gameStateService),
                new SeerAbility(gameStateService, new LobbySubscriptionService()),
                new WitchAbility(gameStateService),
                new HunterAbility(gameStateService)
        );

        gameEngine = new GameEngine(abilityExecutor, gameStateService);
    }

    /**
     * SYSTEMTEST:
     * GameEngine verarbeitet echte Action im echten State.
     */
    @Test
    void shouldRouteSeerActionInRealSystem() {

        GameState state = new GameState();
        state.phase = Phase.NIGHT_SEER;

        state.players.put("seer1",
                new Player("seer1", "seer", Role.SEER, true));

        state.players.put("wolf1",
                new Player("wolf1", "wolf", Role.WEREWOLF, true));

        gameStateService.save("ABCD", state);

        GameAction action = GameAction.newBuilder()
                .setSeer(SeerAction.newBuilder().setTargetId("wolf1"))
                .build();

        gameEngine.handleAction("ABCD", action);

        GameState updated = gameStateService.get("ABCD");

        assertNotNull(updated);
        assertEquals(Phase.NIGHT_SEER, updated.phase);
    }

    /**
     * SYSTEMTEST:
     * Empty Action ist aktuell INVALID → muss Exception werfen.
     */
    @Test
    void shouldRejectEmptyAction() {

        gameStateService.save("ABCD", new GameState());

        GameAction action = GameAction.newBuilder().build();

        assertThrows(
                IllegalArgumentException.class,
                () -> gameEngine.handleAction("ABCD", action)
        );
    }
}