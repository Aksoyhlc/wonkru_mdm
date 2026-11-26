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
import 'device.dart' as _ilo09f9g;
import 'enums/storage_disk.dart' as _ixm72k6o;

abstract class FileAsset
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  FileAsset._({
    this.id,
    required this.name,
    this.customName,
    this.fileExtension,
    required this.filePath,
    this.publicUrl,
    this.mimeType,
    required this.sizeBytes,
    this.fileHashSha256,
    this.disk,
    this.deviceId,
    this.device,
    this.createdAt,
    this.updatedAt,
  });

  factory FileAsset({
    int? id,
    required String name,
    String? customName,
    String? fileExtension,
    required String filePath,
    String? publicUrl,
    String? mimeType,
    required int sizeBytes,
    String? fileHashSha256,
    _ixm72k6o.StorageDisk? disk,
    int? deviceId,
    _ilo09f9g.Device? device,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _FileAssetImpl;

  factory FileAsset.fromJson(Map<String, dynamic> jsonSerialization) {
    return FileAsset(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      customName: jsonSerialization['customName'] as String?,
      fileExtension: jsonSerialization['fileExtension'] as String?,
      filePath: jsonSerialization['filePath'] as String,
      publicUrl: jsonSerialization['publicUrl'] as String?,
      mimeType: jsonSerialization['mimeType'] as String?,
      sizeBytes: jsonSerialization['sizeBytes'] as int,
      fileHashSha256: jsonSerialization['fileHashSha256'] as String?,
      disk: jsonSerialization['disk'] == null
          ? null
          : _ixm72k6o.StorageDisk.fromJson(
              (jsonSerialization['disk'] as String),
            ),
      deviceId: jsonSerialization['deviceId'] as int?,
      device: jsonSerialization['device'] == null
          ? null
          : _icclvb2d.Protocol().deserialize<_ilo09f9g.Device>(
              jsonSerialization['device'],
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

  String name;

  String? customName;

  String? fileExtension;

  String filePath;

  String? publicUrl;

  String? mimeType;

  int sizeBytes;

  String? fileHashSha256;

  _ixm72k6o.StorageDisk? disk;

  int? deviceId;

  /// Set for files uploaded by the device agent; null for panel files.
  _ilo09f9g.Device? device;

  DateTime? createdAt;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [FileAsset]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FileAsset copyWith({
    int? id,
    String? name,
    String? customName,
    String? fileExtension,
    String? filePath,
    String? publicUrl,
    String? mimeType,
    int? sizeBytes,
    String? fileHashSha256,
    _ixm72k6o.StorageDisk? disk,
    int? deviceId,
    _ilo09f9g.Device? device = const _UndefinedFileAsset$device(),
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FileAsset',
      if (id != null) 'id': id,
      'name': name,
      if (customName != null) 'customName': customName,
      if (fileExtension != null) 'fileExtension': fileExtension,
      'filePath': filePath,
      if (publicUrl != null) 'publicUrl': publicUrl,
      if (mimeType != null) 'mimeType': mimeType,
      'sizeBytes': sizeBytes,
      if (fileHashSha256 != null) 'fileHashSha256': fileHashSha256,
      if (disk != null) 'disk': disk?.toJson(),
      if (deviceId != null) 'deviceId': deviceId,
      if (device != null) 'device': device?.toJson(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FileAsset',
      if (id != null) 'id': id,
      'name': name,
      if (customName != null) 'customName': customName,
      if (fileExtension != null) 'fileExtension': fileExtension,
      'filePath': filePath,
      if (publicUrl != null) 'publicUrl': publicUrl,
      if (mimeType != null) 'mimeType': mimeType,
      'sizeBytes': sizeBytes,
      if (fileHashSha256 != null) 'fileHashSha256': fileHashSha256,
      if (disk != null) 'disk': disk?.toJson(),
      if (deviceId != null) 'deviceId': deviceId,
      if (device != null) 'device': device?.toJsonForProtocol(),
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

class _UndefinedFileAsset$device extends _isc.UndefinedSentinel
    implements _ilo09f9g.Device {
  const _UndefinedFileAsset$device();
}

class _FileAssetImpl extends FileAsset {
  _FileAssetImpl({
    int? id,
    required String name,
    String? customName,
    String? fileExtension,
    required String filePath,
    String? publicUrl,
    String? mimeType,
    required int sizeBytes,
    String? fileHashSha256,
    _ixm72k6o.StorageDisk? disk,
    int? deviceId,
    _ilo09f9g.Device? device,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         name: name,
         customName: customName,
         fileExtension: fileExtension,
         filePath: filePath,
         publicUrl: publicUrl,
         mimeType: mimeType,
         sizeBytes: sizeBytes,
         fileHashSha256: fileHashSha256,
         disk: disk,
         deviceId: deviceId,
         device: device,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [FileAsset]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  FileAsset copyWith({
    Object? id = _Undefined,
    String? name,
    Object? customName = _Undefined,
    Object? fileExtension = _Undefined,
    String? filePath,
    Object? publicUrl = _Undefined,
    Object? mimeType = _Undefined,
    int? sizeBytes,
    Object? fileHashSha256 = _Undefined,
    Object? disk = _Undefined,
    Object? deviceId = _Undefined,
    _ilo09f9g.Device? device = const _UndefinedFileAsset$device(),
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
  }) {
    return FileAsset(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      customName: customName is String? ? customName : this.customName,
      fileExtension: fileExtension is String?
          ? fileExtension
          : this.fileExtension,
      filePath: filePath ?? this.filePath,
      publicUrl: publicUrl is String? ? publicUrl : this.publicUrl,
      mimeType: mimeType is String? ? mimeType : this.mimeType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      fileHashSha256: fileHashSha256 is String?
          ? fileHashSha256
          : this.fileHashSha256,
      disk: disk is _ixm72k6o.StorageDisk? ? disk : this.disk,
      deviceId: deviceId is int? ? deviceId : this.deviceId,
      device: device is _isc.UndefinedSentinel
          ? this.device?.copyWith()
          : device,
      createdAt: createdAt is _isc.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      updatedAt: updatedAt is _isc.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
    );
  }
}
