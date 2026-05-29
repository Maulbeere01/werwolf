package com.werewolf.api.grpc;

import com.werewolf.grpc.CreateLobbyRequest;
import com.werewolf.grpc.GameServiceGrpc;
import com.werewolf.grpc.LobbyInfo;
import com.werewolf.logic.model.Lobby;
import com.werewolf.logic.service.LobbyManager;
import io.grpc.stub.StreamObserver;

public class GameServiceImp extends GameServiceGrpc.GameServiceImplBase {

    private final LobbyManager lobbyManager;

    public GameServiceImp(LobbyManager lobbyManager) {
        // LobbyManager wird per Dependency Injection übergeben
        this.lobbyManager = lobbyManager;
    }

    @Override
    public void createLobby(CreateLobbyRequest request,
                            StreamObserver<LobbyInfo> responseObserver) {

        // Erstellt eine neue Lobby über die Business-Logik
        // TODO: hostId und hostName später aus Auth-Token holen
        Lobby lobby = lobbyManager.createLobby(
                "host-id",
                "host-name",
                request.getSettings()
        );

        // Baut die gRPC-Antwort mit den relevanten Lobby-Daten
        LobbyInfo response = LobbyInfo.newBuilder()
                .setLobbyCode(lobby.lobbyCode) // eindeutiger Lobby-Code
                .setHostId(lobby.hostId)       // ID des Hosts
                .setCanStart(false)            // Lobby kann initial noch nicht gestartet werden
                .setSettings(lobby.settings)   // Spiel-Einstellungen übernehmen
                .build();

        // Sendet die Antwort an den Client
        responseObserver.onNext(response);

        // Markiert den gRPC-Request als abgeschlossen
        responseObserver.onCompleted();
    }
}