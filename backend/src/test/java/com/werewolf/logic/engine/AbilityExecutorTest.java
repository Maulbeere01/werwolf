package com.werewolf.logic.engine;

import com.werewolf.grpc.GameAction;
import com.werewolf.grpc.HunterAction;
import com.werewolf.grpc.SeerAction;
import com.werewolf.grpc.WitchAction;
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

        // Mock-Objekte erstellen
        werewolfAbility = mock(WerewolfAbility.class);
        seerAbility = mock(SeerAbility.class);
        witchAbility = mock(WitchAbility.class);
        hunterAbility = mock(HunterAbility.class);

        // AbilityExecutor mit den Mock-Abilities erstellen
        abilityExecutor = new AbilityExecutor(
                werewolfAbility,
                seerAbility,
                witchAbility,
                hunterAbility
        );
    }

    @Test
    void shouldExecuteSeerAbility() {

        // Testet:
        // Ob bei einer Seher-Action die Seher-Fähigkeit ausgeführt wird.

        // GameAction mit Seher-Aktion bauen
        GameAction action = GameAction.newBuilder()
                .setSeer(
                        SeerAction.newBuilder()
                                .setTargetId("player1")
                                .build()
                )
                .build();

        // Methode ausführen
        abilityExecutor.execute("ABCD", action);

        // Prüfen ob die Seher-Ability genau 1x ausgeführt wurde
        verify(seerAbility, times(1))
                .execute(eq("ABCD"), any(SeerAction.class));
    }

    @Test
    void shouldExecuteWitchAbility() {

        // Testet:
        // Ob bei einer Hexen-Action die Hexen-Fähigkeit ausgeführt wird.

        GameAction action = GameAction.newBuilder()
                .setWitch(
                        WitchAction.newBuilder()
                                .setHealTarget(true)
                                .build()
                )
                .build();

        // Methode ausführen
        abilityExecutor.execute("ABCD", action);

        // Prüfen ob die Hexen-Ability genau 1x ausgeführt wurde
        verify(witchAbility, times(1))
                .execute(eq("ABCD"), any(WitchAction.class));
    }

    @Test
    void shouldExecuteHunterAbility() {

        // Testet:
        // Ob bei einer Jäger-Action die Jäger-Fähigkeit ausgeführt wird.

        GameAction action = GameAction.newBuilder()
                .setHunter(
                        HunterAction.newBuilder()
                                .setTargetId("player2")
                                .build()
                )
                .build();

        // Methode ausführen
        abilityExecutor.execute("ABCD", action);

        // Prüfen ob die Hunter-Ability genau 1x ausgeführt wurde
        verify(hunterAbility, times(1))
                .execute(eq("ABCD"), any(HunterAction.class));
    }

    @Test
    void shouldThrowExceptionForUnknownAction() {

        // Testet:
        // Ob eine Exception geworfen wird,
        // wenn keine gültige Action gesetzt wurde.

        // Leere Action -> ACTION_NOT_SET
        GameAction action = GameAction.newBuilder().build();

        // Prüfen ob IllegalStateException geworfen wird
        assertThrows(
                IllegalStateException.class,
                () -> abilityExecutor.execute("ABCD", action)
        );
    }
}