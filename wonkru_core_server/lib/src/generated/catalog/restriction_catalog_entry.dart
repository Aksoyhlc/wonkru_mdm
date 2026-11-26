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

abstract class RestrictionCatalogEntry
    implements _is.SerializableModel, _is.ProtocolSerialization {
  RestrictionCatalogEntry._({
    required this.name,
    required this.key,
    required this.apiLevel,
    this.group,
  });

  factory RestrictionCatalogEntry({
    required String name,
    required String key,
    required int apiLevel,
    String? group,
  }) = _RestrictionCatalogEntryImpl;

  factory RestrictionCatalogEntry.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return RestrictionCatalogEntry(
      name: jsonSerialization['name'] as String,
      key: jsonSerialization['key'] as String,
      apiLevel: jsonSerialization['apiLevel'] as int,
      group: jsonSerialization['group'] as String?,
    );
  }

  String name;

  /// Wire key, e.g. `no_camera`.
  String key;

  int apiLevel;

  String? group;

  /// Returns a shallow copy of this [RestrictionCatalogEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  RestrictionCatalogEntry copyWith({
    String? name,
    String? key,
    int? apiLevel,
    String? group,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'wonkru_core.RestrictionCatalogEntry',
      'name': name,
      'key': key,
      'apiLevel': apiLevel,
      if (group != null) 'group': group,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'wonkru_core.RestrictionCatalogEntry',
      'name': name,
      'key': key,
      'apiLevel': apiLevel,
      if (group != null) 'group': group,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RestrictionCatalogEntryImpl extends RestrictionCatalogEntry {
  _RestrictionCatalogEntryImpl({
    required String name,
    required String key,
    required int apiLevel,
    String? group,
  }) : super._(
         name: name,
         key: key,
         apiLevel: apiLevel,
         group: group,
       );

  /// Returns a shallow copy of this [RestrictionCatalogEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  RestrictionCatalogEntry copyWith({
    String? name,
    String? key,
    int? apiLevel,
    Object? group = _Undefined,
  }) {
    return RestrictionCatalogEntry(
      name: name ?? this.name,
      key: key ?? this.key,
      apiLevel: apiLevel ?? this.apiLevel,
      group: group is String? ? group : this.group,
    );
  }
}
