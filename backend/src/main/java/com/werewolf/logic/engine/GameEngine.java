package com.werewolf.logic.engine;

import com.werewolf.grpc.GameAction;

/**
 * Zentrale Steuerung des Spiels.
 * Nimmt Aktionen aus der API entgegen und leitet sie an die Ability-Logik weiter.
 */
public class GameEngine {

    private final AbilityExecutor abilityExecutor;

    public GameEngine(AbilityExecutor abilityExecutor) {
        this.abilityExecutor = abilityExecutor;
    }
    public void handleAction(String lobbyCode, GameAction action) {
        abilityExecutor.execute(lobbyCode, action);
    }
}
