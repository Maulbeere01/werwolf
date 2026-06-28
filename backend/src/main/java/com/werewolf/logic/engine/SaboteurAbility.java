package com.werewolf.logic.engine;

import com.werewolf.grpc.SaboteurAction;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.service.GameLoopService;
import com.werewolf.logic.service.GameStateService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class SaboteurAbility {

    private final GameStateService stateService;
    private final GameLoopService gameLoopService;

    public void execute(String lobbyCode, SaboteurAction action) {

        GameState state = stateService.get(lobbyCode);
        if (state == null) return;

        state.sabotagedPlayerId = action.getTargetId();

        gameLoopService.advanceNow(lobbyCode);
    }
}
