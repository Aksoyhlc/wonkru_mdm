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
import 'application.dart' as _ice4s91e;

abstract class ApplicationVersion
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ApplicationVersion._({
    this.id,
    required this.applicationId,
    this.application,
    required this.versionName,
    required this.versionCode,
    this.filePath,
    this.fileSizeBytes,
    this.checksumSha256,
    this.minSdkVersion,
    this.targetSdkVersion,
    bool? isActive,
    this.permissions,
    bool? isDefault,
    this.createdAt,
    this.updatedAt,
  }) : isActive = isActive ?? true,
       isDefault = isDefault ?? false;

  factory ApplicationVersion({
    int? id,
    required int applicationId,
    _ice4s91e.Application? application,
    required String versionName,
    required int versionCode,
    String? filePath,
    int? fileSizeBytes,
    String? checksumSha256,
    int? minSdkVersion,
    int? targetSdkVersion,
    bool? isActive,
    String? permissions,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ApplicationVersionImpl;

  factory ApplicationVersion.fromJson(Map<String, dynamic> jsonSerialization) {
    return ApplicationVersion(
      id: jsonSerialization['id'] as int?,
      applicationId: jsonSerialization['applicationId'] as int,
      application: jsonSerialization['application'] == null
          ? null
          : _icclvb2d.Protocol().deserialize<_ice4s91e.Application>(
              jsonSerialization['application'],
            ),
      versionName: jsonSerialization['versionName'] as String,
      versionCode: jsonSerialization['versionCode'] as int,
      filePath: jsonSerialization['filePath'] as String?,
      fileSizeBytes: jsonSerialization['fileSizeBytes'] as int?,
      checksumSha256: jsonSerialization['checksumSha256'] as String?,
      minSdkVersion: jsonSerialization['minSdkVersion'] as int?,
      targetSdkVersion: jsonSerialization['targetSdkVersion'] as int?,
      isActive: jsonSerialization['isActive'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      permissions: jsonSerialization['permissions'] as String?,
      isDefault: jsonSerialization['isDefault'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isDefault']),
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

  int applicationId;

  _ice4s91e.Application? application;

  String versionName;

  int versionCode;

  String? filePath;

  int? fileSizeBytes;

  String? checksumSha256;

  int? minSdkVersion;

  int? targetSdkVersion;

  bool isActive;

  /// JSON list of permissions declared by the APK.
  String? permissions;

  bool isDefault;

  DateTime? createdAt;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [ApplicationVersion]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ApplicationVersion copyWith({
    int? id,
    int? applicationId,
    _ice4s91e.Application? application =
        const _UndefinedApplicationVersion$application(),
    String? versionName,
    int? versionCode,
    String? filePath,
    int? fileSizeBytes,
    String? checksumSha256,
    int? minSdkVersion,
    int? targetSdkVersion,
    bool? isActive,
    String? permissions,
    bool? isDefault,
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ApplicationVersion',
      if (id != null) 'id': id,
      'applicationId': applicationId,
      if (application != null) 'application': application?.toJson(),
      'versionName': versionName,
      'versionCode': versionCode,
      if (filePath != null) 'filePath': filePath,
      if (fileSizeBytes != null) 'fileSizeBytes': fileSizeBytes,
      if (checksumSha256 != null) 'checksumSha256': checksumSha256,
      if (minSdkVersion != null) 'minSdkVersion': minSdkVersion,
      if (targetSdkVersion != null) 'targetSdkVersion': targetSdkVersion,
      'isActive': isActive,
      if (permissions != null) 'permissions': permissions,
      'isDefault': isDefault,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ApplicationVersion',
      if (id != null) 'id': id,
      'applicationId': applicationId,
      if (application != null) 'application': application?.toJsonForProtocol(),
      'versionName': versionName,
      'versionCode': versionCode,
      if (filePath != null) 'filePath': filePath,
      if (fileSizeBytes != null) 'fileSizeBytes': fileSizeBytes,
      if (checksumSha256 != null) 'checksumSha256': checksumSha256,
      if (minSdkVersion != null) 'minSdkVersion': minSdkVersion,
      if (targetSdkVersion != null) 'targetSdkVersion': targetSdkVersion,
      'isActive': isActive,
      if (permissions != null) 'permissions': permissions,
      'isDefault': isDefault,
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

class _UndefinedApplicationVersion$application extends _isc.UndefinedSentinel
    implements _ice4s91e.Application {
  const _UndefinedApplicationVersion$application();
}

class _ApplicationVersionImpl extends ApplicationVersion {
  _ApplicationVersionImpl({
    int? id,
    required int applicationId,
    _ice4s91e.Application? application,
    required String versionName,
    required int versionCode,
    String? filePath,
    int? fileSizeBytes,
    String? checksumSha256,
    int? minSdkVersion,
    int? targetSdkVersion,
    bool? isActive,
    String? permissions,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         applicationId: applicationId,
         application: application,
         versionName: versionName,
         versionCode: versionCode,
         filePath: filePath,
         fileSizeBytes: fileSizeBytes,
         checksumSha256: checksumSha256,
         minSdkVersion: minSdkVersion,
         targetSdkVersion: targetSdkVersion,
         isActive: isActive,
         permissions: permissions,
         isDefault: isDefault,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ApplicationVersion]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ApplicationVersion copyWith({
    Object? id = _Undefined,
    int? applicationId,
    _ice4s91e.Application? application =
        const _UndefinedApplicationVersion$application(),
    String? versionName,
    int? versionCode,
    Object? filePath = _Undefined,
    Object? fileSizeBytes = _Undefined,
    Object? checksumSha256 = _Undefined,
    Object? minSdkVersion = _Undefined,
    Object? targetSdkVersion = _Undefined,
    bool? isActive,
    Object? permissions = _Undefined,
    bool? isDefault,
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
  }) {
    return ApplicationVersion(
      id: id is int? ? id : this.id,
      applicationId: applicationId ?? this.applicationId,
      application: application is _isc.UndefinedSentinel
          ? this.application?.copyWith()
          : application,
      versionName: versionName ?? this.versionName,
      versionCode: versionCode ?? this.versionCode,
      filePath: filePath is String? ? filePath : this.filePath,
      fileSizeBytes: fileSizeBytes is int? ? fileSizeBytes : this.fileSizeBytes,
      checksumSha256: checksumSha256 is String?
          ? checksumSha256
          : this.checksumSha256,
      minSdkVersion: minSdkVersion is int? ? minSdkVersion : this.minSdkVersion,
      targetSdkVersion: targetSdkVersion is int?
          ? targetSdkVersion
          : this.targetSdkVersion,
      isActive: isActive ?? this.isActive,
      permissions: permissions is String? ? permissions : this.permissions,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt is _isc.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      updatedAt: updatedAt is _isc.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
    );
  }
}
