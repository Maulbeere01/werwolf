package com.werewolf.logic.engine;

import com.werewolf.grpc.GameAction;
import com.werewolf.grpc.Phase;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.service.GameStateService;

/**
 * Zentrale Steuerung des Spiels.
 * Nimmt Aktionen aus der API entgegen und leitet sie an die Ability-Logik weiter.
 */
public class GameEngine {


    private final AbilityExecutor abilityExecutor;
    private final GameStateService gameStateService;

    public GameEngine(AbilityExecutor abilityExecutor, GameStateService gameStateService) {
        this.abilityExecutor = abilityExecutor;
        this.gameStateService = gameStateService;
    }

    /**
     * Verarbeitet eine Spieleraktion anhand der aktuellen Spielphase.
     */
    public void handleAction(String lobbyCode, GameAction action) {
        if (action.getActionCase() == GameAction.ActionCase.ACTION_NOT_SET) {
            throw new IllegalArgumentException("Empty action not allowed");
        }

        GameState state = gameStateService.getOrCreate(lobbyCode);

        if (state == null) {
            throw new IllegalStateException("GameState missing for lobby " + lobbyCode);
        }

        if (state.phase == null) {
            throw new IllegalStateException("Phase not initialized for lobby " + lobbyCode);
        }

        // Routing nur basierend auf aktueller Phase im GameState
        abilityExecutor.execute(lobbyCode, action, state.phase);
    }
}
