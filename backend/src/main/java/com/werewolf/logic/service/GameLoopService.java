package com.werewolf.logic.service;

import com.werewolf.grpc.*;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.model.Lobby;

import java.time.Instant;
import java.util.List;
import java.util.Map;
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

    // placeholder durations (seconds)
    static final Map<Phase, Long> PHASE_DURATIONS = Map.ofEntries(
            Map.entry(Phase.NIGHT_START,      10L),
            Map.entry(Phase.NIGHT_WEREWOLVES, 10L),
            Map.entry(Phase.NIGHT_SEER,       10L),
            Map.entry(Phase.NIGHT_WITCH,      10L),
            Map.entry(Phase.NIGHT_FOX,        10L),
            Map.entry(Phase.DAY_RESULT,       10L),
            Map.entry(Phase.DAY_DISCUSSION,   10L),
            Map.entry(Phase.DAY_VOTING,       10L),
            Map.entry(Phase.HUNTER_REVENGE,   10L)
    );

    private static long durationOf(Phase phase) {
        return PHASE_DURATIONS.getOrDefault(phase, 10L);
    }

    /**
     * Startet den Spiel-Loop für eine Lobby.
     * Initialisiert den GameState (falls nötig) und setzt die erste Phase sowie Timer.
     */
    public void start(String lobbyCode) {
        GameState state = gameStateService.get(lobbyCode);
        if (state == null) {
            state = new GameState();
            state.lobbyCode = lobbyCode;
            state.phase = Phase.NIGHT_START;
        }
        gameStateService.save(lobbyCode, state);

        if (state != null) {
            state.phaseEndsAt = Instant.now().plusSeconds(durationOf(state.phase));
            gameStateService.save(lobbyCode, state);
        }
        long firstDelay = state != null ? durationOf(state.phase) : 10L;
        ScheduledFuture<?> future = scheduler.schedule(() -> tickLoop(lobbyCode), firstDelay, TimeUnit.SECONDS);
        activeLoops.put(lobbyCode, future);
        log.info("[LOOP] Started phase loop for lobby {}", lobbyCode);
    }

    /**
     * Berechnet die nächste Phase im festgelegten Phasenablauf.
     */
    public Phase nextPhase(Phase current) {
        int idx = PHASE_SEQUENCE.indexOf(current);
        if (idx < 0 || idx >= PHASE_SEQUENCE.size() - 1) return Phase.GAME_END;
        return PHASE_SEQUENCE.get(idx + 1);
    }

    /**
     * Stoppt den laufenden Game-Loop einer Lobby und beendet alle geplanten Tasks.
     */
    public void stop(String lobbyCode) {
        ScheduledFuture<?> future = activeLoops.remove(lobbyCode);
        if (future != null) {
            future.cancel(false);
            log.info("[LOOP] Stopped phase loop for lobby {}", lobbyCode);
        }
    }

    /**
     * Haupt-Tick des Spiels.
     * Wird zyklisch aufgerufen und wechselt die Phase, aktualisiert den GameState
     * und sendet Updates an alle Spieler.
     */
    private void tickLoop(String lobbyCode) {
        try {
            GameState state = gameStateService.get(lobbyCode);
            if (state == null || state.phase == Phase.GAME_END) {
                stop(lobbyCode);
                return;
            }

            state.pendingPrompts.clear();
            state.lastAnnouncement = null;
            state.phase = nextPhase(state.phase);

            if (state.phase == Phase.GAME_END) {
                state.phaseEndsAt = null;
            } else {
                long duration = durationOf(state.phase);
                state.phaseEndsAt = Instant.now().plusSeconds(duration);
                ScheduledFuture<?> next = scheduler.schedule(() -> tickLoop(lobbyCode), duration, TimeUnit.SECONDS);
                activeLoops.put(lobbyCode, next);
            }

            Lobby lobby = lobbyManager.getLobby(lobbyCode);
            if (lobby != null) {
                onEnter(state, lobby);
                gameStateService.save(lobbyCode, state);
                lobby.players.forEach(p ->
                        lobbySubscriptionService.sendTo(lobbyCode, p.id,
                                GameUpdateFactory.snapshot(state, lobby, p.id)));
            } else {
                gameStateService.save(lobbyCode, state);
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

    /**
     * Wird direkt nach einem Phasenwechsel aufgerufen.
     * Führt phasespezifische Initialisierungen und Benachrichtigungen durch.
     */
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

    /**
     * Sendet eine private Prompt-Nachricht an alle Spieler einer bestimmten Rolle.
     * Wird verwendet, um Rollen-spezifische Aktionen zu starten.
     */
    private void notifyByRole(GameState state, Lobby lobby, Role role, ActionPrompt prompt) {
        state.players.values().stream()
                .filter(p -> p.role == role && p.alive)
                .forEach(p -> {
                    state.pendingPrompts.put(p.id, prompt);
                    lobbySubscriptionService.sendTo(lobby.lobbyCode, p.id,
                            GameUpdateFactory.privatePrompt(state.phase, prompt));
                });
    }

    /**
     * Beendet den Scheduler sauber beim Herunterfahren der Anwendung.
     */
    @PreDestroy
    public void shutdown() {
        scheduler.shutdownNow();
    }
}
