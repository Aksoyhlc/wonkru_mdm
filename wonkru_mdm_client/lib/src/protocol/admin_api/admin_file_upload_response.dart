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

abstract class AdminFileUploadResponse
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AdminFileUploadResponse._({
    required this.filePath,
    required this.disk,
    required this.fileHashSha256,
    required this.sizeBytes,
    this.fileExtension,
    this.mimeType,
    this.publicUrl,
  });

  factory AdminFileUploadResponse({
    required String filePath,
    required String disk,
    required String fileHashSha256,
    required int sizeBytes,
    String? fileExtension,
    String? mimeType,
    String? publicUrl,
  }) = _AdminFileUploadResponseImpl;

  factory AdminFileUploadResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AdminFileUploadResponse(
      filePath: jsonSerialization['filePath'] as String,
      disk: jsonSerialization['disk'] as String,
      fileHashSha256: jsonSerialization['fileHashSha256'] as String,
      sizeBytes: jsonSerialization['sizeBytes'] as int,
      fileExtension: jsonSerialization['fileExtension'] as String?,
      mimeType: jsonSerialization['mimeType'] as String?,
      publicUrl: jsonSerialization['publicUrl'] as String?,
    );
  }

  /// Path of the file inside [disk].
  String filePath;

  String disk;

  /// SHA-256 of the uploaded bytes.
  String fileHashSha256;

  int sizeBytes;

  /// Extension from the uploaded name, without the leading dot.
  String? fileExtension;

  String? mimeType;

  String? publicUrl;

  /// Returns a shallow copy of this [AdminFileUploadResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AdminFileUploadResponse copyWith({
    String? filePath,
    String? disk,
    String? fileHashSha256,
    int? sizeBytes,
    String? fileExtension,
    String? mimeType,
    String? publicUrl,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminFileUploadResponse',
      'filePath': filePath,
      'disk': disk,
      'fileHashSha256': fileHashSha256,
      'sizeBytes': sizeBytes,
      if (fileExtension != null) 'fileExtension': fileExtension,
      if (mimeType != null) 'mimeType': mimeType,
      if (publicUrl != null) 'publicUrl': publicUrl,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminFileUploadResponse',
      'filePath': filePath,
      'disk': disk,
      'fileHashSha256': fileHashSha256,
      'sizeBytes': sizeBytes,
      if (fileExtension != null) 'fileExtension': fileExtension,
      if (mimeType != null) 'mimeType': mimeType,
      if (publicUrl != null) 'publicUrl': publicUrl,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminFileUploadResponseImpl extends AdminFileUploadResponse {
  _AdminFileUploadResponseImpl({
    required String filePath,
    required String disk,
    required String fileHashSha256,
    required int sizeBytes,
    String? fileExtension,
    String? mimeType,
    String? publicUrl,
  }) : super._(
         filePath: filePath,
         disk: disk,
         fileHashSha256: fileHashSha256,
         sizeBytes: sizeBytes,
         fileExtension: fileExtension,
         mimeType: mimeType,
         publicUrl: publicUrl,
       );

  /// Returns a shallow copy of this [AdminFileUploadResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AdminFileUploadResponse copyWith({
    String? filePath,
    String? disk,
    String? fileHashSha256,
    int? sizeBytes,
    Object? fileExtension = _Undefined,
    Object? mimeType = _Undefined,
    Object? publicUrl = _Undefined,
  }) {
    return AdminFileUploadResponse(
      filePath: filePath ?? this.filePath,
      disk: disk ?? this.disk,
      fileHashSha256: fileHashSha256 ?? this.fileHashSha256,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      fileExtension: fileExtension is String?
          ? fileExtension
          : this.fileExtension,
      mimeType: mimeType is String? ? mimeType : this.mimeType,
      publicUrl: publicUrl is String? ? publicUrl : this.publicUrl,
    );
  }
}
