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

abstract class AdminCertificateUploadResponse
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AdminCertificateUploadResponse._({
    required this.filePath,
    required this.fileHash,
    required this.sizeBytes,
    this.publicUrl,
  });

  factory AdminCertificateUploadResponse({
    required String filePath,
    required String fileHash,
    required int sizeBytes,
    String? publicUrl,
  }) = _AdminCertificateUploadResponseImpl;

  factory AdminCertificateUploadResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AdminCertificateUploadResponse(
      filePath: jsonSerialization['filePath'] as String,
      fileHash: jsonSerialization['fileHash'] as String,
      sizeBytes: jsonSerialization['sizeBytes'] as int,
      publicUrl: jsonSerialization['publicUrl'] as String?,
    );
  }

  /// Path inside the public storage.
  String filePath;

  /// SHA-256 of the uploaded bytes.
  String fileHash;

  int sizeBytes;

  String? publicUrl;

  /// Returns a shallow copy of this [AdminCertificateUploadResponse]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdminCertificateUploadResponse copyWith({
    String? filePath,
    String? fileHash,
    int? sizeBytes,
    String? publicUrl,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminCertificateUploadResponse',
      'filePath': filePath,
      'fileHash': fileHash,
      'sizeBytes': sizeBytes,
      if (publicUrl != null) 'publicUrl': publicUrl,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminCertificateUploadResponse',
      'filePath': filePath,
      'fileHash': fileHash,
      'sizeBytes': sizeBytes,
      if (publicUrl != null) 'publicUrl': publicUrl,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminCertificateUploadResponseImpl
    extends AdminCertificateUploadResponse {
  _AdminCertificateUploadResponseImpl({
    required String filePath,
    required String fileHash,
    required int sizeBytes,
    String? publicUrl,
  }) : super._(
         filePath: filePath,
         fileHash: fileHash,
         sizeBytes: sizeBytes,
         publicUrl: publicUrl,
       );

  /// Returns a shallow copy of this [AdminCertificateUploadResponse]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdminCertificateUploadResponse copyWith({
    String? filePath,
    String? fileHash,
    int? sizeBytes,
    Object? publicUrl = _Undefined,
  }) {
    return AdminCertificateUploadResponse(
      filePath: filePath ?? this.filePath,
      fileHash: fileHash ?? this.fileHash,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      publicUrl: publicUrl is String? ? publicUrl : this.publicUrl,
    );
  }
}
