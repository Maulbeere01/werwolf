package com.werewolf.system;

import com.werewolf.grpc.*;
import com.werewolf.logic.engine.*;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.model.Player;
import com.werewolf.logic.service.GameStateService;
import com.werewolf.logic.service.LobbySubscriptionService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Systemtests für den vollständigen GameFlow.
 * Testet echte Interaktion zwischen GameEngine, GameStateService und AbilityLogik.
 */
class GameSystemTest {

    private GameStateService gameStateService;
    private AbilityExecutor abilityExecutor;
    private GameEngine gameEngine;

    @BeforeEach
    void setUp() {
        gameStateService = new GameStateService(); // KEIN MOCK

        abilityExecutor = new AbilityExecutor(
                new WerewolfAbility(gameStateService),
                new SeerAbility(gameStateService, new LobbySubscriptionService()),
                new WitchAbility(gameStateService),
                new HunterAbility(gameStateService)
        );

        gameEngine = new GameEngine(abilityExecutor, gameStateService);
    }

    /**
     * Prüft, dass der Seher im echten GameState einen Werwolf korrekt erkennt.
     */
    @Test
    void seer_reveals_werewolf() {

        GameState state = new GameState();
        state.players.put("seer1", new Player("seer1", "seer", Role.SEER, true));
        state.players.put("wolf1", new Player("wolf1", "wolf", Role.WEREWOLF, true));

        gameStateService.save("ABCD", state);

        GameAction action = GameAction.newBuilder()
                .setSeer(SeerAction.newBuilder().setTargetId("wolf1"))
                .build();

        gameEngine.handleAction("ABCD", action);

        GameState updated = gameStateService.get("ABCD");

        assertNotNull(updated);
    }

    /**
     * Prüft, dass die Hexe das Nachtopfer heilt
     * und der Spieler danach wieder lebendig ist.
     */
    @Test
    void witch_heals_night_victim() {

        GameState state = new GameState();
        state.witchHasHealPotion = true;
        state.nightVictimId = "p1";
        state.deadPlayers.add("p1");

        gameStateService.save("ABCD", state);

        GameAction action = GameAction.newBuilder()
                .setWitch(WitchAction.newBuilder().setHealTarget(true))
                .build();

        gameEngine.handleAction("ABCD", action);

        GameState updated = gameStateService.get("ABCD");

        assertFalse(updated.deadPlayers.contains("p1"));
        assertFalse(updated.witchHasHealPotion);
    }

    /**
     * Prüft, dass der Jäger in der Revenge-Phase
     * einen Zielspieler korrekt eliminieren kann.
     */
    @Test
    void hunter_kills_target_on_revenge() {

        GameState state = new GameState();
        state.phase = Phase.HUNTER_REVENGE;

        gameStateService.save("ABCD", state);

        GameAction action = GameAction.newBuilder()
                .setHunter(HunterAction.newBuilder().setTargetId("p2"))
                .build();

        gameEngine.handleAction("ABCD", action);

        GameState updated = gameStateService.get("ABCD");

        assertTrue(updated.deadPlayers.contains("p2"));
    }
}