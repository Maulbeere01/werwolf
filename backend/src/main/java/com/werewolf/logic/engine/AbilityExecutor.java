package com.werewolf.logic.engine;

import com.werewolf.grpc.GameAction;

/**
 * Führt alle Rollen-Fähigkeiten aus (Werwolf, Seher, Hexe, etc.).
 * Entscheidet anhand der Rolle, welche Spielaktion ausgeführt wird.
 */
public class AbilityExecutor {

    private final WerewolfAbility werewolf;
    private final SeerAbility seer;
    private final WitchAbility witch;
    private final HunterAbility hunter;

    public AbilityExecutor(
            WerewolfAbility werewolf,
            SeerAbility seer,
            WitchAbility witch,
            HunterAbility hunter
    ) {
        this.werewolf = werewolf;
        this.seer = seer;
        this.witch = witch;
        this.hunter = hunter;
    }

    public void execute(String lobbyCode, GameAction action) {

        switch (action.getActionCase()) {

            case VOTE -> {} // später Day logic

            case WITCH -> witch.execute(lobbyCode, action.getWitch());

            case SEER -> seer.execute(lobbyCode, action.getSeer());

            case FOX -> {} // optional später

            case HUNTER -> hunter.execute(lobbyCode, action.getHunter());

            default -> throw new IllegalStateException("Unknown action");
        }
    }
}