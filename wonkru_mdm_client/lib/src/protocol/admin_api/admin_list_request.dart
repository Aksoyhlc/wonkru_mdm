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

abstract class AdminListRequest
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AdminListRequest._({
    int? page,
    int? perPage,
    this.search,
    this.sortBy,
    bool? sortDesc,
  }) : page = page ?? 1,
       perPage = perPage ?? 25,
       sortDesc = sortDesc ?? false;

  factory AdminListRequest({
    int? page,
    int? perPage,
    String? search,
    String? sortBy,
    bool? sortDesc,
  }) = _AdminListRequestImpl;

  factory AdminListRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminListRequest(
      page: jsonSerialization['page'] as int?,
      perPage: jsonSerialization['perPage'] as int?,
      search: jsonSerialization['search'] as String?,
      sortBy: jsonSerialization['sortBy'] as String?,
      sortDesc: jsonSerialization['sortDesc'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['sortDesc']),
    );
  }

  int page;

  int perPage;

  String? search;

  String? sortBy;

  bool sortDesc;

  /// Returns a shallow copy of this [AdminListRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AdminListRequest copyWith({
    int? page,
    int? perPage,
    String? search,
    String? sortBy,
    bool? sortDesc,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminListRequest',
      'page': page,
      'perPage': perPage,
      if (search != null) 'search': search,
      if (sortBy != null) 'sortBy': sortBy,
      'sortDesc': sortDesc,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminListRequest',
      'page': page,
      'perPage': perPage,
      if (search != null) 'search': search,
      if (sortBy != null) 'sortBy': sortBy,
      'sortDesc': sortDesc,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminListRequestImpl extends AdminListRequest {
  _AdminListRequestImpl({
    int? page,
    int? perPage,
    String? search,
    String? sortBy,
    bool? sortDesc,
  }) : super._(
         page: page,
         perPage: perPage,
         search: search,
         sortBy: sortBy,
         sortDesc: sortDesc,
       );

  /// Returns a shallow copy of this [AdminListRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AdminListRequest copyWith({
    int? page,
    int? perPage,
    Object? search = _Undefined,
    Object? sortBy = _Undefined,
    bool? sortDesc,
  }) {
    return AdminListRequest(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      search: search is String? ? search : this.search,
      sortBy: sortBy is String? ? sortBy : this.sortBy,
      sortDesc: sortDesc ?? this.sortDesc,
    );
  }
}
