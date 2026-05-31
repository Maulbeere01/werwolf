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
        PlayerStatus.Builder b = PlayerStatus.newBuilder()
                .setId(p.id)
                .setName(p.name)
                .setIsAlive(p.alive)
                .setIsHost(p.id.equals(hostId));
        // a player's role is revealed to everyone once they are dead
        if (!p.alive && p.role != null) {
            b.setRole(p.role);
        }
        return b.build();
    }

    public static GameUpdate werewolfVoteUpdate(GameState state, Lobby lobby, String recipientId) {
        boolean recipientIsWolf = isWerewolf(state, recipientId);

        GameUpdate.Builder b = GameUpdate.newBuilder().setCurrentPhase(state.phase);
        lobby.players.forEach(lp -> {
            // playerStatus already reveals the role of dead players
            PlayerStatus.Builder ps = playerStatus(lp, lobby.hostId).toBuilder();
            if (recipientIsWolf && lp.role == Role.WEREWOLF
                    && state.werewolfVotes.containsKey(lp.id)) {
                ps.setHasVoted(true).setVotedForTargetId(state.werewolfVotes.get(lp.id));
            }
            b.addPlayers(ps.build());
        });

        Player caller = state.players.get(recipientId);
        if (caller != null && caller.role != null) {
            b.setYourRole(caller.role);
        }

        ActionPrompt prompt = state.pendingPrompts.get(recipientId);
        if (prompt != null) {
            b.setOpenPrompt(prompt);
        }

        if (state.phaseEndsAt != null) {
            b.setPhaseEndsAt(Timestamp.newBuilder()
                    .setSeconds(state.phaseEndsAt.getEpochSecond())
                    .setNanos(state.phaseEndsAt.getNano())
                    .build());
        }

        return b.build();
    }

    private static boolean isWerewolf(GameState state, String userId) {
        Player p = state.players.get(userId);
        return p != null && p.role == Role.WEREWOLF;
    }

    // build GameUpdate for DAY_RESULT
    public static GameUpdate announcement(Phase phase, PublicAnnouncement announcement) {
        return GameUpdate.newBuilder()
                .setCurrentPhase(phase)
                .setAnnouncement(announcement)
                .build();
    }
}
