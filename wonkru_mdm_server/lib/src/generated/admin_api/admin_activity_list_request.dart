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

abstract class AdminActivityListRequest
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AdminActivityListRequest._({
    int? page,
    int? perPage,
    this.search,
    this.sortBy,
    bool? sortDesc,
    this.actorUserId,
    this.action,
    this.from,
    this.to,
  }) : page = page ?? 1,
       perPage = perPage ?? 25,
       sortDesc = sortDesc ?? false;

  factory AdminActivityListRequest({
    int? page,
    int? perPage,
    String? search,
    String? sortBy,
    bool? sortDesc,
    _is.UuidValue? actorUserId,
    String? action,
    DateTime? from,
    DateTime? to,
  }) = _AdminActivityListRequestImpl;

  factory AdminActivityListRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AdminActivityListRequest(
      page: jsonSerialization['page'] as int?,
      perPage: jsonSerialization['perPage'] as int?,
      search: jsonSerialization['search'] as String?,
      sortBy: jsonSerialization['sortBy'] as String?,
      sortDesc: jsonSerialization['sortDesc'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['sortDesc']),
      actorUserId: jsonSerialization['actorUserId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['actorUserId'],
            ),
      action: jsonSerialization['action'] as String?,
      from: jsonSerialization['from'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['from']),
      to: jsonSerialization['to'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['to']),
    );
  }

  int page;

  int perPage;

  /// Free text search over actor name/email and target id.
  String? search;

  /// Column to order by (`createdAt`, `action`).
  String? sortBy;

  bool sortDesc;

  _is.UuidValue? actorUserId;

  String? action;

  DateTime? from;

  DateTime? to;

  /// Returns a shallow copy of this [AdminActivityListRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdminActivityListRequest copyWith({
    int? page,
    int? perPage,
    String? search,
    String? sortBy,
    bool? sortDesc,
    _is.UuidValue? actorUserId = const _is.$UndefinedUuidValue(),
    String? action,
    DateTime? from = const _is.$UndefinedDateTime(),
    DateTime? to = const _is.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminActivityListRequest',
      'page': page,
      'perPage': perPage,
      if (search != null) 'search': search,
      if (sortBy != null) 'sortBy': sortBy,
      'sortDesc': sortDesc,
      if (actorUserId != null) 'actorUserId': actorUserId?.toJson(),
      if (action != null) 'action': action,
      if (from != null) 'from': from?.toJson(),
      if (to != null) 'to': to?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminActivityListRequest',
      'page': page,
      'perPage': perPage,
      if (search != null) 'search': search,
      if (sortBy != null) 'sortBy': sortBy,
      'sortDesc': sortDesc,
      if (actorUserId != null) 'actorUserId': actorUserId?.toJson(),
      if (action != null) 'action': action,
      if (from != null) 'from': from?.toJson(),
      if (to != null) 'to': to?.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminActivityListRequestImpl extends AdminActivityListRequest {
  _AdminActivityListRequestImpl({
    int? page,
    int? perPage,
    String? search,
    String? sortBy,
    bool? sortDesc,
    _is.UuidValue? actorUserId,
    String? action,
    DateTime? from,
    DateTime? to,
  }) : super._(
         page: page,
         perPage: perPage,
         search: search,
         sortBy: sortBy,
         sortDesc: sortDesc,
         actorUserId: actorUserId,
         action: action,
         from: from,
         to: to,
       );

  /// Returns a shallow copy of this [AdminActivityListRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdminActivityListRequest copyWith({
    int? page,
    int? perPage,
    Object? search = _Undefined,
    Object? sortBy = _Undefined,
    bool? sortDesc,
    _is.UuidValue? actorUserId = const _is.$UndefinedUuidValue(),
    Object? action = _Undefined,
    DateTime? from = const _is.$UndefinedDateTime(),
    DateTime? to = const _is.$UndefinedDateTime(),
  }) {
    return AdminActivityListRequest(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      search: search is String? ? search : this.search,
      sortBy: sortBy is String? ? sortBy : this.sortBy,
      sortDesc: sortDesc ?? this.sortDesc,
      actorUserId: actorUserId is _is.UndefinedSentinel
          ? this.actorUserId
          : actorUserId,
      action: action is String? ? action : this.action,
      from: from is _is.UndefinedSentinel ? this.from : from,
      to: to is _is.UndefinedSentinel ? this.to : to,
    );
  }
}
