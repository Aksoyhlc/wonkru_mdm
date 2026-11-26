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
import 'package:wonkru_core_client/wonkru_core_client.dart' as _inc4d0tr;
import 'package:wonkru_mdm_client/src/protocol/protocol.dart' as _icclvb2d;
import 'file_asset.dart' as _i44ond0u;
import 'policy.dart' as _if7d246m;

abstract class PolicyFile
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PolicyFile._({
    this.id,
    required this.policyId,
    this.policy,
    this.fileId,
    this.file,
    required this.usageType,
    this.destinationPath,
    bool? replaceIfExists,
    bool? openAfterDownload,
    this.createdAt,
    this.updatedAt,
  }) : replaceIfExists = replaceIfExists ?? true,
       openAfterDownload = openAfterDownload ?? false;

  factory PolicyFile({
    int? id,
    required int policyId,
    _if7d246m.Policy? policy,
    int? fileId,
    _i44ond0u.FileAsset? file,
    required _inc4d0tr.FileOperationType usageType,
    String? destinationPath,
    bool? replaceIfExists,
    bool? openAfterDownload,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _PolicyFileImpl;

  factory PolicyFile.fromJson(Map<String, dynamic> jsonSerialization) {
    return PolicyFile(
      id: jsonSerialization['id'] as int?,
      policyId: jsonSerialization['policyId'] as int,
      policy: jsonSerialization['policy'] == null
          ? null
          : _icclvb2d.Protocol().deserialize<_if7d246m.Policy>(
              jsonSerialization['policy'],
            ),
      fileId: jsonSerialization['fileId'] as int?,
      file: jsonSerialization['file'] == null
          ? null
          : _icclvb2d.Protocol().deserialize<_i44ond0u.FileAsset>(
              jsonSerialization['file'],
            ),
      usageType: _inc4d0tr.FileOperationType.fromJson(
        (jsonSerialization['usageType'] as String),
      ),
      destinationPath: jsonSerialization['destinationPath'] as String?,
      replaceIfExists: jsonSerialization['replaceIfExists'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['replaceIfExists'],
            ),
      openAfterDownload: jsonSerialization['openAfterDownload'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['openAfterDownload'],
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

  int policyId;

  _if7d246m.Policy? policy;

  int? fileId;

  /// Delete operations are fileless (only the device-side path is known), so
  /// the relation is optional.
  _i44ond0u.FileAsset? file;

  _inc4d0tr.FileOperationType usageType;

  String? destinationPath;

  bool replaceIfExists;

  bool openAfterDownload;

  DateTime? createdAt;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [PolicyFile]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PolicyFile copyWith({
    int? id,
    int? policyId,
    _if7d246m.Policy? policy = const _UndefinedPolicyFile$policy(),
    int? fileId,
    _i44ond0u.FileAsset? file = const _UndefinedPolicyFile$file(),
    _inc4d0tr.FileOperationType? usageType,
    String? destinationPath,
    bool? replaceIfExists,
    bool? openAfterDownload,
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PolicyFile',
      if (id != null) 'id': id,
      'policyId': policyId,
      if (policy != null) 'policy': policy?.toJson(),
      if (fileId != null) 'fileId': fileId,
      if (file != null) 'file': file?.toJson(),
      'usageType': usageType.toJson(),
      if (destinationPath != null) 'destinationPath': destinationPath,
      'replaceIfExists': replaceIfExists,
      'openAfterDownload': openAfterDownload,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PolicyFile',
      if (id != null) 'id': id,
      'policyId': policyId,
      if (policy != null) 'policy': policy?.toJsonForProtocol(),
      if (fileId != null) 'fileId': fileId,
      if (file != null) 'file': file?.toJsonForProtocol(),
      'usageType': usageType.toJson(),
      if (destinationPath != null) 'destinationPath': destinationPath,
      'replaceIfExists': replaceIfExists,
      'openAfterDownload': openAfterDownload,
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

class _UndefinedPolicyFile$policy extends _isc.UndefinedSentinel
    implements _if7d246m.Policy {
  const _UndefinedPolicyFile$policy();
}

class _UndefinedPolicyFile$file extends _isc.UndefinedSentinel
    implements _i44ond0u.FileAsset {
  const _UndefinedPolicyFile$file();
}

class _PolicyFileImpl extends PolicyFile {
  _PolicyFileImpl({
    int? id,
    required int policyId,
    _if7d246m.Policy? policy,
    int? fileId,
    _i44ond0u.FileAsset? file,
    required _inc4d0tr.FileOperationType usageType,
    String? destinationPath,
    bool? replaceIfExists,
    bool? openAfterDownload,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         policyId: policyId,
         policy: policy,
         fileId: fileId,
         file: file,
         usageType: usageType,
         destinationPath: destinationPath,
         replaceIfExists: replaceIfExists,
         openAfterDownload: openAfterDownload,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [PolicyFile]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PolicyFile copyWith({
    Object? id = _Undefined,
    int? policyId,
    _if7d246m.Policy? policy = const _UndefinedPolicyFile$policy(),
    Object? fileId = _Undefined,
    _i44ond0u.FileAsset? file = const _UndefinedPolicyFile$file(),
    _inc4d0tr.FileOperationType? usageType,
    Object? destinationPath = _Undefined,
    bool? replaceIfExists,
    bool? openAfterDownload,
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
  }) {
    return PolicyFile(
      id: id is int? ? id : this.id,
      policyId: policyId ?? this.policyId,
      policy: policy is _isc.UndefinedSentinel
          ? this.policy?.copyWith()
          : policy,
      fileId: fileId is int? ? fileId : this.fileId,
      file: file is _isc.UndefinedSentinel ? this.file?.copyWith() : file,
      usageType: usageType ?? this.usageType,
      destinationPath: destinationPath is String?
          ? destinationPath
          : this.destinationPath,
      replaceIfExists: replaceIfExists ?? this.replaceIfExists,
      openAfterDownload: openAfterDownload ?? this.openAfterDownload,
      createdAt: createdAt is _isc.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      updatedAt: updatedAt is _isc.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
    );
  }
}
