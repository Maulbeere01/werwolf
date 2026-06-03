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
import static org.mockito.Mockito.*;

/**
 * Systemnahe Tests für Nachtphasen-Ability-Logik.
 * Prüft echte Interaktion zwischen GameState und Ability-Klassen.
 */
class NightPhaseSystemTest {

    private GameStateService gameStateService;
    private LobbySubscriptionService subscriptionService;

    private WerewolfAbility werewolfAbility;
    private SeerAbility seerAbility;
    private WitchAbility witchAbility;
    private HunterAbility hunterAbility;

    private AbilityExecutor abilityExecutor;
    private GameEngine gameEngine;

    @BeforeEach
    void setUp() {

        gameStateService = mock(GameStateService.class);
        subscriptionService = mock(LobbySubscriptionService.class);

        werewolfAbility = new WerewolfAbility(gameStateService);
        seerAbility = new SeerAbility(gameStateService, subscriptionService);
        witchAbility = new WitchAbility(gameStateService);
        hunterAbility = new HunterAbility(gameStateService);

        abilityExecutor = new AbilityExecutor(
                werewolfAbility,
                seerAbility,
                witchAbility,
                hunterAbility
        );

        gameEngine = new GameEngine(abilityExecutor, gameStateService);
    }

    /**
     * Prüft, dass der Seher seine Fähigkeit ausführt
     * und das Ergebnis als private Nachricht gesendet wird.
     */
    @Test
    void seer_shouldRevealRoleToSelf() {

        Player seer = new Player();
        seer.id = "seer1";
        seer.role = Role.SEER;

        Player wolf = new Player();
        wolf.id = "wolf1";
        wolf.role = Role.WEREWOLF;

        GameState state = new GameState();
        state.players.put("seer1", seer);
        state.players.put("wolf1", wolf);

        when(gameStateService.get("ABCD")).thenReturn(state);

        SeerAction action = SeerAction.newBuilder()
                .setTargetId("wolf1")
                .build();

        seerAbility.execute("ABCD", action);

        verify(subscriptionService).sendTo(eq("ABCD"), eq("seer1"), any());
    }

    /**
     * Prüft, dass die Hexe ihr Heiltrank korrekt verbraucht
     * und das Nachtopfer aus der Todesliste entfernt wird.
     */
    @Test
    void witch_shouldConsumeHealPotion_whenUsed() {

        GameState state = new GameState();
        state.witchHasHealPotion = true;
        state.nightVictimId = "p1";
        state.deadPlayers.add("p1");

        when(gameStateService.get("ABCD")).thenReturn(state);

        WitchAction action = WitchAction.newBuilder()
                .setHealTarget(true)
                .build();

        witchAbility.execute("ABCD", action);

        assertFalse(state.deadPlayers.contains("p1"));
        assertFalse(state.witchHasHealPotion);
    }

    /**
     * Prüft, dass der Jäger in der Rachephase
     * sein Ziel korrekt eliminieren kann.
     */
    @Test
    void hunter_shouldKillTarget_onRevenge() {

        GameState state = new GameState();

        when(gameStateService.get("ABCD")).thenReturn(state);

        HunterAction action = HunterAction.newBuilder()
                .setTargetId("p2")
                .build();

        hunterAbility.execute("ABCD", action);

        assertTrue(state.deadPlayers.contains("p2"));
    }
}