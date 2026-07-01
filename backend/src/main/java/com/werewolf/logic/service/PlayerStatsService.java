package com.werewolf.logic.service;

import com.werewolf.grpc.Role;
import com.werewolf.logic.model.Player;
import com.werewolf.persistence.entity.UserEntity;
import com.werewolf.persistence.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Collection;

/**
 * Persists per-user game-outcome counters (games played/won/lost) once a game ends.
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class PlayerStatsService {

    private final UserRepository userRepository;

    // Called once per game from GameLoopService.concludeGame(). Failures are
    // logged and swallowed per player so a bad/stale player id (or a transient DB
    // issue) can't take down the game loop that just finished resolving the game.
    public void recordGameEnd(Collection<Player> players, Role winningTeam) {
        for (Player player : players) {
            try {
                recordForPlayer(player, winningTeam);
            } catch (Exception e) {
                log.error("[STATS] Failed to record game result for player {}: {}", player.id, e.getMessage());
            }
        }
    }

    private void recordForPlayer(Player player, Role winningTeam) {
        Long userId = Long.valueOf(player.id);
        UserEntity user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            log.warn("[STATS] Unknown user id {}; skipping stats update", player.id);
            return;
        }

        // team membership mirrors GameLoopService.checkWinner: werewolves vs. everyone else
        boolean isWerewolf = player.role == Role.WEREWOLF;
        boolean won = isWerewolf ? winningTeam == Role.WEREWOLF : winningTeam == Role.VILLAGER;

        user.setGamesPlayed(user.getGamesPlayed() + 1);
        if (!won) {
            user.setGamesLost(user.getGamesLost() + 1);
        } else if (isWerewolf) {
            user.setGamesWonWerewolf(user.getGamesWonWerewolf() + 1);
        } else {
            user.setGamesWonVillager(user.getGamesWonVillager() + 1);
        }

        userRepository.save(user);
    }
}
