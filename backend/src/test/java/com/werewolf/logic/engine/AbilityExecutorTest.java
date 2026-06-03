package com.werewolf.logic.engine;

import com.werewolf.grpc.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.*;

/**
 * Testet den AbilityExecutor.
 * Prüft, ob die richtige Rollen-Fähigkeit ausgeführt wird.
 */
class AbilityExecutorTest {

    private WerewolfAbility werewolfAbility;
    private SeerAbility seerAbility;
    private WitchAbility witchAbility;
    private HunterAbility hunterAbility;

    private AbilityExecutor abilityExecutor;

    @BeforeEach
    void setUp() {
        werewolfAbility = mock(WerewolfAbility.class);
        seerAbility = mock(SeerAbility.class);
        witchAbility = mock(WitchAbility.class);
        hunterAbility = mock(HunterAbility.class);

        abilityExecutor = new AbilityExecutor(werewolfAbility, seerAbility, witchAbility, hunterAbility);
    }

    /**
     * prüft, dass bei NIGHT_SEER die Seer-Fähigkeit mit richtiger Lobby-ID und Action ausgeführt wird
     */
    @Test
    void shouldExecuteSeerAbility() {
        GameAction action = GameAction.newBuilder()
                .setSeer(SeerAction.newBuilder().setTargetId("player1").build())
                .build();

        abilityExecutor.execute("ABCD", action, Phase.NIGHT_SEER);

        verify(seerAbility, times(1)).execute(eq("ABCD"), any(SeerAction.class));
    }

    /**
     * prüft, dass bei NIGHT_WITCH die Witch-Fähigkeit korrekt aufgerufen wird
     */
    @Test
    void shouldExecuteWitchAbility() {
        GameAction action = GameAction.newBuilder()
                .setWitch(WitchAction.newBuilder().setHealTarget(true).build())
                .build();

        abilityExecutor.execute("ABCD", action, Phase.NIGHT_WITCH);

        verify(witchAbility, times(1)).execute(eq("ABCD"), any(WitchAction.class));
    }

    /**
     * prüft, dass bei HUNTER_REVENGE die Hunter-Fähigkeit korrekt ausgeführt wird
     */
    @Test
    void shouldExecuteHunterAbility() {
        GameAction action = GameAction.newBuilder()
                .setHunter(HunterAction.newBuilder().setTargetId("player2").build())
                .build();

        abilityExecutor.execute("ABCD", action, Phase.HUNTER_REVENGE);

        verify(hunterAbility, times(1)).execute(eq("ABCD"), any(HunterAction.class));
    }

    /**
     * prüft, dass bei fehlender Action (ACTION_NOT_SET) eine IllegalArgumentException geworfen wird
     */
    @Test
    void shouldThrowExceptionForUnknownAction() {
        // ACTION_NOT_SET hits the default branch
        GameAction action = GameAction.newBuilder().build();

        assertThrows(
                IllegalArgumentException.class,
                () -> abilityExecutor.execute("ABCD", action, Phase.NIGHT_WEREWOLVES)
        );
    }
}