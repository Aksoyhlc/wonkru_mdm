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
import 'package:wonkru_mdm_client/src/protocol/protocol.dart' as _icclvb2d;

abstract class FileListRequest
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  FileListRequest._({
    int? page,
    int? perPage,
    this.search,
    this.sortBy,
    bool? sortDesc,
    this.extensions,
    this.mimeTypes,
    this.fileGroupIds,
  }) : page = page ?? 1,
       perPage = perPage ?? 25,
       sortDesc = sortDesc ?? false;

  factory FileListRequest({
    int? page,
    int? perPage,
    String? search,
    String? sortBy,
    bool? sortDesc,
    List<String>? extensions,
    List<String>? mimeTypes,
    List<int>? fileGroupIds,
  }) = _FileListRequestImpl;

  factory FileListRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return FileListRequest(
      page: jsonSerialization['page'] as int?,
      perPage: jsonSerialization['perPage'] as int?,
      search: jsonSerialization['search'] as String?,
      sortBy: jsonSerialization['sortBy'] as String?,
      sortDesc: jsonSerialization['sortDesc'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['sortDesc']),
      extensions: jsonSerialization['extensions'] == null
          ? null
          : _icclvb2d.Protocol().deserialize<List<String>>(
              jsonSerialization['extensions'],
            ),
      mimeTypes: jsonSerialization['mimeTypes'] == null
          ? null
          : _icclvb2d.Protocol().deserialize<List<String>>(
              jsonSerialization['mimeTypes'],
            ),
      fileGroupIds: jsonSerialization['fileGroupIds'] == null
          ? null
          : _icclvb2d.Protocol().deserialize<List<int>>(
              jsonSerialization['fileGroupIds'],
            ),
    );
  }

  /// One-based page number.
  int page;

  int perPage;

  /// Free text search across display name, path, public url and checksum.
  String? search;

  String? sortBy;

  bool sortDesc;

  List<String>? extensions;

  List<String>? mimeTypes;

  List<int>? fileGroupIds;

  /// Returns a shallow copy of this [FileListRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FileListRequest copyWith({
    int? page,
    int? perPage,
    String? search,
    String? sortBy,
    bool? sortDesc,
    List<String>? extensions = const _isc.$UndefinedList<String>(),
    List<String>? mimeTypes = const _isc.$UndefinedList<String>(),
    List<int>? fileGroupIds = const _isc.$UndefinedList<int>(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FileListRequest',
      'page': page,
      'perPage': perPage,
      if (search != null) 'search': search,
      if (sortBy != null) 'sortBy': sortBy,
      'sortDesc': sortDesc,
      if (extensions != null) 'extensions': extensions?.toJson(),
      if (mimeTypes != null) 'mimeTypes': mimeTypes?.toJson(),
      if (fileGroupIds != null) 'fileGroupIds': fileGroupIds?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FileListRequest',
      'page': page,
      'perPage': perPage,
      if (search != null) 'search': search,
      if (sortBy != null) 'sortBy': sortBy,
      'sortDesc': sortDesc,
      if (extensions != null) 'extensions': extensions?.toJson(),
      if (mimeTypes != null) 'mimeTypes': mimeTypes?.toJson(),
      if (fileGroupIds != null) 'fileGroupIds': fileGroupIds?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FileListRequestImpl extends FileListRequest {
  _FileListRequestImpl({
    int? page,
    int? perPage,
    String? search,
    String? sortBy,
    bool? sortDesc,
    List<String>? extensions,
    List<String>? mimeTypes,
    List<int>? fileGroupIds,
  }) : super._(
         page: page,
         perPage: perPage,
         search: search,
         sortBy: sortBy,
         sortDesc: sortDesc,
         extensions: extensions,
         mimeTypes: mimeTypes,
         fileGroupIds: fileGroupIds,
       );

  /// Returns a shallow copy of this [FileListRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  FileListRequest copyWith({
    int? page,
    int? perPage,
    Object? search = _Undefined,
    Object? sortBy = _Undefined,
    bool? sortDesc,
    List<String>? extensions = const _isc.$UndefinedList<String>(),
    List<String>? mimeTypes = const _isc.$UndefinedList<String>(),
    List<int>? fileGroupIds = const _isc.$UndefinedList<int>(),
  }) {
    return FileListRequest(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      search: search is String? ? search : this.search,
      sortBy: sortBy is String? ? sortBy : this.sortBy,
      sortDesc: sortDesc ?? this.sortDesc,
      extensions: extensions is _isc.UndefinedSentinel
          ? this.extensions?.map((e0) => e0).toList()
          : extensions,
      mimeTypes: mimeTypes is _isc.UndefinedSentinel
          ? this.mimeTypes?.map((e0) => e0).toList()
          : mimeTypes,
      fileGroupIds: fileGroupIds is _isc.UndefinedSentinel
          ? this.fileGroupIds?.map((e0) => e0).toList()
          : fileGroupIds,
    );
  }
}
