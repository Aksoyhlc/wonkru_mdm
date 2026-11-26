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
import '../enums/admin_account_status.dart' as _ingta7r9;

abstract class AdminUserUpdateRequest
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AdminUserUpdateRequest._({
    required this.authUserId,
    this.name,
    required this.email,
    this.password,
    required this.status,
    required this.blocked,
  });

  factory AdminUserUpdateRequest({
    required _isc.UuidValue authUserId,
    String? name,
    required String email,
    String? password,
    required _ingta7r9.AdminAccountStatus status,
    required bool blocked,
  }) = _AdminUserUpdateRequestImpl;

  factory AdminUserUpdateRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AdminUserUpdateRequest(
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      name: jsonSerialization['name'] as String?,
      email: jsonSerialization['email'] as String,
      password: jsonSerialization['password'] as String?,
      status: _ingta7r9.AdminAccountStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      blocked: _isc.BoolJsonExtension.fromJson(jsonSerialization['blocked']),
    );
  }

  _isc.UuidValue authUserId;

  String? name;

  /// Login email; stored in lower case.
  String email;

  /// New password; null leaves the current one.
  String? password;

  _ingta7r9.AdminAccountStatus status;

  bool blocked;

  /// Returns a shallow copy of this [AdminUserUpdateRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AdminUserUpdateRequest copyWith({
    _isc.UuidValue? authUserId,
    String? name,
    String? email,
    String? password,
    _ingta7r9.AdminAccountStatus? status,
    bool? blocked,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminUserUpdateRequest',
      'authUserId': authUserId.toJson(),
      if (name != null) 'name': name,
      'email': email,
      if (password != null) 'password': password,
      'status': status.toJson(),
      'blocked': blocked,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminUserUpdateRequest',
      'authUserId': authUserId.toJson(),
      if (name != null) 'name': name,
      'email': email,
      if (password != null) 'password': password,
      'status': status.toJson(),
      'blocked': blocked,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminUserUpdateRequestImpl extends AdminUserUpdateRequest {
  _AdminUserUpdateRequestImpl({
    required _isc.UuidValue authUserId,
    String? name,
    required String email,
    String? password,
    required _ingta7r9.AdminAccountStatus status,
    required bool blocked,
  }) : super._(
         authUserId: authUserId,
         name: name,
         email: email,
         password: password,
         status: status,
         blocked: blocked,
       );

  /// Returns a shallow copy of this [AdminUserUpdateRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AdminUserUpdateRequest copyWith({
    _isc.UuidValue? authUserId,
    Object? name = _Undefined,
    String? email,
    Object? password = _Undefined,
    _ingta7r9.AdminAccountStatus? status,
    bool? blocked,
  }) {
    return AdminUserUpdateRequest(
      authUserId: authUserId ?? this.authUserId,
      name: name is String? ? name : this.name,
      email: email ?? this.email,
      password: password is String? ? password : this.password,
      status: status ?? this.status,
      blocked: blocked ?? this.blocked,
    );
  }
}
