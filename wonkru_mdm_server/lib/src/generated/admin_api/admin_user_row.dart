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
import '../enums/admin_account_status.dart' as _ingta7r9;

abstract class AdminUserRow
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AdminUserRow._({
    required this.authUserId,
    this.name,
    this.email,
    required this.hasPassword,
    required this.blocked,
    required this.status,
    this.lastLoginAt,
    required this.createdAt,
  });

  factory AdminUserRow({
    required _is.UuidValue authUserId,
    String? name,
    String? email,
    required bool hasPassword,
    required bool blocked,
    required _ingta7r9.AdminAccountStatus status,
    DateTime? lastLoginAt,
    required DateTime createdAt,
  }) = _AdminUserRowImpl;

  factory AdminUserRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminUserRow(
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      name: jsonSerialization['name'] as String?,
      email: jsonSerialization['email'] as String?,
      hasPassword: _is.BoolJsonExtension.fromJson(
        jsonSerialization['hasPassword'],
      ),
      blocked: _is.BoolJsonExtension.fromJson(jsonSerialization['blocked']),
      status: _ingta7r9.AdminAccountStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      lastLoginAt: jsonSerialization['lastLoginAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastLoginAt'],
            ),
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  _is.UuidValue authUserId;

  String? name;

  /// Login email; falls back to the profile's verified email.
  String? email;

  bool hasPassword;

  bool blocked;

  /// Admin account status; `disabled` when there is no admin profile.
  _ingta7r9.AdminAccountStatus status;

  DateTime? lastLoginAt;

  DateTime createdAt;

  /// Returns a shallow copy of this [AdminUserRow]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdminUserRow copyWith({
    _is.UuidValue? authUserId,
    String? name,
    String? email,
    bool? hasPassword,
    bool? blocked,
    _ingta7r9.AdminAccountStatus? status,
    DateTime? lastLoginAt = const _is.$UndefinedDateTime(),
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminUserRow',
      'authUserId': authUserId.toJson(),
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      'hasPassword': hasPassword,
      'blocked': blocked,
      'status': status.toJson(),
      if (lastLoginAt != null) 'lastLoginAt': lastLoginAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminUserRow',
      'authUserId': authUserId.toJson(),
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      'hasPassword': hasPassword,
      'blocked': blocked,
      'status': status.toJson(),
      if (lastLoginAt != null) 'lastLoginAt': lastLoginAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminUserRowImpl extends AdminUserRow {
  _AdminUserRowImpl({
    required _is.UuidValue authUserId,
    String? name,
    String? email,
    required bool hasPassword,
    required bool blocked,
    required _ingta7r9.AdminAccountStatus status,
    DateTime? lastLoginAt,
    required DateTime createdAt,
  }) : super._(
         authUserId: authUserId,
         name: name,
         email: email,
         hasPassword: hasPassword,
         blocked: blocked,
         status: status,
         lastLoginAt: lastLoginAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AdminUserRow]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdminUserRow copyWith({
    _is.UuidValue? authUserId,
    Object? name = _Undefined,
    Object? email = _Undefined,
    bool? hasPassword,
    bool? blocked,
    _ingta7r9.AdminAccountStatus? status,
    DateTime? lastLoginAt = const _is.$UndefinedDateTime(),
    DateTime? createdAt,
  }) {
    return AdminUserRow(
      authUserId: authUserId ?? this.authUserId,
      name: name is String? ? name : this.name,
      email: email is String? ? email : this.email,
      hasPassword: hasPassword ?? this.hasPassword,
      blocked: blocked ?? this.blocked,
      status: status ?? this.status,
      lastLoginAt: lastLoginAt is _is.UndefinedSentinel
          ? this.lastLoginAt
          : lastLoginAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
