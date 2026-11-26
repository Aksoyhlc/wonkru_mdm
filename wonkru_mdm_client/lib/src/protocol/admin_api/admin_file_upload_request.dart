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

abstract class AdminFileUploadRequest
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AdminFileUploadRequest._({
    required this.fileName,
    required this.byteData,
    this.disk,
    this.mimeType,
  });

  factory AdminFileUploadRequest({
    required String fileName,
    required _idt.ByteData byteData,
    String? disk,
    String? mimeType,
  }) = _AdminFileUploadRequestImpl;

  factory AdminFileUploadRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AdminFileUploadRequest(
      fileName: jsonSerialization['fileName'] as String,
      byteData: _isc.ByteDataJsonExtension.fromJson(
        jsonSerialization['byteData'],
      ),
      disk: jsonSerialization['disk'] as String?,
      mimeType: jsonSerialization['mimeType'] as String?,
    );
  }

  String fileName;

  _idt.ByteData byteData;

  /// Storage id: `private` or `public`; defaults to `private`.
  String? disk;

  String? mimeType;

  /// Returns a shallow copy of this [AdminFileUploadRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AdminFileUploadRequest copyWith({
    String? fileName,
    _idt.ByteData? byteData,
    String? disk,
    String? mimeType,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminFileUploadRequest',
      'fileName': fileName,
      'byteData': byteData.toJson(),
      if (disk != null) 'disk': disk,
      if (mimeType != null) 'mimeType': mimeType,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminFileUploadRequest',
      'fileName': fileName,
      'byteData': byteData.toJson(),
      if (disk != null) 'disk': disk,
      if (mimeType != null) 'mimeType': mimeType,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminFileUploadRequestImpl extends AdminFileUploadRequest {
  _AdminFileUploadRequestImpl({
    required String fileName,
    required _idt.ByteData byteData,
    String? disk,
    String? mimeType,
  }) : super._(
         fileName: fileName,
         byteData: byteData,
         disk: disk,
         mimeType: mimeType,
       );

  /// Returns a shallow copy of this [AdminFileUploadRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AdminFileUploadRequest copyWith({
    String? fileName,
    _idt.ByteData? byteData,
    Object? disk = _Undefined,
    Object? mimeType = _Undefined,
  }) {
    return AdminFileUploadRequest(
      fileName: fileName ?? this.fileName,
      byteData: byteData ?? this.byteData.clone(),
      disk: disk is String? ? disk : this.disk,
      mimeType: mimeType is String? ? mimeType : this.mimeType,
    );
  }
}
