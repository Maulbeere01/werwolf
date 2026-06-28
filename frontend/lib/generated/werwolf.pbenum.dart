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

class Role extends $pb.ProtobufEnum {
  static const Role ROLE_UNSPECIFIED = Role._(0, _omitEnumNames ? '' : 'ROLE_UNSPECIFIED');
  static const Role WEREWOLF = Role._(1, _omitEnumNames ? '' : 'WEREWOLF');
  static const Role VILLAGER = Role._(2, _omitEnumNames ? '' : 'VILLAGER');
  static const Role SEER = Role._(3, _omitEnumNames ? '' : 'SEER');
  static const Role WITCH = Role._(4, _omitEnumNames ? '' : 'WITCH');
  static const Role FOX = Role._(5, _omitEnumNames ? '' : 'FOX');
  static const Role VILLAGE_IDIOT = Role._(6, _omitEnumNames ? '' : 'VILLAGE_IDIOT');
  static const Role HUNTER = Role._(7, _omitEnumNames ? '' : 'HUNTER');
  static const Role CUPID = Role._(8, _omitEnumNames ? '' : 'CUPID');
  static const Role SABOTEUR = Role._(9, _omitEnumNames ? '' : 'SABOTEUR');

  static const $core.List<Role> values = <Role> [
    ROLE_UNSPECIFIED,
    WEREWOLF,
    VILLAGER,
    SEER,
    WITCH,
    FOX,
    VILLAGE_IDIOT,
    HUNTER,
    CUPID,
    SABOTEUR,
  ];

  static final $core.Map<$core.int, Role> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Role? valueOf($core.int value) => _byValue[value];

  const Role._($core.int v, $core.String n) : super(v, n);
}

class Phase extends $pb.ProtobufEnum {
  static const Phase PHASE_UNSPECIFIED = Phase._(0, _omitEnumNames ? '' : 'PHASE_UNSPECIFIED');
  static const Phase LOBBY = Phase._(1, _omitEnumNames ? '' : 'LOBBY');
  static const Phase NIGHT_START = Phase._(2, _omitEnumNames ? '' : 'NIGHT_START');
  static const Phase NIGHT_WEREWOLVES = Phase._(3, _omitEnumNames ? '' : 'NIGHT_WEREWOLVES');
  static const Phase NIGHT_SEER = Phase._(4, _omitEnumNames ? '' : 'NIGHT_SEER');
  static const Phase NIGHT_WITCH = Phase._(5, _omitEnumNames ? '' : 'NIGHT_WITCH');
  static const Phase NIGHT_FOX = Phase._(6, _omitEnumNames ? '' : 'NIGHT_FOX');
  static const Phase NIGHT_SABOTEUR = Phase._(7, _omitEnumNames ? '' : 'NIGHT_SABOTEUR');
  static const Phase DAY_RESULT = Phase._(8, _omitEnumNames ? '' : 'DAY_RESULT');
  static const Phase DAY_DISCUSSION = Phase._(9, _omitEnumNames ? '' : 'DAY_DISCUSSION');
  static const Phase DAY_VOTING = Phase._(10, _omitEnumNames ? '' : 'DAY_VOTING');
  static const Phase HUNTER_REVENGE = Phase._(11, _omitEnumNames ? '' : 'HUNTER_REVENGE');
  static const Phase GAME_END = Phase._(12, _omitEnumNames ? '' : 'GAME_END');
  static const Phase NIGHT_CUPID = Phase._(13, _omitEnumNames ? '' : 'NIGHT_CUPID');

  static const $core.List<Phase> values = <Phase> [
    PHASE_UNSPECIFIED,
    LOBBY,
    NIGHT_START,
    NIGHT_WEREWOLVES,
    NIGHT_SEER,
    NIGHT_WITCH,
    NIGHT_FOX,
    NIGHT_SABOTEUR,
    DAY_RESULT,
    DAY_DISCUSSION,
    DAY_VOTING,
    HUNTER_REVENGE,
    GAME_END,
    NIGHT_CUPID,
  ];

  static final $core.Map<$core.int, Phase> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Phase? valueOf($core.int value) => _byValue[value];

  const Phase._($core.int v, $core.String n) : super(v, n);
}

class EliminationCause extends $pb.ProtobufEnum {
  static const EliminationCause CAUSE_UNSPECIFIED = EliminationCause._(0, _omitEnumNames ? '' : 'CAUSE_UNSPECIFIED');
  static const EliminationCause KILLED_BY_WEREWOLVES = EliminationCause._(1, _omitEnumNames ? '' : 'KILLED_BY_WEREWOLVES');
  static const EliminationCause KILLED_BY_WITCH = EliminationCause._(2, _omitEnumNames ? '' : 'KILLED_BY_WITCH');
  static const EliminationCause VOTED_OUT = EliminationCause._(3, _omitEnumNames ? '' : 'VOTED_OUT');
  static const EliminationCause CAUSE_HUNTER_REVENGE = EliminationCause._(4, _omitEnumNames ? '' : 'CAUSE_HUNTER_REVENGE');
  static const EliminationCause CAUSE_HEARTBREAK = EliminationCause._(5, _omitEnumNames ? '' : 'CAUSE_HEARTBREAK');

  static const $core.List<EliminationCause> values = <EliminationCause> [
    CAUSE_UNSPECIFIED,
    KILLED_BY_WEREWOLVES,
    KILLED_BY_WITCH,
    VOTED_OUT,
    CAUSE_HUNTER_REVENGE,
    CAUSE_HEARTBREAK,
  ];

  static final $core.Map<$core.int, EliminationCause> _byValue = $pb.ProtobufEnum.initByValue(values);
  static EliminationCause? valueOf($core.int value) => _byValue[value];

  const EliminationCause._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
