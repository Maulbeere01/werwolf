package com.werewolf.api.grpc;

import com.google.protobuf.Empty;
import com.werewolf.auth.AuthContext;
import com.werewolf.grpc.*;
import com.werewolf.logic.engine.AbilityExecutor;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.model.Lobby;
import com.werewolf.logic.model.Player;
import com.werewolf.logic.service.GameLoopService;
import com.werewolf.logic.service.GameStateService;
import com.werewolf.logic.service.LobbyManager;
import com.werewolf.logic.service.LobbySubscriptionService;
import io.grpc.Context;
import io.grpc.Status;
import io.grpc.StatusRuntimeException;
import io.grpc.stub.StreamObserver;



public class GameServiceImp extends GameServiceGrpc.GameServiceImplBase{

    private final LobbyManager lobbyManager;
    private final LobbySubscriptionService subscriptionService;
    private final GameStateService gameStateService;
    private final GameLoopService gameLoopService;
    private final AbilityExecutor abilityExecutor;

    public GameServiceImp(LobbyManager lobbyManager, LobbySubscriptionService subscriptionService,
                          GameStateService gameStateService,
                          GameLoopService gameLoopService,
                          AbilityExecutor abilityExecutor) {
        this.lobbyManager = lobbyManager;
        this.subscriptionService = subscriptionService;
        this.gameStateService = gameStateService;
        this.gameLoopService = gameLoopService;
        this.abilityExecutor = abilityExecutor;
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

    public void subscribeToGame(SubscribeRequest request, StreamObserver<GameUpdate> observer) {

        String userId = AuthContext.USER_ID_KEY.get(Context.current());

        Lobby lobby = lobbyManager.getLobby(request.getLobbyCode());

        if (lobby == null) {
            observer.onError(Status.NOT_FOUND
                    .withDescription("Lobby not found")
                    .asRuntimeException());
            return;
        }

        boolean isMember = lobby.players.stream()
                .anyMatch(p -> p.id.equals(userId));

        if (!isMember) {
            observer.onError(Status.PERMISSION_DENIED
                    .withDescription("Not a lobby member")
                    .asRuntimeException());
            return;
        }

        subscriptionService.subscribe(
                lobby.lobbyCode,
                userId,
                observer
        );

        // optional: initial snapshot senden
        GameState state = gameStateService.get(lobby.lobbyCode);

        if (state != null) {
            GameUpdate update = GameUpdate.newBuilder()
                    .setCurrentPhase(state.phase)
                    .build();

            observer.onNext(update);
        }
    }

    @Override
    public void startGame(StartGameRequest request,
                          StreamObserver<Empty> responseObserver) {
        Lobby lobby = lobbyManager.getLobby(request.getLobbyCode());
        if (lobby == null) {
            throw new StatusRuntimeException(Status.NOT_FOUND);
        }

        lobby.started = true;

        // 1. GameState erstellen
        GameState state = new GameState();
        state.lobbyCode = lobby.lobbyCode;
        state.phase = Phase.NIGHT_START;

        // OPTIONAL: initial setup (roles, alive players etc.)
        lobby.players.forEach(p -> {
            Player gp = new Player();
            gp.id = p.id;
            gp.name = p.name;
            gp.alive = true;

            state.players.put(p.id, gp);
        });

        // 2. speichern
        gameStateService.save(lobby.lobbyCode, state);

        // 3. GameLoop starten
        gameLoopService.start(lobby.lobbyCode);

        // 4. response
        responseObserver.onNext(Empty.getDefaultInstance());
        responseObserver.onCompleted();
    }
}