package com.werewolf.logic.engine;

import com.werewolf.grpc.CupidAction;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.service.GameLoopService;
import com.werewolf.logic.service.GameStateService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class CupidAbility {

    private final GameStateService stateService;
    private final GameLoopService gameLoopService;

    public void execute(String lobbyCode, CupidAction action) {

        GameState state = stateService.get(lobbyCode);
        if (state == null) return;

        state.loverA = action.getPlayer1Id();
        state.loverB = action.getPlayer2Id();

        gameLoopService.advanceNow(lobbyCode);
    }
}
