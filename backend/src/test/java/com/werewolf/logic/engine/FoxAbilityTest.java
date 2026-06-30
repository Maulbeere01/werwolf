package com.werewolf.logic.engine;

import com.werewolf.grpc.ActionResult;
import com.werewolf.grpc.FoxAction;
import com.werewolf.grpc.Phase;
import com.werewolf.grpc.Role;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.model.Lobby;
import com.werewolf.logic.model.Player;
import com.werewolf.logic.service.GameLoopService;
import com.werewolf.logic.service.GameStateService;
import com.werewolf.logic.service.LobbyManager;
import com.werewolf.logic.service.LobbySubscriptionService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;


/**
 * Testet die FoxAbility.
 *
 * Prüft, dass:
 * - der Fuchs eine Zielgruppe untersuchen kann
 * - erkannt wird, ob mindestens ein Werwolf darunter ist
 * - das Ergebnis korrekt als private ActionResult gespeichert und gesendet wird
 * - die Fähigkeit korrekt in den GameLoop integriert ist (Grace Phase wird gestartet)
 */
class FoxAbilityTest {

    private FoxAbility foxAbility;

    private GameStateService gameStateService;
    private LobbySubscriptionService subscriptionService;
    private LobbyManager lobbyManager;
    private GameLoopService gameLoopService;

    @BeforeEach
    void setUp() {

        gameStateService = mock(GameStateService.class);
        subscriptionService = mock(LobbySubscriptionService.class);
        lobbyManager = mock(LobbyManager.class);
        gameLoopService = mock(GameLoopService.class);

        foxAbility = new FoxAbility(
                gameStateService,
                subscriptionService,
                lobbyManager,
                gameLoopService
        );
    }

    /**
     * Prüft, dass der Fuchs erkennt, wenn sich unter den gewählten
     * Spielern mindestens ein Werwolf befindet.
     */
    @Test
    void fox_shouldRevealWerewolf_whenTargetContainsWolf() {

        GameState state = new GameState();
        state.phase = Phase.NIGHT_FOX;

        Player fox = new Player();
        fox.id = "fox";
        fox.role = Role.FOX;

        Player wolf = new Player();
        wolf.id = "wolf";
        wolf.role = Role.WEREWOLF;

        Player villager = new Player();
        villager.id = "villager";
        villager.role = Role.VILLAGER;

        state.players.put(fox.id, fox);
        state.players.put(wolf.id, wolf);
        state.players.put(villager.id, villager);

        Lobby lobby = new Lobby();

        when(gameStateService.get("ABCD")).thenReturn(state);
        when(lobbyManager.getLobby("ABCD")).thenReturn(lobby);

        FoxAction action = FoxAction.newBuilder()
                .addTargetIds("wolf")
                .addTargetIds("villager")
                .build();

        foxAbility.execute("ABCD", action);

        ActionResult result = state.pendingResults.get("fox");

        assertNotNull(result);
        assertTrue(result.getFoxReveal().getAnyWerewolfFound());

        verify(subscriptionService).sendTo(eq("ABCD"), eq("fox"), any());
        verify(gameLoopService).beginGrace("ABCD", Phase.NIGHT_FOX, 5);
    }

    /**
     * Prüft, dass der Fuchs kein Werwolf-Ergebnis erhält,
     * wenn sich unter den gewählten Spielern kein Werwolf befindet.
     */
    @Test
    void fox_shouldRevealFalse_whenNoWerewolfFound() {

        GameState state = new GameState();
        state.phase = Phase.NIGHT_FOX;

        Player fox = new Player();
        fox.id = "fox";
        fox.role = Role.FOX;

        Player villager1 = new Player();
        villager1.id = "v1";
        villager1.role = Role.VILLAGER;

        Player villager2 = new Player();
        villager2.id = "v2";
        villager2.role = Role.VILLAGER;

        state.players.put(fox.id, fox);
        state.players.put(villager1.id, villager1);
        state.players.put(villager2.id, villager2);

        Lobby lobby = new Lobby();

        when(gameStateService.get("ABCD")).thenReturn(state);
        when(lobbyManager.getLobby("ABCD")).thenReturn(lobby);

        FoxAction action = FoxAction.newBuilder()
                .addTargetIds("v1")
                .addTargetIds("v2")
                .build();

        foxAbility.execute("ABCD", action);

        ActionResult result = state.pendingResults.get("fox");

        assertNotNull(result);
        assertFalse(result.getFoxReveal().getAnyWerewolfFound());

        verify(subscriptionService).sendTo(eq("ABCD"), eq("fox"), any());
        verify(gameLoopService).beginGrace("ABCD", Phase.NIGHT_FOX, 5);
    }

    /**
     * Prüft, dass keine Verarbeitung erfolgt,
     * wenn kein GameState zur Lobby existiert.
     */
    @Test
    void fox_shouldReturn_whenGameStateMissing() {

        when(gameStateService.get("ABCD")).thenReturn(null);

        FoxAction action = FoxAction.newBuilder().build();

        foxAbility.execute("ABCD", action);

        verify(subscriptionService, never()).sendTo(any(), any(), any());
        verify(gameLoopService, never()).beginGrace(any(), any(), anyLong());
    }

    /**
     * Prüft, dass keine Verarbeitung erfolgt,
     * wenn keine Lobby existiert.
     */
    @Test
    void fox_shouldReturn_whenLobbyMissing() {

        GameState state = new GameState();

        when(gameStateService.get("ABCD")).thenReturn(state);
        when(lobbyManager.getLobby("ABCD")).thenReturn(null);

        FoxAction action = FoxAction.newBuilder().build();

        foxAbility.execute("ABCD", action);

        verify(subscriptionService, never()).sendTo(any(), any(), any());
        verify(gameLoopService, never()).beginGrace(any(), any(), anyLong());
    }

    /**
     * Prüft, dass keine Verarbeitung erfolgt,
     * wenn kein lebender Fuchs im Spiel vorhanden ist.
     */
    @Test
    void fox_shouldReturn_whenNoLivingFoxExists() {

        GameState state = new GameState();

        Player wolf = new Player();
        wolf.id = "wolf";
        wolf.role = Role.WEREWOLF;

        state.players.put(wolf.id, wolf);

        Lobby lobby = new Lobby();

        when(gameStateService.get("ABCD")).thenReturn(state);
        when(lobbyManager.getLobby("ABCD")).thenReturn(lobby);

        FoxAction action = FoxAction.newBuilder().build();

        foxAbility.execute("ABCD", action);

        assertTrue(state.pendingResults.isEmpty());

        verify(subscriptionService, never()).sendTo(any(), any(), any());
        verify(gameLoopService, never()).beginGrace(any(), any(), anyLong());
    }
}