package com.werewolf.logic.engine;

import com.werewolf.grpc.GameAction;
import com.werewolf.grpc.Phase;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class GameEngine {

    private final AbilityExecutor abilityExecutor;

    public void handleAction(String lobbyCode, GameAction action, Phase currentPhase) {
        abilityExecutor.execute(lobbyCode, action, currentPhase);
    }
}
