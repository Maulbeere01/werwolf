package com.werewolf.logic.engine;

import com.werewolf.grpc.CupidAction;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.model.Player;
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

        // cupid acts only once
        if (state.loverA != null) return;

        String a = action.getPlayer1Id();
        String b = action.getPlayer2Id();

        // validate: two distinct, living players
        if (a == null || b == null || a.equals(b)) return;
        Player pa = state.players.get(a);
        Player pb = state.players.get(b);
        if (pa == null || pb == null || !pa.alive || !pb.alive) return;

        state.loverA = a;
        state.loverB = b;

        // Nothing to reveal at night (everyone's eyes are shut): the lovers learn
        // their partner by peeking their own role card during the day, where
        // lover_partner_id is rendered as a heart. So just advance the night.
        gameLoopService.advanceNow(lobbyCode);
    }
}
