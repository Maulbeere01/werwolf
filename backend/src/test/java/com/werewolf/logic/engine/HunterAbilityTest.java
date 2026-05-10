package com.werewolf.logic.engine;

import com.werewolf.grpc.HunterAction;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.service.GameStateService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.*;

/**
 * Testet die HunterAbility.
 * Prüft, ob der Jäger einen Spieler töten kann.
 */
class HunterAbilityTest {

    private GameStateService stateService;
    private HunterAbility hunterAbility;

    @BeforeEach
    void setUp() {

        // Mock für GameStateService erstellen
        stateService = mock(GameStateService.class);

        // HunterAbility erstellen
        hunterAbility = new HunterAbility(stateService);
    }

    @Test
    void shouldAddTargetToDeadPlayers() {

        // Testet:
        // Ob das Ziel des Jägers
        // zur Liste der toten Spieler hinzugefügt wird.

        // GameState erstellen
        GameState state = new GameState();

        // Mock-Verhalten definieren
        when(stateService.get("ABCD")).thenReturn(state);

        // HunterAction erstellen
        HunterAction action = HunterAction.newBuilder()
                .setTargetId("player1")
                .build();

        // Fähigkeit ausführen
        hunterAbility.execute("ABCD", action);

        // Prüfen ob Spieler in deadPlayers enthalten ist
        assertTrue(state.deadPlayers.contains("player1"));
    }
}