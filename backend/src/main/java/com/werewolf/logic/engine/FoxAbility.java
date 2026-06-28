package com.werewolf.logic.engine;

import com.werewolf.grpc.*;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.model.Lobby;
import com.werewolf.logic.model.Player;
import com.werewolf.logic.service.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Set;


@Service
@RequiredArgsConstructor
public class FoxAbility {

    // the fox always peeks at exactly this many distinct players
    private static final int FOX_TARGET_COUNT = 3;

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

        // Server-side validation so a crafted client cannot bypass the targeting
        // rules the UI enforces: exactly three DISTINCT targets, each a living
        // player, and never the fox itself. Reject silently otherwise.
        Set<String> targets = Set.copyOf(action.getTargetIdsList());
        if (targets.size() != FOX_TARGET_COUNT) return;
        boolean allValid = targets.stream().allMatch(id -> {
            Player p = state.players.get(id);
            return p != null && p.alive && !id.equals(fox.id);
        });
        if (!allValid) return;

        boolean foundWerewolf = action.getTargetIdsList().stream()
                .anyMatch(id -> {
                    Player p = state.players.get(id);
                    return p != null && p.role == Role.WEREWOLF;
                });

        // No werewolf among the three targets => the fox loses its power for the
        // rest of the game (NIGHT_FOX is skipped from now on, see shouldSkip).
        if (!foundWerewolf) {
            state.foxHasPower = false;
        }

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