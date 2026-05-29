package com.werewolf.api.grpc;

import com.werewolf.auth.JwtService;
import com.werewolf.grpc.*;
import com.google.protobuf.Empty;
import com.werewolf.persistence.entity.UserEntity;
import com.werewolf.persistence.repository.UserRepository;
import io.grpc.stub.StreamObserver;
import io.grpc.Status;
import net.devh.boot.grpc.server.service.GrpcService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

@Slf4j
@GrpcService
@RequiredArgsConstructor
public class UserServiceImpl extends UserServiceGrpc.UserServiceImplBase {

    private final UserRepository userRepository;
    private final BCryptPasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    @Override
    public void register(RegisterRequest request, StreamObserver<Empty> responseObserver) {
        // check if username exists
        if (userRepository.existsByUsername(request.getUsername())) {
            responseObserver.onError(Status.ALREADY_EXISTS
                    .withDescription("username already taken")
                    .asRuntimeException());
            return;
        }

        // check if email exists
        if (userRepository.existsByEmail(request.getEmail())) {
            responseObserver.onError(Status.ALREADY_EXISTS
                    .withDescription("email already taken")
                    .asRuntimeException());
            return;
        }

        // save new user
        UserEntity newUser = new UserEntity();
        newUser.setUsername(request.getUsername());
        newUser.setEmail(request.getEmail());
        String hashedPassword = passwordEncoder.encode(request.getPassword());
        newUser.setPasswordHash(hashedPassword);

        userRepository.save(newUser);

        // return empty success
        responseObserver.onNext(Empty.newBuilder().build());
        responseObserver.onCompleted();
    }

    @Override
    public void login(LoginRequest request, StreamObserver<LoginResponse> responseObserver) {
        var userOpt = userRepository.findByUsername(request.getUsername());

        log.info("[LOGIN] Attempt for username='{}'", request.getUsername());

        if (userOpt.isPresent() && passwordEncoder.matches(request.getPassword(), userOpt.get().getPasswordHash())) {
            UserEntity user = userOpt.get();
            log.info("[LOGIN] Success for username='{}' userId={}", user.getUsername(), user.getId());

            // build profile
            UserProfile profile = UserProfile.newBuilder()
                    .setUserId(String.valueOf(user.getId()))
                    .setUsername(user.getUsername())
                    .setScore(user.getExp())
                    .build();

            // build response
            LoginResponse response = LoginResponse.newBuilder()
                    .setToken(jwtService.generateToken(user.getId(), user.getUsername()))
                    .setProfile(profile)
                    .build();

            responseObserver.onNext(response);
            responseObserver.onCompleted();
        } else {
            log.warn("[LOGIN] Failed for username='{}'", request.getUsername());
            responseObserver.onError(Status.UNAUTHENTICATED
                    .withDescription("invalid credentials")
                    .asRuntimeException());
        }
    }
}