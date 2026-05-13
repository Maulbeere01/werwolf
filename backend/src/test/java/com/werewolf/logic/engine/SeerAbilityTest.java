package com.werewolf.logic.engine;

import com.werewolf.grpc.SeerAction;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.model.Player;
import com.werewolf.logic.service.GameStateService;
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
    private SeerAbility seerAbility;

    @BeforeEach
    void setUp() {

        // Mock für GameStateService
        stateService = mock(GameStateService.class);

        // SeerAbility erstellen
        seerAbility = new SeerAbility(stateService);
    }

    @Test
    void shouldRevealTargetPlayer() {

        // Ob der Seher den Zielspieler korrekt im GameState findet und dessen Rolle verarbeitet (aktuell via System.out).
        Player player = new Player();
        player.role = com.werewolf.grpc.Role.VILLAGER;

        GameState state = new GameState();
        state.players = new HashMap<>();
        state.players.put("player1", player);

        // Mock Verhalten
        when(stateService.get("ABCD")).thenReturn(state);

        SeerAction action = SeerAction.newBuilder()
                .setTargetId("player1")
                .build();
        seerAbility.execute("ABCD", action);

        // Kein Crash + Player wurde korrekt gefunden
        verify(stateService, times(1)).get("ABCD");
    }
}