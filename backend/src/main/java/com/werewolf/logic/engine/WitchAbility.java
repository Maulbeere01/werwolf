package com.werewolf.logic.engine;

import com.werewolf.grpc.WitchAction;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.service.GameStateService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class WitchAbility {

    private final GameStateService stateService;

    /**
     * Führt die Fähigkeit der Hexe aus.
     * Die Hexe kann entweder ein Opfer heilen oder einen Spieler vergiften.
     */
    public void execute(String lobbyCode, WitchAction action) {
        GameState state = stateService.get(lobbyCode);

        if (state == null) {
            throw new IllegalStateException("GameState not initialized for lobby " + lobbyCode);
        }

        // HEAL
        if (action.getHealTarget()) {
            if (state.witchHasHealPotion && state.nightVictimId != null) {
                state.witchHasHealPotion = false;

                String victim = state.nightVictimId;

                state.deadPlayers.remove(victim);
                state.nightVictimId = null;
            }
        }

        // POISON
        if (!action.getPoisonTargetId().isEmpty()) {
            if (state.witchHasPoisonPotion) {
                state.witchHasPoisonPotion = false;

                String target = action.getPoisonTargetId();

                if (!state.deadPlayers.contains(target)) {
                    state.deadPlayers.add(target);
                }
            }
        }
    }
}