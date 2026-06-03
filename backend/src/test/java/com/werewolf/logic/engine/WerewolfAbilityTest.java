package com.werewolf.logic.engine;

import com.werewolf.grpc.VoteAction;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.service.GameStateService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.*;

/**
 * Testet die WerewolfAbility.
 * Prüft, ob der Werwolf korrekt einen Spieler zum Tod markiert.
 */
class WerewolfAbilityTest {

    private GameStateService stateService;
    private WerewolfAbility werewolfAbility;

    @BeforeEach
    void setUp() {

        // Mock für GameStateService erstellen
        stateService = mock(GameStateService.class);

        // WerewolfAbility erstellen
        werewolfAbility = new WerewolfAbility(stateService);
    }

    /**
     * prüft, dass die WerewolfAbility das gewählte Opfer aus einer VoteAction korrekt
     * in die deadPlayers Liste des GameState einträgt
     * und dabei den GameState einmal über den GameStateService lädt.
     */
    @Test
    void shouldAddTargetToDeadPlayers() {

        // Ob die Werwolf-Fähigkeit den gewählten Spieler in die Liste der toten Spieler einträgt (Night Kill).
        GameState state = new GameState();

        // Mock Verhalten definieren
        when(stateService.get("ABCD")).thenReturn(state);

        // VoteAction (Wolfs-Kill) erstellen
        VoteAction action = VoteAction.newBuilder()
                .setTargetId("player1")
                .build();

        werewolfAbility.execute("ABCD", action);

        // Prüfen ob Spieler als tot markiert wurde
        assertTrue(state.deadPlayers.contains("player1"));

        // Prüfen ob GameState korrekt geladen wurde
        verify(stateService, times(1)).get("ABCD");
    }
}