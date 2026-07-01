package com.werewolf.logic.IntegrationsTest;

import com.werewolf.grpc.*;
import com.werewolf.logic.engine.*;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.model.Lobby;
import com.werewolf.logic.model.Player;
import com.werewolf.logic.service.GameStateService;
import com.werewolf.logic.service.LobbyManager;
import com.werewolf.logic.service.LobbySubscriptionService;
import com.werewolf.logic.service.GameLoopService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.HashMap;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

/**
 * Integrationstests für Ability-Logik
 * (Seher, Hexe, Jäger, Fuchs, Amor, Saboteur).
 *
 * Prüft Zusammenspiel zwischen GameState, Abilitys und Services.
 */
class AbilityIntegrationTest {

    private GameStateService gameStateService;
    private LobbySubscriptionService subscriptionService;
    private GameLoopService gameLoopService;
    private LobbyManager lobbyManager;

    private WerewolfAbility werewolfAbility;
    private SeerAbility seerAbility;
    private WitchAbility witchAbility;
    private HunterAbility hunterAbility;
    private FoxAbility foxAbility;
    private CupidAbility cupidAbility;
    private SaboteurAbility saboteurAbility;

    @BeforeEach
    void setUp() {

        gameStateService = mock(GameStateService.class);
        subscriptionService = mock(LobbySubscriptionService.class);
        gameLoopService = mock(GameLoopService.class);
        lobbyManager = mock(LobbyManager.class);

        werewolfAbility = new WerewolfAbility(
                gameStateService,
                lobbyManager,
                subscriptionService,
                gameLoopService
        );

        seerAbility = new SeerAbility(
                gameStateService,
                subscriptionService,
                lobbyManager,
                gameLoopService
        );

        witchAbility = new WitchAbility(gameStateService, gameLoopService);
        hunterAbility = new HunterAbility(gameStateService, gameLoopService);

        foxAbility = new FoxAbility(
                gameStateService,
                subscriptionService,
                lobbyManager,
                gameLoopService
        );

        cupidAbility = new CupidAbility(gameStateService, gameLoopService);
        saboteurAbility = new SaboteurAbility(gameStateService, gameLoopService);
    }

    // ---------------------------------------------------
    // SEER
    // ---------------------------------------------------

    @Test
    void seer_shouldDetectWerewolf() {

        GameState state = new GameState();

        Player seer = new Player();
        seer.id = "seer1";
        seer.role = Role.SEER;

        Player wolf = new Player();
        wolf.id = "wolf1";
        wolf.role = Role.WEREWOLF;

        state.players = new HashMap<>();
        state.players.put("seer1", seer);
        state.players.put("wolf1", wolf);

        when(gameStateService.get("ABCD")).thenReturn(state);

        seerAbility.execute("ABCD", SeerAction.newBuilder()
                .setTargetId("wolf1")
                .build());

        assertNotNull(state.pendingResults.get("seer1"));
    }

    // ---------------------------------------------------
    // HEXE
    // ---------------------------------------------------

    @Test
    void witch_shouldHealNightVictim() {

        GameState state = new GameState();
        state.attackedThisNight = "player1";
        state.deadPlayers.add("player1");
        state.witchHasHealPotion = true;

        when(gameStateService.get("ABCD")).thenReturn(state);

        witchAbility.execute("ABCD", WitchAction.newBuilder()
                .setHealTarget(true)
                .build());

        assertFalse(state.deadPlayers.contains("player1"));
        assertFalse(state.witchHasHealPotion);
    }

    // ---------------------------------------------------
    // JÄGER
    // ---------------------------------------------------

    @Test
    void hunter_shouldMarkShotTarget() {

        GameState state = new GameState();
        // the hunter may only shoot while they owe a revenge shot
        state.pendingHunterId = "hunter1";

        Player target = new Player();
        target.id = "player2";
        state.players = new HashMap<>();
        state.players.put("player2", target);

        when(gameStateService.get("ABCD")).thenReturn(state);

        hunterAbility.execute("ABCD", HunterAction.newBuilder()
                .setTargetId("player2")
                .build());

        // the ability just records the pick and hands off to the loop; the actual
        // kill is applied in GameLoopService.resolveHunterShot when the phase ends
        assertEquals("player2", state.hunterShotTargetId);
        verify(gameLoopService, times(1)).advanceNow("ABCD");
    }

    // ---------------------------------------------------
    // FUCHS
    // ---------------------------------------------------

    @Test
    void fox_shouldDetectWerewolfPresence() {

        GameState state = new GameState();

        Player fox = new Player();
        fox.id = "fox1";
        fox.role = Role.FOX;

        Player wolf = new Player();
        wolf.id = "wolf1";
        wolf.role = Role.WEREWOLF;

        // the fox peeks at exactly three distinct living players (never itself)
        Player v1 = new Player();
        v1.id = "v1";
        v1.role = Role.VILLAGER;

        Player v2 = new Player();
        v2.id = "v2";
        v2.role = Role.VILLAGER;

        state.players = new HashMap<>();
        state.players.put("fox1", fox);
        state.players.put("wolf1", wolf);
        state.players.put("v1", v1);
        state.players.put("v2", v2);

        when(gameStateService.get("ABCD")).thenReturn(state);

        when(lobbyManager.getLobby("ABCD"))
                .thenReturn(new Lobby());

        foxAbility.execute("ABCD", FoxAction.newBuilder()
                .addTargetIds("wolf1")
                .addTargetIds("v1")
                .addTargetIds("v2")
                .build());

        assertNotNull(state.pendingResults.get("fox1"));
    }

    // ---------------------------------------------------
    // CUPID (AMOR)
    // ---------------------------------------------------

    @Test
    void cupid_shouldLinkTwoPlayers() {

        GameState state = new GameState();

        // cupid only links two DISTINCT, LIVING players, so they must exist
        Player p1 = new Player();
        p1.id = "p1";
        Player p2 = new Player();
        p2.id = "p2";
        state.players = new HashMap<>();
        state.players.put("p1", p1);
        state.players.put("p2", p2);

        when(gameStateService.get("ABCD")).thenReturn(state);

        cupidAbility.execute("ABCD", CupidAction.newBuilder()
                .setPlayer1Id("p1")
                .setPlayer2Id("p2")
                .build());

        assertEquals("p1", state.loverA);
        assertEquals("p2", state.loverB);
    }

    // ---------------------------------------------------
    // SABOTEUR (BLOCK ability)
    // ---------------------------------------------------

    @Test
    void saboteur_shouldMarkTargetAsSabotaged() {

        GameState state = new GameState();

        when(gameStateService.get("ABCD")).thenReturn(state);

        saboteurAbility.execute("ABCD", SaboteurAction.newBuilder()
                .setTargetId("player2")
                .build());

        assertEquals("player2", state.sabotagedPlayerId);
    }
}