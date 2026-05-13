package com.werewolf.logic.engine;

import com.werewolf.logic.model.GameState;
import com.werewolf.logic.service.GameStateService;

public class HunterAbility {

    private final GameStateService stateService;

    public HunterAbility(GameStateService stateService) {
        this.stateService = stateService;
    }

    public void execute(String lobbyCode, com.werewolf.grpc.HunterAction action) {
        GameState state = stateService.get(lobbyCode);
        state.deadPlayers.add(action.getTargetId());
    }
}