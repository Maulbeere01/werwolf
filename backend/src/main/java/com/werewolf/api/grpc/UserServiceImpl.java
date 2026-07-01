package com.werewolf.api.grpc;

import com.werewolf.auth.JwtService;
import com.werewolf.grpc.*;
import com.google.protobuf.Empty;
import com.werewolf.persistence.entity.UserEntity;
import com.werewolf.persistence.repository.UserRepository;
import com.werewolf.auth.AuthContext;
import io.grpc.stub.StreamObserver;
import io.grpc.Status;
import net.devh.boot.grpc.server.service.GrpcService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.util.Set;

@Slf4j
@GrpcService
@RequiredArgsConstructor
public class UserServiceImpl extends UserServiceGrpc.UserServiceImplBase {

    // keep in sync with frontend/lib/screens/profile_view.dart _assetPfps
    private static final Set<String> VALID_AVATARS = Set.of(
            "wolf_pfp.png",
            "seher_pfp.png",
            "sabateur_png.png",
            "jäger_pfp.png",
            "hexe_png.png",
            "fuchs_pfp.png",
            "dorfbewohner_pfp.png",
            "armor_pfp.png"
    );

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

            // build response
            LoginResponse response = LoginResponse.newBuilder()
                    .setToken(jwtService.generateToken(user.getId(), user.getUsername()))
                    .setProfile(toProfile(user))
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

    @Override
    public void getProfile(ProfileRequest request, StreamObserver<UserProfile> responseObserver) {
        String targetId = request.getTargetUserId();
        String userId = targetId.isEmpty() ? AuthContext.USER_ID_KEY.get() : targetId;

        var userOpt = userRepository.findById(Long.valueOf(userId));
        if (userOpt.isEmpty()) {
            responseObserver.onError(Status.NOT_FOUND
                    .withDescription("user not found")
                    .asRuntimeException());
            return;
        }

        responseObserver.onNext(toProfile(userOpt.get()));
        responseObserver.onCompleted();
    }

    @Override
    public void updateAvatar(UpdateAvatarRequest request, StreamObserver<UserProfile> responseObserver) {
        if (!VALID_AVATARS.contains(request.getAvatar())) {
            responseObserver.onError(Status.INVALID_ARGUMENT
                    .withDescription("unknown avatar")
                    .asRuntimeException());
            return;
        }

        String userId = AuthContext.USER_ID_KEY.get();
        var userOpt = userRepository.findById(Long.valueOf(userId));
        if (userOpt.isEmpty()) {
            responseObserver.onError(Status.NOT_FOUND
                    .withDescription("user not found")
                    .asRuntimeException());
            return;
        }

        UserEntity user = userOpt.get();
        user.setAvatar(request.getAvatar());
        userRepository.save(user);

        responseObserver.onNext(toProfile(user));
        responseObserver.onCompleted();
    }

    private UserProfile toProfile(UserEntity user) {
        return UserProfile.newBuilder()
                .setUserId(String.valueOf(user.getId()))
                .setUsername(user.getUsername())
                .setScore(user.getExp())
                .setAvatar(user.getAvatar() == null ? "" : user.getAvatar())
                .build();
    }
}