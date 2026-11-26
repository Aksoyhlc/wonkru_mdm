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
import 'package:serverpod/serverpod.dart' as _is;

abstract class AdminCertificateUploadRequest
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AdminCertificateUploadRequest._({
    required this.fileName,
    required this.byteData,
  });

  factory AdminCertificateUploadRequest({
    required String fileName,
    required _idt.ByteData byteData,
  }) = _AdminCertificateUploadRequestImpl;

  factory AdminCertificateUploadRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AdminCertificateUploadRequest(
      fileName: jsonSerialization['fileName'] as String,
      byteData: _is.ByteDataJsonExtension.fromJson(
        jsonSerialization['byteData'],
      ),
    );
  }

  String fileName;

  _idt.ByteData byteData;

  /// Returns a shallow copy of this [AdminCertificateUploadRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdminCertificateUploadRequest copyWith({
    String? fileName,
    _idt.ByteData? byteData,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminCertificateUploadRequest',
      'fileName': fileName,
      'byteData': byteData.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminCertificateUploadRequest',
      'fileName': fileName,
      'byteData': byteData.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _AdminCertificateUploadRequestImpl extends AdminCertificateUploadRequest {
  _AdminCertificateUploadRequestImpl({
    required String fileName,
    required _idt.ByteData byteData,
  }) : super._(
         fileName: fileName,
         byteData: byteData,
       );

  /// Returns a shallow copy of this [AdminCertificateUploadRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdminCertificateUploadRequest copyWith({
    String? fileName,
    _idt.ByteData? byteData,
  }) {
    return AdminCertificateUploadRequest(
      fileName: fileName ?? this.fileName,
      byteData: byteData ?? this.byteData.clone(),
    );
  }
}
