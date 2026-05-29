package com.werewolf.logic.engine;

import com.werewolf.grpc.Role;
import com.werewolf.grpc.SeerAction;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.model.Player;
import com.werewolf.logic.service.GameStateService;
import com.werewolf.logic.service.LobbySubscriptionService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.HashMap;

import static org.mockito.Mockito.*;

/**
 * Testet die SeerAbility.
 * Prüft, ob der Seher einen Spieler korrekt "sehen" kann.
 */
class SeerAbilityTest {

    private GameStateService stateService;
    private LobbySubscriptionService subscriptionService;
    private SeerAbility seerAbility;

    @BeforeEach
    void setUp() {
        stateService = mock(GameStateService.class);
        subscriptionService = mock(LobbySubscriptionService.class);
        seerAbility = new SeerAbility(stateService, subscriptionService);
    }

    @Test
    void shouldRevealTargetPlayer() {
        Player seer = new Player();
        seer.id = "seer1";
        seer.role = Role.SEER;

        Player target = new Player();
        target.id = "player1";
        target.name = "Hans";
        target.role = Role.VILLAGER;

        GameState state = new GameState();
        state.players = new HashMap<>();
        state.players.put("seer1", seer);
        state.players.put("player1", target);

        when(stateService.get("ABCD")).thenReturn(state);

        SeerAction action = SeerAction.newBuilder().setTargetId("player1").build();
        seerAbility.execute("ABCD", action);

        verify(stateService, times(1)).get("ABCD");
        verify(subscriptionService, times(1)).sendTo(eq("ABCD"), eq("seer1"), any());
    }
}