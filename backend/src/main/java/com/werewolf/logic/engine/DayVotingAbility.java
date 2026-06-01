package com.werewolf.logic.engine;

import com.werewolf.grpc.VoteAction;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.service.GameLoopService;
import com.werewolf.logic.service.GameStateService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;


@Service
@RequiredArgsConstructor

public class DayVotingAbility {

    private final GameStateService stateService;
    private final GameLoopService gameLoopService;

    public void execute(String lobbyCode, VoteAction action, String voterId) {
        GameState state = stateService.get(lobbyCode);
        state.votes.put(voterId, action.getTargetId()); // ein Spieler = eine Stimme

        long alivePlayers = state.players.values().stream()
                .filter(p -> p.alive).count();

        // Frühzeitiger Abschluss: alle haben abgestimmt
        if (state.votes.size() >= alivePlayers) {
            gameLoopService.advanceNow(lobbyCode);
        }

     }
}
