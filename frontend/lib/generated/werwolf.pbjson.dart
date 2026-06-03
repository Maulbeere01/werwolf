//
//  Generated code. Do not modify.
//  source: werwolf.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use roleDescriptor instead')
const Role$json = {
  '1': 'Role',
  '2': [
    {'1': 'ROLE_UNSPECIFIED', '2': 0},
    {'1': 'WEREWOLF', '2': 1},
    {'1': 'VILLAGER', '2': 2},
    {'1': 'SEER', '2': 3},
    {'1': 'WITCH', '2': 4},
    {'1': 'FOX', '2': 5},
    {'1': 'VILLAGE_IDIOT', '2': 6},
    {'1': 'HUNTER', '2': 7},
  ],
};

/// Descriptor for `Role`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List roleDescriptor = $convert.base64Decode(
    'CgRSb2xlEhQKEFJPTEVfVU5TUEVDSUZJRUQQABIMCghXRVJFV09MRhABEgwKCFZJTExBR0VSEA'
    'ISCAoEU0VFUhADEgkKBVdJVENIEAQSBwoDRk9YEAUSEQoNVklMTEFHRV9JRElPVBAGEgoKBkhV'
    'TlRFUhAH');

@$core.Deprecated('Use phaseDescriptor instead')
const Phase$json = {
  '1': 'Phase',
  '2': [
    {'1': 'PHASE_UNSPECIFIED', '2': 0},
    {'1': 'LOBBY', '2': 1},
    {'1': 'NIGHT_START', '2': 2},
    {'1': 'NIGHT_WEREWOLVES', '2': 3},
    {'1': 'NIGHT_SEER', '2': 4},
    {'1': 'NIGHT_WITCH', '2': 5},
    {'1': 'NIGHT_FOX', '2': 6},
    {'1': 'DAY_RESULT', '2': 7},
    {'1': 'DAY_DISCUSSION', '2': 8},
    {'1': 'DAY_VOTING', '2': 9},
    {'1': 'HUNTER_REVENGE', '2': 10},
    {'1': 'GAME_END', '2': 11},
  ],
};

/// Descriptor for `Phase`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List phaseDescriptor = $convert.base64Decode(
    'CgVQaGFzZRIVChFQSEFTRV9VTlNQRUNJRklFRBAAEgkKBUxPQkJZEAESDwoLTklHSFRfU1RBUl'
    'QQAhIUChBOSUdIVF9XRVJFV09MVkVTEAMSDgoKTklHSFRfU0VFUhAEEg8KC05JR0hUX1dJVENI'
    'EAUSDQoJTklHSFRfRk9YEAYSDgoKREFZX1JFU1VMVBAHEhIKDkRBWV9ESVNDVVNTSU9OEAgSDg'
    'oKREFZX1ZPVElORxAJEhIKDkhVTlRFUl9SRVZFTkdFEAoSDAoIR0FNRV9FTkQQCw==');

@$core.Deprecated('Use eliminationCauseDescriptor instead')
const EliminationCause$json = {
  '1': 'EliminationCause',
  '2': [
    {'1': 'CAUSE_UNSPECIFIED', '2': 0},
    {'1': 'KILLED_BY_WEREWOLVES', '2': 1},
    {'1': 'KILLED_BY_WITCH', '2': 2},
    {'1': 'VOTED_OUT', '2': 3},
    {'1': 'CAUSE_HUNTER_REVENGE', '2': 4},
  ],
};

/// Descriptor for `EliminationCause`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List eliminationCauseDescriptor = $convert.base64Decode(
    'ChBFbGltaW5hdGlvbkNhdXNlEhUKEUNBVVNFX1VOU1BFQ0lGSUVEEAASGAoUS0lMTEVEX0JZX1'
    'dFUkVXT0xWRVMQARITCg9LSUxMRURfQllfV0lUQ0gQAhINCglWT1RFRF9PVVQQAxIYChRDQVVT'
    'RV9IVU5URVJfUkVWRU5HRRAE');

@$core.Deprecated('Use userProfileDescriptor instead')
const UserProfile$json = {
  '1': 'UserProfile',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
    {'1': 'score', '3': 3, '4': 1, '5': 5, '10': 'score'},
  ],
};

/// Descriptor for `UserProfile`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userProfileDescriptor = $convert.base64Decode(
    'CgtVc2VyUHJvZmlsZRIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQSGgoIdXNlcm5hbWUYAiABKA'
    'lSCHVzZXJuYW1lEhQKBXNjb3JlGAMgASgFUgVzY29yZQ==');

@$core.Deprecated('Use loginRequestDescriptor instead')
const LoginRequest$json = {
  '1': 'LoginRequest',
  '2': [
    {'1': 'username', '3': 1, '4': 1, '5': 9, '10': 'username'},
    {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
  ],
};

/// Descriptor for `LoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginRequestDescriptor = $convert.base64Decode(
    'CgxMb2dpblJlcXVlc3QSGgoIdXNlcm5hbWUYASABKAlSCHVzZXJuYW1lEhoKCHBhc3N3b3JkGA'
    'IgASgJUghwYXNzd29yZA==');

@$core.Deprecated('Use loginResponseDescriptor instead')
const LoginResponse$json = {
  '1': 'LoginResponse',
  '2': [
    {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
    {'1': 'profile', '3': 2, '4': 1, '5': 11, '6': '.werewolf.UserProfile', '10': 'profile'},
  ],
};

/// Descriptor for `LoginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginResponseDescriptor = $convert.base64Decode(
    'Cg1Mb2dpblJlc3BvbnNlEhQKBXRva2VuGAEgASgJUgV0b2tlbhIvCgdwcm9maWxlGAIgASgLMh'
    'Uud2VyZXdvbGYuVXNlclByb2ZpbGVSB3Byb2ZpbGU=');

@$core.Deprecated('Use registerRequestDescriptor instead')
const RegisterRequest$json = {
  '1': 'RegisterRequest',
  '2': [
    {'1': 'username', '3': 1, '4': 1, '5': 9, '10': 'username'},
    {'1': 'email', '3': 2, '4': 1, '5': 9, '10': 'email'},
    {'1': 'password', '3': 3, '4': 1, '5': 9, '10': 'password'},
  ],
};

/// Descriptor for `RegisterRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerRequestDescriptor = $convert.base64Decode(
    'Cg9SZWdpc3RlclJlcXVlc3QSGgoIdXNlcm5hbWUYASABKAlSCHVzZXJuYW1lEhQKBWVtYWlsGA'
    'IgASgJUgVlbWFpbBIaCghwYXNzd29yZBgDIAEoCVIIcGFzc3dvcmQ=');

@$core.Deprecated('Use profileRequestDescriptor instead')
const ProfileRequest$json = {
  '1': 'ProfileRequest',
  '2': [
    {'1': 'target_user_id', '3': 1, '4': 1, '5': 9, '10': 'targetUserId'},
  ],
};

/// Descriptor for `ProfileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List profileRequestDescriptor = $convert.base64Decode(
    'Cg5Qcm9maWxlUmVxdWVzdBIkCg50YXJnZXRfdXNlcl9pZBgBIAEoCVIMdGFyZ2V0VXNlcklk');

@$core.Deprecated('Use roleCountDescriptor instead')
const RoleCount$json = {
  '1': 'RoleCount',
  '2': [
    {'1': 'role', '3': 1, '4': 1, '5': 14, '6': '.werewolf.Role', '10': 'role'},
    {'1': 'count', '3': 2, '4': 1, '5': 5, '10': 'count'},
  ],
};

/// Descriptor for `RoleCount`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roleCountDescriptor = $convert.base64Decode(
    'CglSb2xlQ291bnQSIgoEcm9sZRgBIAEoDjIOLndlcmV3b2xmLlJvbGVSBHJvbGUSFAoFY291bn'
    'QYAiABKAVSBWNvdW50');

@$core.Deprecated('Use lobbySettingsDescriptor instead')
const LobbySettings$json = {
  '1': 'LobbySettings',
  '2': [
    {'1': 'max_players', '3': 1, '4': 1, '5': 5, '10': 'maxPlayers'},
    {'1': 'roles', '3': 2, '4': 3, '5': 11, '6': '.werewolf.RoleCount', '10': 'roles'},
    {'1': 'discussion_time_seconds', '3': 3, '4': 1, '5': 5, '10': 'discussionTimeSeconds'},
  ],
};

/// Descriptor for `LobbySettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lobbySettingsDescriptor = $convert.base64Decode(
    'Cg1Mb2JieVNldHRpbmdzEh8KC21heF9wbGF5ZXJzGAEgASgFUgptYXhQbGF5ZXJzEikKBXJvbG'
    'VzGAIgAygLMhMud2VyZXdvbGYuUm9sZUNvdW50UgVyb2xlcxI2ChdkaXNjdXNzaW9uX3RpbWVf'
    'c2Vjb25kcxgDIAEoBVIVZGlzY3Vzc2lvblRpbWVTZWNvbmRz');

@$core.Deprecated('Use createLobbyRequestDescriptor instead')
const CreateLobbyRequest$json = {
  '1': 'CreateLobbyRequest',
  '2': [
    {'1': 'settings', '3': 1, '4': 1, '5': 11, '6': '.werewolf.LobbySettings', '10': 'settings'},
  ],
};

/// Descriptor for `CreateLobbyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createLobbyRequestDescriptor = $convert.base64Decode(
    'ChJDcmVhdGVMb2JieVJlcXVlc3QSMwoIc2V0dGluZ3MYASABKAsyFy53ZXJld29sZi5Mb2JieV'
    'NldHRpbmdzUghzZXR0aW5ncw==');

@$core.Deprecated('Use joinRequestDescriptor instead')
const JoinRequest$json = {
  '1': 'JoinRequest',
  '2': [
    {'1': 'lobby_code', '3': 1, '4': 1, '5': 9, '10': 'lobbyCode'},
  ],
};

/// Descriptor for `JoinRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinRequestDescriptor = $convert.base64Decode(
    'CgtKb2luUmVxdWVzdBIdCgpsb2JieV9jb2RlGAEgASgJUglsb2JieUNvZGU=');

@$core.Deprecated('Use startGameRequestDescriptor instead')
const StartGameRequest$json = {
  '1': 'StartGameRequest',
  '2': [
    {'1': 'lobby_code', '3': 1, '4': 1, '5': 9, '10': 'lobbyCode'},
  ],
};

/// Descriptor for `StartGameRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startGameRequestDescriptor = $convert.base64Decode(
    'ChBTdGFydEdhbWVSZXF1ZXN0Eh0KCmxvYmJ5X2NvZGUYASABKAlSCWxvYmJ5Q29kZQ==');

@$core.Deprecated('Use lobbyInfoDescriptor instead')
const LobbyInfo$json = {
  '1': 'LobbyInfo',
  '2': [
    {'1': 'lobby_code', '3': 1, '4': 1, '5': 9, '10': 'lobbyCode'},
    {'1': 'players', '3': 2, '4': 3, '5': 11, '6': '.werewolf.PlayerStatus', '10': 'players'},
    {'1': 'can_start', '3': 3, '4': 1, '5': 8, '10': 'canStart'},
    {'1': 'host_id', '3': 4, '4': 1, '5': 9, '10': 'hostId'},
    {'1': 'settings', '3': 5, '4': 1, '5': 11, '6': '.werewolf.LobbySettings', '10': 'settings'},
  ],
};

/// Descriptor for `LobbyInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lobbyInfoDescriptor = $convert.base64Decode(
    'CglMb2JieUluZm8SHQoKbG9iYnlfY29kZRgBIAEoCVIJbG9iYnlDb2RlEjAKB3BsYXllcnMYAi'
    'ADKAsyFi53ZXJld29sZi5QbGF5ZXJTdGF0dXNSB3BsYXllcnMSGwoJY2FuX3N0YXJ0GAMgASgI'
    'UghjYW5TdGFydBIXCgdob3N0X2lkGAQgASgJUgZob3N0SWQSMwoIc2V0dGluZ3MYBSABKAsyFy'
    '53ZXJld29sZi5Mb2JieVNldHRpbmdzUghzZXR0aW5ncw==');

@$core.Deprecated('Use subscribeRequestDescriptor instead')
const SubscribeRequest$json = {
  '1': 'SubscribeRequest',
  '2': [
    {'1': 'lobby_code', '3': 1, '4': 1, '5': 9, '10': 'lobbyCode'},
  ],
};

/// Descriptor for `SubscribeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscribeRequestDescriptor = $convert.base64Decode(
    'ChBTdWJzY3JpYmVSZXF1ZXN0Eh0KCmxvYmJ5X2NvZGUYASABKAlSCWxvYmJ5Q29kZQ==');

@$core.Deprecated('Use gameUpdateDescriptor instead')
const GameUpdate$json = {
  '1': 'GameUpdate',
  '2': [
    {'1': 'current_phase', '3': 1, '4': 1, '5': 14, '6': '.werewolf.Phase', '10': 'currentPhase'},
    {'1': 'players', '3': 4, '4': 3, '5': 11, '6': '.werewolf.PlayerStatus', '10': 'players'},
    {'1': 'winning_team', '3': 7, '4': 1, '5': 14, '6': '.werewolf.Role', '10': 'winningTeam'},
    {'1': 'your_role', '3': 8, '4': 1, '5': 14, '6': '.werewolf.Role', '10': 'yourRole'},
    {'1': 'open_prompt', '3': 9, '4': 1, '5': 11, '6': '.werewolf.ActionPrompt', '10': 'openPrompt'},
    {'1': 'your_results', '3': 10, '4': 1, '5': 11, '6': '.werewolf.ActionResult', '10': 'yourResults'},
    {'1': 'announcement', '3': 11, '4': 1, '5': 11, '6': '.werewolf.PublicAnnouncement', '10': 'announcement'},
    {'1': 'phase_ends_at', '3': 12, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'phaseEndsAt'},
    {'1': 'pause', '3': 13, '4': 1, '5': 11, '6': '.werewolf.PauseState', '10': 'pause'},
  ],
  '9': [
    {'1': 2, '2': 3},
    {'1': 3, '2': 4},
    {'1': 5, '2': 6},
    {'1': 6, '2': 7},
  ],
};

/// Descriptor for `GameUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameUpdateDescriptor = $convert.base64Decode(
    'CgpHYW1lVXBkYXRlEjQKDWN1cnJlbnRfcGhhc2UYASABKA4yDy53ZXJld29sZi5QaGFzZVIMY3'
    'VycmVudFBoYXNlEjAKB3BsYXllcnMYBCADKAsyFi53ZXJld29sZi5QbGF5ZXJTdGF0dXNSB3Bs'
    'YXllcnMSMQoMd2lubmluZ190ZWFtGAcgASgOMg4ud2VyZXdvbGYuUm9sZVILd2lubmluZ1RlYW'
    '0SKwoJeW91cl9yb2xlGAggASgOMg4ud2VyZXdvbGYuUm9sZVIIeW91clJvbGUSNwoLb3Blbl9w'
    'cm9tcHQYCSABKAsyFi53ZXJld29sZi5BY3Rpb25Qcm9tcHRSCm9wZW5Qcm9tcHQSOQoMeW91cl'
    '9yZXN1bHRzGAogASgLMhYud2VyZXdvbGYuQWN0aW9uUmVzdWx0Ugt5b3VyUmVzdWx0cxJACgxh'
    'bm5vdW5jZW1lbnQYCyABKAsyHC53ZXJld29sZi5QdWJsaWNBbm5vdW5jZW1lbnRSDGFubm91bm'
    'NlbWVudBI+Cg1waGFzZV9lbmRzX2F0GAwgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFt'
    'cFILcGhhc2VFbmRzQXQSKgoFcGF1c2UYDSABKAsyFC53ZXJld29sZi5QYXVzZVN0YXRlUgVwYX'
    'VzZUoECAIQA0oECAMQBEoECAUQBkoECAYQBw==');

@$core.Deprecated('Use playerStatusDescriptor instead')
const PlayerStatus$json = {
  '1': 'PlayerStatus',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'is_alive', '3': 3, '4': 1, '5': 8, '10': 'isAlive'},
    {'1': 'has_voted', '3': 4, '4': 1, '5': 8, '10': 'hasVoted'},
    {'1': 'voted_for_target_id', '3': 5, '4': 1, '5': 9, '10': 'votedForTargetId'},
    {'1': 'role', '3': 6, '4': 1, '5': 14, '6': '.werewolf.Role', '10': 'role'},
    {'1': 'is_host', '3': 7, '4': 1, '5': 8, '10': 'isHost'},
  ],
};

/// Descriptor for `PlayerStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playerStatusDescriptor = $convert.base64Decode(
    'CgxQbGF5ZXJTdGF0dXMSDgoCaWQYASABKAlSAmlkEhIKBG5hbWUYAiABKAlSBG5hbWUSGQoIaX'
    'NfYWxpdmUYAyABKAhSB2lzQWxpdmUSGwoJaGFzX3ZvdGVkGAQgASgIUghoYXNWb3RlZBItChN2'
    'b3RlZF9mb3JfdGFyZ2V0X2lkGAUgASgJUhB2b3RlZEZvclRhcmdldElkEiIKBHJvbGUYBiABKA'
    '4yDi53ZXJld29sZi5Sb2xlUgRyb2xlEhcKB2lzX2hvc3QYByABKAhSBmlzSG9zdA==');

@$core.Deprecated('Use gameActionDescriptor instead')
const GameAction$json = {
  '1': 'GameAction',
  '2': [
    {'1': 'lobby_code', '3': 1, '4': 1, '5': 9, '10': 'lobbyCode'},
    {'1': 'vote', '3': 2, '4': 1, '5': 11, '6': '.werewolf.VoteAction', '9': 0, '10': 'vote'},
    {'1': 'witch', '3': 3, '4': 1, '5': 11, '6': '.werewolf.WitchAction', '9': 0, '10': 'witch'},
    {'1': 'seer', '3': 4, '4': 1, '5': 11, '6': '.werewolf.SeerAction', '9': 0, '10': 'seer'},
    {'1': 'fox', '3': 5, '4': 1, '5': 11, '6': '.werewolf.FoxAction', '9': 0, '10': 'fox'},
    {'1': 'hunter', '3': 6, '4': 1, '5': 11, '6': '.werewolf.HunterAction', '9': 0, '10': 'hunter'},
  ],
  '8': [
    {'1': 'action'},
  ],
};

/// Descriptor for `GameAction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameActionDescriptor = $convert.base64Decode(
    'CgpHYW1lQWN0aW9uEh0KCmxvYmJ5X2NvZGUYASABKAlSCWxvYmJ5Q29kZRIqCgR2b3RlGAIgAS'
    'gLMhQud2VyZXdvbGYuVm90ZUFjdGlvbkgAUgR2b3RlEi0KBXdpdGNoGAMgASgLMhUud2VyZXdv'
    'bGYuV2l0Y2hBY3Rpb25IAFIFd2l0Y2gSKgoEc2VlchgEIAEoCzIULndlcmV3b2xmLlNlZXJBY3'
    'Rpb25IAFIEc2VlchInCgNmb3gYBSABKAsyEy53ZXJld29sZi5Gb3hBY3Rpb25IAFIDZm94EjAK'
    'Bmh1bnRlchgGIAEoCzIWLndlcmV3b2xmLkh1bnRlckFjdGlvbkgAUgZodW50ZXJCCAoGYWN0aW'
    '9u');

@$core.Deprecated('Use voteActionDescriptor instead')
const VoteAction$json = {
  '1': 'VoteAction',
  '2': [
    {'1': 'target_id', '3': 1, '4': 1, '5': 9, '10': 'targetId'},
  ],
};

/// Descriptor for `VoteAction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voteActionDescriptor = $convert.base64Decode(
    'CgpWb3RlQWN0aW9uEhsKCXRhcmdldF9pZBgBIAEoCVIIdGFyZ2V0SWQ=');

@$core.Deprecated('Use witchActionDescriptor instead')
const WitchAction$json = {
  '1': 'WitchAction',
  '2': [
    {'1': 'heal_target', '3': 1, '4': 1, '5': 8, '10': 'healTarget'},
    {'1': 'poison_target_id', '3': 2, '4': 1, '5': 9, '10': 'poisonTargetId'},
  ],
};

/// Descriptor for `WitchAction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List witchActionDescriptor = $convert.base64Decode(
    'CgtXaXRjaEFjdGlvbhIfCgtoZWFsX3RhcmdldBgBIAEoCFIKaGVhbFRhcmdldBIoChBwb2lzb2'
    '5fdGFyZ2V0X2lkGAIgASgJUg5wb2lzb25UYXJnZXRJZA==');

@$core.Deprecated('Use seerActionDescriptor instead')
const SeerAction$json = {
  '1': 'SeerAction',
  '2': [
    {'1': 'target_id', '3': 1, '4': 1, '5': 9, '10': 'targetId'},
  ],
};

/// Descriptor for `SeerAction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seerActionDescriptor = $convert.base64Decode(
    'CgpTZWVyQWN0aW9uEhsKCXRhcmdldF9pZBgBIAEoCVIIdGFyZ2V0SWQ=');

@$core.Deprecated('Use foxActionDescriptor instead')
const FoxAction$json = {
  '1': 'FoxAction',
  '2': [
    {'1': 'target_ids', '3': 1, '4': 3, '5': 9, '10': 'targetIds'},
  ],
};

/// Descriptor for `FoxAction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List foxActionDescriptor = $convert.base64Decode(
    'CglGb3hBY3Rpb24SHQoKdGFyZ2V0X2lkcxgBIAMoCVIJdGFyZ2V0SWRz');

@$core.Deprecated('Use hunterActionDescriptor instead')
const HunterAction$json = {
  '1': 'HunterAction',
  '2': [
    {'1': 'target_id', '3': 1, '4': 1, '5': 9, '10': 'targetId'},
  ],
};

/// Descriptor for `HunterAction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hunterActionDescriptor = $convert.base64Decode(
    'CgxIdW50ZXJBY3Rpb24SGwoJdGFyZ2V0X2lkGAEgASgJUgh0YXJnZXRJZA==');

@$core.Deprecated('Use actionPromptDescriptor instead')
const ActionPrompt$json = {
  '1': 'ActionPrompt',
  '2': [
    {'1': 'werewolf', '3': 1, '4': 1, '5': 11, '6': '.werewolf.WerewolfPrompt', '9': 0, '10': 'werewolf'},
    {'1': 'seer', '3': 2, '4': 1, '5': 11, '6': '.werewolf.SeerPrompt', '9': 0, '10': 'seer'},
    {'1': 'witch', '3': 3, '4': 1, '5': 11, '6': '.werewolf.WitchPrompt', '9': 0, '10': 'witch'},
    {'1': 'fox', '3': 4, '4': 1, '5': 11, '6': '.werewolf.FoxPrompt', '9': 0, '10': 'fox'},
    {'1': 'hunter', '3': 5, '4': 1, '5': 11, '6': '.werewolf.HunterPrompt', '9': 0, '10': 'hunter'},
  ],
  '8': [
    {'1': 'prompt'},
  ],
};

/// Descriptor for `ActionPrompt`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List actionPromptDescriptor = $convert.base64Decode(
    'CgxBY3Rpb25Qcm9tcHQSNgoId2VyZXdvbGYYASABKAsyGC53ZXJld29sZi5XZXJld29sZlByb2'
    '1wdEgAUgh3ZXJld29sZhIqCgRzZWVyGAIgASgLMhQud2VyZXdvbGYuU2VlclByb21wdEgAUgRz'
    'ZWVyEi0KBXdpdGNoGAMgASgLMhUud2VyZXdvbGYuV2l0Y2hQcm9tcHRIAFIFd2l0Y2gSJwoDZm'
    '94GAQgASgLMhMud2VyZXdvbGYuRm94UHJvbXB0SABSA2ZveBIwCgZodW50ZXIYBSABKAsyFi53'
    'ZXJld29sZi5IdW50ZXJQcm9tcHRIAFIGaHVudGVyQggKBnByb21wdA==');

@$core.Deprecated('Use werewolfPromptDescriptor instead')
const WerewolfPrompt$json = {
  '1': 'WerewolfPrompt',
  '2': [
    {'1': 'candidate_ids', '3': 1, '4': 3, '5': 9, '10': 'candidateIds'},
  ],
};

/// Descriptor for `WerewolfPrompt`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List werewolfPromptDescriptor = $convert.base64Decode(
    'Cg5XZXJld29sZlByb21wdBIjCg1jYW5kaWRhdGVfaWRzGAEgAygJUgxjYW5kaWRhdGVJZHM=');

@$core.Deprecated('Use seerPromptDescriptor instead')
const SeerPrompt$json = {
  '1': 'SeerPrompt',
  '2': [
    {'1': 'candidate_ids', '3': 1, '4': 3, '5': 9, '10': 'candidateIds'},
  ],
};

/// Descriptor for `SeerPrompt`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seerPromptDescriptor = $convert.base64Decode(
    'CgpTZWVyUHJvbXB0EiMKDWNhbmRpZGF0ZV9pZHMYASADKAlSDGNhbmRpZGF0ZUlkcw==');

@$core.Deprecated('Use witchPromptDescriptor instead')
const WitchPrompt$json = {
  '1': 'WitchPrompt',
  '2': [
    {'1': 'attacked_player_id', '3': 1, '4': 1, '5': 9, '10': 'attackedPlayerId'},
    {'1': 'has_heal_potion', '3': 2, '4': 1, '5': 8, '10': 'hasHealPotion'},
    {'1': 'has_poison_potion', '3': 3, '4': 1, '5': 8, '10': 'hasPoisonPotion'},
  ],
};

/// Descriptor for `WitchPrompt`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List witchPromptDescriptor = $convert.base64Decode(
    'CgtXaXRjaFByb21wdBIsChJhdHRhY2tlZF9wbGF5ZXJfaWQYASABKAlSEGF0dGFja2VkUGxheW'
    'VySWQSJgoPaGFzX2hlYWxfcG90aW9uGAIgASgIUg1oYXNIZWFsUG90aW9uEioKEWhhc19wb2lz'
    'b25fcG90aW9uGAMgASgIUg9oYXNQb2lzb25Qb3Rpb24=');

@$core.Deprecated('Use foxPromptDescriptor instead')
const FoxPrompt$json = {
  '1': 'FoxPrompt',
  '2': [
    {'1': 'candidate_ids', '3': 1, '4': 3, '5': 9, '10': 'candidateIds'},
  ],
};

/// Descriptor for `FoxPrompt`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List foxPromptDescriptor = $convert.base64Decode(
    'CglGb3hQcm9tcHQSIwoNY2FuZGlkYXRlX2lkcxgBIAMoCVIMY2FuZGlkYXRlSWRz');

@$core.Deprecated('Use hunterPromptDescriptor instead')
const HunterPrompt$json = {
  '1': 'HunterPrompt',
  '2': [
    {'1': 'candidate_ids', '3': 1, '4': 3, '5': 9, '10': 'candidateIds'},
  ],
};

/// Descriptor for `HunterPrompt`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hunterPromptDescriptor = $convert.base64Decode(
    'CgxIdW50ZXJQcm9tcHQSIwoNY2FuZGlkYXRlX2lkcxgBIAMoCVIMY2FuZGlkYXRlSWRz');

@$core.Deprecated('Use actionResultDescriptor instead')
const ActionResult$json = {
  '1': 'ActionResult',
  '2': [
    {'1': 'seer_reveal', '3': 1, '4': 1, '5': 11, '6': '.werewolf.SeerReveal', '9': 0, '10': 'seerReveal'},
    {'1': 'fox_reveal', '3': 2, '4': 1, '5': 11, '6': '.werewolf.FoxReveal', '9': 0, '10': 'foxReveal'},
  ],
  '8': [
    {'1': 'result'},
  ],
};

/// Descriptor for `ActionResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List actionResultDescriptor = $convert.base64Decode(
    'CgxBY3Rpb25SZXN1bHQSNwoLc2Vlcl9yZXZlYWwYASABKAsyFC53ZXJld29sZi5TZWVyUmV2ZW'
    'FsSABSCnNlZXJSZXZlYWwSNAoKZm94X3JldmVhbBgCIAEoCzITLndlcmV3b2xmLkZveFJldmVh'
    'bEgAUglmb3hSZXZlYWxCCAoGcmVzdWx0');

@$core.Deprecated('Use seerRevealDescriptor instead')
const SeerReveal$json = {
  '1': 'SeerReveal',
  '2': [
    {'1': 'target_id', '3': 1, '4': 1, '5': 9, '10': 'targetId'},
    {'1': 'is_werewolf', '3': 2, '4': 1, '5': 8, '10': 'isWerewolf'},
  ],
};

/// Descriptor for `SeerReveal`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seerRevealDescriptor = $convert.base64Decode(
    'CgpTZWVyUmV2ZWFsEhsKCXRhcmdldF9pZBgBIAEoCVIIdGFyZ2V0SWQSHwoLaXNfd2VyZXdvbG'
    'YYAiABKAhSCmlzV2VyZXdvbGY=');

@$core.Deprecated('Use foxRevealDescriptor instead')
const FoxReveal$json = {
  '1': 'FoxReveal',
  '2': [
    {'1': 'any_werewolf_found', '3': 1, '4': 1, '5': 8, '10': 'anyWerewolfFound'},
  ],
};

/// Descriptor for `FoxReveal`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List foxRevealDescriptor = $convert.base64Decode(
    'CglGb3hSZXZlYWwSLAoSYW55X3dlcmV3b2xmX2ZvdW5kGAEgASgIUhBhbnlXZXJld29sZkZvdW'
    '5k');

@$core.Deprecated('Use publicAnnouncementDescriptor instead')
const PublicAnnouncement$json = {
  '1': 'PublicAnnouncement',
  '2': [
    {'1': 'night_death', '3': 1, '4': 1, '5': 11, '6': '.werewolf.NightDeathEvent', '9': 0, '10': 'nightDeath'},
    {'1': 'no_death', '3': 2, '4': 1, '5': 11, '6': '.werewolf.NoDeathEvent', '9': 0, '10': 'noDeath'},
    {'1': 'vote_result', '3': 3, '4': 1, '5': 11, '6': '.werewolf.VoteResultEvent', '9': 0, '10': 'voteResult'},
    {'1': 'hunter_shot', '3': 4, '4': 1, '5': 11, '6': '.werewolf.HunterShotEvent', '9': 0, '10': 'hunterShot'},
    {'1': 'game_end', '3': 5, '4': 1, '5': 11, '6': '.werewolf.GameEndEvent', '9': 0, '10': 'gameEnd'},
  ],
  '8': [
    {'1': 'event'},
  ],
};

/// Descriptor for `PublicAnnouncement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publicAnnouncementDescriptor = $convert.base64Decode(
    'ChJQdWJsaWNBbm5vdW5jZW1lbnQSPAoLbmlnaHRfZGVhdGgYASABKAsyGS53ZXJld29sZi5OaW'
    'dodERlYXRoRXZlbnRIAFIKbmlnaHREZWF0aBIzCghub19kZWF0aBgCIAEoCzIWLndlcmV3b2xm'
    'Lk5vRGVhdGhFdmVudEgAUgdub0RlYXRoEjwKC3ZvdGVfcmVzdWx0GAMgASgLMhkud2VyZXdvbG'
    'YuVm90ZVJlc3VsdEV2ZW50SABSCnZvdGVSZXN1bHQSPAoLaHVudGVyX3Nob3QYBCABKAsyGS53'
    'ZXJld29sZi5IdW50ZXJTaG90RXZlbnRIAFIKaHVudGVyU2hvdBIzCghnYW1lX2VuZBgFIAEoCz'
    'IWLndlcmV3b2xmLkdhbWVFbmRFdmVudEgAUgdnYW1lRW5kQgcKBWV2ZW50');

@$core.Deprecated('Use nightDeathEventDescriptor instead')
const NightDeathEvent$json = {
  '1': 'NightDeathEvent',
  '2': [
    {'1': 'deaths', '3': 1, '4': 3, '5': 11, '6': '.werewolf.PlayerDeath', '10': 'deaths'},
  ],
};

/// Descriptor for `NightDeathEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List nightDeathEventDescriptor = $convert.base64Decode(
    'Cg9OaWdodERlYXRoRXZlbnQSLQoGZGVhdGhzGAEgAygLMhUud2VyZXdvbGYuUGxheWVyRGVhdG'
    'hSBmRlYXRocw==');

@$core.Deprecated('Use playerDeathDescriptor instead')
const PlayerDeath$json = {
  '1': 'PlayerDeath',
  '2': [
    {'1': 'player_id', '3': 1, '4': 1, '5': 9, '10': 'playerId'},
    {'1': 'cause', '3': 2, '4': 1, '5': 14, '6': '.werewolf.EliminationCause', '10': 'cause'},
  ],
};

/// Descriptor for `PlayerDeath`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playerDeathDescriptor = $convert.base64Decode(
    'CgtQbGF5ZXJEZWF0aBIbCglwbGF5ZXJfaWQYASABKAlSCHBsYXllcklkEjAKBWNhdXNlGAIgAS'
    'gOMhoud2VyZXdvbGYuRWxpbWluYXRpb25DYXVzZVIFY2F1c2U=');

@$core.Deprecated('Use noDeathEventDescriptor instead')
const NoDeathEvent$json = {
  '1': 'NoDeathEvent',
};

/// Descriptor for `NoDeathEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List noDeathEventDescriptor = $convert.base64Decode(
    'CgxOb0RlYXRoRXZlbnQ=');

@$core.Deprecated('Use voteResultEventDescriptor instead')
const VoteResultEvent$json = {
  '1': 'VoteResultEvent',
  '2': [
    {'1': 'eliminated_player_id', '3': 1, '4': 1, '5': 9, '10': 'eliminatedPlayerId'},
    {'1': 'tied', '3': 2, '4': 1, '5': 8, '10': 'tied'},
  ],
};

/// Descriptor for `VoteResultEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voteResultEventDescriptor = $convert.base64Decode(
    'Cg9Wb3RlUmVzdWx0RXZlbnQSMAoUZWxpbWluYXRlZF9wbGF5ZXJfaWQYASABKAlSEmVsaW1pbm'
    'F0ZWRQbGF5ZXJJZBISCgR0aWVkGAIgASgIUgR0aWVk');

@$core.Deprecated('Use hunterShotEventDescriptor instead')
const HunterShotEvent$json = {
  '1': 'HunterShotEvent',
  '2': [
    {'1': 'shooter_id', '3': 1, '4': 1, '5': 9, '10': 'shooterId'},
    {'1': 'target_id', '3': 2, '4': 1, '5': 9, '10': 'targetId'},
  ],
};

/// Descriptor for `HunterShotEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hunterShotEventDescriptor = $convert.base64Decode(
    'Cg9IdW50ZXJTaG90RXZlbnQSHQoKc2hvb3Rlcl9pZBgBIAEoCVIJc2hvb3RlcklkEhsKCXRhcm'
    'dldF9pZBgCIAEoCVIIdGFyZ2V0SWQ=');

@$core.Deprecated('Use gameEndEventDescriptor instead')
const GameEndEvent$json = {
  '1': 'GameEndEvent',
  '2': [
    {'1': 'winning_team', '3': 1, '4': 1, '5': 14, '6': '.werewolf.Role', '10': 'winningTeam'},
  ],
};

/// Descriptor for `GameEndEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameEndEventDescriptor = $convert.base64Decode(
    'CgxHYW1lRW5kRXZlbnQSMQoMd2lubmluZ190ZWFtGAEgASgOMg4ud2VyZXdvbGYuUm9sZVILd2'
    'lubmluZ1RlYW0=');

@$core.Deprecated('Use pauseRequestDescriptor instead')
const PauseRequest$json = {
  '1': 'PauseRequest',
  '2': [
    {'1': 'lobby_code', '3': 1, '4': 1, '5': 9, '10': 'lobbyCode'},
  ],
};

/// Descriptor for `PauseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pauseRequestDescriptor = $convert.base64Decode(
    'CgxQYXVzZVJlcXVlc3QSHQoKbG9iYnlfY29kZRgBIAEoCVIJbG9iYnlDb2Rl');

@$core.Deprecated('Use pauseStateDescriptor instead')
const PauseState$json = {
  '1': 'PauseState',
  '2': [
    {'1': 'is_paused', '3': 1, '4': 1, '5': 8, '10': 'isPaused'},
    {'1': 'vote_count', '3': 2, '4': 1, '5': 5, '10': 'voteCount'},
    {'1': 'votes_needed', '3': 3, '4': 1, '5': 5, '10': 'votesNeeded'},
    {'1': 'you_voted', '3': 4, '4': 1, '5': 8, '10': 'youVoted'},
    {'1': 'paused_until', '3': 5, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'pausedUntil'},
  ],
};

/// Descriptor for `PauseState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pauseStateDescriptor = $convert.base64Decode(
    'CgpQYXVzZVN0YXRlEhsKCWlzX3BhdXNlZBgBIAEoCFIIaXNQYXVzZWQSHQoKdm90ZV9jb3VudB'
    'gCIAEoBVIJdm90ZUNvdW50EiEKDHZvdGVzX25lZWRlZBgDIAEoBVILdm90ZXNOZWVkZWQSGwoJ'
    'eW91X3ZvdGVkGAQgASgIUgh5b3VWb3RlZBI9CgxwYXVzZWRfdW50aWwYBSABKAsyGi5nb29nbG'
    'UucHJvdG9idWYuVGltZXN0YW1wUgtwYXVzZWRVbnRpbA==');

