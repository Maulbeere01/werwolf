package com.werewolf.api.grpc;

import com.google.protobuf.Empty;
import com.werewolf.auth.AuthContext;
import com.werewolf.grpc.*;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.model.Lobby;
import com.werewolf.logic.model.Player;
import com.werewolf.logic.service.GameStateService;
import com.werewolf.logic.service.LobbyManager;
import com.werewolf.logic.service.LobbySubscriptionService;
import io.grpc.Status;
import io.grpc.stub.ServerCallStreamObserver;
import io.grpc.stub.StreamObserver;
import lombok.RequiredArgsConstructor;
import net.devh.boot.grpc.server.service.GrpcService;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@GrpcService
@RequiredArgsConstructor
public class GameServiceImp extends GameServiceGrpc.GameServiceImplBase {

    private final LobbyManager lobbyManager;
    private final LobbySubscriptionService lobbySubscriptionService;
    private final GameStateService gameStateService;

    @Override
    public void createLobby(CreateLobbyRequest request,
                            StreamObserver<LobbyInfo> responseObserver) {

        String hostId = AuthContext.USER_ID_KEY.get();
        String hostName = AuthContext.USERNAME_KEY.get();

        Lobby lobby = lobbyManager.createLobby(hostId, hostName, request.getSettings());

        responseObserver.onNext(toLobbyInfo(lobby));
        responseObserver.onCompleted();
    }

    @Override
    public void joinLobby(JoinRequest request,
                          StreamObserver<LobbyInfo> responseObserver) {

        String userId = AuthContext.USER_ID_KEY.get();
        String username = AuthContext.USERNAME_KEY.get();

        try {
            Lobby lobby = lobbyManager.joinLobby(userId, username, request.getLobbyCode());
            lobbySubscriptionService.broadcast(request.getLobbyCode(), toGameUpdate(lobby));
            responseObserver.onNext(toLobbyInfo(lobby));
            responseObserver.onCompleted();
        } catch (IllegalArgumentException e) {
            responseObserver.onError(Status.NOT_FOUND
                    .withDescription(e.getMessage())
                    .asRuntimeException());
        }
    }

    @Override
    public void startGame(StartGameRequest request, StreamObserver<Empty> responseObserver) {
        String userId = AuthContext.USER_ID_KEY.get();
        String lobbyCode = request.getLobbyCode();

        Lobby lobby = lobbyManager.getLobby(lobbyCode);
        if (lobby == null) {
            responseObserver.onError(Status.NOT_FOUND
                    .withDescription("Lobby not found: " + lobbyCode)
                    .asRuntimeException());
            return;
        }

        if (!lobby.hostId.equals(userId)) {
            responseObserver.onError(Status.PERMISSION_DENIED
                    .withDescription("Only the host can start the game")
                    .asRuntimeException());
            return;
        }

        List<Role> rolePool = buildRolePool(lobby.settings, lobby.players.size());

        GameState state = new GameState();
        state.lobbyCode = lobbyCode;
        state.phase = Phase.NIGHT_START;

        for (int i = 0; i < lobby.players.size(); i++) {
            Player p = lobby.players.get(i);
            p.role = rolePool.get(i);
            state.players.put(p.id, p);
        }

        gameStateService.save(state);
        lobby.started = true;

        lobbySubscriptionService.broadcast(lobbyCode, toGameUpdate(state, lobby));

        responseObserver.onNext(Empty.getDefaultInstance());
        responseObserver.onCompleted();
    }

    @Override
    public void subscribeToGame(SubscribeRequest request,
                                StreamObserver<GameUpdate> responseObserver) {

        String lobbyCode = request.getLobbyCode();

        if (responseObserver instanceof ServerCallStreamObserver<GameUpdate> serverObserver) {
            serverObserver.setOnCancelHandler(() ->
                    lobbySubscriptionService.unsubscribe(lobbyCode, responseObserver));
        }

        lobbySubscriptionService.subscribe(lobbyCode, responseObserver);

        Lobby lobby = lobbyManager.getLobby(lobbyCode);
        if (lobby != null) {
            responseObserver.onNext(toGameUpdate(lobby));
        }
    }

    private LobbyInfo toLobbyInfo(Lobby lobby) {
        LobbyInfo.Builder builder = LobbyInfo.newBuilder()
                .setLobbyCode(lobby.lobbyCode)
                .setHostId(lobby.hostId)
                .setCanStart(false)
                .setSettings(lobby.settings);

        for (Player p : lobby.players) {
            builder.addPlayers(toPlayerStatus(p, lobby.hostId));
        }

        return builder.build();
    }

    private GameUpdate toGameUpdate(Lobby lobby) {
        GameUpdate.Builder builder = GameUpdate.newBuilder()
                .setCurrentPhase(Phase.LOBBY);

        for (Player p : lobby.players) {
            builder.addPlayers(toPlayerStatus(p, lobby.hostId));
        }

        return builder.build();
    }

    private GameUpdate toGameUpdate(GameState state, Lobby lobby) {
        GameUpdate.Builder builder = GameUpdate.newBuilder()
                .setCurrentPhase(state.phase)
                .setDisplayText("Das Spiel beginnt. Die Nacht bricht herein.");

        for (Player p : lobby.players) {
            // role is masked in the shared broadcast; private role info is delivered per-player later
            builder.addPlayers(toPlayerStatus(p, lobby.hostId));
        }

        return builder.build();
    }

    private PlayerStatus toPlayerStatus(Player p, String hostId) {
        return PlayerStatus.newBuilder()
                .setId(p.id)
                .setName(p.name)
                .setIsAlive(p.alive)
                .setIsHost(p.id.equals(hostId))
                .build();
    }

    private List<Role> buildRolePool(LobbySettings settings, int playerCount) {
        List<Role> pool = new ArrayList<>();
        for (RoleCount rc : settings.getRolesList()) {
            for (int i = 0; i < rc.getCount(); i++) {
                pool.add(rc.getRole());
            }
        }
        while (pool.size() < playerCount) {
            pool.add(Role.VILLAGER);
        }
        if (pool.size() > playerCount) {
            pool = pool.subList(0, playerCount);
        }
        Collections.shuffle(pool);
        return pool;
    }
}