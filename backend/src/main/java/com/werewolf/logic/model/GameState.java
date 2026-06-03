package com.werewolf.logic.model;

import com.werewolf.grpc.ActionPrompt;
import com.werewolf.grpc.ActionResult;
import com.werewolf.grpc.Phase;
import com.werewolf.grpc.PublicAnnouncement;
import com.werewolf.grpc.Role;
import java.time.Instant;
import java.util.*;

public class GameState {

    public Map<String, Player> players = new HashMap<>();
    public String lobbyCode;
    public Phase phase = Phase.LOBBY;
    // Player IDs marked for death during the current night. Witch can still remove entries
    // here before DAY_RESULT. At DAY_RESULT, process this list to set player.alive = false
    // and clear it for the next round
    public List<String> deadPlayers = new ArrayList<>();

    // When the current phase is scheduled to end (set on every phase transition)
    public Instant phaseEndsAt;

    // Per player action prompt for the current phase; cleared on each phase transition
    public Map<String, ActionPrompt> pendingPrompts = new HashMap<>();

    // Per player private result for the current phase (e.g. the seer's reveal);
    // delivered via the snapshot and cleared on each phase transition
    public Map<String, ActionResult> pendingResults = new HashMap<>();

    // The last public announcement broadcast this phase; cleared on each phase transition
    public PublicAnnouncement lastAnnouncement;

    // The player the werewolves attacked this night; the witch may heal this id
    public String attackedThisNight;

    // Committed werewolf night votes for NIGHT_WEREWOLVES: voterId -> targetId.
    // A vote is final once placed (commit) and is resolved into attackedThisNight
    // when the phase ends. Cleared when the phase starts.
    public Map<String, String> werewolfVotes = new HashMap<>();

    //safe votings from DAY_VOTING
    public Map<String, String> votes = new HashMap<>();

    // The team that has met its win condition once the game reaches GAME_END
    // (WEREWOLF or VILLAGER); null while the game is still running.
    public Role winningTeam;
}