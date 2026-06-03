package com.werewolf.logic.engine;

import com.werewolf.grpc.WitchAction;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.service.GameLoopService;
import com.werewolf.logic.service.GameStateService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class WitchAbility {

    private final GameStateService stateService;
    private final GameLoopService gameLoopService;

    public void execute(String lobbyCode, WitchAction action) {
        GameState state = stateService.get(lobbyCode);
        if (state == null) return;

        // heal saves the player the werewolves attacked this night
        if (action.getHealTarget() && state.witchHasHealPotion
                && state.attackedThisNight != null && !state.attackedThisNight.isEmpty()) {
            state.deadPlayers.removeIf(id -> id.equals(state.attackedThisNight));
            state.witchHasHealPotion = false;
        }

        if (!action.getPoisonTargetId().isEmpty() && state.witchHasPoisonPotion) {
            state.deadPlayers.add(action.getPoisonTargetId());
            state.witchHasPoisonPotion = false;
        }

        // the witch is solo: there is nobody to wait for, so move on immediately
        gameLoopService.advanceNow(lobbyCode);
    }
}
