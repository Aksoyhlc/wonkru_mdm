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

abstract class DeviceGroup
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DeviceGroup._({
    this.id,
    required this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory DeviceGroup({
    int? id,
    required String name,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) = _DeviceGroupImpl;

  factory DeviceGroup.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceGroup(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String? description;

  DateTime? createdAt;

  DateTime? updatedAt;

  DateTime? deletedAt;

  /// Returns a shallow copy of this [DeviceGroup]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DeviceGroup copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
    DateTime? deletedAt = const _isc.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceGroup',
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceGroup',
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeviceGroupImpl extends DeviceGroup {
  _DeviceGroupImpl({
    int? id,
    required String name,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) : super._(
         id: id,
         name: name,
         description: description,
         createdAt: createdAt,
         updatedAt: updatedAt,
         deletedAt: deletedAt,
       );

  /// Returns a shallow copy of this [DeviceGroup]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DeviceGroup copyWith({
    Object? id = _Undefined,
    String? name,
    Object? description = _Undefined,
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
    DateTime? deletedAt = const _isc.$UndefinedDateTime(),
  }) {
    return DeviceGroup(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      createdAt: createdAt is _isc.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      updatedAt: updatedAt is _isc.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
      deletedAt: deletedAt is _isc.UndefinedSentinel
          ? this.deletedAt
          : deletedAt,
    );
  }
}
