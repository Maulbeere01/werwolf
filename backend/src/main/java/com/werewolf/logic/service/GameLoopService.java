package com.werewolf.logic.service;

import com.werewolf.grpc.*;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.model.Lobby;

import java.util.List;
import jakarta.annotation.PreDestroy;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.concurrent.*;

@Slf4j
@Service
@RequiredArgsConstructor
public class GameLoopService {

    private final GameStateService gameStateService;
    private final LobbyManager lobbyManager;
    private final LobbySubscriptionService lobbySubscriptionService;

    private final ScheduledExecutorService scheduler =
            Executors.newScheduledThreadPool(Runtime.getRuntime().availableProcessors());

    private final ConcurrentHashMap<String, ScheduledFuture<?>> activeLoops =
            new ConcurrentHashMap<>();

    // can be skipped conditionally later (e.g. omit NIGHT_FOX if no fox is in the game, skip HUNTER_REVENGE if the hunter
    // is still alive). Add skip logic in nextPhase() when game conditions require it.
    static final List<Phase> PHASE_SEQUENCE = List.of(
            Phase.NIGHT_START,
            Phase.NIGHT_WEREWOLVES,
            Phase.NIGHT_SEER,
            Phase.NIGHT_WITCH,
            Phase.NIGHT_FOX,
            Phase.DAY_RESULT,
            Phase.DAY_DISCUSSION,
            Phase.DAY_VOTING,
            Phase.HUNTER_REVENGE,
            Phase.GAME_END
    );

    public void start(String lobbyCode) {
        // 10 second interval is a placeholder for testing. Replace with per-phase timers
        // once ability handlers signal completion via stop() + immediate re-advance.
        ScheduledFuture<?> future = scheduler.scheduleAtFixedRate(
                () -> tick(lobbyCode), 10, 10, TimeUnit.SECONDS);
        activeLoops.put(lobbyCode, future);
        log.info("[LOOP] Started phase loop for lobby {}", lobbyCode);
    }

    public Phase nextPhase(Phase current) {
        int idx = PHASE_SEQUENCE.indexOf(current);
        if (idx < 0 || idx >= PHASE_SEQUENCE.size() - 1) return Phase.GAME_END;
        return PHASE_SEQUENCE.get(idx + 1);
    }

    public void stop(String lobbyCode) {
        ScheduledFuture<?> future = activeLoops.remove(lobbyCode);
        if (future != null) {
            future.cancel(false);
            log.info("[LOOP] Stopped phase loop for lobby {}", lobbyCode);
        }
    }

    private void tick(String lobbyCode) {
        try {
            GameState state = gameStateService.get(lobbyCode);
            if (state == null || state.phase == Phase.GAME_END) {
                stop(lobbyCode);
                return;
            }

            state.phase = nextPhase(state.phase);
            gameStateService.save(state);

            Lobby lobby = lobbyManager.getLobby(lobbyCode);
            if (lobby != null) {
                lobbySubscriptionService.broadcast(lobbyCode, GameUpdateFactory.forPhase(state, lobby));
                onEnter(state, lobby);
            }

            log.info("[LOOP] Lobby {} advanced to phase {}", lobbyCode, state.phase);

            if (state.phase == Phase.GAME_END) {
                stop(lobbyCode);
            }
        } catch (Exception e) {
            log.error("[LOOP] Error in tick for lobby {}: {}", lobbyCode, e.getMessage());
            stop(lobbyCode);
        }
    }

    // called immediately after every phase transition. add phase setup logic here:
    //  reveal who was killed to the village at DAY_RESULT, announce vote results at
    // DAY_VOTING end, etc. Each case sends private info to the relevant role via sendTo()
    private void onEnter(GameState state, Lobby lobby) {
        switch (state.phase) {
            case NIGHT_WEREWOLVES -> notifyByRole(state, lobby, Role.WEREWOLF,
                    ActionPrompt.newBuilder().setWerewolf(WerewolfPrompt.newBuilder().build()).build());
            case NIGHT_SEER -> notifyByRole(state, lobby, Role.SEER,
                    ActionPrompt.newBuilder().setSeer(SeerPrompt.newBuilder().build()).build());
            case NIGHT_WITCH -> notifyByRole(state, lobby, Role.WITCH,
                    ActionPrompt.newBuilder().setWitch(WitchPrompt.newBuilder().build()).build());
            case NIGHT_FOX -> notifyByRole(state, lobby, Role.FOX,
                    ActionPrompt.newBuilder().setFox(FoxPrompt.newBuilder().build()).build());
            case HUNTER_REVENGE -> notifyByRole(state, lobby, Role.HUNTER,
                    ActionPrompt.newBuilder().setHunter(HunterPrompt.newBuilder().build()).build());
            default -> {}
        }
    }

    private void notifyByRole(GameState state, Lobby lobby, Role role, ActionPrompt prompt) {
        state.players.values().stream()
                .filter(p -> p.role == role && p.alive)
                .forEach(p -> lobbySubscriptionService.sendTo(lobby.lobbyCode, p.id,
                        GameUpdateFactory.privatePrompt(state.phase, prompt)));
    }

    @PreDestroy
    public void shutdown() {
        scheduler.shutdownNow();
    }
}
