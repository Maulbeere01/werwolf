package com.werewolf.logic.engine;

import com.werewolf.grpc.VoteAction;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.service.GameStateService;

public class WerewolfAbility {

    private final GameStateService stateService;

    public WerewolfAbility(GameStateService stateService) {
        this.stateService = stateService;
    }

    public void execute(String lobbyCode, VoteAction action) {
        GameState state = stateService.get(lobbyCode);

        // mark target for death (night kill)
        state.deadPlayers.add(action.getTargetId());
    }
}