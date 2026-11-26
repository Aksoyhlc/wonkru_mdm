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

abstract class AdminNotification
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AdminNotification._({
    this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.data,
    this.readAt,
    required this.createdAt,
  });

  factory AdminNotification({
    int? id,
    required _isc.UuidValue userId,
    required String type,
    required String title,
    required String message,
    String? data,
    DateTime? readAt,
    required DateTime createdAt,
  }) = _AdminNotificationImpl;

  factory AdminNotification.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminNotification(
      id: jsonSerialization['id'] as int?,
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      type: jsonSerialization['type'] as String,
      title: jsonSerialization['title'] as String,
      message: jsonSerialization['message'] as String,
      data: jsonSerialization['data'] as String?,
      readAt: jsonSerialization['readAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['readAt']),
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.UuidValue userId;

  /// One of the `SystemAlertType` values.
  String type;

  String title;

  String message;

  /// Serialized JSON payload; null when absent.
  String? data;

  /// Set when read; null while unread.
  DateTime? readAt;

  DateTime createdAt;

  /// Returns a shallow copy of this [AdminNotification]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AdminNotification copyWith({
    int? id,
    _isc.UuidValue? userId,
    String? type,
    String? title,
    String? message,
    String? data,
    DateTime? readAt = const _isc.$UndefinedDateTime(),
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminNotification',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'type': type,
      'title': title,
      'message': message,
      if (data != null) 'data': data,
      if (readAt != null) 'readAt': readAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminNotification',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'type': type,
      'title': title,
      'message': message,
      if (data != null) 'data': data,
      if (readAt != null) 'readAt': readAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminNotificationImpl extends AdminNotification {
  _AdminNotificationImpl({
    int? id,
    required _isc.UuidValue userId,
    required String type,
    required String title,
    required String message,
    String? data,
    DateTime? readAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         type: type,
         title: title,
         message: message,
         data: data,
         readAt: readAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AdminNotification]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AdminNotification copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? userId,
    String? type,
    String? title,
    String? message,
    Object? data = _Undefined,
    DateTime? readAt = const _isc.$UndefinedDateTime(),
    DateTime? createdAt,
  }) {
    return AdminNotification(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      data: data is String? ? data : this.data,
      readAt: readAt is _isc.UndefinedSentinel ? this.readAt : readAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
