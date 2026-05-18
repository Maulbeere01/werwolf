package com.werewolf.logic.service;

import com.werewolf.grpc.GameUpdate;
import com.werewolf.grpc.Phase;
import com.werewolf.grpc.PlayerStatus;
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

    public static GameUpdate forPhase(GameState state, Lobby lobby) {
        return forPhase(state, lobby, null);
    }

    public static GameUpdate forPhase(GameState state, Lobby lobby, String displayText) {
        GameUpdate.Builder b = GameUpdate.newBuilder().setCurrentPhase(state.phase);
        if (displayText != null && !displayText.isEmpty()) b.setDisplayText(displayText);
        lobby.players.forEach(p -> b.addPlayers(playerStatus(p, lobby.hostId)));
        return b.build();
    }

    // Role specific action prompt => tells the client to render the ability UI
    public static GameUpdate privatePrompt(Phase phase, String message) {
        return GameUpdate.newBuilder()
                .setCurrentPhase(phase)
                .setPrivateInfo(message)
                .setAbilityActive(true)
                .build();
    }

    // Private information delivered to one player
    public static GameUpdate privateInfo(Phase phase, String message) {
        return GameUpdate.newBuilder()
                .setCurrentPhase(phase)
                .setPrivateInfo(message)
                .build();
    }

    private static PlayerStatus playerStatus(Player p, String hostId) {
        return PlayerStatus.newBuilder()
                .setId(p.id)
                .setName(p.name)
                .setIsAlive(p.alive)
                .setIsHost(p.id.equals(hostId))
                .build();
    }
}
