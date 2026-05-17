package com.werewolf.auth;

import io.grpc.Context;

public class AuthContext {
    public static final Context.Key<String> USER_ID_KEY = Context.key("userId");
    public static final Context.Key<String> USERNAME_KEY = Context.key("username");

    private AuthContext() {}
}
