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

abstract class DeviceLog
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DeviceLog._({
    this.id,
    required this.deviceId,
    this.device,
    this.entryUuid,
    this.sessionId,
    this.loggedAt,
    int? level,
    this.tag,
    required this.message,
    this.stacktrace,
    this.createdAt,
    this.updatedAt,
  }) : level = level ?? 2;

  factory DeviceLog({
    int? id,
    required int deviceId,
    _ilo09f9g.Device? device,
    String? entryUuid,
    String? sessionId,
    DateTime? loggedAt,
    int? level,
    String? tag,
    required String message,
    String? stacktrace,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _DeviceLogImpl;

  factory DeviceLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceLog(
      id: jsonSerialization['id'] as int?,
      deviceId: jsonSerialization['deviceId'] as int,
      device: jsonSerialization['device'] == null
          ? null
          : _icclvb2d.Protocol().deserialize<_ilo09f9g.Device>(
              jsonSerialization['device'],
            ),
      entryUuid: jsonSerialization['entryUuid'] as String?,
      sessionId: jsonSerialization['sessionId'] as String?,
      loggedAt: jsonSerialization['loggedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['loggedAt']),
      level: jsonSerialization['level'] as int?,
      tag: jsonSerialization['tag'] as String?,
      message: jsonSerialization['message'] as String,
      stacktrace: jsonSerialization['stacktrace'] as String?,
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

  int deviceId;

  _ilo09f9g.Device? device;

  String? entryUuid;

  String? sessionId;

  DateTime? loggedAt;

  int level;

  String? tag;

  String message;

  String? stacktrace;

  DateTime? createdAt;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [DeviceLog]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DeviceLog copyWith({
    int? id,
    int? deviceId,
    _ilo09f9g.Device? device = const _UndefinedDeviceLog$device(),
    String? entryUuid,
    String? sessionId,
    DateTime? loggedAt = const _isc.$UndefinedDateTime(),
    int? level,
    String? tag,
    String? message,
    String? stacktrace,
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceLog',
      if (id != null) 'id': id,
      'deviceId': deviceId,
      if (device != null) 'device': device?.toJson(),
      if (entryUuid != null) 'entryUuid': entryUuid,
      if (sessionId != null) 'sessionId': sessionId,
      if (loggedAt != null) 'loggedAt': loggedAt?.toJson(),
      'level': level,
      if (tag != null) 'tag': tag,
      'message': message,
      if (stacktrace != null) 'stacktrace': stacktrace,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceLog',
      if (id != null) 'id': id,
      'deviceId': deviceId,
      if (device != null) 'device': device?.toJsonForProtocol(),
      if (entryUuid != null) 'entryUuid': entryUuid,
      if (sessionId != null) 'sessionId': sessionId,
      if (loggedAt != null) 'loggedAt': loggedAt?.toJson(),
      'level': level,
      if (tag != null) 'tag': tag,
      'message': message,
      if (stacktrace != null) 'stacktrace': stacktrace,
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

class _UndefinedDeviceLog$device extends _isc.UndefinedSentinel
    implements _ilo09f9g.Device {
  const _UndefinedDeviceLog$device();
}

class _DeviceLogImpl extends DeviceLog {
  _DeviceLogImpl({
    int? id,
    required int deviceId,
    _ilo09f9g.Device? device,
    String? entryUuid,
    String? sessionId,
    DateTime? loggedAt,
    int? level,
    String? tag,
    required String message,
    String? stacktrace,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         deviceId: deviceId,
         device: device,
         entryUuid: entryUuid,
         sessionId: sessionId,
         loggedAt: loggedAt,
         level: level,
         tag: tag,
         message: message,
         stacktrace: stacktrace,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [DeviceLog]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DeviceLog copyWith({
    Object? id = _Undefined,
    int? deviceId,
    _ilo09f9g.Device? device = const _UndefinedDeviceLog$device(),
    Object? entryUuid = _Undefined,
    Object? sessionId = _Undefined,
    DateTime? loggedAt = const _isc.$UndefinedDateTime(),
    int? level,
    Object? tag = _Undefined,
    String? message,
    Object? stacktrace = _Undefined,
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
  }) {
    return DeviceLog(
      id: id is int? ? id : this.id,
      deviceId: deviceId ?? this.deviceId,
      device: device is _isc.UndefinedSentinel
          ? this.device?.copyWith()
          : device,
      entryUuid: entryUuid is String? ? entryUuid : this.entryUuid,
      sessionId: sessionId is String? ? sessionId : this.sessionId,
      loggedAt: loggedAt is _isc.UndefinedSentinel ? this.loggedAt : loggedAt,
      level: level ?? this.level,
      tag: tag is String? ? tag : this.tag,
      message: message ?? this.message,
      stacktrace: stacktrace is String? ? stacktrace : this.stacktrace,
      createdAt: createdAt is _isc.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      updatedAt: updatedAt is _isc.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
    );
  }
}
