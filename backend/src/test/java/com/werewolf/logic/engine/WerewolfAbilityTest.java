package com.werewolf.logic.engine;

import com.werewolf.grpc.Phase;
import com.werewolf.grpc.Role;
import com.werewolf.grpc.VoteAction;
import com.werewolf.logic.model.GameState;
import com.werewolf.logic.model.Lobby;
import com.werewolf.logic.model.Player;
import com.werewolf.logic.service.GameLoopService;
import com.werewolf.logic.service.GameStateService;
import com.werewolf.logic.service.LobbyManager;
import com.werewolf.logic.service.LobbySubscriptionService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.mockito.Mockito.*;

/**
 * Testet die WerewolfAbility.
 * Eine bestätigte Wolfs-Stimme wird (committed) gespeichert; das Opfer wird erst
 * am Phasenende aufgelöst, hier also NICHT sofort getötet.
 */
class WerewolfAbilityTest {

    private GameStateService stateService;
    private LobbyManager lobbyManager;
    private LobbySubscriptionService subscriptionService;
    private GameLoopService gameLoopService;
    private WerewolfAbility werewolfAbility;

    @BeforeEach
    void setUp() {
        stateService = mock(GameStateService.class);
        lobbyManager = mock(LobbyManager.class);
        subscriptionService = mock(LobbySubscriptionService.class);
        gameLoopService = mock(GameLoopService.class);

        werewolfAbility = new WerewolfAbility(
                stateService, lobbyManager, subscriptionService, gameLoopService);
    }

    private static Player player(String id, Role role) {
        Player p = new Player();
        p.id = id;
        p.name = id;
        p.role = role;
        p.alive = true;
        return p;
    }

    @Test
    void shouldCommitVoteAndAdvanceWhenAllWolvesVoted() {
        GameState state = new GameState();
        state.lobbyCode = "ABCD";
        state.phase = Phase.NIGHT_WEREWOLVES;
        Player wolf = player("wolf1", Role.WEREWOLF);
        Player victim = player("player1", Role.VILLAGER);
        state.players.put(wolf.id, wolf);
        state.players.put(victim.id, victim);

        Lobby lobby = new Lobby();
        lobby.lobbyCode = "ABCD";
        lobby.hostId = "wolf1";
        lobby.players.add(wolf);
        lobby.players.add(victim);

        when(stateService.get("ABCD")).thenReturn(state);
        when(lobbyManager.getLobby("ABCD")).thenReturn(lobby);

        VoteAction action = VoteAction.newBuilder().setTargetId("player1").build();
        werewolfAbility.execute("ABCD", "wolf1", action);

        // committed, not killed yet
        assertEquals("player1", state.werewolfVotes.get("wolf1"));
        assertFalse(state.deadPlayers.contains("player1"));

        // every living wolf voted -> phase ends early
        verify(gameLoopService, times(1))
                .beginWerewolfGrace("ABCD");
    }

    @Test
    void shouldIgnoreVotesFromNonWolves() {
        GameState state = new GameState();
        state.lobbyCode = "ABCD";
        state.phase = Phase.NIGHT_WEREWOLVES;
        Player villager = player("villager1", Role.VILLAGER);
        state.players.put(villager.id, villager);

        Lobby lobby = new Lobby();
        lobby.lobbyCode = "ABCD";
        lobby.hostId = "villager1";
        lobby.players.add(villager);

        when(stateService.get("ABCD")).thenReturn(state);
        when(lobbyManager.getLobby("ABCD")).thenReturn(lobby);

        VoteAction action = VoteAction.newBuilder().setTargetId("player1").build();
        werewolfAbility.execute("ABCD", "villager1", action);

        assertEquals(0, state.werewolfVotes.size());
        verify(gameLoopService, never()).beginWerewolfGrace(anyString());
    }

    @Test
    void shouldNotAllowChangingACommittedVote() {
        GameState state = new GameState();
        state.lobbyCode = "ABCD";
        state.phase = Phase.NIGHT_WEREWOLVES;
        Player wolfA = player("wolfA", Role.WEREWOLF);
        Player wolfB = player("wolfB", Role.WEREWOLF);
        Player v1 = player("v1", Role.VILLAGER);
        Player v2 = player("v2", Role.VILLAGER);
        state.players.put(wolfA.id, wolfA);
        state.players.put(wolfB.id, wolfB);
        state.players.put(v1.id, v1);
        state.players.put(v2.id, v2);

        Lobby lobby = new Lobby();
        lobby.lobbyCode = "ABCD";
        lobby.hostId = "wolfA";
        lobby.players.add(wolfA);
        lobby.players.add(wolfB);
        lobby.players.add(v1);
        lobby.players.add(v2);

        when(stateService.get("ABCD")).thenReturn(state);
        when(lobbyManager.getLobby("ABCD")).thenReturn(lobby);

        werewolfAbility.execute("ABCD", "wolfA",
                VoteAction.newBuilder().setTargetId("v1").build());
        // second vote from the same wolf is ignored (commit)
        werewolfAbility.execute("ABCD", "wolfA",
                VoteAction.newBuilder().setTargetId("v2").build());

        assertEquals("v1", state.werewolfVotes.get("wolfA"));
        // not all wolves voted yet (wolfB pending) => no early advance
        verify(gameLoopService, never()).beginWerewolfGrace(anyString());
    }
}
