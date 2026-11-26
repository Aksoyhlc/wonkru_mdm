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

abstract class AdminUserCreateRequest
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AdminUserCreateRequest._({
    this.name,
    required this.email,
    required this.password,
    required this.status,
    required this.blocked,
  });

  factory AdminUserCreateRequest({
    String? name,
    required String email,
    required String password,
    required _ingta7r9.AdminAccountStatus status,
    required bool blocked,
  }) = _AdminUserCreateRequestImpl;

  factory AdminUserCreateRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AdminUserCreateRequest(
      name: jsonSerialization['name'] as String?,
      email: jsonSerialization['email'] as String,
      password: jsonSerialization['password'] as String,
      status: _ingta7r9.AdminAccountStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      blocked: _is.BoolJsonExtension.fromJson(jsonSerialization['blocked']),
    );
  }

  String? name;

  /// Login email; stored in lower case.
  String email;

  String password;

  _ingta7r9.AdminAccountStatus status;

  bool blocked;

  /// Returns a shallow copy of this [AdminUserCreateRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdminUserCreateRequest copyWith({
    String? name,
    String? email,
    String? password,
    _ingta7r9.AdminAccountStatus? status,
    bool? blocked,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminUserCreateRequest',
      if (name != null) 'name': name,
      'email': email,
      'password': password,
      'status': status.toJson(),
      'blocked': blocked,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminUserCreateRequest',
      if (name != null) 'name': name,
      'email': email,
      'password': password,
      'status': status.toJson(),
      'blocked': blocked,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminUserCreateRequestImpl extends AdminUserCreateRequest {
  _AdminUserCreateRequestImpl({
    String? name,
    required String email,
    required String password,
    required _ingta7r9.AdminAccountStatus status,
    required bool blocked,
  }) : super._(
         name: name,
         email: email,
         password: password,
         status: status,
         blocked: blocked,
       );

  /// Returns a shallow copy of this [AdminUserCreateRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdminUserCreateRequest copyWith({
    Object? name = _Undefined,
    String? email,
    String? password,
    _ingta7r9.AdminAccountStatus? status,
    bool? blocked,
  }) {
    return AdminUserCreateRequest(
      name: name is String? ? name : this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      blocked: blocked ?? this.blocked,
    );
  }
}
