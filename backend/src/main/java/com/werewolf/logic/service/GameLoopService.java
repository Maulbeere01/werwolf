package com.werewolf.logic.service;

import com.werewolf.grpc.*;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.model.Lobby;

import java.time.Instant;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Deque;
import java.util.HashMap;
import java.util.LinkedHashMap;
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

    // NIGHT_START is the one-off intro. The game then loops over CYCLE
    // (night -> day -> night) until a win condition ends it (see checkWinner /
    // concludeGame); phases without a living holder are skipped (see shouldSkip).
    // HUNTER_REVENGE is NOT part of the regular cycle: it is an interrupt injected
    // by nextPhaseConsideringHunter the moment a hunter dies, after which the loop
    // resumes where it would have gone (see resumeAfterHunter).
    static final List<Phase> CYCLE = List.of(
            Phase.NIGHT_CUPID,
            Phase.NIGHT_WEREWOLVES,
            Phase.NIGHT_SEER,
            Phase.NIGHT_WITCH,
            Phase.NIGHT_FOX,
            Phase.NIGHT_SABOTEUR,
            Phase.DAY_RESULT,
            Phase.DAY_DISCUSSION,
            Phase.DAY_VOTING
    );

    // werewolves get a full minute to agree on a victim
    static final long WEREWOLF_PHASE_SECONDS = 60;

    // once all werewolves have voted, this short grace lets them see the final
    // tally and fall back asleep before the night moves on
    static final long WEREWOLF_GRACE_SECONDS = 5;

    // the whole village gets a full minute to vote someone out by day
    static final long DAY_VOTE_PHASE_SECONDS = 60;

    // the seer and the witch each get 40s to make their choice
    static final long SEER_PHASE_SECONDS = 40;
    static final long WITCH_PHASE_SECONDS = 40;
    static final long FOX_PHASE_SECONDS = 40;

    // When the hunter's revenge shot ends the game, hold the HUNTER_REVENGE reveal
    // this long before concluding to GAME_END, so the "the hunter took someone"
    // narration (~12s) plays out on the hunter screen before the win screen appears.
    static final long HUNTER_WIN_REVEAL_SECONDS = 14;

    // Phase durations (seconds). These also bound how long the narrator voice
    // lines have to play before the phase advances (frontend lib/narration): a
    // duration must be >= the lines that play when the phase BEGINS, or the line
    // gets cut off. The night action phases (40-60s) already dwarf their ~15s
    // wake-up lines; NIGHT_START and DAY_RESULT are sized to their narration.
    static final Map<Phase, Long> PHASE_DURATIONS = Map.ofEntries(
            Map.entry(Phase.NIGHT_START,      55L),
            Map.entry(Phase.NIGHT_CUPID,      40L),
            Map.entry(Phase.NIGHT_WEREWOLVES, WEREWOLF_PHASE_SECONDS),
            Map.entry(Phase.NIGHT_SEER,       SEER_PHASE_SECONDS),
            Map.entry(Phase.NIGHT_WITCH,      WITCH_PHASE_SECONDS),
            Map.entry(Phase.NIGHT_FOX,        FOX_PHASE_SECONDS),
            Map.entry(Phase.NIGHT_SABOTEUR, 40L),
            // morning "Der Tag beginnt" scene. Set to 20s the morning
            // narration (close-eyes/wake/victim/lover lines) can run longer and
            // then continues into the discussion phase.
            Map.entry(Phase.DAY_RESULT,       16L),
            Map.entry(Phase.DAY_DISCUSSION,   10L),   // "Diskutiert..." (~7s)
            Map.entry(Phase.DAY_VOTING,       DAY_VOTE_PHASE_SECONDS),
            Map.entry(Phase.HUNTER_REVENGE,   30L)
    );

    // Bounds for the lobby's configurable discussion length (see CreateLobby /
    // LobbySettings.discussion_time_seconds). The value is clamped to this range
    // at game start in GameServiceImp.
    public static final long MIN_DISCUSSION_SECONDS = 10;
    public static final long MAX_DISCUSSION_SECONDS = 120;

    // Duration of a phase. DAY_DISCUSSION is configurable per lobby (the host's
    // discussion-length setting, stored on the GameState at game start); every
    // other phase uses the fixed PHASE_DURATIONS table.
    private static long durationOf(GameState state, Phase phase) {
        if (phase == Phase.DAY_DISCUSSION && state != null && state.discussionSeconds > 0) {
            return state.discussionSeconds;
        }
        return PHASE_DURATIONS.getOrDefault(phase, 10L);
    }

    public void start(String lobbyCode) {
        GameState state = gameStateService.get(lobbyCode);
        if (state != null) {
            state.phaseEndsAt = Instant.now().plusSeconds(durationOf(state, state.phase));
            gameStateService.save(state);
        }
        long firstDelay = state != null ? durationOf(state, state.phase) : 10L;
        ScheduledFuture<?> future = scheduler.schedule(() -> tickLoop(lobbyCode), firstDelay, TimeUnit.SECONDS);
        activeLoops.put(lobbyCode, future);
        log.info("[LOOP] Started phase loop for lobby {}", lobbyCode);
    }

    // Advances to the next relevant phase within the night/day CYCLE, wrapping
    // around so the game keeps looping. NIGHT_START (intro) and anything off-cycle
    // begin a fresh night. Phases whose role has no living holder are skipped. The
    // game leaves the cycle only via a win condition (concludeGame), never here.
    public Phase nextPhase(GameState state, Phase current) {
        int idx = CYCLE.indexOf(current);
        int start = (idx < 0) ? 0 : idx + 1;
        for (int i = 0; i < CYCLE.size(); i++) {
            Phase candidate = CYCLE.get((start + i) % CYCLE.size());
            if (!shouldSkip(state, candidate)) return candidate;
        }
        return Phase.GAME_END; // nothing left to run (should not happen)
    }

    // Wraps nextPhase with the hunter-revenge interrupt: the moment a hunter dies
    // (pendingHunterId set, during onExit/onEnter of the leaving phase), the loop
    // diverts into HUNTER_REVENGE and remembers where it would have gone, then
    // resumes there once the revenge is resolved. A revenge shot that kills another
    // hunter chains into a further HUNTER_REVENGE before resuming.
    private Phase nextPhaseConsideringHunter(GameState state, Phase leaving) {
        if (leaving == Phase.HUNTER_REVENGE) {
            if (state.pendingHunterId != null) return Phase.HUNTER_REVENGE; // chained
            Phase resume = state.resumeAfterHunter != null
                    ? state.resumeAfterHunter
                    : nextPhase(state, leaving);
            state.resumeAfterHunter = null;
            return resume;
        }
        Phase normalNext = nextPhase(state, leaving);
        if (state.pendingHunterId != null) {
            state.resumeAfterHunter = normalNext;
            return Phase.HUNTER_REVENGE;
        }
        return normalNext;
    }

    // Flag the hunter for a revenge shot if the player who just died is a (now
    // dead) hunter. Called from every place a player is killed.
    private void markHunterPendingIfHunter(GameState state, String deadId) {
        Player p = state.players.get(deadId);
        if (p != null && p.role == Role.HUNTER) {
            state.pendingHunterId = deadId;
        }
    }

    // Win conditions, evaluated after every death: the werewolves win once they
    // reach parity with everyone else; the village wins once no werewolf is left
    // alive. Returns the winning team, or null while the game continues.
    Role checkWinner(GameState state) {
        long wolves = countAlive(state, Role.WEREWOLF);
        long others = state.players.values().stream()
                .filter(p -> p.alive && p.role != Role.WEREWOLF).count();
        if (wolves == 0) return Role.VILLAGER;
        if (wolves >= others) return Role.WEREWOLF;
        return null;
    }

    // Ends the game: switch to GAME_END. The winner is carried by the dedicated
    // winning_team field of the snapshot (see GameUpdateFactory), so we do NOT
    // overwrite lastAnnouncement here: the result that ended the game (the day
    // vote lynch or the night death) survives to the GAME_END snapshot, letting
    // the client reveal it before showing the win screen.
    private void concludeGame(GameState state, Role winningTeam) {
        state.winningTeam = winningTeam;
        state.phase = Phase.GAME_END;
        state.phaseEndsAt = null;
        state.pendingPrompts.clear();
        log.info("[LOOP] Game over: {} win", winningTeam);
    }

    // A role phase is skipped when no LIVING player holds that role, whether the
    // role was never in the game or its holders have since died. Because a
    // players role is revealed on death, a shorter night leaks nothing the
    // village doesn't already know
    private boolean shouldSkip(GameState state, Phase phase) {
        return switch (phase) {
            // cupid only ever wakes once (the first night). cupidDone is set the
            // moment the phase runs, so even a timeout without a pick won't repeat it
            case NIGHT_CUPID -> countAlive(state, Role.CUPID) == 0 || state.cupidDone;
            case NIGHT_WEREWOLVES -> countAlive(state, Role.WEREWOLF) == 0;
            case NIGHT_SEER -> countAlive(state, Role.SEER) == 0;
            case NIGHT_WITCH -> countAlive(state, Role.WITCH) == 0
                    || (!state.witchHasHealPotion && !state.witchHasPoisonPotion);
            // the fox acts only while it still has its power AND at least five
            // players are alive (so peeking at three still leaves real ambiguity)
            case NIGHT_FOX -> countAlive(state, Role.FOX) == 0
                    || !state.foxHasPower
                    || countAliveTotal(state) < 5;
            case NIGHT_SABOTEUR -> countAlive(state, Role.SABOTEUR) == 0;
            default -> false;
        };
    }

    private long countAlive(GameState state, Role role) {
        return state.players.values().stream().filter(p -> p.role == role && p.alive).count();
    }

    private long countAliveTotal(GameState state) {
        return state.players.values().stream().filter(p -> p.alive).count();
    }

    public void stop(String lobbyCode) {
        ScheduledFuture<?> future = activeLoops.remove(lobbyCode);
        if (future != null) {
            future.cancel(false);
            log.info("[LOOP] Stopped phase loop for lobby {}", lobbyCode);
        }
    }

    // Shortens the current phase to a brief grace period instead of ending it
    // instantly, so clients can see the outcome (e.g. the werewolf tally or the
    // seer's reveal) before the loop advances. No-op unless we are still in the
    // expected phase. phase_ends_at is updated so the countdown reflects the grace.
    public void beginGrace(String lobbyCode, Phase expectedPhase, long graceSeconds) {
        GameState state = gameStateService.get(lobbyCode);
        if (state == null || state.phase != expectedPhase) return;

        ScheduledFuture<?> current = activeLoops.get(lobbyCode);
        if (current != null) current.cancel(false);

        state.phaseEndsAt = Instant.now().plusSeconds(graceSeconds);
        gameStateService.save(state);

        ScheduledFuture<?> next = scheduler.schedule(
                () -> tickLoop(lobbyCode), graceSeconds, TimeUnit.SECONDS);
        activeLoops.put(lobbyCode, next);
        log.info("[LOOP] Grace in {} for phase {}: {}s before advancing",
                lobbyCode, expectedPhase, graceSeconds);
    }

    // Called once all living werewolves have committed their vote: a short grace
    // so they see the final tally and fall back asleep before the night moves on.
    public void beginWerewolfGrace(String lobbyCode) {
        beginGrace(lobbyCode, Phase.NIGHT_WEREWOLVES, WEREWOLF_GRACE_SECONDS);
    }

    private void tickLoop(String lobbyCode) {
        try {
            GameState state = gameStateService.get(lobbyCode);
            if (state == null || state.phase == Phase.GAME_END) {
                stop(lobbyCode);
                return;
            }

            // Deferred game end: a previous tick detected a win but kept the current
            // phase held so its result narration could play instead of being cut off
            // by an instant jump to GAME_END — the DAY_RESULT morning reveal
            // (close-eyes -> day breaks -> night victim) or the HUNTER_REVENGE
            // reveal (the hunter's shot). That hold is up now, so end the game.
            // lastAnnouncement (the deaths / hunter shot) is left untouched so it
            // rides along on the GAME_END snapshot and the win line can follow it.
            if (state.winningTeam != null) {
                Lobby endLobby = lobbyManager.getLobby(lobbyCode);
                concludeGame(state, state.winningTeam);
                gameStateService.save(state);
                if (endLobby != null) {
                    endLobby.players.forEach(p ->
                            lobbySubscriptionService.sendTo(lobbyCode, p.id,
                                    GameUpdateFactory.snapshot(state, endLobby, p.id)));
                }
                log.info("[LOOP] Lobby {} ended after result reveal: {} win",
                        lobbyCode, state.winningTeam);
                stop(lobbyCode);
                return;
            }

            // Clear the per-phase transient data before resolving the ending phase,
            // so any announcement produced while resolving (e.g. the day vote result)
            // is still present when the personalised snapshot is sent below.
            state.pendingPrompts.clear();
            state.pendingResults.clear();
            state.lastAnnouncement = null;

            // resolve the phase that is ending before moving on (may kill via lynch)
            Phase leaving = state.phase;
            onExit(state, leaving);

            // a death may already have decided the game (e.g. lynching the last wolf)
            Role winner = checkWinner(state);
            if (winner != null) {
                if (leaving == Phase.HUNTER_REVENGE) {
                    // The hunter's revenge shot just ended the game. As with the
                    // night deaths at DAY_RESULT, don't cut to GAME_END instantly
                    // (which would cram the hunter-shot line and the win line into
                    // one end-screen snapshot). Keep the HUNTER_REVENGE reveal a
                    // little longer so its "the hunter took someone" narration plays
                    // on the hunter screen; the deferred-win guard at the top of the
                    // next tick ends the game and the win line then follows.
                    state.winningTeam = winner;
                } else {
                    concludeGame(state, winner);
                }
            } else {
                state.phase = nextPhaseConsideringHunter(state, leaving);
            }

            Lobby lobby = lobbyManager.getLobby(lobbyCode);

            // onEnter for the new phase may apply deaths (the night victims at
            // DAY_RESULT), so re-check the win condition afterwards. Skipped once a
            // win is already pending (a deferred hunter-shot win, above) so we don't
            // re-run onEnter for the phase we are deliberately holding.
            if (state.phase != Phase.GAME_END && state.winningTeam == null && lobby != null) {
                onEnter(state, lobby);
                winner = checkWinner(state);
                if (winner != null) {
                    if (state.phase == Phase.DAY_RESULT) {
                        // The night's deaths just decided the game. Don't jump
                        // straight to GAME_END: that would cram close-eyes,
                        // day-break, victim and win narration into one instant and
                        // skip the night hold. Instead keep the DAY_RESULT morning
                        // phase (recording the winner) so its narration plays; the
                        // deferred-win guard at the top of the next tick ends the game.
                        state.winningTeam = winner;
                    } else {
                        concludeGame(state, winner);
                    }
                }
            }

            if (state.phase == Phase.GAME_END) {
                state.phaseEndsAt = null;
            } else {
                // A deferred hunter-shot win holds HUNTER_REVENGE only long enough for
                // its reveal narration, not the full revenge timer. (A deferred
                // DAY_RESULT win keeps that phase's normal morning duration.)
                long duration = (state.winningTeam != null && state.phase == Phase.HUNTER_REVENGE)
                        ? HUNTER_WIN_REVEAL_SECONDS
                        : durationOf(state, state.phase);
                state.phaseEndsAt = Instant.now().plusSeconds(duration);
                ScheduledFuture<?> next = scheduler.schedule(() -> tickLoop(lobbyCode), duration, TimeUnit.SECONDS);
                activeLoops.put(lobbyCode, next);
            }

            if (lobby != null) {
                gameStateService.save(state);
                lobby.players.forEach(p ->
                        lobbySubscriptionService.sendTo(lobbyCode, p.id,
                                GameUpdateFactory.snapshot(state, lobby, p.id)));
            } else {
                gameStateService.save(state);
            }

            log.info("[LOOP] Lobby {} advanced to phase {} ({}s)",
                    lobbyCode, state.phase,
                    state.phase == Phase.GAME_END ? 0 : durationOf(state, state.phase));

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
            case NIGHT_CUPID -> {
                // cupid wakes exactly once; mark it so the phase never repeats
                state.cupidDone = true;
                notifyByRole(state, lobby, Role.CUPID,
                        ActionPrompt.newBuilder().setCupid(CupidPrompt.newBuilder()
                                .addAllCandidateIds(aliveAllIds(state))
                                .build()).build());
            }
            case NIGHT_WEREWOLVES -> {
                state.werewolfVotes.clear(); // fresh tally each night
                state.deadPlayers.clear();   // discard stale day-vote entries before the new night
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
                // attackedThisNight was already set by resolveWerewolfAttack (onExit of NIGHT_WEREWOLVES).
                // The witch always sees who was attacked so she can decide whether to act.
                String attacked = state.attackedThisNight != null ? state.attackedThisNight : "";
                notifyByRole(state, lobby, Role.WITCH,
                        ActionPrompt.newBuilder().setWitch(WitchPrompt.newBuilder()
                                .setAttackedPlayerId(attacked)
                                .setHasHealPotion(state.witchHasHealPotion)
                                .setHasPoisonPotion(state.witchHasPoisonPotion)
                                .build()).build());
            }
            case NIGHT_FOX -> notifyByRole(state, lobby, Role.FOX,
                    ActionPrompt.newBuilder().setFox(FoxPrompt.newBuilder()
                            .addAllCandidateIds(aliveTargetIds(state, Role.FOX))
                            .build()).build());

            case NIGHT_SABOTEUR -> {

                state.sabotagedPlayerId = null;

                notifyByRole(
                        state,
                        lobby,
                        Role.SABOTEUR,
                        ActionPrompt.newBuilder()
                                .setSaboteur(
                                        SaboteurPrompt.newBuilder()
                                                .addAllCandidateIds(
                                                        aliveTargetIds(state, Role.SABOTEUR))
                                                .build())
                                .build());
            }
            // the hunter is already DEAD here, so notifyByRole (alive only) would
            // never reach them: send the revenge prompt straight to that player id
            case HUNTER_REVENGE -> {
                if (state.pendingHunterId != null) {
                    state.pendingPrompts.put(state.pendingHunterId,
                            ActionPrompt.newBuilder().setHunter(HunterPrompt.newBuilder()
                                    .addAllCandidateIds(aliveAllIds(state))
                                    .build()).build());
                }
            }

            // morning: apply the deaths gathered during the night and reveal them
            case DAY_RESULT -> resolveNightDeaths(state);

            // the village votes by day: every living player may cast one vote.
            // There is no per-role prompt (the client opens the vote screen for
            // the DAY_VOTING phase); we just start from a clean tally. The result
            // is resolved in onExit(DAY_VOTING) once the timer runs out or all
            // living players have voted.
            case DAY_VOTING -> state.votes.clear();

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
            case HUNTER_REVENGE -> resolveHunterShot(state);
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

    // every living player; cupid may pair any two of them (including itself)
    private List<String> aliveAllIds(GameState state) {
        return state.players.values().stream()
                .filter(p -> p.alive)
                .map(p -> p.id)
                .toList();
    }

    private void notifyByRole(GameState state, Lobby lobby, Role role, ActionPrompt prompt) {
        // Only record the prompt; it is delivered via the full personalised
        // snapshot that tickLoop broadcasts right after onEnter. We deliberately
        state.players.values().stream()
                .filter(p -> p.role == role && p.alive)
                .forEach(p -> state.pendingPrompts.put(p.id, prompt));
    }

    // Tally the day votes once DAY_VOTING ends and turn them into a lynch result.
    // The most-voted living player is eliminated; a tie (or too few votes) means
    // nobody dies. The result is stored in lastAnnouncement and delivered to every
    // player through the snapshot that follows this phase transition.
    private void resolveDayVote(GameState state) {
        // the sabotaged player sits this day out: they cast no vote and don't
        // count towards the half-of-the-living threshold for a lynch either,
        String sabotaged = state.sabotagedPlayerId;
        long eligibleVoters = state.players.values().stream()
                .filter(p -> p.alive)
                .filter(p -> !p.id.equals(sabotaged))
                .count();

        Map<String, String> effectiveVotes = new HashMap<>(state.votes);
        if (sabotaged != null) {
            // defensive: the sabotaged player's vote is already rejected on the
            // way in (DayVotingAbility), but drop any stray entry from the tally
            effectiveVotes.remove(sabotaged);
        }
        // consume the sabotage so it only affects this one day vote (and a dead
        // saboteur, whose night phase is skipped, can't keep silencing)
        state.sabotagedPlayerId = null;
        // abstentions (skip votes) have an empty target and elect nobody; only
        // real votes for an actual player are tallied here.
        Map<String, Long> tally = effectiveVotes.values().stream()
                .filter(id -> id != null && !id.isEmpty())
                .collect(java.util.stream.Collectors.groupingBy(
                        id -> id, java.util.stream.Collectors.counting()));

        // at least half of the eligible (living, non-sabotaged) players must have
        // voted for a real player (skips do NOT count) for a lynch to be possible
        long votesForSomeone = tally.values().stream().mapToLong(Long::longValue).sum();
        boolean halfVotedForSomeone = votesForSomeone * 2L >= eligibleVoters;

        PublicAnnouncement announcement;
        if (tally.isEmpty() || !halfVotedForSomeone) {
            // nobody picked a target (all abstained) or too few voted => no lynch
            announcement = PublicAnnouncement.newBuilder()
                    .setVoteResult(VoteResultEvent.newBuilder().setTied(true).build())
                    .build();
        } else {
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
                markHunterPendingIfHunter(state, eliminatedId);
                if (!state.deadPlayers.contains(eliminatedId)) {
                    state.deadPlayers.add(eliminatedId);
                }
                // a lynched lover dies together with their partner (heartbreak);
                // both deaths are announced to the village in the vote result
                List<String> alsoDied = new ArrayList<>();
                String partner = loverPartnerOf(state, eliminatedId);
                if (partner != null) {
                    Player lp = state.players.get(partner);
                    if (lp != null && lp.alive) {
                        lp.alive = false;
                        markHunterPendingIfHunter(state, partner);
                        alsoDied.add(partner);
                        if (!state.deadPlayers.contains(partner)) {
                            state.deadPlayers.add(partner);
                        }
                    }
                }
                announcement = PublicAnnouncement.newBuilder()
                        .setVoteResult(VoteResultEvent.newBuilder()
                                .setEliminatedPlayerId(eliminatedId)
                                .setTied(false)
                                .addAllAlsoDiedIds(alsoDied)
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
        // Seed each queued victim's cause: the werewolves' target is
        // attackedThisNight, anyone else queued during the night was the witch's
        // poison. Lover chaining (below) appends more victims with HEARTBREAK.
        Map<String, EliminationCause> causes = new LinkedHashMap<>();
        for (String id : state.deadPlayers) {
            causes.putIfAbsent(id, id.equals(state.attackedThisNight)
                    ? EliminationCause.KILLED_BY_WEREWOLVES
                    : EliminationCause.KILLED_BY_WITCH);
        }

        // Work through the victims as a queue: killing a lover drags their
        // partner in, which appends to the queue. Using a queue (not a for-each
        // over deadPlayers) keeps that safe and terminates once everyone is dead.
        List<PlayerDeath> killedThisNight = new ArrayList<>();
        Deque<String> queue = new ArrayDeque<>(state.deadPlayers);
        while (!queue.isEmpty()) {
            String id = queue.poll();
            Player p = state.players.get(id);
            if (p == null || !p.alive) continue;
            p.alive = false;
            markHunterPendingIfHunter(state, id);
            killedThisNight.add(PlayerDeath.newBuilder()
                    .setPlayerId(id)
                    .setCause(causes.getOrDefault(id, EliminationCause.CAUSE_UNSPECIFIED))
                    .build());

            String partner = loverPartnerOf(state, id);
            if (partner != null && !causes.containsKey(partner)) {
                Player lp = state.players.get(partner);
                if (lp != null && lp.alive) {
                    causes.put(partner, EliminationCause.CAUSE_HEARTBREAK);
                    queue.add(partner);
                }
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
                            .addAllDeaths(killedThisNight)
                            .build())
                    .build();
        }
        state.lastAnnouncement = announcement;
    }

    // A random living player other than the given one (the dying hunter), or
    // null if there is nobody left to shoot.
    private String randomAliveTarget(GameState state, String exclude) {
        List<String> candidates = state.players.values().stream()
                .filter(p -> p.alive && !p.id.equals(exclude))
                .map(p -> p.id)
                .toList();
        if (candidates.isEmpty()) return null;
        return candidates.get(ThreadLocalRandom.current().nextInt(candidates.size()));
    }

    // The partner a player is in love with (cupid's pairing), or null if this
    // player is not one of the two lovers.
    private String loverPartnerOf(GameState state, String id) {
        if (state.loverA == null || state.loverB == null) return null;
        if (id.equals(state.loverA)) return state.loverB;
        if (id.equals(state.loverB)) return state.loverA;
        return null;
    }

    // Resolve the dying hunter's revenge shot when HUNTER_REVENGE ends: kill the
    // chosen target (and drag in their lover), announce it, and clear the pending
    // state. Killing another hunter re-arms pendingHunterId for a further round.
    private void resolveHunterShot(GameState state) {
        String shooter = state.pendingHunterId;
        String target = state.hunterShotTargetId;
        // clear first so a chained hunter death below re-arms a new revenge round
        state.pendingHunterId = null;
        state.hunterShotTargetId = null;

        // the hunter never picked in time -> a random living player is shot
        // instead (never the hunter themselves: they are already dead, so they
        // are not among the living candidates)
        if (target == null) {
            target = randomAliveTarget(state, shooter);
            if (target == null) return; // nobody left to shoot
        }

        Player t = state.players.get(target);
        if (t == null || !t.alive) return;
        t.alive = false;
        markHunterPendingIfHunter(state, target);

        // shooting a lover drags their partner into death as well
        String partner = loverPartnerOf(state, target);
        if (partner != null) {
            Player lp = state.players.get(partner);
            if (lp != null && lp.alive) {
                lp.alive = false;
                markHunterPendingIfHunter(state, partner);
            }
        }

        state.lastAnnouncement = PublicAnnouncement.newBuilder()
                .setHunterShot(HunterShotEvent.newBuilder()
                        .setShooterId(shooter != null ? shooter : "")
                        .setTargetId(target)
                        .build())
                .build();
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
