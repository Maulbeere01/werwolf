package com.werewolf.integration;

import com.werewolf.grpc.*;
import com.werewolf.logic.engine.*;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.model.Player;
import com.werewolf.logic.service.GameStateService;
import com.werewolf.logic.service.LobbySubscriptionService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.HashMap;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

/**
 * Integrationstests für Ability-Logik (Seher, Hexe, Jäger).
 * Prüft Zusammenspiel zwischen GameState, Abilitys und Services.
 */
class AbilityIntegrationTest {

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
     * Prüft, dass der Seher einen Werwolf korrekt erkennt
     * und ein privates Ergebnis über den SubscriptionService erhält.
     */
    @Test
    void seer_shouldDetectWerewolf() {

        Player seer = new Player();
        seer.id = "seer1";
        seer.role = Role.SEER;

        Player wolf = new Player();
        wolf.id = "wolf1";
        wolf.role = Role.WEREWOLF;

        GameState state = new GameState();
        state.players = new HashMap<>();
        state.players.put("seer1", seer);
        state.players.put("wolf1", wolf);

        when(gameStateService.get("ABCD")).thenReturn(state);

        SeerAction action = SeerAction.newBuilder()
                .setTargetId("wolf1")
                .build();

        seerAbility.execute("ABCD", action);

        verify(gameStateService).get("ABCD");
        verify(subscriptionService).sendTo(eq("ABCD"), eq("seer1"), any());
    }

    /**
     * Prüft, dass die Hexe das Nachtopfer korrekt heilt
     * und der Spieler wieder als lebendig gilt.
     */
    @Test
    void witch_shouldHealNightVictim() {

        GameState state = new GameState();
        state.nightVictimId = "player1";
        state.deadPlayers.add("player1");

        state.witchHasHealPotion = true;

        when(gameStateService.get("ABCD")).thenReturn(state);

        WitchAction action = WitchAction.newBuilder()
                .setHealTarget(true)
                .build();

        witchAbility.execute("ABCD", action);

        assertFalse(state.deadPlayers.contains("player1"));
    }

    /**
     * Prüft, dass der Jäger beim Auslösen seiner Fähigkeit
     * einen Zielspieler korrekt eliminiert.
     */
    @Test
    void hunter_shouldKillTarget() {

        GameState state = new GameState();

        when(gameStateService.get("ABCD")).thenReturn(state);

        HunterAction action = HunterAction.newBuilder()
                .setTargetId("player2")
                .build();

        hunterAbility.execute("ABCD", action);

        assertTrue(state.deadPlayers.contains("player2"));

        verify(gameStateService).get("ABCD");
    }
}