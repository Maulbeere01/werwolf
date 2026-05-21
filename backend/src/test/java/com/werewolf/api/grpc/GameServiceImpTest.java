package com.werewolf.api.grpc;

import com.werewolf.auth.AuthContext;
import com.werewolf.grpc.*;
import com.werewolf.logic.model.Lobby;
import com.werewolf.logic.model.Player;
import com.werewolf.logic.engine.AbilityExecutor;
import com.werewolf.logic.service.GameLoopService;
import com.werewolf.logic.service.GameStateService;
import com.werewolf.logic.service.LobbyManager;
import com.werewolf.logic.service.LobbySubscriptionService;
import io.grpc.Context;
import io.grpc.Status;
import io.grpc.StatusRuntimeException;
import io.grpc.stub.StreamObserver;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;

import static org.mockito.Mockito.*;

/**
 * Testet gRPC GameServiceImp.
 * Prüft ob Lobby korrekt über API erstellt wird.
 */
class GameServiceImpTest {

    @Test
    void shouldReturnLobbyInfo() {

        LobbyManager manager = mock(LobbyManager.class);
        LobbySubscriptionService subscriptionService = mock(LobbySubscriptionService.class);
        GameStateService gameStateService = mock(GameStateService.class);
        GameLoopService gameLoopService = mock(GameLoopService.class);
        AbilityExecutor abilityExecutor = mock(AbilityExecutor.class);

        Lobby lobby = new Lobby();
        lobby.lobbyCode = "ABCD";
        lobby.hostId = "host1";
        lobby.settings = LobbySettings.newBuilder().build();

        when(manager.createLobby(any(), any(), any())).thenReturn(lobby);

        GameServiceImp service = new GameServiceImp(manager, subscriptionService, gameStateService, gameLoopService, abilityExecutor);

        StreamObserver<LobbyInfo> observer = mock(StreamObserver.class);

        CreateLobbyRequest request = CreateLobbyRequest.newBuilder()
                .setSettings(LobbySettings.newBuilder().build())
                .build();

        service.createLobby(request, observer);

        // Prüft: Antwort wurde gesendet
        verify(observer, times(1)).onNext(any());
        verify(observer, times(1)).onCompleted();
    }

    private GameServiceImp buildService(LobbyManager manager, LobbySubscriptionService sub,
                                        GameStateService gss) {
        return new GameServiceImp(manager, sub, gss,
                mock(GameLoopService.class), mock(AbilityExecutor.class));
    }

    @Test
    void subscribeToGame_rejectsNonMember() {
        LobbyManager manager = mock(LobbyManager.class);
        LobbySubscriptionService sub = mock(LobbySubscriptionService.class);
        GameStateService gss = mock(GameStateService.class);

        Lobby lobby = new Lobby();
        lobby.lobbyCode = "ABCDEF";
        lobby.players = new ArrayList<>();
        when(manager.getLobby("ABCDEF")).thenReturn(lobby);

        GameServiceImp service = buildService(manager, sub, gss);
        StreamObserver<GameUpdate> observer = mock(StreamObserver.class);
        SubscribeRequest request = SubscribeRequest.newBuilder().setLobbyCode("ABCDEF").build();

        Context.current().withValue(AuthContext.USER_ID_KEY, "outsider").run(() ->
                service.subscribeToGame(request, observer));

        verify(observer, times(1)).onError(argThat(t ->
                t instanceof StatusRuntimeException &&
                ((StatusRuntimeException) t).getStatus().getCode() == Status.Code.PERMISSION_DENIED));
        verify(sub, never()).subscribe(any(), any(), any());
    }

    @Test
    void subscribeToGame_rejectsUnknownLobby() {
        LobbyManager manager = mock(LobbyManager.class);
        LobbySubscriptionService sub = mock(LobbySubscriptionService.class);
        GameStateService gss = mock(GameStateService.class);

        when(manager.getLobby("NOEXST")).thenReturn(null);

        GameServiceImp service = buildService(manager, sub, gss);
        StreamObserver<GameUpdate> observer = mock(StreamObserver.class);
        SubscribeRequest request = SubscribeRequest.newBuilder().setLobbyCode("NOEXST").build();

        Context.current().withValue(AuthContext.USER_ID_KEY, "anyone").run(() ->
                service.subscribeToGame(request, observer));

        verify(observer, times(1)).onError(argThat(t ->
                t instanceof StatusRuntimeException &&
                ((StatusRuntimeException) t).getStatus().getCode() == Status.Code.NOT_FOUND));
        verify(sub, never()).subscribe(any(), any(), any());
    }

    @Test
    void subscribeToGame_acceptsMember() {
        LobbyManager manager = mock(LobbyManager.class);
        LobbySubscriptionService sub = mock(LobbySubscriptionService.class);
        GameStateService gss = mock(GameStateService.class);

        Player member = new Player();
        member.id = "user1";
        member.name = "Anna";
        Lobby lobby = new Lobby();
        lobby.lobbyCode = "MEMBER";
        lobby.hostId = "user1";
        lobby.players = new ArrayList<>();
        lobby.players.add(member);

        when(manager.getLobby("MEMBER")).thenReturn(lobby);
        when(gss.get("MEMBER")).thenReturn(null);

        GameServiceImp service = buildService(manager, sub, gss);
        StreamObserver<GameUpdate> observer = mock(StreamObserver.class);
        SubscribeRequest request = SubscribeRequest.newBuilder().setLobbyCode("MEMBER").build();

        Context.current().withValue(AuthContext.USER_ID_KEY, "user1").run(() ->
                service.subscribeToGame(request, observer));

        verify(sub, times(1)).subscribe(eq("MEMBER"), eq("user1"), eq(observer));
        verify(observer, times(1)).onNext(any());
        verify(observer, never()).onError(any());
    }
}