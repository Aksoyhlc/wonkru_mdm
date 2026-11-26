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
import 'dart:typed_data' as _idt;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:wonkru_mdm_client/src/protocol/protocol.dart' as _icclvb2d;

abstract class AdminApplicationVersionUploadRequest
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AdminApplicationVersionUploadRequest._({
    required this.applicationId,
    required this.fileName,
    required this.byteData,
    required this.versionName,
    required this.versionCode,
    this.minSdkVersion,
    this.targetSdkVersion,
    this.permissions,
  });

  factory AdminApplicationVersionUploadRequest({
    required int applicationId,
    required String fileName,
    required _idt.ByteData byteData,
    required String versionName,
    required int versionCode,
    int? minSdkVersion,
    int? targetSdkVersion,
    Map<String, String>? permissions,
  }) = _AdminApplicationVersionUploadRequestImpl;

  factory AdminApplicationVersionUploadRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AdminApplicationVersionUploadRequest(
      applicationId: jsonSerialization['applicationId'] as int,
      fileName: jsonSerialization['fileName'] as String,
      byteData: _isc.ByteDataJsonExtension.fromJson(
        jsonSerialization['byteData'],
      ),
      versionName: jsonSerialization['versionName'] as String,
      versionCode: jsonSerialization['versionCode'] as int,
      minSdkVersion: jsonSerialization['minSdkVersion'] as int?,
      targetSdkVersion: jsonSerialization['targetSdkVersion'] as int?,
      permissions: jsonSerialization['permissions'] == null
          ? null
          : _icclvb2d.Protocol().deserialize<Map<String, String>>(
              jsonSerialization['permissions'],
            ),
    );
  }

  int applicationId;

  String fileName;

  _idt.ByteData byteData;

  String versionName;

  int versionCode;

  int? minSdkVersion;

  int? targetSdkVersion;

  /// Permission map keyed by permission name.
  Map<String, String>? permissions;

  /// Returns a shallow copy of this [AdminApplicationVersionUploadRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AdminApplicationVersionUploadRequest copyWith({
    int? applicationId,
    String? fileName,
    _idt.ByteData? byteData,
    String? versionName,
    int? versionCode,
    int? minSdkVersion,
    int? targetSdkVersion,
    Map<String, String>? permissions =
        const _isc.$UndefinedMap<String, String>(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminApplicationVersionUploadRequest',
      'applicationId': applicationId,
      'fileName': fileName,
      'byteData': byteData.toJson(),
      'versionName': versionName,
      'versionCode': versionCode,
      if (minSdkVersion != null) 'minSdkVersion': minSdkVersion,
      if (targetSdkVersion != null) 'targetSdkVersion': targetSdkVersion,
      if (permissions != null) 'permissions': permissions?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminApplicationVersionUploadRequest',
      'applicationId': applicationId,
      'fileName': fileName,
      'byteData': byteData.toJson(),
      'versionName': versionName,
      'versionCode': versionCode,
      if (minSdkVersion != null) 'minSdkVersion': minSdkVersion,
      if (targetSdkVersion != null) 'targetSdkVersion': targetSdkVersion,
      if (permissions != null) 'permissions': permissions?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminApplicationVersionUploadRequestImpl
    extends AdminApplicationVersionUploadRequest {
  _AdminApplicationVersionUploadRequestImpl({
    required int applicationId,
    required String fileName,
    required _idt.ByteData byteData,
    required String versionName,
    required int versionCode,
    int? minSdkVersion,
    int? targetSdkVersion,
    Map<String, String>? permissions,
  }) : super._(
         applicationId: applicationId,
         fileName: fileName,
         byteData: byteData,
         versionName: versionName,
         versionCode: versionCode,
         minSdkVersion: minSdkVersion,
         targetSdkVersion: targetSdkVersion,
         permissions: permissions,
       );

  /// Returns a shallow copy of this [AdminApplicationVersionUploadRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AdminApplicationVersionUploadRequest copyWith({
    int? applicationId,
    String? fileName,
    _idt.ByteData? byteData,
    String? versionName,
    int? versionCode,
    Object? minSdkVersion = _Undefined,
    Object? targetSdkVersion = _Undefined,
    Map<String, String>? permissions =
        const _isc.$UndefinedMap<String, String>(),
  }) {
    return AdminApplicationVersionUploadRequest(
      applicationId: applicationId ?? this.applicationId,
      fileName: fileName ?? this.fileName,
      byteData: byteData ?? this.byteData.clone(),
      versionName: versionName ?? this.versionName,
      versionCode: versionCode ?? this.versionCode,
      minSdkVersion: minSdkVersion is int? ? minSdkVersion : this.minSdkVersion,
      targetSdkVersion: targetSdkVersion is int?
          ? targetSdkVersion
          : this.targetSdkVersion,
      permissions: permissions is _isc.UndefinedSentinel
          ? this.permissions?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            )
          : permissions,
    );
  }
}
