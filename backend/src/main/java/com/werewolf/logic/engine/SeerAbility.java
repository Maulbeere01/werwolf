package com.werewolf.logic.engine;

import com.werewolf.logic.model.GameState;
import com.werewolf.logic.model.Player;
import com.werewolf.logic.service.GameStateService;

public class SeerAbility {

    private final GameStateService stateService;

    public SeerAbility(GameStateService stateService) {
        this.stateService = stateService;
    }

    public void execute(String lobbyCode, com.werewolf.grpc.SeerAction action) {
        GameState state = stateService.get(lobbyCode);
        Player target = state.players.get(action.getTargetId());

        // reveal role ONLY to seer
        System.out.println("SEER sees: " + target.role);
    }
}