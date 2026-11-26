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

abstract class PolicyListRequest
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PolicyListRequest._({
    int? page,
    int? perPage,
    this.search,
    this.sortBy,
    bool? sortDesc,
    this.isActive,
    this.defaultPolicy,
  }) : page = page ?? 1,
       perPage = perPage ?? 25,
       sortDesc = sortDesc ?? false;

  factory PolicyListRequest({
    int? page,
    int? perPage,
    String? search,
    String? sortBy,
    bool? sortDesc,
    bool? isActive,
    bool? defaultPolicy,
  }) = _PolicyListRequestImpl;

  factory PolicyListRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return PolicyListRequest(
      page: jsonSerialization['page'] as int?,
      perPage: jsonSerialization['perPage'] as int?,
      search: jsonSerialization['search'] as String?,
      sortBy: jsonSerialization['sortBy'] as String?,
      sortDesc: jsonSerialization['sortDesc'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['sortDesc']),
      isActive: jsonSerialization['isActive'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      defaultPolicy: jsonSerialization['defaultPolicy'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['defaultPolicy']),
    );
  }

  /// One-based page number.
  int page;

  int perPage;

  /// Free text search applied to the policy name.
  String? search;

  String? sortBy;

  bool sortDesc;

  /// Ternary filter: `true` active, `false` inactive, null both.
  bool? isActive;

  bool? defaultPolicy;

  /// Returns a shallow copy of this [PolicyListRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PolicyListRequest copyWith({
    int? page,
    int? perPage,
    String? search,
    String? sortBy,
    bool? sortDesc,
    bool? isActive,
    bool? defaultPolicy,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PolicyListRequest',
      'page': page,
      'perPage': perPage,
      if (search != null) 'search': search,
      if (sortBy != null) 'sortBy': sortBy,
      'sortDesc': sortDesc,
      if (isActive != null) 'isActive': isActive,
      if (defaultPolicy != null) 'defaultPolicy': defaultPolicy,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PolicyListRequest',
      'page': page,
      'perPage': perPage,
      if (search != null) 'search': search,
      if (sortBy != null) 'sortBy': sortBy,
      'sortDesc': sortDesc,
      if (isActive != null) 'isActive': isActive,
      if (defaultPolicy != null) 'defaultPolicy': defaultPolicy,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PolicyListRequestImpl extends PolicyListRequest {
  _PolicyListRequestImpl({
    int? page,
    int? perPage,
    String? search,
    String? sortBy,
    bool? sortDesc,
    bool? isActive,
    bool? defaultPolicy,
  }) : super._(
         page: page,
         perPage: perPage,
         search: search,
         sortBy: sortBy,
         sortDesc: sortDesc,
         isActive: isActive,
         defaultPolicy: defaultPolicy,
       );

  /// Returns a shallow copy of this [PolicyListRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PolicyListRequest copyWith({
    int? page,
    int? perPage,
    Object? search = _Undefined,
    Object? sortBy = _Undefined,
    bool? sortDesc,
    Object? isActive = _Undefined,
    Object? defaultPolicy = _Undefined,
  }) {
    return PolicyListRequest(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      search: search is String? ? search : this.search,
      sortBy: sortBy is String? ? sortBy : this.sortBy,
      sortDesc: sortDesc ?? this.sortDesc,
      isActive: isActive is bool? ? isActive : this.isActive,
      defaultPolicy: defaultPolicy is bool?
          ? defaultPolicy
          : this.defaultPolicy,
    );
  }
}
