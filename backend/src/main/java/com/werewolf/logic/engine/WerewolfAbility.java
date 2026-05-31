package com.werewolf.logic.engine;

import com.werewolf.grpc.Role;
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
public class WerewolfAbility {

    private final GameStateService stateService;
    private final LobbyManager lobbyManager;
    private final LobbySubscriptionService subscriptionService;
    private final GameLoopService gameLoopService;

    // Records a werewolf's vote for the night victim. The vote is committed: once
    // a wolf has voted it cannot be changed. On every committed vote we push the
    // live tally to all living wolves and, once every living wolf has voted, end
    // the phase early. The actual victim is resolved at phase end (see
    // GameLoopService), not here, so the witch can still heal.
    public void execute(String lobbyCode, String voterId, VoteAction action) {
        GameState state = stateService.get(lobbyCode);
        if (state == null) return;

        Lobby lobby = lobbyManager.getLobby(lobbyCode);
        if (lobby == null) return;

        synchronized (state) {
            Player voter = state.players.get(voterId);
            // only living werewolves may vote, and only once (commit)
            if (voter == null || voter.role != Role.WEREWOLF || !voter.alive) return;
            if (state.werewolfVotes.containsKey(voterId)) return;

            state.werewolfVotes.put(voterId, action.getTargetId());

            // once all living wolves have committed, start the short grace period
            // first so the push below carries the updated (grace) countdown
            long livingWolves = state.players.values().stream()
                    .filter(p -> p.role == Role.WEREWOLF && p.alive)
                    .count();
            if (state.werewolfVotes.size() >= livingWolves) {
                gameLoopService.beginWerewolfGrace(lobbyCode);
            }

            // push the updated tally (and countdown) to every living wolf
            state.players.values().stream()
                    .filter(p -> p.role == Role.WEREWOLF && p.alive)
                    .forEach(wolf -> subscriptionService.sendTo(lobbyCode, wolf.id,
                            GameUpdateFactory.werewolfVoteUpdate(state, lobby, wolf.id)));
        }
    }
}
