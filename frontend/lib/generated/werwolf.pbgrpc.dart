//
//  Generated code. Do not modify.
//  source: werwolf.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'google/protobuf/empty.pb.dart' as $1;
import 'werwolf.pb.dart' as $0;

export 'werwolf.pb.dart';

@$pb.GrpcServiceName('werewolf.UserService')
class UserServiceClient extends $grpc.Client {
  static final _$login = $grpc.ClientMethod<$0.LoginRequest, $0.LoginResponse>(
      '/werewolf.UserService/Login',
      ($0.LoginRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.LoginResponse.fromBuffer(value));
  static final _$register = $grpc.ClientMethod<$0.RegisterRequest, $1.Empty>(
      '/werewolf.UserService/Register',
      ($0.RegisterRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$getProfile = $grpc.ClientMethod<$0.ProfileRequest, $0.UserProfile>(
      '/werewolf.UserService/GetProfile',
      ($0.ProfileRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.UserProfile.fromBuffer(value));
  static final _$updateAvatar = $grpc.ClientMethod<$0.UpdateAvatarRequest, $0.UserProfile>(
      '/werewolf.UserService/UpdateAvatar',
      ($0.UpdateAvatarRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.UserProfile.fromBuffer(value));

  UserServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.LoginResponse> login($0.LoginRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$login, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> register($0.RegisterRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$register, request, options: options);
  }

  $grpc.ResponseFuture<$0.UserProfile> getProfile($0.ProfileRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getProfile, request, options: options);
  }

  $grpc.ResponseFuture<$0.UserProfile> updateAvatar($0.UpdateAvatarRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateAvatar, request, options: options);
  }
}

@$pb.GrpcServiceName('werewolf.UserService')
abstract class UserServiceBase extends $grpc.Service {
  $core.String get $name => 'werewolf.UserService';

  UserServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.LoginRequest, $0.LoginResponse>(
        'Login',
        login_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LoginRequest.fromBuffer(value),
        ($0.LoginResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RegisterRequest, $1.Empty>(
        'Register',
        register_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RegisterRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ProfileRequest, $0.UserProfile>(
        'GetProfile',
        getProfile_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ProfileRequest.fromBuffer(value),
        ($0.UserProfile value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateAvatarRequest, $0.UserProfile>(
        'UpdateAvatar',
        updateAvatar_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UpdateAvatarRequest.fromBuffer(value),
        ($0.UserProfile value) => value.writeToBuffer()));
  }

  $async.Future<$0.LoginResponse> login_Pre($grpc.ServiceCall call, $async.Future<$0.LoginRequest> request) async {
    return login(call, await request);
  }

  $async.Future<$1.Empty> register_Pre($grpc.ServiceCall call, $async.Future<$0.RegisterRequest> request) async {
    return register(call, await request);
  }

  $async.Future<$0.UserProfile> getProfile_Pre($grpc.ServiceCall call, $async.Future<$0.ProfileRequest> request) async {
    return getProfile(call, await request);
  }

  $async.Future<$0.UserProfile> updateAvatar_Pre($grpc.ServiceCall call, $async.Future<$0.UpdateAvatarRequest> request) async {
    return updateAvatar(call, await request);
  }

  $async.Future<$0.LoginResponse> login($grpc.ServiceCall call, $0.LoginRequest request);
  $async.Future<$1.Empty> register($grpc.ServiceCall call, $0.RegisterRequest request);
  $async.Future<$0.UserProfile> getProfile($grpc.ServiceCall call, $0.ProfileRequest request);
  $async.Future<$0.UserProfile> updateAvatar($grpc.ServiceCall call, $0.UpdateAvatarRequest request);
}
@$pb.GrpcServiceName('werewolf.GameService')
class GameServiceClient extends $grpc.Client {
  static final _$createLobby = $grpc.ClientMethod<$0.CreateLobbyRequest, $0.LobbyInfo>(
      '/werewolf.GameService/CreateLobby',
      ($0.CreateLobbyRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.LobbyInfo.fromBuffer(value));
  static final _$joinLobby = $grpc.ClientMethod<$0.JoinRequest, $0.LobbyInfo>(
      '/werewolf.GameService/JoinLobby',
      ($0.JoinRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.LobbyInfo.fromBuffer(value));
  static final _$startGame = $grpc.ClientMethod<$0.StartGameRequest, $1.Empty>(
      '/werewolf.GameService/StartGame',
      ($0.StartGameRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$subscribeToGame = $grpc.ClientMethod<$0.SubscribeRequest, $0.GameUpdate>(
      '/werewolf.GameService/SubscribeToGame',
      ($0.SubscribeRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.GameUpdate.fromBuffer(value));
  static final _$performAction = $grpc.ClientMethod<$0.GameAction, $1.Empty>(
      '/werewolf.GameService/PerformAction',
      ($0.GameAction value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$requestPause = $grpc.ClientMethod<$0.PauseRequest, $1.Empty>(
      '/werewolf.GameService/RequestPause',
      ($0.PauseRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$resumeGame = $grpc.ClientMethod<$0.PauseRequest, $1.Empty>(
      '/werewolf.GameService/ResumeGame',
      ($0.PauseRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));

  GameServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.LobbyInfo> createLobby($0.CreateLobbyRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createLobby, request, options: options);
  }

  $grpc.ResponseFuture<$0.LobbyInfo> joinLobby($0.JoinRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$joinLobby, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> startGame($0.StartGameRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$startGame, request, options: options);
  }

  $grpc.ResponseStream<$0.GameUpdate> subscribeToGame($0.SubscribeRequest request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$subscribeToGame, $async.Stream.fromIterable([request]), options: options);
  }

  $grpc.ResponseFuture<$1.Empty> performAction($0.GameAction request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$performAction, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> requestPause($0.PauseRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$requestPause, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> resumeGame($0.PauseRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$resumeGame, request, options: options);
  }
}

@$pb.GrpcServiceName('werewolf.GameService')
abstract class GameServiceBase extends $grpc.Service {
  $core.String get $name => 'werewolf.GameService';

  GameServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CreateLobbyRequest, $0.LobbyInfo>(
        'CreateLobby',
        createLobby_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CreateLobbyRequest.fromBuffer(value),
        ($0.LobbyInfo value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.JoinRequest, $0.LobbyInfo>(
        'JoinLobby',
        joinLobby_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.JoinRequest.fromBuffer(value),
        ($0.LobbyInfo value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StartGameRequest, $1.Empty>(
        'StartGame',
        startGame_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.StartGameRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SubscribeRequest, $0.GameUpdate>(
        'SubscribeToGame',
        subscribeToGame_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.SubscribeRequest.fromBuffer(value),
        ($0.GameUpdate value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GameAction, $1.Empty>(
        'PerformAction',
        performAction_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GameAction.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PauseRequest, $1.Empty>(
        'RequestPause',
        requestPause_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.PauseRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PauseRequest, $1.Empty>(
        'ResumeGame',
        resumeGame_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.PauseRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
  }

  $async.Future<$0.LobbyInfo> createLobby_Pre($grpc.ServiceCall call, $async.Future<$0.CreateLobbyRequest> request) async {
    return createLobby(call, await request);
  }

  $async.Future<$0.LobbyInfo> joinLobby_Pre($grpc.ServiceCall call, $async.Future<$0.JoinRequest> request) async {
    return joinLobby(call, await request);
  }

  $async.Future<$1.Empty> startGame_Pre($grpc.ServiceCall call, $async.Future<$0.StartGameRequest> request) async {
    return startGame(call, await request);
  }

  $async.Stream<$0.GameUpdate> subscribeToGame_Pre($grpc.ServiceCall call, $async.Future<$0.SubscribeRequest> request) async* {
    yield* subscribeToGame(call, await request);
  }

  $async.Future<$1.Empty> performAction_Pre($grpc.ServiceCall call, $async.Future<$0.GameAction> request) async {
    return performAction(call, await request);
  }

  $async.Future<$1.Empty> requestPause_Pre($grpc.ServiceCall call, $async.Future<$0.PauseRequest> request) async {
    return requestPause(call, await request);
  }

  $async.Future<$1.Empty> resumeGame_Pre($grpc.ServiceCall call, $async.Future<$0.PauseRequest> request) async {
    return resumeGame(call, await request);
  }

  $async.Future<$0.LobbyInfo> createLobby($grpc.ServiceCall call, $0.CreateLobbyRequest request);
  $async.Future<$0.LobbyInfo> joinLobby($grpc.ServiceCall call, $0.JoinRequest request);
  $async.Future<$1.Empty> startGame($grpc.ServiceCall call, $0.StartGameRequest request);
  $async.Stream<$0.GameUpdate> subscribeToGame($grpc.ServiceCall call, $0.SubscribeRequest request);
  $async.Future<$1.Empty> performAction($grpc.ServiceCall call, $0.GameAction request);
  $async.Future<$1.Empty> requestPause($grpc.ServiceCall call, $0.PauseRequest request);
  $async.Future<$1.Empty> resumeGame($grpc.ServiceCall call, $0.PauseRequest request);
}
