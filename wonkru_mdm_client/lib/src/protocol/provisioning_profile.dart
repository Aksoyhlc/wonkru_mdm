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

abstract class ProvisioningProfile
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProvisioningProfile._({
    this.id,
    required this.name,
    this.description,
    required this.config,
    bool? isActive,
    this.createdById,
    this.createdAt,
    this.updatedAt,
  }) : isActive = isActive ?? true;

  factory ProvisioningProfile({
    int? id,
    required String name,
    String? description,
    required String config,
    bool? isActive,
    _isc.UuidValue? createdById,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ProvisioningProfileImpl;

  factory ProvisioningProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProvisioningProfile(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      config: jsonSerialization['config'] as String,
      isActive: jsonSerialization['isActive'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      createdById: jsonSerialization['createdById'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['createdById'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String? description;

  /// JSON configuration payload.
  String config;

  bool isActive;

  _isc.UuidValue? createdById;

  DateTime? createdAt;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [ProvisioningProfile]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProvisioningProfile copyWith({
    int? id,
    String? name,
    String? description,
    String? config,
    bool? isActive,
    _isc.UuidValue? createdById = const _isc.$UndefinedUuidValue(),
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProvisioningProfile',
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      'config': config,
      'isActive': isActive,
      if (createdById != null) 'createdById': createdById?.toJson(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProvisioningProfile',
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      'config': config,
      'isActive': isActive,
      if (createdById != null) 'createdById': createdById?.toJson(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProvisioningProfileImpl extends ProvisioningProfile {
  _ProvisioningProfileImpl({
    int? id,
    required String name,
    String? description,
    required String config,
    bool? isActive,
    _isc.UuidValue? createdById,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         name: name,
         description: description,
         config: config,
         isActive: isActive,
         createdById: createdById,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ProvisioningProfile]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProvisioningProfile copyWith({
    Object? id = _Undefined,
    String? name,
    Object? description = _Undefined,
    String? config,
    bool? isActive,
    _isc.UuidValue? createdById = const _isc.$UndefinedUuidValue(),
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
  }) {
    return ProvisioningProfile(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      config: config ?? this.config,
      isActive: isActive ?? this.isActive,
      createdById: createdById is _isc.UndefinedSentinel
          ? this.createdById
          : createdById,
      createdAt: createdAt is _isc.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      updatedAt: updatedAt is _isc.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
    );
  }
}
