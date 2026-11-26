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
import 'file_asset.dart' as _i44ond0u;
import 'file_group.dart' as _i8zsj03n;

abstract class FileGroupMember
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  FileGroupMember._({
    this.id,
    required this.fileId,
    this.file,
    required this.fileGroupId,
    this.fileGroup,
    this.createdAt,
    this.updatedAt,
  });

  factory FileGroupMember({
    int? id,
    required int fileId,
    _i44ond0u.FileAsset? file,
    required int fileGroupId,
    _i8zsj03n.FileGroup? fileGroup,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _FileGroupMemberImpl;

  factory FileGroupMember.fromJson(Map<String, dynamic> jsonSerialization) {
    return FileGroupMember(
      id: jsonSerialization['id'] as int?,
      fileId: jsonSerialization['fileId'] as int,
      file: jsonSerialization['file'] == null
          ? null
          : _icclvb2d.Protocol().deserialize<_i44ond0u.FileAsset>(
              jsonSerialization['file'],
            ),
      fileGroupId: jsonSerialization['fileGroupId'] as int,
      fileGroup: jsonSerialization['fileGroup'] == null
          ? null
          : _icclvb2d.Protocol().deserialize<_i8zsj03n.FileGroup>(
              jsonSerialization['fileGroup'],
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

  int fileId;

  _i44ond0u.FileAsset? file;

  int fileGroupId;

  _i8zsj03n.FileGroup? fileGroup;

  DateTime? createdAt;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [FileGroupMember]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FileGroupMember copyWith({
    int? id,
    int? fileId,
    _i44ond0u.FileAsset? file = const _UndefinedFileGroupMember$file(),
    int? fileGroupId,
    _i8zsj03n.FileGroup? fileGroup =
        const _UndefinedFileGroupMember$fileGroup(),
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FileGroupMember',
      if (id != null) 'id': id,
      'fileId': fileId,
      if (file != null) 'file': file?.toJson(),
      'fileGroupId': fileGroupId,
      if (fileGroup != null) 'fileGroup': fileGroup?.toJson(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FileGroupMember',
      if (id != null) 'id': id,
      'fileId': fileId,
      if (file != null) 'file': file?.toJsonForProtocol(),
      'fileGroupId': fileGroupId,
      if (fileGroup != null) 'fileGroup': fileGroup?.toJsonForProtocol(),
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

class _UndefinedFileGroupMember$file extends _isc.UndefinedSentinel
    implements _i44ond0u.FileAsset {
  const _UndefinedFileGroupMember$file();
}

class _UndefinedFileGroupMember$fileGroup extends _isc.UndefinedSentinel
    implements _i8zsj03n.FileGroup {
  const _UndefinedFileGroupMember$fileGroup();
}

class _FileGroupMemberImpl extends FileGroupMember {
  _FileGroupMemberImpl({
    int? id,
    required int fileId,
    _i44ond0u.FileAsset? file,
    required int fileGroupId,
    _i8zsj03n.FileGroup? fileGroup,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         fileId: fileId,
         file: file,
         fileGroupId: fileGroupId,
         fileGroup: fileGroup,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [FileGroupMember]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  FileGroupMember copyWith({
    Object? id = _Undefined,
    int? fileId,
    _i44ond0u.FileAsset? file = const _UndefinedFileGroupMember$file(),
    int? fileGroupId,
    _i8zsj03n.FileGroup? fileGroup =
        const _UndefinedFileGroupMember$fileGroup(),
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
  }) {
    return FileGroupMember(
      id: id is int? ? id : this.id,
      fileId: fileId ?? this.fileId,
      file: file is _isc.UndefinedSentinel ? this.file?.copyWith() : file,
      fileGroupId: fileGroupId ?? this.fileGroupId,
      fileGroup: fileGroup is _isc.UndefinedSentinel
          ? this.fileGroup?.copyWith()
          : fileGroup,
      createdAt: createdAt is _isc.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      updatedAt: updatedAt is _isc.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
    );
  }
}
