package com.werewolf.logic.service;

import com.werewolf.grpc.Role;
import com.werewolf.logic.model.Player;
import com.werewolf.persistence.entity.UserEntity;
import com.werewolf.persistence.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

/**
 * Testet PlayerStatsService.
 * Prueft, dass Spielergebnisse korrekt auf gamesPlayed/gamesWon.../gamesLost gemappt werden.
 */
class PlayerStatsServiceTest {

    private UserRepository userRepository;
    private PlayerStatsService service;

    @BeforeEach
    void setUp() {
        userRepository = mock(UserRepository.class);
        service = new PlayerStatsService(userRepository);
    }

    private Player player(String id, Role role) {
        Player p = new Player();
        p.id = id;
        p.role = role;
        return p;
    }

    private UserEntity userWithId(long id) {
        UserEntity user = new UserEntity();
        user.setId(id);
        return user;
    }

    @Test
    void recordGameEnd_shouldCreditWerewolfWin_whenWerewolfRoleAndWerewolvesWon() {
        UserEntity user = userWithId(1L);
        when(userRepository.findById(1L)).thenReturn(Optional.of(user));

        service.recordGameEnd(List.of(player("1", Role.WEREWOLF)), Role.WEREWOLF);

        assertEquals(1, user.getGamesPlayed());
        assertEquals(1, user.getGamesWonWerewolf());
        assertEquals(0, user.getGamesWonVillager());
        assertEquals(0, user.getGamesLost());
        verify(userRepository).save(user);
    }

    @Test
    void recordGameEnd_shouldCreditVillagerWin_whenNonWerewolfRoleAndVillageWon() {
        UserEntity user = userWithId(2L);
        when(userRepository.findById(2L)).thenReturn(Optional.of(user));

        service.recordGameEnd(List.of(player("2", Role.SEER)), Role.VILLAGER);

        assertEquals(1, user.getGamesPlayed());
        assertEquals(1, user.getGamesWonVillager());
        assertEquals(0, user.getGamesWonWerewolf());
        assertEquals(0, user.getGamesLost());
    }

    @Test
    void recordGameEnd_shouldCreditLoss_whenWerewolfRoleButVillageWon() {
        UserEntity user = userWithId(3L);
        when(userRepository.findById(3L)).thenReturn(Optional.of(user));

        service.recordGameEnd(List.of(player("3", Role.WEREWOLF)), Role.VILLAGER);

        assertEquals(1, user.getGamesPlayed());
        assertEquals(1, user.getGamesLost());
        assertEquals(0, user.getGamesWonWerewolf());
    }

    @Test
    void recordGameEnd_shouldCreditLoss_whenVillagerRoleButWerewolvesWon() {
        UserEntity user = userWithId(4L);
        when(userRepository.findById(4L)).thenReturn(Optional.of(user));

        service.recordGameEnd(List.of(player("4", Role.HUNTER)), Role.WEREWOLF);

        assertEquals(1, user.getGamesPlayed());
        assertEquals(1, user.getGamesLost());
        assertEquals(0, user.getGamesWonVillager());
    }

    @Test
    void recordGameEnd_shouldUpdateEveryPlayer_whenMultiplePlayersFinish() {
        UserEntity wolf = userWithId(5L);
        UserEntity villager = userWithId(6L);
        when(userRepository.findById(5L)).thenReturn(Optional.of(wolf));
        when(userRepository.findById(6L)).thenReturn(Optional.of(villager));

        service.recordGameEnd(
                List.of(player("5", Role.WEREWOLF), player("6", Role.VILLAGER)),
                Role.WEREWOLF);

        assertEquals(1, wolf.getGamesWonWerewolf());
        assertEquals(1, villager.getGamesLost());
    }

    @Test
    void recordGameEnd_shouldSkipSilently_whenUserIdUnknown() {
        when(userRepository.findById(99L)).thenReturn(Optional.empty());

        assertDoesNotThrow(() ->
                service.recordGameEnd(List.of(player("99", Role.WEREWOLF)), Role.WEREWOLF));

        verify(userRepository, never()).save(any());
    }

    @Test
    void recordGameEnd_shouldNotThrow_whenPlayerIdIsNotNumeric() {
        assertDoesNotThrow(() ->
                service.recordGameEnd(List.of(player("not-a-number", Role.WEREWOLF)), Role.WEREWOLF));

        verify(userRepository, never()).save(any());
    }
}
