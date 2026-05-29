package com.werewolf.logic.service;

import com.werewolf.grpc.GameUpdate;
import io.grpc.stub.StreamObserver;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
/**
//  manages all active gRPC streaming connections
*/
@Slf4j
@Service
public class LobbySubscriptionService {

    // lobbyCode → userId → observer
    private final ConcurrentHashMap<String, ConcurrentHashMap<String, StreamObserver<GameUpdate>>> subscribers =
            new ConcurrentHashMap<>();

    public void subscribe(String lobbyCode, String userId, StreamObserver<GameUpdate> observer) {
        subscribers.computeIfAbsent(lobbyCode, k -> new ConcurrentHashMap<>()).put(userId, observer);
        log.info("[STREAM] {} subscribed to lobby {}", userId, lobbyCode);
    }

    public void unsubscribe(String lobbyCode, String userId, StreamObserver<GameUpdate> observer) {
        ConcurrentHashMap<String, StreamObserver<GameUpdate>> lobby = subscribers.get(lobbyCode);
        if (lobby != null && lobby.remove(userId, observer)) {
            log.info("[STREAM] {} unsubscribed from lobby {}", userId, lobbyCode);
        }
    }

    // Use broadcast() for public state changes visible to all players
    public void broadcast(String lobbyCode, GameUpdate update) {
        Map<String, StreamObserver<GameUpdate>> lobby = subscribers.get(lobbyCode);
        if (lobby == null || lobby.isEmpty()) return;
        log.info("[STREAM] Broadcasting to {} subscriber(s) in lobby {}", lobby.size(), lobbyCode);
        for (StreamObserver<GameUpdate> observer : lobby.values()) {
            send(observer, update, lobbyCode);
        }
    }

    // Use sendTo() for role-specific private info (seer results, werewolf teammate list,
    // witch prompts). Use broadcast() for public state changes visible to all players.
    public void sendTo(String lobbyCode, String userId, GameUpdate update) {
        Map<String, StreamObserver<GameUpdate>> lobby = subscribers.get(lobbyCode);
        if (lobby == null) return;
        StreamObserver<GameUpdate> observer = lobby.get(userId);
        if (observer == null) {
            log.warn("[STREAM] No subscriber found for user {} in lobby {}", userId, lobbyCode);
            return;
        }
        log.info("[STREAM] Sending private update to {} in lobby {}", userId, lobbyCode);
        send(observer, update, lobbyCode);
    }

    private void send(StreamObserver<GameUpdate> observer, GameUpdate update, String lobbyCode) {
        try {
            // gRPC StreamObservers are not thread-safe; synchronize per observer
            // since broadcast() and sendTo() can be called from the scheduler thread
            synchronized (observer) {
                observer.onNext(update);
            }
        } catch (Exception e) {
            log.warn("[STREAM] Failed to send update in lobby {}: {}", lobbyCode, e.getMessage());
        }
    }
}
