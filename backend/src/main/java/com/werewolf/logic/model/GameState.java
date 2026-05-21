package com.werewolf.logic.model;

import com.werewolf.grpc.ActionPrompt;
import com.werewolf.grpc.Phase;
import com.werewolf.grpc.PublicAnnouncement;
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

    // The last public announcement broadcast this phase; cleared on each phase transition
    public PublicAnnouncement lastAnnouncement;
}