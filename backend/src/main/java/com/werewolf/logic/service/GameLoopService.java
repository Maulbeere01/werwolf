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

    // can be skipped conditionally later (e.g. omit NIGHT_FOX if no fox is in the game, skip HUNTER_REVENGE if
    // the hunter is still alive).
    // Add skip logic in nextPhase() when game conditions require it.
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
            Map.entry(Phase.DAY_DISCUSSION,   10L),   // increase timer to 30 seconds
            Map.entry(Phase.DAY_VOTING,       10L),   // increase timer ?
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

            // Clear the per-phase transient data before resolving the ending phase,
            // so any announcement produced while resolving (e.g. the day vote result)
            // is still present when the personalised snapshot is sent below.
            state.pendingPrompts.clear();
            state.lastAnnouncement = null;

            // resolve the phase that is ending before moving on (may set lastAnnouncement)
            onExit(state, state.phase);

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

            // morning: apply the deaths gathered during the night and reveal them
            case DAY_RESULT -> resolveNightDeaths(state);

            // DAY_VOTING only opens the vote here; the result is tallied in
            // onExit(DAY_VOTING) once the phase ends (timer or all players voted).

            default -> {
            }
        }
    }

    // called just before a phase ends, to turn the votes/choices gathered during
    // that phase into game state for the following phases.
    private void onExit(GameState state, Phase leaving) {
        switch (leaving) {
            case NIGHT_WEREWOLVES -> resolveWerewolfAttack(state);
            case DAY_VOTING -> resolveDayVote(state);
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

    // Tally the day votes once DAY_VOTING ends and turn them into a lynch result.
    // The most-voted living player is eliminated; a tie (or too few votes) means
    // nobody dies. The result is stored in lastAnnouncement and delivered to every
    // player through the snapshot that follows this phase transition.
    private void resolveDayVote(GameState state) {
        long alivePlayers = state.players.values().stream()
                .filter(p -> p.alive).count();

        // at least half of the living players must have cast a vote for a lynch
        boolean halfOfPlayersVoted = state.votes.size() * 2L >= alivePlayers;

        PublicAnnouncement announcement;
        if (state.votes.isEmpty() || !halfOfPlayersVoted) {
            // not enough participation => nobody is lynched
            announcement = PublicAnnouncement.newBuilder()
                    .setVoteResult(VoteResultEvent.newBuilder().setTied(true).build())
                    .build();
        } else {
            Map<String, Long> tally = state.votes.values().stream()
                    .collect(java.util.stream.Collectors.groupingBy(
                            id -> id, java.util.stream.Collectors.counting()));
            long maxVotes = tally.values().stream().max(Long::compareTo).orElse(0L);
            List<String> topTargets = tally.entrySet().stream()
                    .filter(e -> e.getValue() == maxVotes)
                    .map(Map.Entry::getKey)
                    .toList();

            if (topTargets.size() != 1) { // a tie => nobody dies
                announcement = PublicAnnouncement.newBuilder()
                        .setVoteResult(VoteResultEvent.newBuilder().setTied(true).build())
                        .build();
            } else { // the single most-voted player is lynched
                String eliminatedId = topTargets.get(0);
                Player p = state.players.get(eliminatedId);
                if (p != null) p.alive = false;
                if (!state.deadPlayers.contains(eliminatedId)) {
                    state.deadPlayers.add(eliminatedId);
                }
                announcement = PublicAnnouncement.newBuilder()
                        .setVoteResult(VoteResultEvent.newBuilder()
                                .setEliminatedPlayerId(eliminatedId)
                                .setTied(false)
                                .build())
                        .build();
            }
        }

        state.votes.clear();
        state.lastAnnouncement = announcement;
    }

    // Morning resolution: apply every death that piled up during the night
    // (werewolf victim, witch poison; the witch's heal already removed the saved
    // player) and announce it. As with the day vote, the announcement rides along
    // on the snapshot sent right after this phase transition.
    private void resolveNightDeaths(GameState state) {
        List<String> killedThisNight = new ArrayList<>();
        for (String id : state.deadPlayers) {
            Player p = state.players.get(id);
            if (p != null && p.alive) {
                p.alive = false;
                killedThisNight.add(id);
            }
        }
        state.deadPlayers.clear();

        PublicAnnouncement announcement;
        if (killedThisNight.isEmpty()) {
            announcement = PublicAnnouncement.newBuilder()
                    .setNoDeath(NoDeathEvent.newBuilder().build())
                    .build();
        } else {
            announcement = PublicAnnouncement.newBuilder()
                    .setNightDeath(NightDeathEvent.newBuilder()
                            .setPlayerId(killedThisNight.get(0))
                            .setCause(EliminationCause.KILLED_BY_WEREWOLVES)
                            .build())
                    .build();
        }
        state.lastAnnouncement = announcement;
    }


    public void advanceNow(String lobbyCode) {  // Abbruch-Methode, wenn alle Spieler gevoted haben
        ScheduledFuture<?> current = activeLoops.get(lobbyCode);
        if (current != null) current.cancel(false);
        scheduler.execute(() -> tickLoop(lobbyCode));
    }


    @PreDestroy
    public void shutdown() {
        scheduler.shutdownNow();
    }
}
