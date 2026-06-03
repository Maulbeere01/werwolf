package com.werewolf.integration;

import com.werewolf.grpc.*;
import com.werewolf.logic.engine.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;

/**
 * Integrationstests für Nachtphasen-Logik im AbilityExecutor.
 * Prüft, ob Aktionen korrekt an die jeweiligen Ability-Klassen weitergeleitet werden.
 */
public class NightPhaseIntegrationTest {

    private AbilityExecutor abilityExecutor;
    private WerewolfAbility werewolfAbility;
    private SeerAbility seerAbility;
    private WitchAbility witchAbility;
    private HunterAbility hunterAbility;

    @BeforeEach
    void setUp() {

        werewolfAbility = mock(WerewolfAbility.class);
        seerAbility = mock(SeerAbility.class);
        witchAbility = mock(WitchAbility.class);
        hunterAbility = mock(HunterAbility.class);

        abilityExecutor = new AbilityExecutor(
                werewolfAbility,
                seerAbility,
                witchAbility,
                hunterAbility
        );
    }

    /**
     * Prüft, dass in der Seher-Nachtphase die SeerAbility ausgeführt wird.
     */
    @Test
    void shouldExecuteSeerInNightPhase() {

        GameAction action = GameAction.newBuilder()
                .setSeer(SeerAction.newBuilder().setTargetId("p1"))
                .build();

        abilityExecutor.execute("ABCD", action, Phase.NIGHT_SEER);

        verify(seerAbility).execute(eq("ABCD"), any(SeerAction.class));
    }

    /**
     * Prüft, ob in der Werwolf-Nachtphase ein Kill ausgeführt wird.
     */
    @Test
    void shouldExecuteWerewolfKill() {

        GameAction action = GameAction.newBuilder()
                .setVote(VoteAction.newBuilder().setTargetId("p1"))
                .build();

        abilityExecutor.execute("ABCD", action, Phase.NIGHT_WEREWOLVES);

        verify(werewolfAbility).execute(eq("ABCD"), any(VoteAction.class));
    }

    /**
     * Prüft, dass die Hexen-Fähigkeit in der Nachtphase korrekt ausgeführt wird.
     */
    @Test
    void shouldExecuteWitchAbilityInNight() {

        GameAction action = GameAction.newBuilder()
                .setWitch(WitchAction.newBuilder().setHealTarget(true))
                .build();

        abilityExecutor.execute("ABCD", action, Phase.NIGHT_WITCH);

        verify(witchAbility).execute(eq("ABCD"), any(WitchAction.class));
    }

    /**
     * Prüft, dass bei einer leeren Action eine Exception geworfen wird,
     * da keine gültige Fähigkeit ausgeführt werden kann.
     */
    @Test
    void shouldThrowExceptionForEmptyAction() {

        GameAction action = GameAction.newBuilder().build();

        assertThrows(
                IllegalArgumentException.class,
                () -> abilityExecutor.execute("ABCD", action, Phase.NIGHT_SEER)
        );
    }


}
