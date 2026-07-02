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
        addPlayers(b, state, lobby, userId);

        Player caller = state.players.get(userId);
        if (caller != null && caller.role != null) {
            b.setYourRole(caller.role);
        }

        ActionPrompt prompt = state.pendingPrompts.get(userId);
        if (prompt != null) {
            b.setOpenPrompt(prompt);
        }

        ActionResult result = state.pendingResults.get(userId);
        if (result != null) {
            b.setYourResults(result);
        }

        if (state.lastAnnouncement != null) {
            b.setAnnouncement(state.lastAnnouncement);
        }

        if (state.phase == Phase.GAME_END && state.winningTeam != null) {
            b.setWinningTeam(state.winningTeam);
        }

        if (state.phaseEndsAt != null) {
            b.setPhaseEndsAt(Timestamp.newBuilder()
                    .setSeconds(state.phaseEndsAt.getEpochSecond())
                    .setNanos(state.phaseEndsAt.getNano())
                    .build());
        }

        // the saboteur's victim sits out this day (set going into the day phases,
        // cleared once the day vote resolves); tells their client to show the
        // "you are sabotaged" screen instead of the discussion/vote UI
        b.setYouAreSabotaged(userId.equals(state.sabotagedPlayerId));

        // privately tell each lover who their partner is (only in their own
        // snapshot, so nobody else learns the pairing)
        if (userId.equals(state.loverA)) {
            b.setLoverPartnerId(state.loverB);
        } else if (userId.equals(state.loverB)) {
            b.setLoverPartnerId(state.loverA);
        }

        // the just-killed hunter still owes a revenge shot: their client stays on
        // the revenge screen instead of latching the death screen
        b.setYouMustTakeRevenge(userId.equals(state.pendingHunterId));

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
                .setIsHost(p.id.equals(hostId))
                .setAvatar(p.avatar == null ? "" : p.avatar);
        // a player's role is revealed to everyone once they are dead
        if (!p.alive && p.role != null) {
            b.setRole(p.role);
        }
        return b.build();
    }

    // Adds the lobby's players to the update with the live vote tally attached:
    //  - NIGHT_WEREWOLVES: each wolf's committed target, visible only to wolves
    //  - DAY_VOTING: each player's committed vote, visible to everyone (the day
    //    vote is public); an empty votedForTargetId means the player abstained
    // For everyone else the vote fields stay masked.
    private static void addPlayers(GameUpdate.Builder b, GameState state, Lobby lobby, String recipientId) {
        boolean showWolfVotes = state.phase == Phase.NIGHT_WEREWOLVES && isWerewolf(state, recipientId);
        boolean showDayVotes = state.phase == Phase.DAY_VOTING;
        lobby.players.forEach(lp -> {
            // playerStatus already reveals the role of dead players
            PlayerStatus.Builder ps = playerStatus(lp, lobby.hostId).toBuilder();
            if (showWolfVotes && lp.role == Role.WEREWOLF
                    && state.werewolfVotes.containsKey(lp.id)) {
                ps.setHasVoted(true).setVotedForTargetId(state.werewolfVotes.get(lp.id));
            } else if (showDayVotes && state.votes.containsKey(lp.id)) {
                ps.setHasVoted(true).setVotedForTargetId(state.votes.get(lp.id));
            }
            b.addPlayers(ps.build());
        });
    }

    // The live werewolf tally pushed to each wolf on every committed vote. This is
    // just the personalised snapshot, which already carries the vote annotations.
    public static GameUpdate werewolfVoteUpdate(GameState state, Lobby lobby, String recipientId) {
        return snapshot(state, lobby, recipientId);
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
