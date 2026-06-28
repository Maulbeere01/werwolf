package com.werewolf.logic.engine;

import com.werewolf.grpc.*;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.model.Lobby;
import com.werewolf.logic.model.Player;
import com.werewolf.logic.service.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;


@Service
@RequiredArgsConstructor
public class FoxAbility {

    private final GameStateService stateService;
    private final LobbySubscriptionService subscriptionService;
    private final LobbyManager lobbyManager;
    private final GameLoopService gameLoopService;

    public void execute(String lobbyCode, FoxAction action) {
        GameState state = stateService.get(lobbyCode);
        if (state == null) return;

        Lobby lobby = lobbyManager.getLobby(lobbyCode);
        if (lobby == null) return;

        Player fox = state.players.values().stream()
                .filter(p -> p.role == Role.FOX && p.alive)
                .findFirst()
                .orElse(null);

        if (fox == null) return;

        boolean foundWerewolf = action.getTargetIdsList().stream()
                .anyMatch(id -> {
                    Player p = state.players.get(id);
                    return p != null && p.role == Role.WEREWOLF;
                });

        ActionResult result = ActionResult.newBuilder()
                .setFoxReveal(FoxReveal.newBuilder()
                        .setAnyWerewolfFound(foundWerewolf)
                        .build())
                .build();

        state.pendingResults.put(fox.id, result);
        state.pendingPrompts.remove(fox.id);

        subscriptionService.sendTo(
                lobbyCode,
                fox.id,
                GameUpdateFactory.snapshot(state, lobby, fox.id)
        );

        gameLoopService.beginGrace(lobbyCode, Phase.NIGHT_FOX, 5);
    }
}