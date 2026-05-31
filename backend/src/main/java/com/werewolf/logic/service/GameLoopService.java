package com.werewolf.logic.service;

import com.werewolf.grpc.*;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.model.Lobby;

import java.time.Instant;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ThreadLocalRandom;

import com.werewolf.logic.model.Player;
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

    // werewolves get a full minute to agree on a victim
    static final long WEREWOLF_PHASE_SECONDS = 60;

    // once all werewolves have voted, this short grace lets them see the final
    // tally and fall back asleep before the night moves on
    static final long WEREWOLF_GRACE_SECONDS = 5;

    // placeholder durations (seconds)
    static final Map<Phase, Long> PHASE_DURATIONS = Map.ofEntries(
            Map.entry(Phase.NIGHT_START,      10L),
            Map.entry(Phase.NIGHT_WEREWOLVES, WEREWOLF_PHASE_SECONDS),
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

    public void start(String lobbyCode) {
        GameState state = gameStateService.get(lobbyCode);
        if (state != null) {
            state.phaseEndsAt = Instant.now().plusSeconds(durationOf(state.phase));
            gameStateService.save(state);
        }
        long firstDelay = state != null ? durationOf(state.phase) : 10L;
        ScheduledFuture<?> future = scheduler.schedule(() -> tickLoop(lobbyCode), firstDelay, TimeUnit.SECONDS);
        activeLoops.put(lobbyCode, future);
        log.info("[LOOP] Started phase loop for lobby {}", lobbyCode);
    }

    // Advances to the next phase that is actually relevant for this game,
    // skipping role phases whose role isn't part of the game (see shouldSkip).
    public Phase nextPhase(GameState state, Phase current) {
        int idx = PHASE_SEQUENCE.indexOf(current);
        if (idx < 0) return Phase.GAME_END;
        for (int i = idx + 1; i < PHASE_SEQUENCE.size(); i++) {
            Phase candidate = PHASE_SEQUENCE.get(i);
            if (!shouldSkip(state, candidate)) return candidate;
        }
        return Phase.GAME_END;
    }

    // A role phase is skipped when no LIVING player holds that role, whether the
    // role was never in the game or its holders have since died. Because a
    // players role is revealed on death, a shorter night leaks nothing the
    // village doesn't already know
    private boolean shouldSkip(GameState state, Phase phase) {
        return switch (phase) {
            case NIGHT_WEREWOLVES -> countAlive(state, Role.WEREWOLF) == 0;
            case NIGHT_SEER -> countAlive(state, Role.SEER) == 0;
            case NIGHT_WITCH -> countAlive(state, Role.WITCH) == 0;
            case NIGHT_FOX -> countAlive(state, Role.FOX) == 0;
            // the hunter only takes revenge when a hunter is in the game AND dead;
            // a living hunter must never be prompted to shoot
            case HUNTER_REVENGE -> !roleInGame(state, Role.HUNTER) || countAlive(state, Role.HUNTER) > 0;
            default -> false;
        };
    }

    private boolean roleInGame(GameState state, Role role) {
        return state.players.values().stream().anyMatch(p -> p.role == role);
    }

    private long countAlive(GameState state, Role role) {
        return state.players.values().stream().filter(p -> p.role == role && p.alive).count();
    }

    public void stop(String lobbyCode) {
        ScheduledFuture<?> future = activeLoops.remove(lobbyCode);
        if (future != null) {
            future.cancel(false);
            log.info("[LOOP] Stopped phase loop for lobby {}", lobbyCode);
        }
    }

    // Called once all living werewolves have committed their vote. Instead of
    // ending instantly we shorten the phase to a brief grace period so the wolves
    // can see the final tally and fall back asleep. phase_ends_at is updated so
    // the clients' countdown reflects the grace, then the loop advances normally.
    public void beginWerewolfGrace(String lobbyCode) {
        GameState state = gameStateService.get(lobbyCode);
        if (state == null || state.phase != Phase.NIGHT_WEREWOLVES) return;

        ScheduledFuture<?> current = activeLoops.get(lobbyCode);
        if (current != null) current.cancel(false);

        state.phaseEndsAt = Instant.now().plusSeconds(WEREWOLF_GRACE_SECONDS);
        gameStateService.save(state);

        ScheduledFuture<?> next = scheduler.schedule(
                () -> tickLoop(lobbyCode), WEREWOLF_GRACE_SECONDS, TimeUnit.SECONDS);
        activeLoops.put(lobbyCode, next);
        log.info("[LOOP] All werewolves voted in {}, {}s grace before advancing",
                lobbyCode, WEREWOLF_GRACE_SECONDS);
    }

    private void tickLoop(String lobbyCode) {
        try {
            GameState state = gameStateService.get(lobbyCode);
            if (state == null || state.phase == Phase.GAME_END) {
                stop(lobbyCode);
                return;
            }

            // resolve the phase that is ending before moving on
            onExit(state, state.phase);

            state.pendingPrompts.clear();
            state.lastAnnouncement = null;
            state.phase = nextPhase(state, state.phase);

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
                gameStateService.save(state);
                lobby.players.forEach(p ->
                        lobbySubscriptionService.sendTo(lobbyCode, p.id,
                                GameUpdateFactory.snapshot(state, lobby, p.id)));
            } else {
                gameStateService.save(state);
            }

            log.info("[LOOP] Lobby {} advanced to phase {} ({}s)",
                    lobbyCode, state.phase,
                    state.phase == Phase.GAME_END ? 0 : durationOf(state.phase));

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
            case NIGHT_WEREWOLVES -> {
                state.werewolfVotes.clear(); // fresh tally each night
                notifyByRole(state, lobby, Role.WEREWOLF,
                        ActionPrompt.newBuilder().setWerewolf(WerewolfPrompt.newBuilder()
                                .addAllCandidateIds(aliveTargetIds(state, Role.WEREWOLF))
                                .build()).build());
            }
            case NIGHT_SEER -> notifyByRole(state, lobby, Role.SEER,
                    ActionPrompt.newBuilder().setSeer(SeerPrompt.newBuilder()
                            .addAllCandidateIds(aliveTargetIds(state, Role.SEER))
                            .build()).build());
            case NIGHT_WITCH -> {
                // the werewolves' victim is sitting in deadPlayers at this point
                state.attackedThisNight = state.deadPlayers.isEmpty() ? "" : state.deadPlayers.get(0);
                notifyByRole(state, lobby, Role.WITCH,
                        ActionPrompt.newBuilder().setWitch(WitchPrompt.newBuilder()
                                .setAttackedPlayerId(state.attackedThisNight)
                                .setHasHealPotion(true)
                                .setHasPoisonPotion(true)
                                .build()).build());
            }
            case NIGHT_FOX -> notifyByRole(state, lobby, Role.FOX,
                    ActionPrompt.newBuilder().setFox(FoxPrompt.newBuilder().build()).build());
            case HUNTER_REVENGE -> notifyByRole(state, lobby, Role.HUNTER,
                    ActionPrompt.newBuilder().setHunter(HunterPrompt.newBuilder().build()).build());

            case DAY_RESULT -> notifyAllPlayersDayResult(state, lobby);  // reveal who was killed to all players

            case DAY_VOTING -> notifyAllPlayersDayVotingResult( state, lobby); // announce vote results to all players -> noifyAll() aufrufen

            default -> {}
        }
    }

    // called just before a phase ends, to turn the votes/choices gathered during
    // that phase into game state for the following phases.
    private void onExit(GameState state, Phase leaving) {
        switch (leaving) {
            case NIGHT_WEREWOLVES -> resolveWerewolfAttack(state);
            default -> {}
        }
    }

    // Tally the committed werewolf votes and pick the night victim: the target
    // with the most votes, ties broken at random. The victim is NOT killed here;
    // it is handed to the rest of the night via attackedThisNight + deadPlayers so
    // the witch can still heal and DAY_RESULT produces the final death event.
    private void resolveWerewolfAttack(GameState state) {
        if (state.werewolfVotes.isEmpty()) return; // nobody voted => no attack

        Map<String, Integer> counts = new HashMap<>();
        for (String targetId : state.werewolfVotes.values()) {
            counts.merge(targetId, 1, Integer::sum);
        }
        int max = counts.values().stream().max(Integer::compareTo).orElse(0);
        List<String> topTargets = counts.entrySet().stream()
                .filter(e -> e.getValue() == max)
                .map(Map.Entry::getKey)
                .toList();
        String victim = topTargets.get(ThreadLocalRandom.current().nextInt(topTargets.size()));

        state.attackedThisNight = victim;
        if (!state.deadPlayers.contains(victim)) {
            state.deadPlayers.add(victim);
        }
        log.info("[LOOP] Werewolves chose victim {} ({} vote(s))", victim, max);
    }

    // living players that may be targeted by an ability, excluding the acting role itself
    private List<String> aliveTargetIds(GameState state, Role excludeRole) {
        return state.players.values().stream()
                .filter(p -> p.alive && p.role != excludeRole)
                .map(p -> p.id)
                .toList();
    }

    private void notifyByRole(GameState state, Lobby lobby, Role role, ActionPrompt prompt) {
        state.players.values().stream()
                .filter(p -> p.role == role && p.alive)
                .forEach(p -> {
                    state.pendingPrompts.put(p.id, prompt);
                    lobbySubscriptionService.sendTo(lobby.lobbyCode, p.id,
                            GameUpdateFactory.privatePrompt(state.phase, prompt));
                });
    }

    //notyfyAllPlayers() für DAY_RESULT
    private void notifyAllPlayersDayResult(GameState state, Lobby lobby){

        List<String> died = new ArrayList<>(state.deadPlayers);
        died.forEach(id -> {
            Player p = state.players.get(id);   //Klasse importiert -> soll das vermieden werden?
            if (p != null) p.alive = false;
        });
        state.deadPlayers.clear();

        PublicAnnouncement announcement;

        if (died.isEmpty()) {
            announcement = PublicAnnouncement.newBuilder()
                    .setNoDeath(NoDeathEvent.newBuilder().build())
                    .build();
        } else {
            // Für mehrere Tote: entweder nur den ersten ankündigen oder mehrere Broadcasts
            announcement = PublicAnnouncement.newBuilder()
                    .setNightDeath(NightDeathEvent.newBuilder()
                            .setPlayerId(died.get(0))
                            .setCause(EliminationCause.KILLED_BY_WEREWOLVES)
                            .build())
                    .build();
        }
        lobbySubscriptionService.broadcast(lobby.lobbyCode,
                GameUpdateFactory.announcement(Phase.DAY_RESULT,announcement));

    }

    // notifyAllPlayers() für DAY_VOTING
    private void notifyAllPlayersDayVotingResult(GameState state, Lobby lobby){
        // wird hier der Ablauf von DAY_VOTING selbst implementiert, oder nur der
        // outcome bzw. der GameState verarbeitet

        // in the end: announce the results to all players
        List<String> died = new ArrayList<>(state.deadPlayers);
        died.forEach(id -> {
            Player p = state.players.get(id);   //Klasse importiert -> soll das vermieden werden?
            if (p != null) p.alive = false;
        });

        state.deadPlayers.clear();

        PublicAnnouncement announcement = PublicAnnouncement.newBuilder()
                .setNightDeath(NightDeathEvent.newBuilder()
                        .setPlayerId(died.get(0))
                        .setCause(EliminationCause.VOTED_OUT)
                        .build())
                .build();

        lobbySubscriptionService.broadcast(lobby.lobbyCode,
                GameUpdateFactory.announcement(Phase.DAY_RESULT,announcement));

    }



    @PreDestroy
    public void shutdown() {
        scheduler.shutdownNow();
    }
}
