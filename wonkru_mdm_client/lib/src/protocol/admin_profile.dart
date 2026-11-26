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
import 'enums/admin_account_status.dart' as _iejobxhm;

abstract class AdminProfile
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AdminProfile._({
    this.id,
    required this.userId,
    _iejobxhm.AdminAccountStatus? status,
    this.totpSecret,
    this.recoveryCodes,
    this.totpLastUsedCounter,
    this.lastLoginAt,
    int? totpFailedAttempts,
    this.totpLockedUntil,
    this.createdAt,
    this.updatedAt,
  }) : status = status ?? _iejobxhm.AdminAccountStatus.disabled,
       totpFailedAttempts = totpFailedAttempts ?? 0;

  factory AdminProfile({
    int? id,
    required _isc.UuidValue userId,
    _iejobxhm.AdminAccountStatus? status,
    String? totpSecret,
    String? recoveryCodes,
    int? totpLastUsedCounter,
    DateTime? lastLoginAt,
    int? totpFailedAttempts,
    DateTime? totpLockedUntil,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AdminProfileImpl;

  factory AdminProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminProfile(
      id: jsonSerialization['id'] as int?,
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      status: jsonSerialization['status'] == null
          ? null
          : _iejobxhm.AdminAccountStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      totpSecret: jsonSerialization['totpSecret'] as String?,
      recoveryCodes: jsonSerialization['recoveryCodes'] as String?,
      totpLastUsedCounter: jsonSerialization['totpLastUsedCounter'] as int?,
      lastLoginAt: jsonSerialization['lastLoginAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastLoginAt'],
            ),
      totpFailedAttempts: jsonSerialization['totpFailedAttempts'] as int?,
      totpLockedUntil: jsonSerialization['totpLockedUntil'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['totpLockedUntil'],
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

  _isc.UuidValue userId;

  /// Panel access is granted only while `active`; the fail-closed default is
  /// `disabled`.
  _iejobxhm.AdminAccountStatus status;

  String? totpSecret;

  /// JSON array of two-factor recovery codes.
  String? recoveryCodes;

  /// Last accepted TOTP time step; blocks code replay.
  int? totpLastUsedCounter;

  /// Last successful panel login; null if never.
  DateTime? lastLoginAt;

  /// Consecutive failed code attempts; drives lockout.
  int totpFailedAttempts;

  /// Attempts are rejected until this time; null when unlocked.
  DateTime? totpLockedUntil;

  DateTime? createdAt;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [AdminProfile]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AdminProfile copyWith({
    int? id,
    _isc.UuidValue? userId,
    _iejobxhm.AdminAccountStatus? status,
    String? totpSecret,
    String? recoveryCodes,
    int? totpLastUsedCounter,
    DateTime? lastLoginAt = const _isc.$UndefinedDateTime(),
    int? totpFailedAttempts,
    DateTime? totpLockedUntil = const _isc.$UndefinedDateTime(),
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminProfile',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'status': status.toJson(),
      if (totpSecret != null) 'totpSecret': totpSecret,
      if (recoveryCodes != null) 'recoveryCodes': recoveryCodes,
      if (totpLastUsedCounter != null)
        'totpLastUsedCounter': totpLastUsedCounter,
      if (lastLoginAt != null) 'lastLoginAt': lastLoginAt?.toJson(),
      'totpFailedAttempts': totpFailedAttempts,
      if (totpLockedUntil != null) 'totpLockedUntil': totpLockedUntil?.toJson(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminProfile',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'status': status.toJson(),
      if (totpSecret != null) 'totpSecret': totpSecret,
      if (recoveryCodes != null) 'recoveryCodes': recoveryCodes,
      if (totpLastUsedCounter != null)
        'totpLastUsedCounter': totpLastUsedCounter,
      if (lastLoginAt != null) 'lastLoginAt': lastLoginAt?.toJson(),
      'totpFailedAttempts': totpFailedAttempts,
      if (totpLockedUntil != null) 'totpLockedUntil': totpLockedUntil?.toJson(),
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

class _AdminProfileImpl extends AdminProfile {
  _AdminProfileImpl({
    int? id,
    required _isc.UuidValue userId,
    _iejobxhm.AdminAccountStatus? status,
    String? totpSecret,
    String? recoveryCodes,
    int? totpLastUsedCounter,
    DateTime? lastLoginAt,
    int? totpFailedAttempts,
    DateTime? totpLockedUntil,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         status: status,
         totpSecret: totpSecret,
         recoveryCodes: recoveryCodes,
         totpLastUsedCounter: totpLastUsedCounter,
         lastLoginAt: lastLoginAt,
         totpFailedAttempts: totpFailedAttempts,
         totpLockedUntil: totpLockedUntil,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [AdminProfile]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AdminProfile copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? userId,
    _iejobxhm.AdminAccountStatus? status,
    Object? totpSecret = _Undefined,
    Object? recoveryCodes = _Undefined,
    Object? totpLastUsedCounter = _Undefined,
    DateTime? lastLoginAt = const _isc.$UndefinedDateTime(),
    int? totpFailedAttempts,
    DateTime? totpLockedUntil = const _isc.$UndefinedDateTime(),
    DateTime? createdAt = const _isc.$UndefinedDateTime(),
    DateTime? updatedAt = const _isc.$UndefinedDateTime(),
  }) {
    return AdminProfile(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      totpSecret: totpSecret is String? ? totpSecret : this.totpSecret,
      recoveryCodes: recoveryCodes is String?
          ? recoveryCodes
          : this.recoveryCodes,
      totpLastUsedCounter: totpLastUsedCounter is int?
          ? totpLastUsedCounter
          : this.totpLastUsedCounter,
      lastLoginAt: lastLoginAt is _isc.UndefinedSentinel
          ? this.lastLoginAt
          : lastLoginAt,
      totpFailedAttempts: totpFailedAttempts ?? this.totpFailedAttempts,
      totpLockedUntil: totpLockedUntil is _isc.UndefinedSentinel
          ? this.totpLockedUntil
          : totpLockedUntil,
      createdAt: createdAt is _isc.UndefinedSentinel
          ? this.createdAt
          : createdAt,
      updatedAt: updatedAt is _isc.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
    );
  }
}
