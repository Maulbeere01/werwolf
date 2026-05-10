package com.werewolf.logic.model;

import com.werewolf.grpc.Role;
import java.util.*;

/**
 * Repräsentiert den aktuellen Zustand eines Spiels.
 * Enthält Spieler, Status (lebendig/tot) und Spielinformationen.
 */
public class GameState {

    public Map<String, Player> players = new HashMap<>();
    public String lobbyCode;

    public List<String> deadPlayers = new ArrayList<>();

}