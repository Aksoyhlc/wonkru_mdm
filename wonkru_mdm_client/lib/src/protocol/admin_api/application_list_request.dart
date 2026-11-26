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

abstract class ApplicationListRequest
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ApplicationListRequest._({
    int? page,
    int? perPage,
    this.search,
    this.sortBy,
    bool? sortDesc,
    this.sourceType,
    this.category,
    this.isSystemApp,
  }) : page = page ?? 1,
       perPage = perPage ?? 25,
       sortDesc = sortDesc ?? false;

  factory ApplicationListRequest({
    int? page,
    int? perPage,
    String? search,
    String? sortBy,
    bool? sortDesc,
    String? sourceType,
    String? category,
    bool? isSystemApp,
  }) = _ApplicationListRequestImpl;

  factory ApplicationListRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ApplicationListRequest(
      page: jsonSerialization['page'] as int?,
      perPage: jsonSerialization['perPage'] as int?,
      search: jsonSerialization['search'] as String?,
      sortBy: jsonSerialization['sortBy'] as String?,
      sortDesc: jsonSerialization['sortDesc'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['sortDesc']),
      sourceType: jsonSerialization['sourceType'] as String?,
      category: jsonSerialization['category'] as String?,
      isSystemApp: jsonSerialization['isSystemApp'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isSystemApp']),
    );
  }

  int page;

  int perPage;

  String? search;

  String? sortBy;

  bool sortDesc;

  String? sourceType;

  String? category;

  /// Ternary: `true` keeps system apps, `false` user-installed.
  bool? isSystemApp;

  /// Returns a shallow copy of this [ApplicationListRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ApplicationListRequest copyWith({
    int? page,
    int? perPage,
    String? search,
    String? sortBy,
    bool? sortDesc,
    String? sourceType,
    String? category,
    bool? isSystemApp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ApplicationListRequest',
      'page': page,
      'perPage': perPage,
      if (search != null) 'search': search,
      if (sortBy != null) 'sortBy': sortBy,
      'sortDesc': sortDesc,
      if (sourceType != null) 'sourceType': sourceType,
      if (category != null) 'category': category,
      if (isSystemApp != null) 'isSystemApp': isSystemApp,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ApplicationListRequest',
      'page': page,
      'perPage': perPage,
      if (search != null) 'search': search,
      if (sortBy != null) 'sortBy': sortBy,
      'sortDesc': sortDesc,
      if (sourceType != null) 'sourceType': sourceType,
      if (category != null) 'category': category,
      if (isSystemApp != null) 'isSystemApp': isSystemApp,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ApplicationListRequestImpl extends ApplicationListRequest {
  _ApplicationListRequestImpl({
    int? page,
    int? perPage,
    String? search,
    String? sortBy,
    bool? sortDesc,
    String? sourceType,
    String? category,
    bool? isSystemApp,
  }) : super._(
         page: page,
         perPage: perPage,
         search: search,
         sortBy: sortBy,
         sortDesc: sortDesc,
         sourceType: sourceType,
         category: category,
         isSystemApp: isSystemApp,
       );

  /// Returns a shallow copy of this [ApplicationListRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ApplicationListRequest copyWith({
    int? page,
    int? perPage,
    Object? search = _Undefined,
    Object? sortBy = _Undefined,
    bool? sortDesc,
    Object? sourceType = _Undefined,
    Object? category = _Undefined,
    Object? isSystemApp = _Undefined,
  }) {
    return ApplicationListRequest(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      search: search is String? ? search : this.search,
      sortBy: sortBy is String? ? sortBy : this.sortBy,
      sortDesc: sortDesc ?? this.sortDesc,
      sourceType: sourceType is String? ? sourceType : this.sourceType,
      category: category is String? ? category : this.category,
      isSystemApp: isSystemApp is bool? ? isSystemApp : this.isSystemApp,
    );
  }
}
