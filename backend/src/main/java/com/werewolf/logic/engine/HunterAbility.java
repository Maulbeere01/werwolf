package com.werewolf.logic.engine;

import com.werewolf.grpc.HunterAction;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.model.Player;
import com.werewolf.logic.service.GameLoopService;
import com.werewolf.logic.service.GameStateService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class HunterAbility {

    private final GameStateService stateService;
    private final GameLoopService gameLoopService;

    public void execute(String lobbyCode, HunterAction action) {
        GameState state = stateService.get(lobbyCode);
        if (state == null) return;

        // only valid while a hunter actually owes a revenge shot
        if (state.pendingHunterId == null) return;

        // the target must be a living player; the shot is applied (and announced)
        // when HUNTER_REVENGE ends, in resolveHunterShot
        String targetId = action.getTargetId();
        Player target = state.players.get(targetId);
        if (target == null || !target.alive) return;

        state.hunterShotTargetId = targetId;
        gameLoopService.advanceNow(lobbyCode);
    }
}
