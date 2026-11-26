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

abstract class Policy
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Policy._({
    this.id,
    required this.name,
    this.slug,
    this.description,
    this.activeTimeRanges,
    bool? isActive,
    int? version,
    bool? defaultPolicy,
    this.adminPassword,
    this.batterySettings,
    this.storageSettings,
    this.audioSettings,
    this.displaySettings,
    this.securitySettings,
    this.restrictionSettings,
    this.launcher,
    this.syncSettings,
    this.otherSettings,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  }) : isActive = isActive ?? true,
       version = version ?? 1,
       defaultPolicy = defaultPolicy ?? false;

  factory Policy({
    int? id,
    required String name,
    String? slug,
    String? description,
    String? activeTimeRanges,
    bool? isActive,
    int? version,
    bool? defaultPolicy,
    String? adminPassword,
    String? batterySettings,
    String? storageSettings,
    String? audioSettings,
    String? displaySettings,
    String? securitySettings,
    String? restrictionSettings,
    String? launcher,
    String? syncSettings,
    String? otherSettings,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) = _PolicyImpl;

  factory Policy.fromJson(Map<String, dynamic> jsonSerialization) {
    return Policy(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      slug: jsonSerialization['slug'] as String?,
      description: jsonSerialization['description'] as String?,
      activeTimeRanges: jsonSerialization['activeTimeRanges'] as String?,
      isActive: jsonSerialization['isActive'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      version: jsonSerialization['version'] as int?,
      defaultPolicy: jsonSerialization['defaultPolicy'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['defaultPolicy']),
      adminPassword: jsonSerialization['adminPassword'] as String?,
      batterySettings: jsonSerialization['batterySettings'] as String?,
      storageSettings: jsonSerialization['storageSettings'] as String?,
      audioSettings: jsonSerialization['audioSettings'] as String?,
      displaySettings: jsonSerialization['displaySettings'] as String?,
      securitySettings: jsonSerialization['securitySettings'] as String?,
      restrictionSettings: jsonSerialization['restrictionSettings'] as String?,
      launcher: jsonSerialization['launcher'] as String?,
      syncSettings: jsonSerialization['syncSettings'] as String?,
      otherSettings: jsonSerialization['otherSettings'] as String?,
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

  String? slug;

  String? description;

  /// JSON describing the allowed time ranges.
  String? activeTimeRanges;

  bool isActive;

  int version;

  bool defaultPolicy;

  /// Argon2id hash of the admin password.
  String? adminPassword;

  /// JSON setting blocks.
  String? batterySettings;

  String? storageSettings;

  String? audioSettings;

  String? displaySettings;

  String? securitySettings;

  String? restrictionSettings;

  /// JSON launcher configuration.
  String? launcher;

  String? syncSettings;

  String? otherSettings;

  DateTime? createdAt;

  DateTime? updatedAt;

  DateTime? deletedAt;

  /// Returns a shallow copy of this [Policy]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Policy copyWith({
    int? id,
    String? name,
    String? slug,
    String? description,
    String? activeTimeRanges,
    bool? isActive,
    int? version,
    bool? defaultPolicy,
    String? adminPassword,
    String? batterySettings,
    String? storageSettings,
    String? audioSettings,
    String? displaySettings,
    String? securitySettings,
    String? restrictionSettings,
    String? launcher,
    String? syncSettings,
    String? otherSettings,
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
    DateTime? deletedAt = const _isc.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Policy',
      if (id != null) 'id': id,
      'name': name,
      if (slug != null) 'slug': slug,
      if (description != null) 'description': description,
      if (activeTimeRanges != null) 'activeTimeRanges': activeTimeRanges,
      'isActive': isActive,
      'version': version,
      'defaultPolicy': defaultPolicy,
      if (adminPassword != null) 'adminPassword': adminPassword,
      if (batterySettings != null) 'batterySettings': batterySettings,
      if (storageSettings != null) 'storageSettings': storageSettings,
      if (audioSettings != null) 'audioSettings': audioSettings,
      if (displaySettings != null) 'displaySettings': displaySettings,
      if (securitySettings != null) 'securitySettings': securitySettings,
      if (restrictionSettings != null)
        'restrictionSettings': restrictionSettings,
      if (launcher != null) 'launcher': launcher,
      if (syncSettings != null) 'syncSettings': syncSettings,
      if (otherSettings != null) 'otherSettings': otherSettings,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Policy',
      if (id != null) 'id': id,
      'name': name,
      if (slug != null) 'slug': slug,
      if (description != null) 'description': description,
      if (activeTimeRanges != null) 'activeTimeRanges': activeTimeRanges,
      'isActive': isActive,
      'version': version,
      'defaultPolicy': defaultPolicy,
      if (adminPassword != null) 'adminPassword': adminPassword,
      if (batterySettings != null) 'batterySettings': batterySettings,
      if (storageSettings != null) 'storageSettings': storageSettings,
      if (audioSettings != null) 'audioSettings': audioSettings,
      if (displaySettings != null) 'displaySettings': displaySettings,
      if (securitySettings != null) 'securitySettings': securitySettings,
      if (restrictionSettings != null)
        'restrictionSettings': restrictionSettings,
      if (launcher != null) 'launcher': launcher,
      if (syncSettings != null) 'syncSettings': syncSettings,
      if (otherSettings != null) 'otherSettings': otherSettings,
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

class _PolicyImpl extends Policy {
  _PolicyImpl({
    int? id,
    required String name,
    String? slug,
    String? description,
    String? activeTimeRanges,
    bool? isActive,
    int? version,
    bool? defaultPolicy,
    String? adminPassword,
    String? batterySettings,
    String? storageSettings,
    String? audioSettings,
    String? displaySettings,
    String? securitySettings,
    String? restrictionSettings,
    String? launcher,
    String? syncSettings,
    String? otherSettings,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) : super._(
         id: id,
         name: name,
         slug: slug,
         description: description,
         activeTimeRanges: activeTimeRanges,
         isActive: isActive,
         version: version,
         defaultPolicy: defaultPolicy,
         adminPassword: adminPassword,
         batterySettings: batterySettings,
         storageSettings: storageSettings,
         audioSettings: audioSettings,
         displaySettings: displaySettings,
         securitySettings: securitySettings,
         restrictionSettings: restrictionSettings,
         launcher: launcher,
         syncSettings: syncSettings,
         otherSettings: otherSettings,
         createdAt: createdAt,
         updatedAt: updatedAt,
         deletedAt: deletedAt,
       );

  /// Returns a shallow copy of this [Policy]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Policy copyWith({
    Object? id = _Undefined,
    String? name,
    Object? slug = _Undefined,
    Object? description = _Undefined,
    Object? activeTimeRanges = _Undefined,
    bool? isActive,
    int? version,
    bool? defaultPolicy,
    Object? adminPassword = _Undefined,
    Object? batterySettings = _Undefined,
    Object? storageSettings = _Undefined,
    Object? audioSettings = _Undefined,
    Object? displaySettings = _Undefined,
    Object? securitySettings = _Undefined,
    Object? restrictionSettings = _Undefined,
    Object? launcher = _Undefined,
    Object? syncSettings = _Undefined,
    Object? otherSettings = _Undefined,
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
    DateTime? deletedAt = const _isc.$UndefinedDateTime(),
  }) {
    return Policy(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      slug: slug is String? ? slug : this.slug,
      description: description is String? ? description : this.description,
      activeTimeRanges: activeTimeRanges is String?
          ? activeTimeRanges
          : this.activeTimeRanges,
      isActive: isActive ?? this.isActive,
      version: version ?? this.version,
      defaultPolicy: defaultPolicy ?? this.defaultPolicy,
      adminPassword: adminPassword is String?
          ? adminPassword
          : this.adminPassword,
      batterySettings: batterySettings is String?
          ? batterySettings
          : this.batterySettings,
      storageSettings: storageSettings is String?
          ? storageSettings
          : this.storageSettings,
      audioSettings: audioSettings is String?
          ? audioSettings
          : this.audioSettings,
      displaySettings: displaySettings is String?
          ? displaySettings
          : this.displaySettings,
      securitySettings: securitySettings is String?
          ? securitySettings
          : this.securitySettings,
      restrictionSettings: restrictionSettings is String?
          ? restrictionSettings
          : this.restrictionSettings,
      launcher: launcher is String? ? launcher : this.launcher,
      syncSettings: syncSettings is String? ? syncSettings : this.syncSettings,
      otherSettings: otherSettings is String?
          ? otherSettings
          : this.otherSettings,
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
