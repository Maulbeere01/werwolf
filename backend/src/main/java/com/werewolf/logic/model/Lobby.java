package com.werewolf.logic.model;

import com.werewolf.grpc.LobbySettings;

import java.util.ArrayList;
import java.util.List;

public class Lobby {

    public String lobbyCode;
    public String hostId;

    public List<Player> players = new ArrayList<>();

    public LobbySettings settings;

    public boolean started = false;
}