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

abstract class DeviceFileUploadResponse
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DeviceFileUploadResponse._({
    required this.id,
    required this.name,
    required this.filePath,
    required this.sizeBytes,
    this.publicUrl,
  });

  factory DeviceFileUploadResponse({
    required int id,
    required String name,
    required String filePath,
    required int sizeBytes,
    String? publicUrl,
  }) = _DeviceFileUploadResponseImpl;

  factory DeviceFileUploadResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DeviceFileUploadResponse(
      id: jsonSerialization['id'] as int,
      name: jsonSerialization['name'] as String,
      filePath: jsonSerialization['filePath'] as String,
      sizeBytes: jsonSerialization['sizeBytes'] as int,
      publicUrl: jsonSerialization['publicUrl'] as String?,
    );
  }

  int id;

  String name;

  /// Path inside the public storage.
  String filePath;

  int sizeBytes;

  String? publicUrl;

  /// Returns a shallow copy of this [DeviceFileUploadResponse]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DeviceFileUploadResponse copyWith({
    int? id,
    String? name,
    String? filePath,
    int? sizeBytes,
    String? publicUrl,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'wonkru_core.DeviceFileUploadResponse',
      'id': id,
      'name': name,
      'filePath': filePath,
      'sizeBytes': sizeBytes,
      if (publicUrl != null) 'publicUrl': publicUrl,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'wonkru_core.DeviceFileUploadResponse',
      'id': id,
      'name': name,
      'filePath': filePath,
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

class _DeviceFileUploadResponseImpl extends DeviceFileUploadResponse {
  _DeviceFileUploadResponseImpl({
    required int id,
    required String name,
    required String filePath,
    required int sizeBytes,
    String? publicUrl,
  }) : super._(
         id: id,
         name: name,
         filePath: filePath,
         sizeBytes: sizeBytes,
         publicUrl: publicUrl,
       );

  /// Returns a shallow copy of this [DeviceFileUploadResponse]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DeviceFileUploadResponse copyWith({
    int? id,
    String? name,
    String? filePath,
    int? sizeBytes,
    Object? publicUrl = _Undefined,
  }) {
    return DeviceFileUploadResponse(
      id: id ?? this.id,
      name: name ?? this.name,
      filePath: filePath ?? this.filePath,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      publicUrl: publicUrl is String? ? publicUrl : this.publicUrl,
    );
  }
}
