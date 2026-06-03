package com.werewolf.logic.engine;

import com.werewolf.logic.model.GameState;
import com.werewolf.logic.model.Player;
import com.werewolf.logic.service.GameStateService;
import com.werewolf.logic.service.LobbySubscriptionService;
import com.werewolf.grpc.GameUpdate;
import com.werewolf.grpc.*;
import com.werewolf.grpc.SeerAction;

public class SeerAbility {

    private final GameStateService stateService;
    private final LobbySubscriptionService subscriptionService;

    public SeerAbility(GameStateService stateService, LobbySubscriptionService subscriptionService) {
        this.stateService = stateService;
        this.subscriptionService = subscriptionService;
    }

    /**
     * Führt die Fähigkeit des Sehers aus.
     * Der Seher überprüft die Rolle eines Zielspielers und erhält ein privates Ergebnis.
     */
    public void execute(String lobbyCode, SeerAction action) {
        GameState state = stateService.get(lobbyCode);
        Player target = state.players.get(action.getTargetId());

        if (target == null) {
            // entweder ignorieren ODER später Fehler-Event schicken
            return;
        }

        boolean isWerewolf = target.role == Role.WEREWOLF;

        SeerReveal reveal = SeerReveal.newBuilder()
                .setTargetId(target.id)
                .setIsWerewolf(isWerewolf)
                .build();

        ActionResult result = ActionResult.newBuilder()
                .setSeerReveal(reveal)
                .build();

        GameUpdate update = GameUpdate.newBuilder()
                .setYourResults(result)
                .setCurrentPhase(state.phase)
                .build();

        subscriptionService.sendTo(
                lobbyCode,
                "seer1",   // später: aus Context holen!
                update
        );
    }
}