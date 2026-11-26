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

abstract class AdminUploadDescription
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AdminUploadDescription._({
    required this.storageId,
    required this.path,
    required this.description,
  });

  factory AdminUploadDescription({
    required String storageId,
    required String path,
    required String description,
  }) = _AdminUploadDescriptionImpl;

  factory AdminUploadDescription.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AdminUploadDescription(
      storageId: jsonSerialization['storageId'] as String,
      path: jsonSerialization['path'] as String,
      description: jsonSerialization['description'] as String,
    );
  }

  /// Storage the file goes to: `public` or `private`.
  String storageId;

  /// Server-derived path inside the storage.
  String path;

  /// The encoded upload description for `FileUploader`.
  String description;

  /// Returns a shallow copy of this [AdminUploadDescription]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdminUploadDescription copyWith({
    String? storageId,
    String? path,
    String? description,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminUploadDescription',
      'storageId': storageId,
      'path': path,
      'description': description,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminUploadDescription',
      'storageId': storageId,
      'path': path,
      'description': description,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _AdminUploadDescriptionImpl extends AdminUploadDescription {
  _AdminUploadDescriptionImpl({
    required String storageId,
    required String path,
    required String description,
  }) : super._(
         storageId: storageId,
         path: path,
         description: description,
       );

  /// Returns a shallow copy of this [AdminUploadDescription]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdminUploadDescription copyWith({
    String? storageId,
    String? path,
    String? description,
  }) {
    return AdminUploadDescription(
      storageId: storageId ?? this.storageId,
      path: path ?? this.path,
      description: description ?? this.description,
    );
  }
}
