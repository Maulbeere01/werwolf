package com.werewolf.logic.service;

import com.werewolf.grpc.GameUpdate;
import io.grpc.stub.StreamObserver;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;

@Slf4j
@Service
public class LobbySubscriptionService {

    private final ConcurrentHashMap<String, List<StreamObserver<GameUpdate>>> subscribers =
            new ConcurrentHashMap<>();

    public void subscribe(String lobbyCode, StreamObserver<GameUpdate> observer) {
        subscribers.computeIfAbsent(lobbyCode, k -> new CopyOnWriteArrayList<>()).add(observer);
        log.info("[STREAM] Client subscribed to lobby {}", lobbyCode);
    }

    public void unsubscribe(String lobbyCode, StreamObserver<GameUpdate> observer) {
        List<StreamObserver<GameUpdate>> list = subscribers.get(lobbyCode);
        if (list != null) list.remove(observer);
        log.info("[STREAM] Client unsubscribed from lobby {}", lobbyCode);
    }

    public void broadcast(String lobbyCode, GameUpdate update) {
        List<StreamObserver<GameUpdate>> list = subscribers.get(lobbyCode);
        if (list == null || list.isEmpty()) return;
        log.info("[STREAM] Broadcasting to {} subscriber(s) in lobby {}", list.size(), lobbyCode);
        for (StreamObserver<GameUpdate> observer : list) {
            try {
                synchronized (observer) {
                    observer.onNext(update);
                }
            } catch (Exception e) {
                log.warn("[STREAM] Failed to send update to subscriber in lobby {}: {}", lobbyCode, e.getMessage());
            }
        }
    }
}
