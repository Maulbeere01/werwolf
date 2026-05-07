package com.werewolf.api.grpc;

import com.werewolf.grpc.RegisterRequest;
import com.werewolf.grpc.LoginRequest;
import com.werewolf.grpc.LoginResponse;
import com.google.protobuf.Empty;
import com.werewolf.persistence.entity.UserEntity;
import com.werewolf.persistence.repository.UserRepository;
import io.grpc.stub.StreamObserver;
import io.grpc.Status;
import io.grpc.StatusRuntimeException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.data.jpa.test.autoconfigure.DataJpaTest;
import org.springframework.boot.jdbc.test.autoconfigure.AutoConfigureTestDatabase;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.testcontainers.containers.MySQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@DataJpaTest
@Testcontainers
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
class UserServiceImplTest {

    // spin up isolated mysql for all tests in this class to ensure clean state
    @Container
    static MySQLContainer<?> mysql = new MySQLContainer<>("mysql:8.0.46")
            .withDatabaseName("game_werwolf")
            .withUsername("testuser")
            .withPassword("testpass");

    // inject random container ports into spring context since they change every run
    @DynamicPropertySource
    static void configureProperties(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", mysql::getJdbcUrl);
        registry.add("spring.datasource.username", mysql::getUsername);
        registry.add("spring.datasource.password", mysql::getPassword);
        registry.add("spring.datasource.driver-class-name", () -> "com.mysql.cj.jdbc.Driver");
        registry.add("spring.jpa.hibernate.ddl-auto", () -> "create-drop");
    }

    @Autowired
    private UserRepository userRepository;

    private UserServiceImpl userService;

    @BeforeEach
    void setup() {
        // flush db between tests to avoid data leakage
        userRepository.deleteAllInBatch();
        userService = new UserServiceImpl(userRepository);
    }

    @Test
    void register_shouldSaveUser_whenDataIsNew() {
        RegisterRequest request = RegisterRequest.newBuilder()
                .setUsername("testuser")
                .setEmail("test@mail.com")
                .setPassword("pass123")
                .build();

        StreamObserver<Empty> observer = mock(StreamObserver.class);

        userService.register(request, observer);

        // check persistence and grpc lifecycle
        assertTrue(userRepository.findByUsername("testuser").isPresent());
        verify(observer).onNext(any(Empty.class));
        verify(observer).onCompleted();
    }

    @Test
    void login_shouldReturnProfile_whenCredentialsMatch() {
        // populate container db for login scenario
        UserEntity user = new UserEntity();
        user.setUsername("loginuser");
        user.setEmail("login@mail.com");
        user.setPasswordHash("secret");
        user.setExp(0);
        userRepository.save(user);

        LoginRequest request = LoginRequest.newBuilder()
                .setUsername("loginuser")
                .setPassword("secret")
                .build();

        StreamObserver<LoginResponse> observer = mock(StreamObserver.class);
        ArgumentCaptor<LoginResponse> responseCaptor = ArgumentCaptor.forClass(LoginResponse.class);

        userService.login(request, observer);

        // check if db profile correctly maps to response
        verify(observer).onNext(responseCaptor.capture());
        LoginResponse response = responseCaptor.getValue();
        assertEquals("loginuser", response.getProfile().getUsername());
        verify(observer).onCompleted();
    }

    @Test
    void login_shouldFail_whenPasswordIsWrong() {
        UserEntity user = new UserEntity();
        user.setUsername("wrongpass");
        user.setEmail("wrongpass@test.com");
        user.setPasswordHash("correct_hash");
        user.setExp(0);
        userRepository.save(user);

        LoginRequest request = LoginRequest.newBuilder()
                .setUsername("wrongpass")
                .setPassword("wrong_hash")
                .build();

        StreamObserver<LoginResponse> observer = mock(StreamObserver.class);
        ArgumentCaptor<Throwable> errorCaptor = ArgumentCaptor.forClass(Throwable.class);

        userService.login(request, observer);

        // verify error status code for auth failure
        verify(observer).onError(errorCaptor.capture());
        assertTrue(errorCaptor.getValue() instanceof StatusRuntimeException);
        StatusRuntimeException exception = (StatusRuntimeException) errorCaptor.getValue();
        assertEquals(Status.Code.UNAUTHENTICATED, exception.getStatus().getCode());
    }
}