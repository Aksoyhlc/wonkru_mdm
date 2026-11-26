/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import 'package:wonkru_mdm_server/src/generated/protocol.dart' as _ij1wyujj;

abstract class AdminDeviceLogListRequest
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AdminDeviceLogListRequest._({
    int? page,
    int? perPage,
    this.search,
    this.sortBy,
    bool? sortDesc,
    this.levels,
    this.deviceId,
    this.loggedFrom,
    this.loggedUntil,
    this.period,
    this.sessionId,
    this.tag,
    this.hasStacktrace,
  }) : page = page ?? 1,
       perPage = perPage ?? 25,
       sortDesc = sortDesc ?? false;

  factory AdminDeviceLogListRequest({
    int? page,
    int? perPage,
    String? search,
    String? sortBy,
    bool? sortDesc,
    List<int>? levels,
    int? deviceId,
    DateTime? loggedFrom,
    DateTime? loggedUntil,
    String? period,
    String? sessionId,
    String? tag,
    bool? hasStacktrace,
  }) = _AdminDeviceLogListRequestImpl;

  factory AdminDeviceLogListRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AdminDeviceLogListRequest(
      page: jsonSerialization['page'] as int?,
      perPage: jsonSerialization['perPage'] as int?,
      search: jsonSerialization['search'] as String?,
      sortBy: jsonSerialization['sortBy'] as String?,
      sortDesc: jsonSerialization['sortDesc'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['sortDesc']),
      levels: jsonSerialization['levels'] == null
          ? null
          : _ij1wyujj.Protocol().deserialize<List<int>>(
              jsonSerialization['levels'],
            ),
      deviceId: jsonSerialization['deviceId'] as int?,
      loggedFrom: jsonSerialization['loggedFrom'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['loggedFrom']),
      loggedUntil: jsonSerialization['loggedUntil'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['loggedUntil'],
            ),
      period: jsonSerialization['period'] as String?,
      sessionId: jsonSerialization['sessionId'] as String?,
      tag: jsonSerialization['tag'] as String?,
      hasStacktrace: jsonSerialization['hasStacktrace'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['hasStacktrace']),
    );
  }

  int page;

  int perPage;

  /// Searches tag, message and device identity.
  String? search;

  String? sortBy;

  bool sortDesc;

  List<int>? levels;

  int? deviceId;

  /// Inclusive lower bound of the `logged_at` range.
  DateTime? loggedFrom;

  /// Inclusive upper bound of the `logged_at` range.
  DateTime? loggedUntil;

  /// Named range. Accepted values: `today`, `yesterday`, `last_7_days`,
  /// `last_30_days`, `this_week` and `this_month`.
  String? period;

  String? sessionId;

  String? tag;

  bool? hasStacktrace;

  /// Returns a shallow copy of this [AdminDeviceLogListRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdminDeviceLogListRequest copyWith({
    int? page,
    int? perPage,
    String? search,
    String? sortBy,
    bool? sortDesc,
    List<int>? levels = const _is.$UndefinedList<int>(),
    int? deviceId,
    DateTime? loggedFrom = const _is.$UndefinedDateTime(),
    DateTime? loggedUntil = const _is.$UndefinedDateTime(),
    String? period,
    String? sessionId,
    String? tag,
    bool? hasStacktrace,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminDeviceLogListRequest',
      'page': page,
      'perPage': perPage,
      if (search != null) 'search': search,
      if (sortBy != null) 'sortBy': sortBy,
      'sortDesc': sortDesc,
      if (levels != null) 'levels': levels?.toJson(),
      if (deviceId != null) 'deviceId': deviceId,
      if (loggedFrom != null) 'loggedFrom': loggedFrom?.toJson(),
      if (loggedUntil != null) 'loggedUntil': loggedUntil?.toJson(),
      if (period != null) 'period': period,
      if (sessionId != null) 'sessionId': sessionId,
      if (tag != null) 'tag': tag,
      if (hasStacktrace != null) 'hasStacktrace': hasStacktrace,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminDeviceLogListRequest',
      'page': page,
      'perPage': perPage,
      if (search != null) 'search': search,
      if (sortBy != null) 'sortBy': sortBy,
      'sortDesc': sortDesc,
      if (levels != null) 'levels': levels?.toJson(),
      if (deviceId != null) 'deviceId': deviceId,
      if (loggedFrom != null) 'loggedFrom': loggedFrom?.toJson(),
      if (loggedUntil != null) 'loggedUntil': loggedUntil?.toJson(),
      if (period != null) 'period': period,
      if (sessionId != null) 'sessionId': sessionId,
      if (tag != null) 'tag': tag,
      if (hasStacktrace != null) 'hasStacktrace': hasStacktrace,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminDeviceLogListRequestImpl extends AdminDeviceLogListRequest {
  _AdminDeviceLogListRequestImpl({
    int? page,
    int? perPage,
    String? search,
    String? sortBy,
    bool? sortDesc,
    List<int>? levels,
    int? deviceId,
    DateTime? loggedFrom,
    DateTime? loggedUntil,
    String? period,
    String? sessionId,
    String? tag,
    bool? hasStacktrace,
  }) : super._(
         page: page,
         perPage: perPage,
         search: search,
         sortBy: sortBy,
         sortDesc: sortDesc,
         levels: levels,
         deviceId: deviceId,
         loggedFrom: loggedFrom,
         loggedUntil: loggedUntil,
         period: period,
         sessionId: sessionId,
         tag: tag,
         hasStacktrace: hasStacktrace,
       );

  /// Returns a shallow copy of this [AdminDeviceLogListRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdminDeviceLogListRequest copyWith({
    int? page,
    int? perPage,
    Object? search = _Undefined,
    Object? sortBy = _Undefined,
    bool? sortDesc,
    List<int>? levels = const _is.$UndefinedList<int>(),
    Object? deviceId = _Undefined,
    DateTime? loggedFrom = const _is.$UndefinedDateTime(),
    DateTime? loggedUntil = const _is.$UndefinedDateTime(),
    Object? period = _Undefined,
    Object? sessionId = _Undefined,
    Object? tag = _Undefined,
    Object? hasStacktrace = _Undefined,
  }) {
    return AdminDeviceLogListRequest(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      search: search is String? ? search : this.search,
      sortBy: sortBy is String? ? sortBy : this.sortBy,
      sortDesc: sortDesc ?? this.sortDesc,
      levels: levels is _is.UndefinedSentinel
          ? this.levels?.map((e0) => e0).toList()
          : levels,
      deviceId: deviceId is int? ? deviceId : this.deviceId,
      loggedFrom: loggedFrom is _is.UndefinedSentinel
          ? this.loggedFrom
          : loggedFrom,
      loggedUntil: loggedUntil is _is.UndefinedSentinel
          ? this.loggedUntil
          : loggedUntil,
      period: period is String? ? period : this.period,
      sessionId: sessionId is String? ? sessionId : this.sessionId,
      tag: tag is String? ? tag : this.tag,
      hasStacktrace: hasStacktrace is bool?
          ? hasStacktrace
          : this.hasStacktrace,
    );
  }
}
