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
import 'package:wonkru_core_client/wonkru_core_client.dart' as _inc4d0tr;

abstract class DeviceNotification
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DeviceNotification._({
    this.id,
    this.uuid,
    required this.title,
    required this.message,
    required this.type,
    this.extra,
    this.sentAt,
    this.createdAt,
    this.updatedAt,
  });

  factory DeviceNotification({
    int? id,
    String? uuid,
    required String title,
    required String message,
    required _inc4d0tr.NotificationType type,
    String? extra,
    DateTime? sentAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _DeviceNotificationImpl;

  factory DeviceNotification.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceNotification(
      id: jsonSerialization['id'] as int?,
      uuid: jsonSerialization['uuid'] as String?,
      title: jsonSerialization['title'] as String,
      message: jsonSerialization['message'] as String,
      type: _inc4d0tr.NotificationType.fromJson(
        (jsonSerialization['type'] as String),
      ),
      extra: jsonSerialization['extra'] as String?,
      sentAt: jsonSerialization['sentAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['sentAt']),
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

  String? uuid;

  String title;

  String message;

  _inc4d0tr.NotificationType type;

  /// Serialized JSON payload with additional notification data.
  String? extra;

  DateTime? sentAt;

  DateTime? createdAt;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [DeviceNotification]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DeviceNotification copyWith({
    int? id,
    String? uuid,
    String? title,
    String? message,
    _inc4d0tr.NotificationType? type,
    String? extra,
    DateTime? sentAt = const _isc.$UndefinedDateTime(),
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceNotification',
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      'title': title,
      'message': message,
      'type': type.toJson(),
      if (extra != null) 'extra': extra,
      if (sentAt != null) 'sentAt': sentAt?.toJson(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceNotification',
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      'title': title,
      'message': message,
      'type': type.toJson(),
      if (extra != null) 'extra': extra,
      if (sentAt != null) 'sentAt': sentAt?.toJson(),
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

class _DeviceNotificationImpl extends DeviceNotification {
  _DeviceNotificationImpl({
    int? id,
    String? uuid,
    required String title,
    required String message,
    required _inc4d0tr.NotificationType type,
    String? extra,
    DateTime? sentAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         uuid: uuid,
         title: title,
         message: message,
         type: type,
         extra: extra,
         sentAt: sentAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [DeviceNotification]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DeviceNotification copyWith({
    Object? id = _Undefined,
    Object? uuid = _Undefined,
    String? title,
    String? message,
    _inc4d0tr.NotificationType? type,
    Object? extra = _Undefined,
    DateTime? sentAt = const _isc.$UndefinedDateTime(),
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
  }) {
    return DeviceNotification(
      id: id is int? ? id : this.id,
      uuid: uuid is String? ? uuid : this.uuid,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      extra: extra is String? ? extra : this.extra,
      sentAt: sentAt is _isc.UndefinedSentinel ? this.sentAt : sentAt,
      createdAt: createdAt is _isc.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      updatedAt: updatedAt is _isc.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
    );
  }
}
