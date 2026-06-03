package com.werewolf.logic.engine;

import com.werewolf.grpc.VoteAction;
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

public class DayVotingAbility {

    private final GameStateService stateService;
    private final LobbyManager lobbyManager;
    private final LobbySubscriptionService subscriptionService;
    private final GameLoopService gameLoopService;

    public void execute(String lobbyCode, VoteAction action, String voterId) {
        GameState state = stateService.get(lobbyCode);
        if (state == null) return;

        // only living players may vote by day (dead players are out of the game)
        Player voter = state.players.get(voterId);
        if (voter == null || !voter.alive) return;

        // an empty target id means the player abstained (votes for nobody)
        state.votes.put(voterId, action.getTargetId());

        // the day vote is public: push the updated tally to every subscriber so
        // they see who voted for whom live (yellow dots on the client)
        Lobby lobby = lobbyManager.getLobby(lobbyCode);
        if (lobby != null) {
            lobby.players.forEach(p -> subscriptionService.sendTo(lobbyCode, p.id,
                    GameUpdateFactory.snapshot(state, lobby, p.id)));
        }

        long alivePlayers = state.players.values().stream()
                .filter(p -> p.alive).count();

        // Frühzeitiger Abschluss: alle lebenden Spieler haben abgestimmt
        if (state.votes.size() >= alivePlayers) {
            gameLoopService.advanceNow(lobbyCode);
        }
    }
}
