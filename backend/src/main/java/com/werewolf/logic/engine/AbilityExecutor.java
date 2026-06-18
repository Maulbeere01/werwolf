package com.werewolf.logic.engine;

import com.werewolf.auth.AuthContext;
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
    private final FoxAbility fox;
    private final CupidAbility cupid;
    private final SaboteurAbility saboteur;
    private final DayVotingAbility dayVoting;


    public void execute(String lobbyCode, String userId, GameAction action, Phase currentPhase) {
        switch (action.getActionCase()) {

            // VOTE is reused by both werewolves (night kill) and the village (day elimination). currentPhase determines which handler to call.
            case VOTE -> {
                if (currentPhase == Phase.NIGHT_WEREWOLVES) {
                    werewolf.execute(lobbyCode, userId, action.getVote());
                }

                // DAY_DISCUSSION  ( before DAY_VOTING )
                //if(currentPhase == Phase.DAY_DISCUSSION) {
                    // TODO: timer (30 sek.) in der alle diskutieren können
                //}

                // DAY_VOTING -> erneuter timer/loop muss laufen bis 50% der Spieler eine Person gewählt haben.
                if (currentPhase == Phase.DAY_VOTING) {
                    dayVoting.execute(lobbyCode, action.getVote(), AuthContext.USER_ID_KEY.get());   //VoterId aus AuthContext
                }
            }
            case SEER    -> seer.execute(lobbyCode, action.getSeer());
            case WITCH   -> witch.execute(lobbyCode, action.getWitch());
            case HUNTER  -> hunter.execute(lobbyCode, action.getHunter());
            case FOX     -> fox.execute(lobbyCode, action.getFox());
            case CUPID   -> cupid.execute(lobbyCode, action.getCupid());
            case SABOTEUR -> saboteur.execute(lobbyCode, action.getSaboteur());
            default      -> throw new IllegalArgumentException("Unhandled action type: " + action.getActionCase());
        }
    }
}