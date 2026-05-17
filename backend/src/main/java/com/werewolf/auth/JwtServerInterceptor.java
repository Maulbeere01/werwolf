package com.werewolf.auth;

import io.grpc.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.devh.boot.grpc.server.interceptor.GrpcGlobalServerInterceptor;

import java.util.Set;

@Slf4j
@GrpcGlobalServerInterceptor
@RequiredArgsConstructor
public class JwtServerInterceptor implements ServerInterceptor {

    private static final Metadata.Key<String> AUTH_KEY =
            Metadata.Key.of("authorization", Metadata.ASCII_STRING_MARSHALLER);

    private static final Set<String> PUBLIC_METHODS = Set.of(
            "werewolf.UserService/Login",
            "werewolf.UserService/Register"
    );

    private final JwtService jwtService;

    @Override
    public <ReqT, RespT> ServerCall.Listener<ReqT> interceptCall(
            ServerCall<ReqT, RespT> call,
            Metadata headers,
            ServerCallHandler<ReqT, RespT> next) {

        String method = call.getMethodDescriptor().getFullMethodName();

        if (PUBLIC_METHODS.contains(method)) {
            log.info("[AUTH] Public call: {}", method);
            return next.startCall(call, headers);
        }

        String authHeader = headers.get(AUTH_KEY);
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            log.warn("[AUTH] Rejected — no token for: {}", method);
            call.close(Status.UNAUTHENTICATED.withDescription("missing token"), new Metadata());
            return new ServerCall.Listener<>() {};
        }

        try {
            String token = authHeader.substring(7);
            String userId = jwtService.extractUserId(token);
            String username = jwtService.extractUsername(token);
            log.info("[AUTH] Accepted — userId={} username='{}' calling: {}", userId, username, method);
            Context ctx = Context.current()
                    .withValue(AuthContext.USER_ID_KEY, userId)
                    .withValue(AuthContext.USERNAME_KEY, username);
            return Contexts.interceptCall(ctx, call, headers, next);
        } catch (Exception e) {
            log.warn("[AUTH] Rejected — invalid token for: {}", method);
            call.close(Status.UNAUTHENTICATED.withDescription("invalid token"), new Metadata());
            return new ServerCall.Listener<>() {};
        }
    }
}
