package com.werewolf.api.grpc;

import com.werewolf.grpc.CreateLobbyRequest;
import com.werewolf.grpc.LobbyInfo;
import com.werewolf.grpc.LobbySettings;
import com.werewolf.logic.model.Lobby;
import com.werewolf.logic.engine.AbilityExecutor;
import com.werewolf.logic.service.GameLoopService;
import com.werewolf.logic.service.GameStateService;
import com.werewolf.logic.service.LobbyManager;
import com.werewolf.logic.service.LobbySubscriptionService;
import io.grpc.stub.StreamObserver;
import org.junit.jupiter.api.Test;

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
}