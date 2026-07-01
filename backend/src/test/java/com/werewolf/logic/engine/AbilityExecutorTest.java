package com.werewolf.logic.engine;

import com.werewolf.grpc.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.*;
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
    private FoxAbility foxAbility;
    private CupidAbility cupidAbility;
    private SaboteurAbility saboteurAbility;
    private DayVotingAbility dayVotingAbility;

    private AbilityExecutor abilityExecutor;

    @BeforeEach
    void setUp() {

        werewolfAbility = mock(WerewolfAbility.class);
        seerAbility = mock(SeerAbility.class);
        witchAbility = mock(WitchAbility.class);
        hunterAbility = mock(HunterAbility.class);
        foxAbility = mock(FoxAbility.class);
        cupidAbility = mock(CupidAbility.class);
        saboteurAbility = mock(SaboteurAbility.class);
        dayVotingAbility = mock(DayVotingAbility.class);

        abilityExecutor = new AbilityExecutor(
                werewolfAbility,
                seerAbility,
                witchAbility,
                hunterAbility,
                foxAbility,
                cupidAbility,
                saboteurAbility,
                dayVotingAbility
        );
    }

    @Test
    void shouldExecuteSeerAbility() {

        GameAction action = GameAction.newBuilder()
                .setSeer(SeerAction.newBuilder().setTargetId("player1").build())
                .build();

        abilityExecutor.execute("ABCD", "user1", action, Phase.NIGHT_SEER);

        verify(seerAbility, times(1))
                .execute(eq("ABCD"), any(SeerAction.class));
    }

    @Test
    void shouldExecuteWitchAbility() {

        GameAction action = GameAction.newBuilder()
                .setWitch(WitchAction.newBuilder().setHealTarget(true).build())
                .build();

        abilityExecutor.execute("ABCD", "user1", action, Phase.NIGHT_WITCH);

        verify(witchAbility, times(1))
                .execute(eq("ABCD"), any(WitchAction.class));
    }

    @Test
    void shouldExecuteHunterAbility() {

        GameAction action = GameAction.newBuilder()
                .setHunter(HunterAction.newBuilder().setTargetId("player2").build())
                .build();

        abilityExecutor.execute("ABCD", "user1", action, Phase.HUNTER_REVENGE);

        verify(hunterAbility, times(1))
                .execute(eq("ABCD"), any(HunterAction.class));
    }

    @Test
    void shouldThrowExceptionForUnknownAction() {

        GameAction action = GameAction.newBuilder().build();

        assertThrows(
                IllegalArgumentException.class,
                () -> abilityExecutor.execute("ABCD", "user1", action, Phase.NIGHT_WEREWOLVES)
        );
    }
}