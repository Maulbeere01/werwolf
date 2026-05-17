package com.werewolf.api.grpc;

import com.werewolf.auth.AuthContext;
import com.werewolf.grpc.CreateLobbyRequest;
import com.werewolf.grpc.GameServiceGrpc;
import com.werewolf.grpc.LobbyInfo;
import com.werewolf.logic.model.Lobby;
import com.werewolf.logic.service.LobbyManager;
import io.grpc.stub.StreamObserver;
import lombok.RequiredArgsConstructor;
import net.devh.boot.grpc.server.service.GrpcService;

@GrpcService
@RequiredArgsConstructor
public class GameServiceImp extends GameServiceGrpc.GameServiceImplBase {

    private final LobbyManager lobbyManager;

    @Override
    public void createLobby(CreateLobbyRequest request,
                            StreamObserver<LobbyInfo> responseObserver) {

        String hostId = AuthContext.USER_ID_KEY.get();
        String hostName = AuthContext.USERNAME_KEY.get();

        Lobby lobby = lobbyManager.createLobby(
                hostId,
                hostName,
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