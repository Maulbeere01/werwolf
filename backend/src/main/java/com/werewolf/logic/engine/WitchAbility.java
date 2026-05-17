package com.werewolf.logic.engine;

import com.werewolf.grpc.WitchAction;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.service.GameStateService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class WitchAbility {

    private final GameStateService stateService;

    public void execute(String lobbyCode, WitchAction action) {
        GameState state = stateService.get(lobbyCode);
        if (action.getHealTarget()) {
            state.deadPlayers.removeIf(id -> id.equals("lastNightTarget"));
        }

        if (!action.getPoisonTargetId().isEmpty()) {
            state.deadPlayers.add(action.getPoisonTargetId());
        }
    }
}