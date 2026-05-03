package com.werewolf.uni.backend.service;

import com.uni.werewolf.grpc.UserServiceGrpc;
import com.uni.werewolf.grpc.RegisterRequest;
import com.uni.werewolf.grpc.LoginRequest;
import com.uni.werewolf.grpc.LoginResponse;
import com.uni.werewolf.grpc.UserProfile;
import com.google.protobuf.Empty;
import com.werewolf.uni.backend.entity.UserEntity;
import com.werewolf.uni.backend.repository.UserRepository;
import io.grpc.stub.StreamObserver;
import io.grpc.Status;
import net.devh.boot.grpc.server.service.GrpcService;
import lombok.RequiredArgsConstructor;

@GrpcService
@RequiredArgsConstructor
public class UserServiceImpl extends UserServiceGrpc.UserServiceImplBase {

    private final UserRepository userRepository;

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
        // todo: add bcrypt
        newUser.setPasswordHash(request.getPassword());

        userRepository.save(newUser);

        // return empty success
        responseObserver.onNext(Empty.newBuilder().build());
        responseObserver.onCompleted();
    }

    @Override
    public void login(LoginRequest request, StreamObserver<LoginResponse> responseObserver) {
        var userOpt = userRepository.findByUsername(request.getUsername());

        if (userOpt.isPresent() && userOpt.get().getPasswordHash().equals(request.getPassword())) {
            UserEntity user = userOpt.get();

            // build profile
            UserProfile profile = UserProfile.newBuilder()
                    .setUserId(String.valueOf(user.getId()))
                    .setUsername(user.getUsername())
                    .setScore(user.getExp())
                    .build();

            // build response
            LoginResponse response = LoginResponse.newBuilder()
                    .setToken("dummy-jwt-token") // todo: jwt
                    .setProfile(profile)
                    .build();

            responseObserver.onNext(response);
            responseObserver.onCompleted();
        } else {
            // invalid credentials
            responseObserver.onError(Status.UNAUTHENTICATED
                    .withDescription("invalid credentials")
                    .asRuntimeException());
        }
    }
}