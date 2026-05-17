package com.werewolf.logic.engine;

import com.werewolf.grpc.HunterAction;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.service.GameStateService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class HunterAbility {

    private final GameStateService stateService;

    public void execute(String lobbyCode, HunterAction action) {
        GameState state = stateService.get(lobbyCode);
        state.deadPlayers.add(action.getTargetId());
    }
}