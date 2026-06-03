package com.werewolf.logic.engine;

import com.werewolf.grpc.VoteAction;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.service.GameStateService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class WerewolfAbility {

    private final GameStateService stateService;

    /**
     * Führt die Fähigkeit der Werwölfe aus.
     * Die Werwölfe wählen gemeinsam ein Opfer, das in der Nacht stirbt.
     */
    public void execute(String lobbyCode, VoteAction action) {
        GameState state = stateService.get(lobbyCode);
        state.nightVictimId = action.getTargetId();

        // mark target for death (night kill)
        state.deadPlayers.add(action.getTargetId());
    }
}