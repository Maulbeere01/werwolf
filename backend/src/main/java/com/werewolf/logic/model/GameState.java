package com.werewolf.logic.model;

import com.werewolf.grpc.Phase;
import com.werewolf.grpc.Role;
import java.util.*;

/**
 * Repräsentiert den aktuellen Zustand eines Spiels.
 * Enthält Spieler, Status (lebendig/tot) und Spielinformationen.
 */
public class GameState {

    public Map<String, Player> players = new HashMap<>();
    public String lobbyCode;
    public Phase phase = Phase.LOBBY;
    // Player IDs marked for death during the current night. Witch can still remove entries
    // here before DAY_RESULT. At DAY_RESULT, process this list to set player.alive = false
    // and clear it for the next round
    public List<String> deadPlayers = new ArrayList<>();
}