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
import '../enums/log_level.dart' as _iyuokkn8;

abstract class DeviceLogEntry
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DeviceLogEntry._({
    this.id,
    required this.timestamp,
    required this.level,
    this.tag,
    required this.message,
    this.stacktrace,
    this.sessionId,
  });

  factory DeviceLogEntry({
    String? id,
    required String timestamp,
    required _iyuokkn8.LogLevel level,
    String? tag,
    required String message,
    String? stacktrace,
    String? sessionId,
  }) = _DeviceLogEntryImpl;

  factory DeviceLogEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceLogEntry(
      id: jsonSerialization['id'] as String?,
      timestamp: jsonSerialization['timestamp'] as String,
      level: _iyuokkn8.LogLevel.fromJson(
        (jsonSerialization['level'] as String),
      ),
      tag: jsonSerialization['tag'] as String?,
      message: jsonSerialization['message'] as String,
      stacktrace: jsonSerialization['stacktrace'] as String?,
      sessionId: jsonSerialization['sessionId'] as String?,
    );
  }

  String? id;

  String timestamp;

  _iyuokkn8.LogLevel level;

  String? tag;

  String message;

  String? stacktrace;

  /// Falls back to the batch-level `DeviceLogRequest.sessionId` when absent
  /// (older agents).
  String? sessionId;

  /// Returns a shallow copy of this [DeviceLogEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DeviceLogEntry copyWith({
    String? id,
    String? timestamp,
    _iyuokkn8.LogLevel? level,
    String? tag,
    String? message,
    String? stacktrace,
    String? sessionId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'wonkru_core.DeviceLogEntry',
      if (id != null) 'id': id,
      'timestamp': timestamp,
      'level': level.toJson(),
      if (tag != null) 'tag': tag,
      'message': message,
      if (stacktrace != null) 'stacktrace': stacktrace,
      if (sessionId != null) 'sessionId': sessionId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'wonkru_core.DeviceLogEntry',
      if (id != null) 'id': id,
      'timestamp': timestamp,
      'level': level.toJson(),
      if (tag != null) 'tag': tag,
      'message': message,
      if (stacktrace != null) 'stacktrace': stacktrace,
      if (sessionId != null) 'sessionId': sessionId,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeviceLogEntryImpl extends DeviceLogEntry {
  _DeviceLogEntryImpl({
    String? id,
    required String timestamp,
    required _iyuokkn8.LogLevel level,
    String? tag,
    required String message,
    String? stacktrace,
    String? sessionId,
  }) : super._(
         id: id,
         timestamp: timestamp,
         level: level,
         tag: tag,
         message: message,
         stacktrace: stacktrace,
         sessionId: sessionId,
       );

  /// Returns a shallow copy of this [DeviceLogEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DeviceLogEntry copyWith({
    Object? id = _Undefined,
    String? timestamp,
    _iyuokkn8.LogLevel? level,
    Object? tag = _Undefined,
    String? message,
    Object? stacktrace = _Undefined,
    Object? sessionId = _Undefined,
  }) {
    return DeviceLogEntry(
      id: id is String? ? id : this.id,
      timestamp: timestamp ?? this.timestamp,
      level: level ?? this.level,
      tag: tag is String? ? tag : this.tag,
      message: message ?? this.message,
      stacktrace: stacktrace is String? ? stacktrace : this.stacktrace,
      sessionId: sessionId is String? ? sessionId : this.sessionId,
    );
  }
}
