//
//  Generated code. Do not modify.
//  source: werwolf.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'google/protobuf/timestamp.pb.dart' as $2;
import 'werwolf.pbenum.dart';

export 'werwolf.pbenum.dart';

class UserProfile extends $pb.GeneratedMessage {
  factory UserProfile({
    $core.String? userId,
    $core.String? username,
    $core.int? score,
    $core.String? avatar,
  }) {
    final $result = create();
    if (userId != null) {
      $result.userId = userId;
    }
    if (username != null) {
      $result.username = username;
    }
    if (score != null) {
      $result.score = score;
    }
    if (avatar != null) {
      $result.avatar = avatar;
    }
    return $result;
  }
  UserProfile._() : super();
  factory UserProfile.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UserProfile.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UserProfile', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'username')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'score', $pb.PbFieldType.O3)
    ..aOS(4, _omitFieldNames ? '' : 'avatar')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UserProfile clone() => UserProfile()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UserProfile copyWith(void Function(UserProfile) updates) => super.copyWith((message) => updates(message as UserProfile)) as UserProfile;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserProfile create() => UserProfile._();
  UserProfile createEmptyInstance() => create();
  static $pb.PbList<UserProfile> createRepeated() => $pb.PbList<UserProfile>();
  @$core.pragma('dart2js:noInline')
  static UserProfile getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserProfile>(create);
  static UserProfile? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get username => $_getSZ(1);
  @$pb.TagNumber(2)
  set username($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUsername() => $_has(1);
  @$pb.TagNumber(2)
  void clearUsername() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get score => $_getIZ(2);
  @$pb.TagNumber(3)
  set score($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasScore() => $_has(2);
  @$pb.TagNumber(3)
  void clearScore() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get avatar => $_getSZ(3);
  @$pb.TagNumber(4)
  set avatar($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAvatar() => $_has(3);
  @$pb.TagNumber(4)
  void clearAvatar() => clearField(4);
}

class LoginRequest extends $pb.GeneratedMessage {
  factory LoginRequest({
    $core.String? username,
    $core.String? password,
  }) {
    final $result = create();
    if (username != null) {
      $result.username = username;
    }
    if (password != null) {
      $result.password = password;
    }
    return $result;
  }
  LoginRequest._() : super();
  factory LoginRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoginRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoginRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'username')
    ..aOS(2, _omitFieldNames ? '' : 'password')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoginRequest clone() => LoginRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoginRequest copyWith(void Function(LoginRequest) updates) => super.copyWith((message) => updates(message as LoginRequest)) as LoginRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoginRequest create() => LoginRequest._();
  LoginRequest createEmptyInstance() => create();
  static $pb.PbList<LoginRequest> createRepeated() => $pb.PbList<LoginRequest>();
  @$core.pragma('dart2js:noInline')
  static LoginRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoginRequest>(create);
  static LoginRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get username => $_getSZ(0);
  @$pb.TagNumber(1)
  set username($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUsername() => $_has(0);
  @$pb.TagNumber(1)
  void clearUsername() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get password => $_getSZ(1);
  @$pb.TagNumber(2)
  set password($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassword() => clearField(2);
}

class LoginResponse extends $pb.GeneratedMessage {
  factory LoginResponse({
    $core.String? token,
    UserProfile? profile,
  }) {
    final $result = create();
    if (token != null) {
      $result.token = token;
    }
    if (profile != null) {
      $result.profile = profile;
    }
    return $result;
  }
  LoginResponse._() : super();
  factory LoginResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoginResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoginResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'token')
    ..aOM<UserProfile>(2, _omitFieldNames ? '' : 'profile', subBuilder: UserProfile.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoginResponse clone() => LoginResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoginResponse copyWith(void Function(LoginResponse) updates) => super.copyWith((message) => updates(message as LoginResponse)) as LoginResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoginResponse create() => LoginResponse._();
  LoginResponse createEmptyInstance() => create();
  static $pb.PbList<LoginResponse> createRepeated() => $pb.PbList<LoginResponse>();
  @$core.pragma('dart2js:noInline')
  static LoginResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoginResponse>(create);
  static LoginResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => clearField(1);

  @$pb.TagNumber(2)
  UserProfile get profile => $_getN(1);
  @$pb.TagNumber(2)
  set profile(UserProfile v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasProfile() => $_has(1);
  @$pb.TagNumber(2)
  void clearProfile() => clearField(2);
  @$pb.TagNumber(2)
  UserProfile ensureProfile() => $_ensure(1);
}

class RegisterRequest extends $pb.GeneratedMessage {
  factory RegisterRequest({
    $core.String? username,
    $core.String? email,
    $core.String? password,
  }) {
    final $result = create();
    if (username != null) {
      $result.username = username;
    }
    if (email != null) {
      $result.email = email;
    }
    if (password != null) {
      $result.password = password;
    }
    return $result;
  }
  RegisterRequest._() : super();
  factory RegisterRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RegisterRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RegisterRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'username')
    ..aOS(2, _omitFieldNames ? '' : 'email')
    ..aOS(3, _omitFieldNames ? '' : 'password')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RegisterRequest clone() => RegisterRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RegisterRequest copyWith(void Function(RegisterRequest) updates) => super.copyWith((message) => updates(message as RegisterRequest)) as RegisterRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterRequest create() => RegisterRequest._();
  RegisterRequest createEmptyInstance() => create();
  static $pb.PbList<RegisterRequest> createRepeated() => $pb.PbList<RegisterRequest>();
  @$core.pragma('dart2js:noInline')
  static RegisterRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RegisterRequest>(create);
  static RegisterRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get username => $_getSZ(0);
  @$pb.TagNumber(1)
  set username($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUsername() => $_has(0);
  @$pb.TagNumber(1)
  void clearUsername() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get email => $_getSZ(1);
  @$pb.TagNumber(2)
  set email($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasEmail() => $_has(1);
  @$pb.TagNumber(2)
  void clearEmail() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get password => $_getSZ(2);
  @$pb.TagNumber(3)
  set password($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPassword() => $_has(2);
  @$pb.TagNumber(3)
  void clearPassword() => clearField(3);
}

class ProfileRequest extends $pb.GeneratedMessage {
  factory ProfileRequest({
    $core.String? targetUserId,
  }) {
    final $result = create();
    if (targetUserId != null) {
      $result.targetUserId = targetUserId;
    }
    return $result;
  }
  ProfileRequest._() : super();
  factory ProfileRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ProfileRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ProfileRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'targetUserId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ProfileRequest clone() => ProfileRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ProfileRequest copyWith(void Function(ProfileRequest) updates) => super.copyWith((message) => updates(message as ProfileRequest)) as ProfileRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProfileRequest create() => ProfileRequest._();
  ProfileRequest createEmptyInstance() => create();
  static $pb.PbList<ProfileRequest> createRepeated() => $pb.PbList<ProfileRequest>();
  @$core.pragma('dart2js:noInline')
  static ProfileRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProfileRequest>(create);
  static ProfileRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get targetUserId => $_getSZ(0);
  @$pb.TagNumber(1)
  set targetUserId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTargetUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTargetUserId() => clearField(1);
}

class UpdateAvatarRequest extends $pb.GeneratedMessage {
  factory UpdateAvatarRequest({
    $core.String? avatar,
  }) {
    final $result = create();
    if (avatar != null) {
      $result.avatar = avatar;
    }
    return $result;
  }
  UpdateAvatarRequest._() : super();
  factory UpdateAvatarRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateAvatarRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateAvatarRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'avatar')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateAvatarRequest clone() => UpdateAvatarRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateAvatarRequest copyWith(void Function(UpdateAvatarRequest) updates) => super.copyWith((message) => updates(message as UpdateAvatarRequest)) as UpdateAvatarRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateAvatarRequest create() => UpdateAvatarRequest._();
  UpdateAvatarRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateAvatarRequest> createRepeated() => $pb.PbList<UpdateAvatarRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateAvatarRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateAvatarRequest>(create);
  static UpdateAvatarRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get avatar => $_getSZ(0);
  @$pb.TagNumber(1)
  set avatar($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAvatar() => $_has(0);
  @$pb.TagNumber(1)
  void clearAvatar() => clearField(1);
}

class RoleCount extends $pb.GeneratedMessage {
  factory RoleCount({
    Role? role,
    $core.int? count,
  }) {
    final $result = create();
    if (role != null) {
      $result.role = role;
    }
    if (count != null) {
      $result.count = count;
    }
    return $result;
  }
  RoleCount._() : super();
  factory RoleCount.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RoleCount.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RoleCount', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..e<Role>(1, _omitFieldNames ? '' : 'role', $pb.PbFieldType.OE, defaultOrMaker: Role.ROLE_UNSPECIFIED, valueOf: Role.valueOf, enumValues: Role.values)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'count', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RoleCount clone() => RoleCount()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RoleCount copyWith(void Function(RoleCount) updates) => super.copyWith((message) => updates(message as RoleCount)) as RoleCount;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoleCount create() => RoleCount._();
  RoleCount createEmptyInstance() => create();
  static $pb.PbList<RoleCount> createRepeated() => $pb.PbList<RoleCount>();
  @$core.pragma('dart2js:noInline')
  static RoleCount getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RoleCount>(create);
  static RoleCount? _defaultInstance;

  @$pb.TagNumber(1)
  Role get role => $_getN(0);
  @$pb.TagNumber(1)
  set role(Role v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasRole() => $_has(0);
  @$pb.TagNumber(1)
  void clearRole() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get count => $_getIZ(1);
  @$pb.TagNumber(2)
  set count($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearCount() => clearField(2);
}

class LobbySettings extends $pb.GeneratedMessage {
  factory LobbySettings({
    $core.int? maxPlayers,
    $core.Iterable<RoleCount>? roles,
    $core.int? discussionTimeSeconds,
  }) {
    final $result = create();
    if (maxPlayers != null) {
      $result.maxPlayers = maxPlayers;
    }
    if (roles != null) {
      $result.roles.addAll(roles);
    }
    if (discussionTimeSeconds != null) {
      $result.discussionTimeSeconds = discussionTimeSeconds;
    }
    return $result;
  }
  LobbySettings._() : super();
  factory LobbySettings.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LobbySettings.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LobbySettings', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'maxPlayers', $pb.PbFieldType.O3)
    ..pc<RoleCount>(2, _omitFieldNames ? '' : 'roles', $pb.PbFieldType.PM, subBuilder: RoleCount.create)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'discussionTimeSeconds', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LobbySettings clone() => LobbySettings()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LobbySettings copyWith(void Function(LobbySettings) updates) => super.copyWith((message) => updates(message as LobbySettings)) as LobbySettings;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LobbySettings create() => LobbySettings._();
  LobbySettings createEmptyInstance() => create();
  static $pb.PbList<LobbySettings> createRepeated() => $pb.PbList<LobbySettings>();
  @$core.pragma('dart2js:noInline')
  static LobbySettings getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LobbySettings>(create);
  static LobbySettings? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get maxPlayers => $_getIZ(0);
  @$pb.TagNumber(1)
  set maxPlayers($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMaxPlayers() => $_has(0);
  @$pb.TagNumber(1)
  void clearMaxPlayers() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<RoleCount> get roles => $_getList(1);

  @$pb.TagNumber(3)
  $core.int get discussionTimeSeconds => $_getIZ(2);
  @$pb.TagNumber(3)
  set discussionTimeSeconds($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDiscussionTimeSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearDiscussionTimeSeconds() => clearField(3);
}

class CreateLobbyRequest extends $pb.GeneratedMessage {
  factory CreateLobbyRequest({
    LobbySettings? settings,
  }) {
    final $result = create();
    if (settings != null) {
      $result.settings = settings;
    }
    return $result;
  }
  CreateLobbyRequest._() : super();
  factory CreateLobbyRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateLobbyRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateLobbyRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..aOM<LobbySettings>(1, _omitFieldNames ? '' : 'settings', subBuilder: LobbySettings.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateLobbyRequest clone() => CreateLobbyRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateLobbyRequest copyWith(void Function(CreateLobbyRequest) updates) => super.copyWith((message) => updates(message as CreateLobbyRequest)) as CreateLobbyRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateLobbyRequest create() => CreateLobbyRequest._();
  CreateLobbyRequest createEmptyInstance() => create();
  static $pb.PbList<CreateLobbyRequest> createRepeated() => $pb.PbList<CreateLobbyRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateLobbyRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateLobbyRequest>(create);
  static CreateLobbyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  LobbySettings get settings => $_getN(0);
  @$pb.TagNumber(1)
  set settings(LobbySettings v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSettings() => $_has(0);
  @$pb.TagNumber(1)
  void clearSettings() => clearField(1);
  @$pb.TagNumber(1)
  LobbySettings ensureSettings() => $_ensure(0);
}

class JoinRequest extends $pb.GeneratedMessage {
  factory JoinRequest({
    $core.String? lobbyCode,
  }) {
    final $result = create();
    if (lobbyCode != null) {
      $result.lobbyCode = lobbyCode;
    }
    return $result;
  }
  JoinRequest._() : super();
  factory JoinRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory JoinRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'JoinRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'lobbyCode')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  JoinRequest clone() => JoinRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  JoinRequest copyWith(void Function(JoinRequest) updates) => super.copyWith((message) => updates(message as JoinRequest)) as JoinRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static JoinRequest create() => JoinRequest._();
  JoinRequest createEmptyInstance() => create();
  static $pb.PbList<JoinRequest> createRepeated() => $pb.PbList<JoinRequest>();
  @$core.pragma('dart2js:noInline')
  static JoinRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<JoinRequest>(create);
  static JoinRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get lobbyCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set lobbyCode($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLobbyCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearLobbyCode() => clearField(1);
}

class StartGameRequest extends $pb.GeneratedMessage {
  factory StartGameRequest({
    $core.String? lobbyCode,
  }) {
    final $result = create();
    if (lobbyCode != null) {
      $result.lobbyCode = lobbyCode;
    }
    return $result;
  }
  StartGameRequest._() : super();
  factory StartGameRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StartGameRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'StartGameRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'lobbyCode')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StartGameRequest clone() => StartGameRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StartGameRequest copyWith(void Function(StartGameRequest) updates) => super.copyWith((message) => updates(message as StartGameRequest)) as StartGameRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartGameRequest create() => StartGameRequest._();
  StartGameRequest createEmptyInstance() => create();
  static $pb.PbList<StartGameRequest> createRepeated() => $pb.PbList<StartGameRequest>();
  @$core.pragma('dart2js:noInline')
  static StartGameRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StartGameRequest>(create);
  static StartGameRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get lobbyCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set lobbyCode($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLobbyCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearLobbyCode() => clearField(1);
}

class LobbyInfo extends $pb.GeneratedMessage {
  factory LobbyInfo({
    $core.String? lobbyCode,
    $core.Iterable<PlayerStatus>? players,
    $core.bool? canStart,
    $core.String? hostId,
    LobbySettings? settings,
  }) {
    final $result = create();
    if (lobbyCode != null) {
      $result.lobbyCode = lobbyCode;
    }
    if (players != null) {
      $result.players.addAll(players);
    }
    if (canStart != null) {
      $result.canStart = canStart;
    }
    if (hostId != null) {
      $result.hostId = hostId;
    }
    if (settings != null) {
      $result.settings = settings;
    }
    return $result;
  }
  LobbyInfo._() : super();
  factory LobbyInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LobbyInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LobbyInfo', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'lobbyCode')
    ..pc<PlayerStatus>(2, _omitFieldNames ? '' : 'players', $pb.PbFieldType.PM, subBuilder: PlayerStatus.create)
    ..aOB(3, _omitFieldNames ? '' : 'canStart')
    ..aOS(4, _omitFieldNames ? '' : 'hostId')
    ..aOM<LobbySettings>(5, _omitFieldNames ? '' : 'settings', subBuilder: LobbySettings.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LobbyInfo clone() => LobbyInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LobbyInfo copyWith(void Function(LobbyInfo) updates) => super.copyWith((message) => updates(message as LobbyInfo)) as LobbyInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LobbyInfo create() => LobbyInfo._();
  LobbyInfo createEmptyInstance() => create();
  static $pb.PbList<LobbyInfo> createRepeated() => $pb.PbList<LobbyInfo>();
  @$core.pragma('dart2js:noInline')
  static LobbyInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LobbyInfo>(create);
  static LobbyInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get lobbyCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set lobbyCode($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLobbyCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearLobbyCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<PlayerStatus> get players => $_getList(1);

  @$pb.TagNumber(3)
  $core.bool get canStart => $_getBF(2);
  @$pb.TagNumber(3)
  set canStart($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCanStart() => $_has(2);
  @$pb.TagNumber(3)
  void clearCanStart() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get hostId => $_getSZ(3);
  @$pb.TagNumber(4)
  set hostId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasHostId() => $_has(3);
  @$pb.TagNumber(4)
  void clearHostId() => clearField(4);

  @$pb.TagNumber(5)
  LobbySettings get settings => $_getN(4);
  @$pb.TagNumber(5)
  set settings(LobbySettings v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasSettings() => $_has(4);
  @$pb.TagNumber(5)
  void clearSettings() => clearField(5);
  @$pb.TagNumber(5)
  LobbySettings ensureSettings() => $_ensure(4);
}

class SubscribeRequest extends $pb.GeneratedMessage {
  factory SubscribeRequest({
    $core.String? lobbyCode,
  }) {
    final $result = create();
    if (lobbyCode != null) {
      $result.lobbyCode = lobbyCode;
    }
    return $result;
  }
  SubscribeRequest._() : super();
  factory SubscribeRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SubscribeRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SubscribeRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'lobbyCode')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SubscribeRequest clone() => SubscribeRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SubscribeRequest copyWith(void Function(SubscribeRequest) updates) => super.copyWith((message) => updates(message as SubscribeRequest)) as SubscribeRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubscribeRequest create() => SubscribeRequest._();
  SubscribeRequest createEmptyInstance() => create();
  static $pb.PbList<SubscribeRequest> createRepeated() => $pb.PbList<SubscribeRequest>();
  @$core.pragma('dart2js:noInline')
  static SubscribeRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubscribeRequest>(create);
  static SubscribeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get lobbyCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set lobbyCode($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLobbyCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearLobbyCode() => clearField(1);
}

class GameUpdate extends $pb.GeneratedMessage {
  factory GameUpdate({
    Phase? currentPhase,
    $core.Iterable<PlayerStatus>? players,
    Role? winningTeam,
    Role? yourRole,
    ActionPrompt? openPrompt,
    ActionResult? yourResults,
    PublicAnnouncement? announcement,
    $2.Timestamp? phaseEndsAt,
    PauseState? pause,
    $core.bool? youAreSabotaged,
    $core.String? loverPartnerId,
    $core.bool? youMustTakeRevenge,
  }) {
    final $result = create();
    if (currentPhase != null) {
      $result.currentPhase = currentPhase;
    }
    if (players != null) {
      $result.players.addAll(players);
    }
    if (winningTeam != null) {
      $result.winningTeam = winningTeam;
    }
    if (yourRole != null) {
      $result.yourRole = yourRole;
    }
    if (openPrompt != null) {
      $result.openPrompt = openPrompt;
    }
    if (yourResults != null) {
      $result.yourResults = yourResults;
    }
    if (announcement != null) {
      $result.announcement = announcement;
    }
    if (phaseEndsAt != null) {
      $result.phaseEndsAt = phaseEndsAt;
    }
    if (pause != null) {
      $result.pause = pause;
    }
    if (youAreSabotaged != null) {
      $result.youAreSabotaged = youAreSabotaged;
    }
    if (loverPartnerId != null) {
      $result.loverPartnerId = loverPartnerId;
    }
    if (youMustTakeRevenge != null) {
      $result.youMustTakeRevenge = youMustTakeRevenge;
    }
    return $result;
  }
  GameUpdate._() : super();
  factory GameUpdate.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GameUpdate.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GameUpdate', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..e<Phase>(1, _omitFieldNames ? '' : 'currentPhase', $pb.PbFieldType.OE, defaultOrMaker: Phase.PHASE_UNSPECIFIED, valueOf: Phase.valueOf, enumValues: Phase.values)
    ..pc<PlayerStatus>(4, _omitFieldNames ? '' : 'players', $pb.PbFieldType.PM, subBuilder: PlayerStatus.create)
    ..e<Role>(7, _omitFieldNames ? '' : 'winningTeam', $pb.PbFieldType.OE, defaultOrMaker: Role.ROLE_UNSPECIFIED, valueOf: Role.valueOf, enumValues: Role.values)
    ..e<Role>(8, _omitFieldNames ? '' : 'yourRole', $pb.PbFieldType.OE, defaultOrMaker: Role.ROLE_UNSPECIFIED, valueOf: Role.valueOf, enumValues: Role.values)
    ..aOM<ActionPrompt>(9, _omitFieldNames ? '' : 'openPrompt', subBuilder: ActionPrompt.create)
    ..aOM<ActionResult>(10, _omitFieldNames ? '' : 'yourResults', subBuilder: ActionResult.create)
    ..aOM<PublicAnnouncement>(11, _omitFieldNames ? '' : 'announcement', subBuilder: PublicAnnouncement.create)
    ..aOM<$2.Timestamp>(12, _omitFieldNames ? '' : 'phaseEndsAt', subBuilder: $2.Timestamp.create)
    ..aOM<PauseState>(13, _omitFieldNames ? '' : 'pause', subBuilder: PauseState.create)
    ..aOB(14, _omitFieldNames ? '' : 'youAreSabotaged')
    ..aOS(15, _omitFieldNames ? '' : 'loverPartnerId')
    ..aOB(16, _omitFieldNames ? '' : 'youMustTakeRevenge')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GameUpdate clone() => GameUpdate()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GameUpdate copyWith(void Function(GameUpdate) updates) => super.copyWith((message) => updates(message as GameUpdate)) as GameUpdate;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GameUpdate create() => GameUpdate._();
  GameUpdate createEmptyInstance() => create();
  static $pb.PbList<GameUpdate> createRepeated() => $pb.PbList<GameUpdate>();
  @$core.pragma('dart2js:noInline')
  static GameUpdate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GameUpdate>(create);
  static GameUpdate? _defaultInstance;

  @$pb.TagNumber(1)
  Phase get currentPhase => $_getN(0);
  @$pb.TagNumber(1)
  set currentPhase(Phase v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCurrentPhase() => $_has(0);
  @$pb.TagNumber(1)
  void clearCurrentPhase() => clearField(1);

  @$pb.TagNumber(4)
  $core.List<PlayerStatus> get players => $_getList(1);

  @$pb.TagNumber(7)
  Role get winningTeam => $_getN(2);
  @$pb.TagNumber(7)
  set winningTeam(Role v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasWinningTeam() => $_has(2);
  @$pb.TagNumber(7)
  void clearWinningTeam() => clearField(7);

  /// empty in shared broadcasts, populated in personalised snapshots
  @$pb.TagNumber(8)
  Role get yourRole => $_getN(3);
  @$pb.TagNumber(8)
  set yourRole(Role v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasYourRole() => $_has(3);
  @$pb.TagNumber(8)
  void clearYourRole() => clearField(8);

  @$pb.TagNumber(9)
  ActionPrompt get openPrompt => $_getN(4);
  @$pb.TagNumber(9)
  set openPrompt(ActionPrompt v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasOpenPrompt() => $_has(4);
  @$pb.TagNumber(9)
  void clearOpenPrompt() => clearField(9);
  @$pb.TagNumber(9)
  ActionPrompt ensureOpenPrompt() => $_ensure(4);

  @$pb.TagNumber(10)
  ActionResult get yourResults => $_getN(5);
  @$pb.TagNumber(10)
  set yourResults(ActionResult v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasYourResults() => $_has(5);
  @$pb.TagNumber(10)
  void clearYourResults() => clearField(10);
  @$pb.TagNumber(10)
  ActionResult ensureYourResults() => $_ensure(5);

  @$pb.TagNumber(11)
  PublicAnnouncement get announcement => $_getN(6);
  @$pb.TagNumber(11)
  set announcement(PublicAnnouncement v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasAnnouncement() => $_has(6);
  @$pb.TagNumber(11)
  void clearAnnouncement() => clearField(11);
  @$pb.TagNumber(11)
  PublicAnnouncement ensureAnnouncement() => $_ensure(6);

  @$pb.TagNumber(12)
  $2.Timestamp get phaseEndsAt => $_getN(7);
  @$pb.TagNumber(12)
  set phaseEndsAt($2.Timestamp v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasPhaseEndsAt() => $_has(7);
  @$pb.TagNumber(12)
  void clearPhaseEndsAt() => clearField(12);
  @$pb.TagNumber(12)
  $2.Timestamp ensurePhaseEndsAt() => $_ensure(7);

  @$pb.TagNumber(13)
  PauseState get pause => $_getN(8);
  @$pb.TagNumber(13)
  set pause(PauseState v) { setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasPause() => $_has(8);
  @$pb.TagNumber(13)
  void clearPause() => clearField(13);
  @$pb.TagNumber(13)
  PauseState ensurePause() => $_ensure(8);

  /// true only for the player the saboteur silenced: they sit out this day's
  /// discussion and vote (their day vote is discarded server-side)
  @$pb.TagNumber(14)
  $core.bool get youAreSabotaged => $_getBF(9);
  @$pb.TagNumber(14)
  set youAreSabotaged($core.bool v) { $_setBool(9, v); }
  @$pb.TagNumber(14)
  $core.bool hasYouAreSabotaged() => $_has(9);
  @$pb.TagNumber(14)
  void clearYouAreSabotaged() => clearField(14);

  /// set only in a lover's own snapshot: the id of the player they are in love
  /// with (empty for everyone else). Lets each lover privately know their partner.
  @$pb.TagNumber(15)
  $core.String get loverPartnerId => $_getSZ(10);
  @$pb.TagNumber(15)
  set loverPartnerId($core.String v) { $_setString(10, v); }
  @$pb.TagNumber(15)
  $core.bool hasLoverPartnerId() => $_has(10);
  @$pb.TagNumber(15)
  void clearLoverPartnerId() => clearField(15);

  /// true only for a just-killed hunter who still owes a revenge shot, keeps the
  /// client on the revenge screen instead of latching the death screen
  @$pb.TagNumber(16)
  $core.bool get youMustTakeRevenge => $_getBF(11);
  @$pb.TagNumber(16)
  set youMustTakeRevenge($core.bool v) { $_setBool(11, v); }
  @$pb.TagNumber(16)
  $core.bool hasYouMustTakeRevenge() => $_has(11);
  @$pb.TagNumber(16)
  void clearYouMustTakeRevenge() => clearField(16);
}

class PlayerStatus extends $pb.GeneratedMessage {
  factory PlayerStatus({
    $core.String? id,
    $core.String? name,
    $core.bool? isAlive,
    $core.bool? hasVoted,
    $core.String? votedForTargetId,
    Role? role,
    $core.bool? isHost,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (name != null) {
      $result.name = name;
    }
    if (isAlive != null) {
      $result.isAlive = isAlive;
    }
    if (hasVoted != null) {
      $result.hasVoted = hasVoted;
    }
    if (votedForTargetId != null) {
      $result.votedForTargetId = votedForTargetId;
    }
    if (role != null) {
      $result.role = role;
    }
    if (isHost != null) {
      $result.isHost = isHost;
    }
    return $result;
  }
  PlayerStatus._() : super();
  factory PlayerStatus.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PlayerStatus.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PlayerStatus', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOB(3, _omitFieldNames ? '' : 'isAlive')
    ..aOB(4, _omitFieldNames ? '' : 'hasVoted')
    ..aOS(5, _omitFieldNames ? '' : 'votedForTargetId')
    ..e<Role>(6, _omitFieldNames ? '' : 'role', $pb.PbFieldType.OE, defaultOrMaker: Role.ROLE_UNSPECIFIED, valueOf: Role.valueOf, enumValues: Role.values)
    ..aOB(7, _omitFieldNames ? '' : 'isHost')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PlayerStatus clone() => PlayerStatus()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PlayerStatus copyWith(void Function(PlayerStatus) updates) => super.copyWith((message) => updates(message as PlayerStatus)) as PlayerStatus;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayerStatus create() => PlayerStatus._();
  PlayerStatus createEmptyInstance() => create();
  static $pb.PbList<PlayerStatus> createRepeated() => $pb.PbList<PlayerStatus>();
  @$core.pragma('dart2js:noInline')
  static PlayerStatus getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PlayerStatus>(create);
  static PlayerStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isAlive => $_getBF(2);
  @$pb.TagNumber(3)
  set isAlive($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIsAlive() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsAlive() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get hasVoted => $_getBF(3);
  @$pb.TagNumber(4)
  set hasVoted($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasHasVoted() => $_has(3);
  @$pb.TagNumber(4)
  void clearHasVoted() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get votedForTargetId => $_getSZ(4);
  @$pb.TagNumber(5)
  set votedForTargetId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasVotedForTargetId() => $_has(4);
  @$pb.TagNumber(5)
  void clearVotedForTargetId() => clearField(5);

  @$pb.TagNumber(6)
  Role get role => $_getN(5);
  @$pb.TagNumber(6)
  set role(Role v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasRole() => $_has(5);
  @$pb.TagNumber(6)
  void clearRole() => clearField(6);

  @$pb.TagNumber(7)
  $core.bool get isHost => $_getBF(6);
  @$pb.TagNumber(7)
  set isHost($core.bool v) { $_setBool(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasIsHost() => $_has(6);
  @$pb.TagNumber(7)
  void clearIsHost() => clearField(7);
}

enum GameAction_Action {
  vote, 
  witch, 
  seer, 
  fox, 
  hunter, 
  cupid, 
  saboteur, 
  notSet
}

class GameAction extends $pb.GeneratedMessage {
  factory GameAction({
    $core.String? lobbyCode,
    VoteAction? vote,
    WitchAction? witch,
    SeerAction? seer,
    FoxAction? fox,
    HunterAction? hunter,
    CupidAction? cupid,
    SaboteurAction? saboteur,
  }) {
    final $result = create();
    if (lobbyCode != null) {
      $result.lobbyCode = lobbyCode;
    }
    if (vote != null) {
      $result.vote = vote;
    }
    if (witch != null) {
      $result.witch = witch;
    }
    if (seer != null) {
      $result.seer = seer;
    }
    if (fox != null) {
      $result.fox = fox;
    }
    if (hunter != null) {
      $result.hunter = hunter;
    }
    if (cupid != null) {
      $result.cupid = cupid;
    }
    if (saboteur != null) {
      $result.saboteur = saboteur;
    }
    return $result;
  }
  GameAction._() : super();
  factory GameAction.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GameAction.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, GameAction_Action> _GameAction_ActionByTag = {
    2 : GameAction_Action.vote,
    3 : GameAction_Action.witch,
    4 : GameAction_Action.seer,
    5 : GameAction_Action.fox,
    6 : GameAction_Action.hunter,
    7 : GameAction_Action.cupid,
    8 : GameAction_Action.saboteur,
    0 : GameAction_Action.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GameAction', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..oo(0, [2, 3, 4, 5, 6, 7, 8])
    ..aOS(1, _omitFieldNames ? '' : 'lobbyCode')
    ..aOM<VoteAction>(2, _omitFieldNames ? '' : 'vote', subBuilder: VoteAction.create)
    ..aOM<WitchAction>(3, _omitFieldNames ? '' : 'witch', subBuilder: WitchAction.create)
    ..aOM<SeerAction>(4, _omitFieldNames ? '' : 'seer', subBuilder: SeerAction.create)
    ..aOM<FoxAction>(5, _omitFieldNames ? '' : 'fox', subBuilder: FoxAction.create)
    ..aOM<HunterAction>(6, _omitFieldNames ? '' : 'hunter', subBuilder: HunterAction.create)
    ..aOM<CupidAction>(7, _omitFieldNames ? '' : 'cupid', subBuilder: CupidAction.create)
    ..aOM<SaboteurAction>(8, _omitFieldNames ? '' : 'saboteur', subBuilder: SaboteurAction.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GameAction clone() => GameAction()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GameAction copyWith(void Function(GameAction) updates) => super.copyWith((message) => updates(message as GameAction)) as GameAction;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GameAction create() => GameAction._();
  GameAction createEmptyInstance() => create();
  static $pb.PbList<GameAction> createRepeated() => $pb.PbList<GameAction>();
  @$core.pragma('dart2js:noInline')
  static GameAction getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GameAction>(create);
  static GameAction? _defaultInstance;

  GameAction_Action whichAction() => _GameAction_ActionByTag[$_whichOneof(0)]!;
  void clearAction() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get lobbyCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set lobbyCode($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLobbyCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearLobbyCode() => clearField(1);

  @$pb.TagNumber(2)
  VoteAction get vote => $_getN(1);
  @$pb.TagNumber(2)
  set vote(VoteAction v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasVote() => $_has(1);
  @$pb.TagNumber(2)
  void clearVote() => clearField(2);
  @$pb.TagNumber(2)
  VoteAction ensureVote() => $_ensure(1);

  @$pb.TagNumber(3)
  WitchAction get witch => $_getN(2);
  @$pb.TagNumber(3)
  set witch(WitchAction v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasWitch() => $_has(2);
  @$pb.TagNumber(3)
  void clearWitch() => clearField(3);
  @$pb.TagNumber(3)
  WitchAction ensureWitch() => $_ensure(2);

  @$pb.TagNumber(4)
  SeerAction get seer => $_getN(3);
  @$pb.TagNumber(4)
  set seer(SeerAction v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasSeer() => $_has(3);
  @$pb.TagNumber(4)
  void clearSeer() => clearField(4);
  @$pb.TagNumber(4)
  SeerAction ensureSeer() => $_ensure(3);

  @$pb.TagNumber(5)
  FoxAction get fox => $_getN(4);
  @$pb.TagNumber(5)
  set fox(FoxAction v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasFox() => $_has(4);
  @$pb.TagNumber(5)
  void clearFox() => clearField(5);
  @$pb.TagNumber(5)
  FoxAction ensureFox() => $_ensure(4);

  @$pb.TagNumber(6)
  HunterAction get hunter => $_getN(5);
  @$pb.TagNumber(6)
  set hunter(HunterAction v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasHunter() => $_has(5);
  @$pb.TagNumber(6)
  void clearHunter() => clearField(6);
  @$pb.TagNumber(6)
  HunterAction ensureHunter() => $_ensure(5);

  @$pb.TagNumber(7)
  CupidAction get cupid => $_getN(6);
  @$pb.TagNumber(7)
  set cupid(CupidAction v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasCupid() => $_has(6);
  @$pb.TagNumber(7)
  void clearCupid() => clearField(7);
  @$pb.TagNumber(7)
  CupidAction ensureCupid() => $_ensure(6);

  @$pb.TagNumber(8)
  SaboteurAction get saboteur => $_getN(7);
  @$pb.TagNumber(8)
  set saboteur(SaboteurAction v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasSaboteur() => $_has(7);
  @$pb.TagNumber(8)
  void clearSaboteur() => clearField(8);
  @$pb.TagNumber(8)
  SaboteurAction ensureSaboteur() => $_ensure(7);
}

class CupidAction extends $pb.GeneratedMessage {
  factory CupidAction({
    $core.String? player1Id,
    $core.String? player2Id,
  }) {
    final $result = create();
    if (player1Id != null) {
      $result.player1Id = player1Id;
    }
    if (player2Id != null) {
      $result.player2Id = player2Id;
    }
    return $result;
  }
  CupidAction._() : super();
  factory CupidAction.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CupidAction.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CupidAction', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'player1Id')
    ..aOS(2, _omitFieldNames ? '' : 'player2Id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CupidAction clone() => CupidAction()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CupidAction copyWith(void Function(CupidAction) updates) => super.copyWith((message) => updates(message as CupidAction)) as CupidAction;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CupidAction create() => CupidAction._();
  CupidAction createEmptyInstance() => create();
  static $pb.PbList<CupidAction> createRepeated() => $pb.PbList<CupidAction>();
  @$core.pragma('dart2js:noInline')
  static CupidAction getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CupidAction>(create);
  static CupidAction? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get player1Id => $_getSZ(0);
  @$pb.TagNumber(1)
  set player1Id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPlayer1Id() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlayer1Id() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get player2Id => $_getSZ(1);
  @$pb.TagNumber(2)
  set player2Id($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPlayer2Id() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlayer2Id() => clearField(2);
}

class VoteAction extends $pb.GeneratedMessage {
  factory VoteAction({
    $core.String? targetId,
  }) {
    final $result = create();
    if (targetId != null) {
      $result.targetId = targetId;
    }
    return $result;
  }
  VoteAction._() : super();
  factory VoteAction.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VoteAction.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'VoteAction', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'targetId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VoteAction clone() => VoteAction()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VoteAction copyWith(void Function(VoteAction) updates) => super.copyWith((message) => updates(message as VoteAction)) as VoteAction;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VoteAction create() => VoteAction._();
  VoteAction createEmptyInstance() => create();
  static $pb.PbList<VoteAction> createRepeated() => $pb.PbList<VoteAction>();
  @$core.pragma('dart2js:noInline')
  static VoteAction getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VoteAction>(create);
  static VoteAction? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get targetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set targetId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTargetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTargetId() => clearField(1);
}

class WitchAction extends $pb.GeneratedMessage {
  factory WitchAction({
    $core.bool? healTarget,
    $core.String? poisonTargetId,
  }) {
    final $result = create();
    if (healTarget != null) {
      $result.healTarget = healTarget;
    }
    if (poisonTargetId != null) {
      $result.poisonTargetId = poisonTargetId;
    }
    return $result;
  }
  WitchAction._() : super();
  factory WitchAction.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WitchAction.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'WitchAction', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'healTarget')
    ..aOS(2, _omitFieldNames ? '' : 'poisonTargetId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WitchAction clone() => WitchAction()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WitchAction copyWith(void Function(WitchAction) updates) => super.copyWith((message) => updates(message as WitchAction)) as WitchAction;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WitchAction create() => WitchAction._();
  WitchAction createEmptyInstance() => create();
  static $pb.PbList<WitchAction> createRepeated() => $pb.PbList<WitchAction>();
  @$core.pragma('dart2js:noInline')
  static WitchAction getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WitchAction>(create);
  static WitchAction? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get healTarget => $_getBF(0);
  @$pb.TagNumber(1)
  set healTarget($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasHealTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearHealTarget() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get poisonTargetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set poisonTargetId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPoisonTargetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPoisonTargetId() => clearField(2);
}

class SeerAction extends $pb.GeneratedMessage {
  factory SeerAction({
    $core.String? targetId,
  }) {
    final $result = create();
    if (targetId != null) {
      $result.targetId = targetId;
    }
    return $result;
  }
  SeerAction._() : super();
  factory SeerAction.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SeerAction.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SeerAction', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'targetId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SeerAction clone() => SeerAction()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SeerAction copyWith(void Function(SeerAction) updates) => super.copyWith((message) => updates(message as SeerAction)) as SeerAction;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SeerAction create() => SeerAction._();
  SeerAction createEmptyInstance() => create();
  static $pb.PbList<SeerAction> createRepeated() => $pb.PbList<SeerAction>();
  @$core.pragma('dart2js:noInline')
  static SeerAction getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SeerAction>(create);
  static SeerAction? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get targetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set targetId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTargetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTargetId() => clearField(1);
}

class FoxAction extends $pb.GeneratedMessage {
  factory FoxAction({
    $core.Iterable<$core.String>? targetIds,
  }) {
    final $result = create();
    if (targetIds != null) {
      $result.targetIds.addAll(targetIds);
    }
    return $result;
  }
  FoxAction._() : super();
  factory FoxAction.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FoxAction.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FoxAction', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'targetIds')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FoxAction clone() => FoxAction()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FoxAction copyWith(void Function(FoxAction) updates) => super.copyWith((message) => updates(message as FoxAction)) as FoxAction;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FoxAction create() => FoxAction._();
  FoxAction createEmptyInstance() => create();
  static $pb.PbList<FoxAction> createRepeated() => $pb.PbList<FoxAction>();
  @$core.pragma('dart2js:noInline')
  static FoxAction getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FoxAction>(create);
  static FoxAction? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get targetIds => $_getList(0);
}

class SaboteurAction extends $pb.GeneratedMessage {
  factory SaboteurAction({
    $core.String? targetId,
  }) {
    final $result = create();
    if (targetId != null) {
      $result.targetId = targetId;
    }
    return $result;
  }
  SaboteurAction._() : super();
  factory SaboteurAction.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SaboteurAction.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SaboteurAction', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'targetId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SaboteurAction clone() => SaboteurAction()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SaboteurAction copyWith(void Function(SaboteurAction) updates) => super.copyWith((message) => updates(message as SaboteurAction)) as SaboteurAction;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SaboteurAction create() => SaboteurAction._();
  SaboteurAction createEmptyInstance() => create();
  static $pb.PbList<SaboteurAction> createRepeated() => $pb.PbList<SaboteurAction>();
  @$core.pragma('dart2js:noInline')
  static SaboteurAction getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SaboteurAction>(create);
  static SaboteurAction? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get targetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set targetId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTargetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTargetId() => clearField(1);
}

class HunterAction extends $pb.GeneratedMessage {
  factory HunterAction({
    $core.String? targetId,
  }) {
    final $result = create();
    if (targetId != null) {
      $result.targetId = targetId;
    }
    return $result;
  }
  HunterAction._() : super();
  factory HunterAction.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HunterAction.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'HunterAction', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'targetId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HunterAction clone() => HunterAction()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HunterAction copyWith(void Function(HunterAction) updates) => super.copyWith((message) => updates(message as HunterAction)) as HunterAction;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HunterAction create() => HunterAction._();
  HunterAction createEmptyInstance() => create();
  static $pb.PbList<HunterAction> createRepeated() => $pb.PbList<HunterAction>();
  @$core.pragma('dart2js:noInline')
  static HunterAction getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HunterAction>(create);
  static HunterAction? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get targetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set targetId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTargetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTargetId() => clearField(1);
}

enum ActionPrompt_Prompt {
  werewolf, 
  seer, 
  witch, 
  fox, 
  hunter, 
  saboteur, 
  cupid, 
  notSet
}

class ActionPrompt extends $pb.GeneratedMessage {
  factory ActionPrompt({
    WerewolfPrompt? werewolf,
    SeerPrompt? seer,
    WitchPrompt? witch,
    FoxPrompt? fox,
    HunterPrompt? hunter,
    SaboteurPrompt? saboteur,
    CupidPrompt? cupid,
  }) {
    final $result = create();
    if (werewolf != null) {
      $result.werewolf = werewolf;
    }
    if (seer != null) {
      $result.seer = seer;
    }
    if (witch != null) {
      $result.witch = witch;
    }
    if (fox != null) {
      $result.fox = fox;
    }
    if (hunter != null) {
      $result.hunter = hunter;
    }
    if (saboteur != null) {
      $result.saboteur = saboteur;
    }
    if (cupid != null) {
      $result.cupid = cupid;
    }
    return $result;
  }
  ActionPrompt._() : super();
  factory ActionPrompt.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ActionPrompt.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, ActionPrompt_Prompt> _ActionPrompt_PromptByTag = {
    1 : ActionPrompt_Prompt.werewolf,
    2 : ActionPrompt_Prompt.seer,
    3 : ActionPrompt_Prompt.witch,
    4 : ActionPrompt_Prompt.fox,
    5 : ActionPrompt_Prompt.hunter,
    6 : ActionPrompt_Prompt.saboteur,
    7 : ActionPrompt_Prompt.cupid,
    0 : ActionPrompt_Prompt.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ActionPrompt', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7])
    ..aOM<WerewolfPrompt>(1, _omitFieldNames ? '' : 'werewolf', subBuilder: WerewolfPrompt.create)
    ..aOM<SeerPrompt>(2, _omitFieldNames ? '' : 'seer', subBuilder: SeerPrompt.create)
    ..aOM<WitchPrompt>(3, _omitFieldNames ? '' : 'witch', subBuilder: WitchPrompt.create)
    ..aOM<FoxPrompt>(4, _omitFieldNames ? '' : 'fox', subBuilder: FoxPrompt.create)
    ..aOM<HunterPrompt>(5, _omitFieldNames ? '' : 'hunter', subBuilder: HunterPrompt.create)
    ..aOM<SaboteurPrompt>(6, _omitFieldNames ? '' : 'saboteur', subBuilder: SaboteurPrompt.create)
    ..aOM<CupidPrompt>(7, _omitFieldNames ? '' : 'cupid', subBuilder: CupidPrompt.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ActionPrompt clone() => ActionPrompt()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ActionPrompt copyWith(void Function(ActionPrompt) updates) => super.copyWith((message) => updates(message as ActionPrompt)) as ActionPrompt;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ActionPrompt create() => ActionPrompt._();
  ActionPrompt createEmptyInstance() => create();
  static $pb.PbList<ActionPrompt> createRepeated() => $pb.PbList<ActionPrompt>();
  @$core.pragma('dart2js:noInline')
  static ActionPrompt getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ActionPrompt>(create);
  static ActionPrompt? _defaultInstance;

  ActionPrompt_Prompt whichPrompt() => _ActionPrompt_PromptByTag[$_whichOneof(0)]!;
  void clearPrompt() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  WerewolfPrompt get werewolf => $_getN(0);
  @$pb.TagNumber(1)
  set werewolf(WerewolfPrompt v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasWerewolf() => $_has(0);
  @$pb.TagNumber(1)
  void clearWerewolf() => clearField(1);
  @$pb.TagNumber(1)
  WerewolfPrompt ensureWerewolf() => $_ensure(0);

  @$pb.TagNumber(2)
  SeerPrompt get seer => $_getN(1);
  @$pb.TagNumber(2)
  set seer(SeerPrompt v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasSeer() => $_has(1);
  @$pb.TagNumber(2)
  void clearSeer() => clearField(2);
  @$pb.TagNumber(2)
  SeerPrompt ensureSeer() => $_ensure(1);

  @$pb.TagNumber(3)
  WitchPrompt get witch => $_getN(2);
  @$pb.TagNumber(3)
  set witch(WitchPrompt v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasWitch() => $_has(2);
  @$pb.TagNumber(3)
  void clearWitch() => clearField(3);
  @$pb.TagNumber(3)
  WitchPrompt ensureWitch() => $_ensure(2);

  @$pb.TagNumber(4)
  FoxPrompt get fox => $_getN(3);
  @$pb.TagNumber(4)
  set fox(FoxPrompt v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasFox() => $_has(3);
  @$pb.TagNumber(4)
  void clearFox() => clearField(4);
  @$pb.TagNumber(4)
  FoxPrompt ensureFox() => $_ensure(3);

  @$pb.TagNumber(5)
  HunterPrompt get hunter => $_getN(4);
  @$pb.TagNumber(5)
  set hunter(HunterPrompt v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasHunter() => $_has(4);
  @$pb.TagNumber(5)
  void clearHunter() => clearField(5);
  @$pb.TagNumber(5)
  HunterPrompt ensureHunter() => $_ensure(4);

  @$pb.TagNumber(6)
  SaboteurPrompt get saboteur => $_getN(5);
  @$pb.TagNumber(6)
  set saboteur(SaboteurPrompt v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasSaboteur() => $_has(5);
  @$pb.TagNumber(6)
  void clearSaboteur() => clearField(6);
  @$pb.TagNumber(6)
  SaboteurPrompt ensureSaboteur() => $_ensure(5);

  @$pb.TagNumber(7)
  CupidPrompt get cupid => $_getN(6);
  @$pb.TagNumber(7)
  set cupid(CupidPrompt v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasCupid() => $_has(6);
  @$pb.TagNumber(7)
  void clearCupid() => clearField(7);
  @$pb.TagNumber(7)
  CupidPrompt ensureCupid() => $_ensure(6);
}

class WerewolfPrompt extends $pb.GeneratedMessage {
  factory WerewolfPrompt({
    $core.Iterable<$core.String>? candidateIds,
  }) {
    final $result = create();
    if (candidateIds != null) {
      $result.candidateIds.addAll(candidateIds);
    }
    return $result;
  }
  WerewolfPrompt._() : super();
  factory WerewolfPrompt.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WerewolfPrompt.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'WerewolfPrompt', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'candidateIds')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WerewolfPrompt clone() => WerewolfPrompt()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WerewolfPrompt copyWith(void Function(WerewolfPrompt) updates) => super.copyWith((message) => updates(message as WerewolfPrompt)) as WerewolfPrompt;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WerewolfPrompt create() => WerewolfPrompt._();
  WerewolfPrompt createEmptyInstance() => create();
  static $pb.PbList<WerewolfPrompt> createRepeated() => $pb.PbList<WerewolfPrompt>();
  @$core.pragma('dart2js:noInline')
  static WerewolfPrompt getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WerewolfPrompt>(create);
  static WerewolfPrompt? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get candidateIds => $_getList(0);
}

class SeerPrompt extends $pb.GeneratedMessage {
  factory SeerPrompt({
    $core.Iterable<$core.String>? candidateIds,
  }) {
    final $result = create();
    if (candidateIds != null) {
      $result.candidateIds.addAll(candidateIds);
    }
    return $result;
  }
  SeerPrompt._() : super();
  factory SeerPrompt.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SeerPrompt.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SeerPrompt', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'candidateIds')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SeerPrompt clone() => SeerPrompt()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SeerPrompt copyWith(void Function(SeerPrompt) updates) => super.copyWith((message) => updates(message as SeerPrompt)) as SeerPrompt;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SeerPrompt create() => SeerPrompt._();
  SeerPrompt createEmptyInstance() => create();
  static $pb.PbList<SeerPrompt> createRepeated() => $pb.PbList<SeerPrompt>();
  @$core.pragma('dart2js:noInline')
  static SeerPrompt getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SeerPrompt>(create);
  static SeerPrompt? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get candidateIds => $_getList(0);
}

class WitchPrompt extends $pb.GeneratedMessage {
  factory WitchPrompt({
    $core.String? attackedPlayerId,
    $core.bool? hasHealPotion,
    $core.bool? hasPoisonPotion,
  }) {
    final $result = create();
    if (attackedPlayerId != null) {
      $result.attackedPlayerId = attackedPlayerId;
    }
    if (hasHealPotion != null) {
      $result.hasHealPotion = hasHealPotion;
    }
    if (hasPoisonPotion != null) {
      $result.hasPoisonPotion = hasPoisonPotion;
    }
    return $result;
  }
  WitchPrompt._() : super();
  factory WitchPrompt.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WitchPrompt.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'WitchPrompt', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'attackedPlayerId')
    ..aOB(2, _omitFieldNames ? '' : 'hasHealPotion')
    ..aOB(3, _omitFieldNames ? '' : 'hasPoisonPotion')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WitchPrompt clone() => WitchPrompt()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WitchPrompt copyWith(void Function(WitchPrompt) updates) => super.copyWith((message) => updates(message as WitchPrompt)) as WitchPrompt;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WitchPrompt create() => WitchPrompt._();
  WitchPrompt createEmptyInstance() => create();
  static $pb.PbList<WitchPrompt> createRepeated() => $pb.PbList<WitchPrompt>();
  @$core.pragma('dart2js:noInline')
  static WitchPrompt getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WitchPrompt>(create);
  static WitchPrompt? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get attackedPlayerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set attackedPlayerId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAttackedPlayerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAttackedPlayerId() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get hasHealPotion => $_getBF(1);
  @$pb.TagNumber(2)
  set hasHealPotion($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasHasHealPotion() => $_has(1);
  @$pb.TagNumber(2)
  void clearHasHealPotion() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get hasPoisonPotion => $_getBF(2);
  @$pb.TagNumber(3)
  set hasPoisonPotion($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasHasPoisonPotion() => $_has(2);
  @$pb.TagNumber(3)
  void clearHasPoisonPotion() => clearField(3);
}

class FoxPrompt extends $pb.GeneratedMessage {
  factory FoxPrompt({
    $core.Iterable<$core.String>? candidateIds,
  }) {
    final $result = create();
    if (candidateIds != null) {
      $result.candidateIds.addAll(candidateIds);
    }
    return $result;
  }
  FoxPrompt._() : super();
  factory FoxPrompt.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FoxPrompt.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FoxPrompt', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'candidateIds')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FoxPrompt clone() => FoxPrompt()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FoxPrompt copyWith(void Function(FoxPrompt) updates) => super.copyWith((message) => updates(message as FoxPrompt)) as FoxPrompt;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FoxPrompt create() => FoxPrompt._();
  FoxPrompt createEmptyInstance() => create();
  static $pb.PbList<FoxPrompt> createRepeated() => $pb.PbList<FoxPrompt>();
  @$core.pragma('dart2js:noInline')
  static FoxPrompt getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FoxPrompt>(create);
  static FoxPrompt? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get candidateIds => $_getList(0);
}

class HunterPrompt extends $pb.GeneratedMessage {
  factory HunterPrompt({
    $core.Iterable<$core.String>? candidateIds,
  }) {
    final $result = create();
    if (candidateIds != null) {
      $result.candidateIds.addAll(candidateIds);
    }
    return $result;
  }
  HunterPrompt._() : super();
  factory HunterPrompt.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HunterPrompt.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'HunterPrompt', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'candidateIds')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HunterPrompt clone() => HunterPrompt()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HunterPrompt copyWith(void Function(HunterPrompt) updates) => super.copyWith((message) => updates(message as HunterPrompt)) as HunterPrompt;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HunterPrompt create() => HunterPrompt._();
  HunterPrompt createEmptyInstance() => create();
  static $pb.PbList<HunterPrompt> createRepeated() => $pb.PbList<HunterPrompt>();
  @$core.pragma('dart2js:noInline')
  static HunterPrompt getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HunterPrompt>(create);
  static HunterPrompt? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get candidateIds => $_getList(0);
}

class SaboteurPrompt extends $pb.GeneratedMessage {
  factory SaboteurPrompt({
    $core.Iterable<$core.String>? candidateIds,
  }) {
    final $result = create();
    if (candidateIds != null) {
      $result.candidateIds.addAll(candidateIds);
    }
    return $result;
  }
  SaboteurPrompt._() : super();
  factory SaboteurPrompt.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SaboteurPrompt.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SaboteurPrompt', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'candidateIds')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SaboteurPrompt clone() => SaboteurPrompt()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SaboteurPrompt copyWith(void Function(SaboteurPrompt) updates) => super.copyWith((message) => updates(message as SaboteurPrompt)) as SaboteurPrompt;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SaboteurPrompt create() => SaboteurPrompt._();
  SaboteurPrompt createEmptyInstance() => create();
  static $pb.PbList<SaboteurPrompt> createRepeated() => $pb.PbList<SaboteurPrompt>();
  @$core.pragma('dart2js:noInline')
  static SaboteurPrompt getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SaboteurPrompt>(create);
  static SaboteurPrompt? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get candidateIds => $_getList(0);
}

class CupidPrompt extends $pb.GeneratedMessage {
  factory CupidPrompt({
    $core.Iterable<$core.String>? candidateIds,
  }) {
    final $result = create();
    if (candidateIds != null) {
      $result.candidateIds.addAll(candidateIds);
    }
    return $result;
  }
  CupidPrompt._() : super();
  factory CupidPrompt.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CupidPrompt.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CupidPrompt', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'candidateIds')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CupidPrompt clone() => CupidPrompt()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CupidPrompt copyWith(void Function(CupidPrompt) updates) => super.copyWith((message) => updates(message as CupidPrompt)) as CupidPrompt;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CupidPrompt create() => CupidPrompt._();
  CupidPrompt createEmptyInstance() => create();
  static $pb.PbList<CupidPrompt> createRepeated() => $pb.PbList<CupidPrompt>();
  @$core.pragma('dart2js:noInline')
  static CupidPrompt getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CupidPrompt>(create);
  static CupidPrompt? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get candidateIds => $_getList(0);
}

enum ActionResult_Result {
  seerReveal, 
  foxReveal, 
  notSet
}

class ActionResult extends $pb.GeneratedMessage {
  factory ActionResult({
    SeerReveal? seerReveal,
    FoxReveal? foxReveal,
  }) {
    final $result = create();
    if (seerReveal != null) {
      $result.seerReveal = seerReveal;
    }
    if (foxReveal != null) {
      $result.foxReveal = foxReveal;
    }
    return $result;
  }
  ActionResult._() : super();
  factory ActionResult.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ActionResult.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, ActionResult_Result> _ActionResult_ResultByTag = {
    1 : ActionResult_Result.seerReveal,
    2 : ActionResult_Result.foxReveal,
    0 : ActionResult_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ActionResult', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<SeerReveal>(1, _omitFieldNames ? '' : 'seerReveal', subBuilder: SeerReveal.create)
    ..aOM<FoxReveal>(2, _omitFieldNames ? '' : 'foxReveal', subBuilder: FoxReveal.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ActionResult clone() => ActionResult()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ActionResult copyWith(void Function(ActionResult) updates) => super.copyWith((message) => updates(message as ActionResult)) as ActionResult;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ActionResult create() => ActionResult._();
  ActionResult createEmptyInstance() => create();
  static $pb.PbList<ActionResult> createRepeated() => $pb.PbList<ActionResult>();
  @$core.pragma('dart2js:noInline')
  static ActionResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ActionResult>(create);
  static ActionResult? _defaultInstance;

  ActionResult_Result whichResult() => _ActionResult_ResultByTag[$_whichOneof(0)]!;
  void clearResult() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  SeerReveal get seerReveal => $_getN(0);
  @$pb.TagNumber(1)
  set seerReveal(SeerReveal v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSeerReveal() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeerReveal() => clearField(1);
  @$pb.TagNumber(1)
  SeerReveal ensureSeerReveal() => $_ensure(0);

  @$pb.TagNumber(2)
  FoxReveal get foxReveal => $_getN(1);
  @$pb.TagNumber(2)
  set foxReveal(FoxReveal v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasFoxReveal() => $_has(1);
  @$pb.TagNumber(2)
  void clearFoxReveal() => clearField(2);
  @$pb.TagNumber(2)
  FoxReveal ensureFoxReveal() => $_ensure(1);
}

class SeerReveal extends $pb.GeneratedMessage {
  factory SeerReveal({
    $core.String? targetId,
    $core.bool? isWerewolf,
  }) {
    final $result = create();
    if (targetId != null) {
      $result.targetId = targetId;
    }
    if (isWerewolf != null) {
      $result.isWerewolf = isWerewolf;
    }
    return $result;
  }
  SeerReveal._() : super();
  factory SeerReveal.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SeerReveal.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SeerReveal', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'targetId')
    ..aOB(2, _omitFieldNames ? '' : 'isWerewolf')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SeerReveal clone() => SeerReveal()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SeerReveal copyWith(void Function(SeerReveal) updates) => super.copyWith((message) => updates(message as SeerReveal)) as SeerReveal;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SeerReveal create() => SeerReveal._();
  SeerReveal createEmptyInstance() => create();
  static $pb.PbList<SeerReveal> createRepeated() => $pb.PbList<SeerReveal>();
  @$core.pragma('dart2js:noInline')
  static SeerReveal getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SeerReveal>(create);
  static SeerReveal? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get targetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set targetId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTargetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTargetId() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isWerewolf => $_getBF(1);
  @$pb.TagNumber(2)
  set isWerewolf($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIsWerewolf() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsWerewolf() => clearField(2);
}

class FoxReveal extends $pb.GeneratedMessage {
  factory FoxReveal({
    $core.bool? anyWerewolfFound,
  }) {
    final $result = create();
    if (anyWerewolfFound != null) {
      $result.anyWerewolfFound = anyWerewolfFound;
    }
    return $result;
  }
  FoxReveal._() : super();
  factory FoxReveal.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FoxReveal.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FoxReveal', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'anyWerewolfFound')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FoxReveal clone() => FoxReveal()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FoxReveal copyWith(void Function(FoxReveal) updates) => super.copyWith((message) => updates(message as FoxReveal)) as FoxReveal;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FoxReveal create() => FoxReveal._();
  FoxReveal createEmptyInstance() => create();
  static $pb.PbList<FoxReveal> createRepeated() => $pb.PbList<FoxReveal>();
  @$core.pragma('dart2js:noInline')
  static FoxReveal getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FoxReveal>(create);
  static FoxReveal? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get anyWerewolfFound => $_getBF(0);
  @$pb.TagNumber(1)
  set anyWerewolfFound($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAnyWerewolfFound() => $_has(0);
  @$pb.TagNumber(1)
  void clearAnyWerewolfFound() => clearField(1);
}

enum PublicAnnouncement_Event {
  nightDeath, 
  noDeath, 
  voteResult, 
  hunterShot, 
  gameEnd, 
  notSet
}

class PublicAnnouncement extends $pb.GeneratedMessage {
  factory PublicAnnouncement({
    NightDeathEvent? nightDeath,
    NoDeathEvent? noDeath,
    VoteResultEvent? voteResult,
    HunterShotEvent? hunterShot,
    GameEndEvent? gameEnd,
  }) {
    final $result = create();
    if (nightDeath != null) {
      $result.nightDeath = nightDeath;
    }
    if (noDeath != null) {
      $result.noDeath = noDeath;
    }
    if (voteResult != null) {
      $result.voteResult = voteResult;
    }
    if (hunterShot != null) {
      $result.hunterShot = hunterShot;
    }
    if (gameEnd != null) {
      $result.gameEnd = gameEnd;
    }
    return $result;
  }
  PublicAnnouncement._() : super();
  factory PublicAnnouncement.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PublicAnnouncement.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, PublicAnnouncement_Event> _PublicAnnouncement_EventByTag = {
    1 : PublicAnnouncement_Event.nightDeath,
    2 : PublicAnnouncement_Event.noDeath,
    3 : PublicAnnouncement_Event.voteResult,
    4 : PublicAnnouncement_Event.hunterShot,
    5 : PublicAnnouncement_Event.gameEnd,
    0 : PublicAnnouncement_Event.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PublicAnnouncement', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5])
    ..aOM<NightDeathEvent>(1, _omitFieldNames ? '' : 'nightDeath', subBuilder: NightDeathEvent.create)
    ..aOM<NoDeathEvent>(2, _omitFieldNames ? '' : 'noDeath', subBuilder: NoDeathEvent.create)
    ..aOM<VoteResultEvent>(3, _omitFieldNames ? '' : 'voteResult', subBuilder: VoteResultEvent.create)
    ..aOM<HunterShotEvent>(4, _omitFieldNames ? '' : 'hunterShot', subBuilder: HunterShotEvent.create)
    ..aOM<GameEndEvent>(5, _omitFieldNames ? '' : 'gameEnd', subBuilder: GameEndEvent.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PublicAnnouncement clone() => PublicAnnouncement()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PublicAnnouncement copyWith(void Function(PublicAnnouncement) updates) => super.copyWith((message) => updates(message as PublicAnnouncement)) as PublicAnnouncement;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PublicAnnouncement create() => PublicAnnouncement._();
  PublicAnnouncement createEmptyInstance() => create();
  static $pb.PbList<PublicAnnouncement> createRepeated() => $pb.PbList<PublicAnnouncement>();
  @$core.pragma('dart2js:noInline')
  static PublicAnnouncement getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PublicAnnouncement>(create);
  static PublicAnnouncement? _defaultInstance;

  PublicAnnouncement_Event whichEvent() => _PublicAnnouncement_EventByTag[$_whichOneof(0)]!;
  void clearEvent() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  NightDeathEvent get nightDeath => $_getN(0);
  @$pb.TagNumber(1)
  set nightDeath(NightDeathEvent v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasNightDeath() => $_has(0);
  @$pb.TagNumber(1)
  void clearNightDeath() => clearField(1);
  @$pb.TagNumber(1)
  NightDeathEvent ensureNightDeath() => $_ensure(0);

  @$pb.TagNumber(2)
  NoDeathEvent get noDeath => $_getN(1);
  @$pb.TagNumber(2)
  set noDeath(NoDeathEvent v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasNoDeath() => $_has(1);
  @$pb.TagNumber(2)
  void clearNoDeath() => clearField(2);
  @$pb.TagNumber(2)
  NoDeathEvent ensureNoDeath() => $_ensure(1);

  @$pb.TagNumber(3)
  VoteResultEvent get voteResult => $_getN(2);
  @$pb.TagNumber(3)
  set voteResult(VoteResultEvent v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasVoteResult() => $_has(2);
  @$pb.TagNumber(3)
  void clearVoteResult() => clearField(3);
  @$pb.TagNumber(3)
  VoteResultEvent ensureVoteResult() => $_ensure(2);

  @$pb.TagNumber(4)
  HunterShotEvent get hunterShot => $_getN(3);
  @$pb.TagNumber(4)
  set hunterShot(HunterShotEvent v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasHunterShot() => $_has(3);
  @$pb.TagNumber(4)
  void clearHunterShot() => clearField(4);
  @$pb.TagNumber(4)
  HunterShotEvent ensureHunterShot() => $_ensure(3);

  @$pb.TagNumber(5)
  GameEndEvent get gameEnd => $_getN(4);
  @$pb.TagNumber(5)
  set gameEnd(GameEndEvent v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasGameEnd() => $_has(4);
  @$pb.TagNumber(5)
  void clearGameEnd() => clearField(5);
  @$pb.TagNumber(5)
  GameEndEvent ensureGameEnd() => $_ensure(4);
}

class NightDeathEvent extends $pb.GeneratedMessage {
  factory NightDeathEvent({
    $core.Iterable<PlayerDeath>? deaths,
  }) {
    final $result = create();
    if (deaths != null) {
      $result.deaths.addAll(deaths);
    }
    return $result;
  }
  NightDeathEvent._() : super();
  factory NightDeathEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory NightDeathEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'NightDeathEvent', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..pc<PlayerDeath>(1, _omitFieldNames ? '' : 'deaths', $pb.PbFieldType.PM, subBuilder: PlayerDeath.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  NightDeathEvent clone() => NightDeathEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  NightDeathEvent copyWith(void Function(NightDeathEvent) updates) => super.copyWith((message) => updates(message as NightDeathEvent)) as NightDeathEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NightDeathEvent create() => NightDeathEvent._();
  NightDeathEvent createEmptyInstance() => create();
  static $pb.PbList<NightDeathEvent> createRepeated() => $pb.PbList<NightDeathEvent>();
  @$core.pragma('dart2js:noInline')
  static NightDeathEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NightDeathEvent>(create);
  static NightDeathEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<PlayerDeath> get deaths => $_getList(0);
}

class PlayerDeath extends $pb.GeneratedMessage {
  factory PlayerDeath({
    $core.String? playerId,
    EliminationCause? cause,
  }) {
    final $result = create();
    if (playerId != null) {
      $result.playerId = playerId;
    }
    if (cause != null) {
      $result.cause = cause;
    }
    return $result;
  }
  PlayerDeath._() : super();
  factory PlayerDeath.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PlayerDeath.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PlayerDeath', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'playerId')
    ..e<EliminationCause>(2, _omitFieldNames ? '' : 'cause', $pb.PbFieldType.OE, defaultOrMaker: EliminationCause.CAUSE_UNSPECIFIED, valueOf: EliminationCause.valueOf, enumValues: EliminationCause.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PlayerDeath clone() => PlayerDeath()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PlayerDeath copyWith(void Function(PlayerDeath) updates) => super.copyWith((message) => updates(message as PlayerDeath)) as PlayerDeath;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayerDeath create() => PlayerDeath._();
  PlayerDeath createEmptyInstance() => create();
  static $pb.PbList<PlayerDeath> createRepeated() => $pb.PbList<PlayerDeath>();
  @$core.pragma('dart2js:noInline')
  static PlayerDeath getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PlayerDeath>(create);
  static PlayerDeath? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get playerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set playerId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPlayerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlayerId() => clearField(1);

  @$pb.TagNumber(2)
  EliminationCause get cause => $_getN(1);
  @$pb.TagNumber(2)
  set cause(EliminationCause v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCause() => $_has(1);
  @$pb.TagNumber(2)
  void clearCause() => clearField(2);
}

class NoDeathEvent extends $pb.GeneratedMessage {
  factory NoDeathEvent() => create();
  NoDeathEvent._() : super();
  factory NoDeathEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory NoDeathEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'NoDeathEvent', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  NoDeathEvent clone() => NoDeathEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  NoDeathEvent copyWith(void Function(NoDeathEvent) updates) => super.copyWith((message) => updates(message as NoDeathEvent)) as NoDeathEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NoDeathEvent create() => NoDeathEvent._();
  NoDeathEvent createEmptyInstance() => create();
  static $pb.PbList<NoDeathEvent> createRepeated() => $pb.PbList<NoDeathEvent>();
  @$core.pragma('dart2js:noInline')
  static NoDeathEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NoDeathEvent>(create);
  static NoDeathEvent? _defaultInstance;
}

class VoteResultEvent extends $pb.GeneratedMessage {
  factory VoteResultEvent({
    $core.String? eliminatedPlayerId,
    $core.bool? tied,
    $core.Iterable<$core.String>? alsoDiedIds,
  }) {
    final $result = create();
    if (eliminatedPlayerId != null) {
      $result.eliminatedPlayerId = eliminatedPlayerId;
    }
    if (tied != null) {
      $result.tied = tied;
    }
    if (alsoDiedIds != null) {
      $result.alsoDiedIds.addAll(alsoDiedIds);
    }
    return $result;
  }
  VoteResultEvent._() : super();
  factory VoteResultEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VoteResultEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'VoteResultEvent', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'eliminatedPlayerId')
    ..aOB(2, _omitFieldNames ? '' : 'tied')
    ..pPS(3, _omitFieldNames ? '' : 'alsoDiedIds')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VoteResultEvent clone() => VoteResultEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VoteResultEvent copyWith(void Function(VoteResultEvent) updates) => super.copyWith((message) => updates(message as VoteResultEvent)) as VoteResultEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VoteResultEvent create() => VoteResultEvent._();
  VoteResultEvent createEmptyInstance() => create();
  static $pb.PbList<VoteResultEvent> createRepeated() => $pb.PbList<VoteResultEvent>();
  @$core.pragma('dart2js:noInline')
  static VoteResultEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VoteResultEvent>(create);
  static VoteResultEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get eliminatedPlayerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set eliminatedPlayerId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEliminatedPlayerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEliminatedPlayerId() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get tied => $_getBF(1);
  @$pb.TagNumber(2)
  set tied($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTied() => $_has(1);
  @$pb.TagNumber(2)
  void clearTied() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.String> get alsoDiedIds => $_getList(2);
}

class HunterShotEvent extends $pb.GeneratedMessage {
  factory HunterShotEvent({
    $core.String? shooterId,
    $core.String? targetId,
  }) {
    final $result = create();
    if (shooterId != null) {
      $result.shooterId = shooterId;
    }
    if (targetId != null) {
      $result.targetId = targetId;
    }
    return $result;
  }
  HunterShotEvent._() : super();
  factory HunterShotEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HunterShotEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'HunterShotEvent', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'shooterId')
    ..aOS(2, _omitFieldNames ? '' : 'targetId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HunterShotEvent clone() => HunterShotEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HunterShotEvent copyWith(void Function(HunterShotEvent) updates) => super.copyWith((message) => updates(message as HunterShotEvent)) as HunterShotEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HunterShotEvent create() => HunterShotEvent._();
  HunterShotEvent createEmptyInstance() => create();
  static $pb.PbList<HunterShotEvent> createRepeated() => $pb.PbList<HunterShotEvent>();
  @$core.pragma('dart2js:noInline')
  static HunterShotEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HunterShotEvent>(create);
  static HunterShotEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get shooterId => $_getSZ(0);
  @$pb.TagNumber(1)
  set shooterId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasShooterId() => $_has(0);
  @$pb.TagNumber(1)
  void clearShooterId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get targetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set targetId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTargetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTargetId() => clearField(2);
}

class GameEndEvent extends $pb.GeneratedMessage {
  factory GameEndEvent({
    Role? winningTeam,
  }) {
    final $result = create();
    if (winningTeam != null) {
      $result.winningTeam = winningTeam;
    }
    return $result;
  }
  GameEndEvent._() : super();
  factory GameEndEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GameEndEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GameEndEvent', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..e<Role>(1, _omitFieldNames ? '' : 'winningTeam', $pb.PbFieldType.OE, defaultOrMaker: Role.ROLE_UNSPECIFIED, valueOf: Role.valueOf, enumValues: Role.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GameEndEvent clone() => GameEndEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GameEndEvent copyWith(void Function(GameEndEvent) updates) => super.copyWith((message) => updates(message as GameEndEvent)) as GameEndEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GameEndEvent create() => GameEndEvent._();
  GameEndEvent createEmptyInstance() => create();
  static $pb.PbList<GameEndEvent> createRepeated() => $pb.PbList<GameEndEvent>();
  @$core.pragma('dart2js:noInline')
  static GameEndEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GameEndEvent>(create);
  static GameEndEvent? _defaultInstance;

  @$pb.TagNumber(1)
  Role get winningTeam => $_getN(0);
  @$pb.TagNumber(1)
  set winningTeam(Role v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasWinningTeam() => $_has(0);
  @$pb.TagNumber(1)
  void clearWinningTeam() => clearField(1);
}

class PauseRequest extends $pb.GeneratedMessage {
  factory PauseRequest({
    $core.String? lobbyCode,
  }) {
    final $result = create();
    if (lobbyCode != null) {
      $result.lobbyCode = lobbyCode;
    }
    return $result;
  }
  PauseRequest._() : super();
  factory PauseRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PauseRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PauseRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'lobbyCode')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PauseRequest clone() => PauseRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PauseRequest copyWith(void Function(PauseRequest) updates) => super.copyWith((message) => updates(message as PauseRequest)) as PauseRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PauseRequest create() => PauseRequest._();
  PauseRequest createEmptyInstance() => create();
  static $pb.PbList<PauseRequest> createRepeated() => $pb.PbList<PauseRequest>();
  @$core.pragma('dart2js:noInline')
  static PauseRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PauseRequest>(create);
  static PauseRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get lobbyCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set lobbyCode($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLobbyCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearLobbyCode() => clearField(1);
}

class PauseState extends $pb.GeneratedMessage {
  factory PauseState({
    $core.bool? isPaused,
    $core.int? voteCount,
    $core.int? votesNeeded,
    $core.bool? youVoted,
    $2.Timestamp? pausedUntil,
  }) {
    final $result = create();
    if (isPaused != null) {
      $result.isPaused = isPaused;
    }
    if (voteCount != null) {
      $result.voteCount = voteCount;
    }
    if (votesNeeded != null) {
      $result.votesNeeded = votesNeeded;
    }
    if (youVoted != null) {
      $result.youVoted = youVoted;
    }
    if (pausedUntil != null) {
      $result.pausedUntil = pausedUntil;
    }
    return $result;
  }
  PauseState._() : super();
  factory PauseState.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PauseState.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PauseState', package: const $pb.PackageName(_omitMessageNames ? '' : 'werewolf'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'isPaused')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'voteCount', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'votesNeeded', $pb.PbFieldType.O3)
    ..aOB(4, _omitFieldNames ? '' : 'youVoted')
    ..aOM<$2.Timestamp>(5, _omitFieldNames ? '' : 'pausedUntil', subBuilder: $2.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PauseState clone() => PauseState()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PauseState copyWith(void Function(PauseState) updates) => super.copyWith((message) => updates(message as PauseState)) as PauseState;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PauseState create() => PauseState._();
  PauseState createEmptyInstance() => create();
  static $pb.PbList<PauseState> createRepeated() => $pb.PbList<PauseState>();
  @$core.pragma('dart2js:noInline')
  static PauseState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PauseState>(create);
  static PauseState? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get isPaused => $_getBF(0);
  @$pb.TagNumber(1)
  set isPaused($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIsPaused() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsPaused() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get voteCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set voteCount($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasVoteCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearVoteCount() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get votesNeeded => $_getIZ(2);
  @$pb.TagNumber(3)
  set votesNeeded($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasVotesNeeded() => $_has(2);
  @$pb.TagNumber(3)
  void clearVotesNeeded() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get youVoted => $_getBF(3);
  @$pb.TagNumber(4)
  set youVoted($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasYouVoted() => $_has(3);
  @$pb.TagNumber(4)
  void clearYouVoted() => clearField(4);

  @$pb.TagNumber(5)
  $2.Timestamp get pausedUntil => $_getN(4);
  @$pb.TagNumber(5)
  set pausedUntil($2.Timestamp v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasPausedUntil() => $_has(4);
  @$pb.TagNumber(5)
  void clearPausedUntil() => clearField(5);
  @$pb.TagNumber(5)
  $2.Timestamp ensurePausedUntil() => $_ensure(4);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
