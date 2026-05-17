package com.werewolf.logic.engine;

import com.werewolf.grpc.GameUpdate;
import com.werewolf.grpc.Role;
import com.werewolf.grpc.SeerAction;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.model.Player;
import com.werewolf.logic.service.GameStateService;
import com.werewolf.logic.service.LobbySubscriptionService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class SeerAbility {

    private final GameStateService stateService;
    private final LobbySubscriptionService subscriptionService;

    public void execute(String lobbyCode, SeerAction action) {
        GameState state = stateService.get(lobbyCode);
        Player target = state.players.get(action.getTargetId());

        // AuthContext is only available on the gRPC thread, not here. Look up the seer's
        // userId from GameState so sendTo() can target the right subscriber
        String seerId = state.players.values().stream()
                .filter(p -> p.role == Role.SEER)
                .map(p -> p.id)
                .findFirst()
                .orElse(null);

        if (seerId == null || target == null) return;

        GameUpdate result = GameUpdate.newBuilder()
                .setCurrentPhase(state.phase)
                .setPrivateInfo("Der Spieler " + target.name + " ist: " + target.role.name())
                .build();

        subscriptionService.sendTo(lobbyCode, seerId, result);
    }
}