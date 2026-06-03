package com.werewolf.logic.engine;

import com.werewolf.grpc.*;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.model.Lobby;
import com.werewolf.logic.model.Player;
import com.werewolf.logic.service.GameLoopService;
import com.werewolf.logic.service.GameStateService;
import com.werewolf.logic.service.GameUpdateFactory;
import com.werewolf.logic.service.LobbyManager;
import com.werewolf.logic.service.LobbySubscriptionService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class SeerAbility {

    // how long the seer gets to read the reveal before the night moves on
    private static final long SEER_RESULT_GRACE_SECONDS = 5;

    private final GameStateService stateService;
    private final LobbySubscriptionService subscriptionService;
    private final LobbyManager lobbyManager;
    private final GameLoopService gameLoopService;

    public void execute(String lobbyCode, SeerAction action) {
        GameState state = stateService.get(lobbyCode);
        if (state == null) return;

        Player target = state.players.get(action.getTargetId());

        // AuthContext is only available on the gRPC thread, not here. Look up the seer's
        // userId from GameState so sendTo() can target the right subscriber
        String seerId = state.players.values().stream()
                .filter(p -> p.role == Role.SEER)
                .map(p -> p.id)
                .findFirst()
                .orElse(null);

        if (seerId == null || target == null) return;

        ActionResult result = ActionResult.newBuilder()
                .setSeerReveal(SeerReveal.newBuilder()
                        .setTargetId(target.id)
                        .setIsWerewolf(target.role == Role.WEREWOLF)
                        .build())
                .build();

        // store the reveal so it rides along on the snapshot (robust against
        // reconnects); the seer has acted -> drop the prompt
        state.pendingResults.put(seerId, result);
        state.pendingPrompts.remove(seerId);

        Lobby lobby = lobbyManager.getLobby(lobbyCode);
        if (lobby != null) {
            subscriptionService.sendTo(lobbyCode, seerId,
                    GameUpdateFactory.snapshot(state, lobby, seerId));
        }

        // the seer is solo: give them a few seconds to read the result, then move on
        gameLoopService.beginGrace(lobbyCode, Phase.NIGHT_SEER, SEER_RESULT_GRACE_SECONDS);
    }
}
