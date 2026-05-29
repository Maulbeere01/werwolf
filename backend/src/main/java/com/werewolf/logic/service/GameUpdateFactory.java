package com.werewolf.logic.service;

import com.google.protobuf.Timestamp;
import com.werewolf.grpc.*;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.model.Lobby;
import com.werewolf.logic.model.Player;

public final class GameUpdateFactory {

    private GameUpdateFactory() {}

    public static GameUpdate forLobby(Lobby lobby) {
        GameUpdate.Builder b = GameUpdate.newBuilder().setCurrentPhase(Phase.LOBBY);
        lobby.players.forEach(p -> b.addPlayers(playerStatus(p, lobby.hostId)));
        return b.build();
    }

    // Full personalised snapshot sent as the first message on (re)subscribe
    public static GameUpdate snapshot(GameState state, Lobby lobby, String userId) {
        GameUpdate.Builder b = GameUpdate.newBuilder().setCurrentPhase(state.phase);
        lobby.players.forEach(p -> b.addPlayers(playerStatus(p, lobby.hostId)));

        Player caller = state.players.get(userId);
        if (caller != null && caller.role != null) {
            b.setYourRole(caller.role);
        }

        ActionPrompt prompt = state.pendingPrompts.get(userId);
        if (prompt != null) {
            b.setOpenPrompt(prompt);
        }

        if (state.lastAnnouncement != null) {
            b.setAnnouncement(state.lastAnnouncement);
        }

        if (state.phaseEndsAt != null) {
            b.setPhaseEndsAt(Timestamp.newBuilder()
                    .setSeconds(state.phaseEndsAt.getEpochSecond())
                    .setNanos(state.phaseEndsAt.getNano())
                    .build());
        }

        return b.build();
    }

    // Role specific action prompt => tells the client to render the ability UI
    public static GameUpdate privatePrompt(Phase phase, ActionPrompt prompt) {
        return GameUpdate.newBuilder()
                .setCurrentPhase(phase)
                .setOpenPrompt(prompt)
                .build();
    }

    // Delivers a private action result to one player (e.g. seer reveal, fox result).
    public static GameUpdate privateResult(Phase phase, ActionResult result) {
        return GameUpdate.newBuilder()
                .setCurrentPhase(phase)
                .setYourResults(result)
                .build();
    }

    static PlayerStatus playerStatus(Player p, String hostId) {
        return PlayerStatus.newBuilder()
                .setId(p.id)
                .setName(p.name)
                .setIsAlive(p.alive)
                .setIsHost(p.id.equals(hostId))
                .build();
    }
}
