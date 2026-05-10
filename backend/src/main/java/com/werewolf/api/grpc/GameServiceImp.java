package com.werewolf.api.grpc;

import com.werewolf.grpc.CreateLobbyRequest;
import com.werewolf.grpc.GameServiceGrpc;
import com.werewolf.grpc.LobbyInfo;
import com.werewolf.logic.model.Lobby;
import com.werewolf.logic.service.LobbyManager;
import io.grpc.stub.StreamObserver;



public class GameServiceImp extends GameServiceGrpc.GameServiceImplBase{

    private final LobbyManager lobbyManager;

    public GameServiceImp(LobbyManager lobbyManager) {
        this.lobbyManager = lobbyManager;
    }

    @Override
    public void createLobby(CreateLobbyRequest request,
                            StreamObserver<LobbyInfo> responseObserver) {

        Lobby lobby = lobbyManager.createLobby(
                "host-id", // später aus token
                "host-name",
                request.getSettings()
        );

        LobbyInfo response = LobbyInfo.newBuilder()
                .setLobbyCode(lobby.lobbyCode)
                .setHostId(lobby.hostId)
                .setCanStart(false)
                .setSettings(lobby.settings)
                .build();

        responseObserver.onNext(response);
        responseObserver.onCompleted();
    }
}