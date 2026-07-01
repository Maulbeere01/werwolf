package com.werewolf.logic.model;

import com.werewolf.grpc.Role;

/**
 * Repräsentiert einen Spieler im Werwolfspiel.
 * Enthält ID, Name, Rolle und Status (lebendig oder tot).
 */
public class Player {
    public String id;
    public String name;
    public Role role;
    public boolean alive = true;
    // filename of the player's chosen profile picture; looked up once when they
    // join the lobby, null if they never set one (see LobbyManager)
    public String avatar;
}