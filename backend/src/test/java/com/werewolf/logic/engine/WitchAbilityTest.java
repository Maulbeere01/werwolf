package com.werewolf.logic.engine;

import com.werewolf.grpc.WitchAction;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.service.GameStateService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.*;

/**
 * Testet die WitchAbility.
 * Prüft Heilen und Vergiften der Hexe.
 */
class WitchAbilityTest {

    private GameStateService stateService;
    private WitchAbility witchAbility;

    @BeforeEach
    void setUp() {

        // Mock für GameStateService erstellen
        stateService = mock(GameStateService.class);

        // WitchAbility erstellen
        witchAbility = new WitchAbility(stateService);
    }

    @Test
    void shouldHealTargetByRemovingLastNightTarget() {

        // Testet:
        // Ob die Hexe einen Spieler heilen kann,
        // indem "lastNightTarget" aus der Todesliste entfernt wird.

        GameState state = new GameState();
        state.deadPlayers.add("lastNightTarget");

        when(stateService.get("ABCD")).thenReturn(state);

        WitchAction action = WitchAction.newBuilder()
                .setHealTarget(true)
                .setPoisonTargetId("")
                .build();

        witchAbility.execute("ABCD", action);

        // Spieler wurde wieder entfernt (geheilt)
        assertFalse(state.deadPlayers.contains("lastNightTarget"));

        verify(stateService, times(1)).get("ABCD");
    }

    @Test
    void shouldPoisonTarget() {

        // Testet:
        // Ob die Hexe einen Spieler vergiften kann,
        // indem dieser zur deadPlayers Liste hinzugefügt wird.

        GameState state = new GameState();

        when(stateService.get("ABCD")).thenReturn(state);

        WitchAction action = WitchAction.newBuilder()
                .setHealTarget(false)
                .setPoisonTargetId("player1")
                .build();

        witchAbility.execute("ABCD", action);

        // Spieler wurde vergiftet
        assertTrue(state.deadPlayers.contains("player1"));

        verify(stateService, times(1)).get("ABCD");
    }

    @Test
    void shouldDoNothingWhenNoActionGiven() {

        // Testet:
        // Ob die Hexe nichts verändert,
        // wenn weder Heal noch Poison gesetzt ist.

        GameState state = new GameState();

        when(stateService.get("ABCD")).thenReturn(state);

        WitchAction action = WitchAction.newBuilder()
                .setHealTarget(false)
                .setPoisonTargetId("")
                .build();

        witchAbility.execute("ABCD", action);

        // Liste bleibt leer
        assertTrue(state.deadPlayers.isEmpty());

        verify(stateService, times(1)).get("ABCD");
    }
}