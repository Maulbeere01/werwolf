package com.werewolf.logic.engine;

import com.werewolf.grpc.GameAction;
import com.werewolf.grpc.Phase;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AbilityExecutor {

    private final WerewolfAbility werewolf;
    private final SeerAbility seer;
    private final WitchAbility witch;
    private final HunterAbility hunter;

    public void execute(String lobbyCode, GameAction action, Phase currentPhase) {
        switch (action.getActionCase()) {
            // VOTE is reused by both werewolves (night kill) and the village (day elimination). currentPhase determines which handler to call.
            case VOTE -> {
                if (currentPhase == Phase.NIGHT_WEREWOLVES) {
                    werewolf.execute(lobbyCode, action.getVote());
                }
                // DAY_VOTING added later

                //DAY_DISCUSSION  ( before DAY_VOTING )
                if( currentPhase == Phase.DAY_DISCUSSION ) {
                    //execute discussion
                }

                //DAY_VOTING
                if (currentPhase == Phase.DAY_VOTING) {
                    //execute voting with discussion outcome
                }
            }
            case SEER    -> seer.execute(lobbyCode, action.getSeer());
            case WITCH   -> witch.execute(lobbyCode, action.getWitch());
            case HUNTER  -> hunter.execute(lobbyCode, action.getHunter());
            case FOX     -> {}
            default      -> throw new IllegalArgumentException("Unhandled action type: " + action.getActionCase());
        }
    }
}