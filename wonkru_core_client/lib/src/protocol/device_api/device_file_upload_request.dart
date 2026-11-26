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

abstract class DeviceFileUploadRequest
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DeviceFileUploadRequest._({
    required this.deviceUuid,
    required this.token,
    required this.fileName,
    this.fileExtension,
    this.mimeType,
    required this.byteData,
  });

  factory DeviceFileUploadRequest({
    required String deviceUuid,
    required String token,
    required String fileName,
    String? fileExtension,
    String? mimeType,
    required _idt.ByteData byteData,
  }) = _DeviceFileUploadRequestImpl;

  factory DeviceFileUploadRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DeviceFileUploadRequest(
      deviceUuid: jsonSerialization['deviceUuid'] as String,
      token: jsonSerialization['token'] as String,
      fileName: jsonSerialization['fileName'] as String,
      fileExtension: jsonSerialization['fileExtension'] as String?,
      mimeType: jsonSerialization['mimeType'] as String?,
      byteData: _isc.ByteDataJsonExtension.fromJson(
        jsonSerialization['byteData'],
      ),
    );
  }

  String deviceUuid;

  String token;

  String fileName;

  String? fileExtension;

  String? mimeType;

  _idt.ByteData byteData;

  /// Returns a shallow copy of this [DeviceFileUploadRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DeviceFileUploadRequest copyWith({
    String? deviceUuid,
    String? token,
    String? fileName,
    String? fileExtension,
    String? mimeType,
    _idt.ByteData? byteData,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'wonkru_core.DeviceFileUploadRequest',
      'deviceUuid': deviceUuid,
      'token': token,
      'fileName': fileName,
      if (fileExtension != null) 'fileExtension': fileExtension,
      if (mimeType != null) 'mimeType': mimeType,
      'byteData': byteData.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'wonkru_core.DeviceFileUploadRequest',
      'deviceUuid': deviceUuid,
      'token': token,
      'fileName': fileName,
      if (fileExtension != null) 'fileExtension': fileExtension,
      if (mimeType != null) 'mimeType': mimeType,
      'byteData': byteData.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeviceFileUploadRequestImpl extends DeviceFileUploadRequest {
  _DeviceFileUploadRequestImpl({
    required String deviceUuid,
    required String token,
    required String fileName,
    String? fileExtension,
    String? mimeType,
    required _idt.ByteData byteData,
  }) : super._(
         deviceUuid: deviceUuid,
         token: token,
         fileName: fileName,
         fileExtension: fileExtension,
         mimeType: mimeType,
         byteData: byteData,
       );

  /// Returns a shallow copy of this [DeviceFileUploadRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DeviceFileUploadRequest copyWith({
    String? deviceUuid,
    String? token,
    String? fileName,
    Object? fileExtension = _Undefined,
    Object? mimeType = _Undefined,
    _idt.ByteData? byteData,
  }) {
    return DeviceFileUploadRequest(
      deviceUuid: deviceUuid ?? this.deviceUuid,
      token: token ?? this.token,
      fileName: fileName ?? this.fileName,
      fileExtension: fileExtension is String?
          ? fileExtension
          : this.fileExtension,
      mimeType: mimeType is String? ? mimeType : this.mimeType,
      byteData: byteData ?? this.byteData.clone(),
    );
  }
}
