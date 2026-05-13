package com.werewolf.logic.engine;

import com.werewolf.logic.model.GameState;
import com.werewolf.logic.service.GameStateService;

public class WitchAbility {

    private final GameStateService stateService;

    public WitchAbility(GameStateService stateService) {
        this.stateService = stateService;
    }

    public void execute(String lobbyCode, com.werewolf.grpc.WitchAction action) {
        GameState state = stateService.get(lobbyCode);
        if (action.getHealTarget()) {
            state.deadPlayers.removeIf(id -> id.equals("lastNightTarget"));
        }

        if (!action.getPoisonTargetId().isEmpty()) {
            state.deadPlayers.add(action.getPoisonTargetId());
        }
    }
}