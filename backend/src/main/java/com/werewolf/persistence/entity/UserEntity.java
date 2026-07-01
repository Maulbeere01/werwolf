package com.werewolf.persistence.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "users")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
public class UserEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String username;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(name = "password_hash", nullable = false)
    private String passwordHash;

    @Column(name = "created_at", insertable = false, updatable = false)
    private LocalDateTime createdAt;

    private Integer exp = 0;

    private String avatar;

    @Column(name = "games_played")
    private Integer gamesPlayed = 0;

    @Column(name = "games_won_werewolf")
    private Integer gamesWonWerewolf = 0;

    @Column(name = "games_won_villager")
    private Integer gamesWonVillager = 0;

    @Column(name = "games_lost")
    private Integer gamesLost = 0;
}