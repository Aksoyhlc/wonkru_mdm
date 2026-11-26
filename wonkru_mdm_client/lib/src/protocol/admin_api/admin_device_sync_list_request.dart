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
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class AdminDeviceSyncListRequest
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AdminDeviceSyncListRequest._({
    int? page,
    int? perPage,
    this.search,
    this.sortBy,
    bool? sortDesc,
    this.deviceId,
    this.from,
    this.to,
  }) : page = page ?? 1,
       perPage = perPage ?? 25,
       sortDesc = sortDesc ?? false;

  factory AdminDeviceSyncListRequest({
    int? page,
    int? perPage,
    String? search,
    String? sortBy,
    bool? sortDesc,
    int? deviceId,
    DateTime? from,
    DateTime? to,
  }) = _AdminDeviceSyncListRequestImpl;

  factory AdminDeviceSyncListRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AdminDeviceSyncListRequest(
      page: jsonSerialization['page'] as int?,
      perPage: jsonSerialization['perPage'] as int?,
      search: jsonSerialization['search'] as String?,
      sortBy: jsonSerialization['sortBy'] as String?,
      sortDesc: jsonSerialization['sortDesc'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['sortDesc']),
      deviceId: jsonSerialization['deviceId'] as int?,
      from: jsonSerialization['from'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['from']),
      to: jsonSerialization['to'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['to']),
    );
  }

  int page;

  int perPage;

  String? search;

  String? sortBy;

  bool sortDesc;

  int? deviceId;

  /// Inclusive lower bound of the `collected_at` range.
  DateTime? from;

  /// Inclusive upper bound of the `collected_at` range.
  DateTime? to;

  /// Returns a shallow copy of this [AdminDeviceSyncListRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AdminDeviceSyncListRequest copyWith({
    int? page,
    int? perPage,
    String? search,
    String? sortBy,
    bool? sortDesc,
    int? deviceId,
    DateTime? from = const _isc.$UndefinedDateTime(),
    DateTime? to = const _isc.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminDeviceSyncListRequest',
      'page': page,
      'perPage': perPage,
      if (search != null) 'search': search,
      if (sortBy != null) 'sortBy': sortBy,
      'sortDesc': sortDesc,
      if (deviceId != null) 'deviceId': deviceId,
      if (from != null) 'from': from?.toJson(),
      if (to != null) 'to': to?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminDeviceSyncListRequest',
      'page': page,
      'perPage': perPage,
      if (search != null) 'search': search,
      if (sortBy != null) 'sortBy': sortBy,
      'sortDesc': sortDesc,
      if (deviceId != null) 'deviceId': deviceId,
      if (from != null) 'from': from?.toJson(),
      if (to != null) 'to': to?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminDeviceSyncListRequestImpl extends AdminDeviceSyncListRequest {
  _AdminDeviceSyncListRequestImpl({
    int? page,
    int? perPage,
    String? search,
    String? sortBy,
    bool? sortDesc,
    int? deviceId,
    DateTime? from,
    DateTime? to,
  }) : super._(
         page: page,
         perPage: perPage,
         search: search,
         sortBy: sortBy,
         sortDesc: sortDesc,
         deviceId: deviceId,
         from: from,
         to: to,
       );

  /// Returns a shallow copy of this [AdminDeviceSyncListRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AdminDeviceSyncListRequest copyWith({
    int? page,
    int? perPage,
    Object? search = _Undefined,
    Object? sortBy = _Undefined,
    bool? sortDesc,
    Object? deviceId = _Undefined,
    DateTime? from = const _isc.$UndefinedDateTime(),
    DateTime? to = const _isc.$UndefinedDateTime(),
  }) {
    return AdminDeviceSyncListRequest(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      search: search is String? ? search : this.search,
      sortBy: sortBy is String? ? sortBy : this.sortBy,
      sortDesc: sortDesc ?? this.sortDesc,
      deviceId: deviceId is int? ? deviceId : this.deviceId,
      from: from is _isc.UndefinedSentinel ? this.from : from,
      to: to is _isc.UndefinedSentinel ? this.to : to,
    );
  }
}
