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

/// Audit record of an admin action.
///
/// Rows are immutable: never edited or deleted through the panel. Actor name
/// and email are stored as a snapshot so the record stays readable after the
/// account is deleted.
abstract class AdminActivity
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AdminActivity._({
    this.id,
    this.actorUserId,
    this.actorEmail,
    this.actorName,
    required this.action,
    this.targetType,
    this.targetId,
    this.data,
    this.ipAddress,
    required this.createdAt,
  });

  factory AdminActivity({
    int? id,
    _isc.UuidValue? actorUserId,
    String? actorEmail,
    String? actorName,
    required String action,
    String? targetType,
    String? targetId,
    String? data,
    String? ipAddress,
    required DateTime createdAt,
  }) = _AdminActivityImpl;

  factory AdminActivity.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminActivity(
      id: jsonSerialization['id'] as int?,
      actorUserId: jsonSerialization['actorUserId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['actorUserId'],
            ),
      actorEmail: jsonSerialization['actorEmail'] as String?,
      actorName: jsonSerialization['actorName'] as String?,
      action: jsonSerialization['action'] as String,
      targetType: jsonSerialization['targetType'] as String?,
      targetId: jsonSerialization['targetId'] as String?,
      data: jsonSerialization['data'] as String?,
      ipAddress: jsonSerialization['ipAddress'] as String?,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Auth user id of the actor; null for system or failed sign-ins.
  _isc.UuidValue? actorUserId;

  /// Email at the time of the action; the attempted email on a failed sign-in.
  String? actorEmail;

  String? actorName;

  /// Action code `<domain>.<action>` (e.g. `device.delete`); the panel resolves
  /// its label via i18n.
  String action;

  String? targetType;

  String? targetId;

  /// Action-specific extra data as JSON.
  String? data;

  String? ipAddress;

  DateTime createdAt;

  /// Returns a shallow copy of this [AdminActivity]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AdminActivity copyWith({
    int? id,
    _isc.UuidValue? actorUserId = const _isc.$UndefinedUuidValue(),
    String? actorEmail,
    String? actorName,
    String? action,
    String? targetType,
    String? targetId,
    String? data,
    String? ipAddress,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminActivity',
      if (id != null) 'id': id,
      if (actorUserId != null) 'actorUserId': actorUserId?.toJson(),
      if (actorEmail != null) 'actorEmail': actorEmail,
      if (actorName != null) 'actorName': actorName,
      'action': action,
      if (targetType != null) 'targetType': targetType,
      if (targetId != null) 'targetId': targetId,
      if (data != null) 'data': data,
      if (ipAddress != null) 'ipAddress': ipAddress,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminActivity',
      if (id != null) 'id': id,
      if (actorUserId != null) 'actorUserId': actorUserId?.toJson(),
      if (actorEmail != null) 'actorEmail': actorEmail,
      if (actorName != null) 'actorName': actorName,
      'action': action,
      if (targetType != null) 'targetType': targetType,
      if (targetId != null) 'targetId': targetId,
      if (data != null) 'data': data,
      if (ipAddress != null) 'ipAddress': ipAddress,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminActivityImpl extends AdminActivity {
  _AdminActivityImpl({
    int? id,
    _isc.UuidValue? actorUserId,
    String? actorEmail,
    String? actorName,
    required String action,
    String? targetType,
    String? targetId,
    String? data,
    String? ipAddress,
    required DateTime createdAt,
  }) : super._(
         id: id,
         actorUserId: actorUserId,
         actorEmail: actorEmail,
         actorName: actorName,
         action: action,
         targetType: targetType,
         targetId: targetId,
         data: data,
         ipAddress: ipAddress,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AdminActivity]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AdminActivity copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? actorUserId = const _isc.$UndefinedUuidValue(),
    Object? actorEmail = _Undefined,
    Object? actorName = _Undefined,
    String? action,
    Object? targetType = _Undefined,
    Object? targetId = _Undefined,
    Object? data = _Undefined,
    Object? ipAddress = _Undefined,
    DateTime? createdAt,
  }) {
    return AdminActivity(
      id: id is int? ? id : this.id,
      actorUserId: actorUserId is _isc.UndefinedSentinel
          ? this.actorUserId
          : actorUserId,
      actorEmail: actorEmail is String? ? actorEmail : this.actorEmail,
      actorName: actorName is String? ? actorName : this.actorName,
      action: action ?? this.action,
      targetType: targetType is String? ? targetType : this.targetType,
      targetId: targetId is String? ? targetId : this.targetId,
      data: data is String? ? data : this.data,
      ipAddress: ipAddress is String? ? ipAddress : this.ipAddress,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
