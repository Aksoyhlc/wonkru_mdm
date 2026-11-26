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

abstract class AdminSessionInfo
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AdminSessionInfo._({
    this.status,
    this.adminProfileId,
    this.displayName,
    required this.needsBootstrap,
    bool? hasAdminScope,
    bool? totpEnabled,
    bool? twoFactorRequired,
    int? unreadNotificationCount,
  }) : hasAdminScope = hasAdminScope ?? false,
       totpEnabled = totpEnabled ?? false,
       twoFactorRequired = twoFactorRequired ?? false,
       unreadNotificationCount = unreadNotificationCount ?? 0;

  factory AdminSessionInfo({
    _ingta7r9.AdminAccountStatus? status,
    int? adminProfileId,
    String? displayName,
    required bool needsBootstrap,
    bool? hasAdminScope,
    bool? totpEnabled,
    bool? twoFactorRequired,
    int? unreadNotificationCount,
  }) = _AdminSessionInfoImpl;

  factory AdminSessionInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminSessionInfo(
      status: jsonSerialization['status'] == null
          ? null
          : _ingta7r9.AdminAccountStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      adminProfileId: jsonSerialization['adminProfileId'] as int?,
      displayName: jsonSerialization['displayName'] as String?,
      needsBootstrap: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['needsBootstrap'],
      ),
      hasAdminScope: jsonSerialization['hasAdminScope'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['hasAdminScope']),
      totpEnabled: jsonSerialization['totpEnabled'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['totpEnabled']),
      twoFactorRequired: jsonSerialization['twoFactorRequired'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['twoFactorRequired'],
            ),
      unreadNotificationCount:
          jsonSerialization['unreadNotificationCount'] as int?,
    );
  }

  _ingta7r9.AdminAccountStatus? status;

  int? adminProfileId;

  String? displayName;

  /// True when no admin profile exists and first-run setup is required.
  bool needsBootstrap;

  /// Whether this session's token carries the `admin` scope. Scopes are
  /// embedded in the JWT at sign-in, so a token issued before the scope was
  /// granted gets 403 on panel endpoints.
  bool hasAdminScope;

  bool totpEnabled;

  /// 2FA enabled but not yet verified in this session; the panel shows the
  /// code step only when true.
  bool twoFactorRequired;

  int unreadNotificationCount;

  /// Returns a shallow copy of this [AdminSessionInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AdminSessionInfo copyWith({
    _ingta7r9.AdminAccountStatus? status,
    int? adminProfileId,
    String? displayName,
    bool? needsBootstrap,
    bool? hasAdminScope,
    bool? totpEnabled,
    bool? twoFactorRequired,
    int? unreadNotificationCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminSessionInfo',
      if (status != null) 'status': status?.toJson(),
      if (adminProfileId != null) 'adminProfileId': adminProfileId,
      if (displayName != null) 'displayName': displayName,
      'needsBootstrap': needsBootstrap,
      'hasAdminScope': hasAdminScope,
      'totpEnabled': totpEnabled,
      'twoFactorRequired': twoFactorRequired,
      'unreadNotificationCount': unreadNotificationCount,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminSessionInfo',
      if (status != null) 'status': status?.toJson(),
      if (adminProfileId != null) 'adminProfileId': adminProfileId,
      if (displayName != null) 'displayName': displayName,
      'needsBootstrap': needsBootstrap,
      'hasAdminScope': hasAdminScope,
      'totpEnabled': totpEnabled,
      'twoFactorRequired': twoFactorRequired,
      'unreadNotificationCount': unreadNotificationCount,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminSessionInfoImpl extends AdminSessionInfo {
  _AdminSessionInfoImpl({
    _ingta7r9.AdminAccountStatus? status,
    int? adminProfileId,
    String? displayName,
    required bool needsBootstrap,
    bool? hasAdminScope,
    bool? totpEnabled,
    bool? twoFactorRequired,
    int? unreadNotificationCount,
  }) : super._(
         status: status,
         adminProfileId: adminProfileId,
         displayName: displayName,
         needsBootstrap: needsBootstrap,
         hasAdminScope: hasAdminScope,
         totpEnabled: totpEnabled,
         twoFactorRequired: twoFactorRequired,
         unreadNotificationCount: unreadNotificationCount,
       );

  /// Returns a shallow copy of this [AdminSessionInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AdminSessionInfo copyWith({
    Object? status = _Undefined,
    Object? adminProfileId = _Undefined,
    Object? displayName = _Undefined,
    bool? needsBootstrap,
    bool? hasAdminScope,
    bool? totpEnabled,
    bool? twoFactorRequired,
    int? unreadNotificationCount,
  }) {
    return AdminSessionInfo(
      status: status is _ingta7r9.AdminAccountStatus? ? status : this.status,
      adminProfileId: adminProfileId is int?
          ? adminProfileId
          : this.adminProfileId,
      displayName: displayName is String? ? displayName : this.displayName,
      needsBootstrap: needsBootstrap ?? this.needsBootstrap,
      hasAdminScope: hasAdminScope ?? this.hasAdminScope,
      totpEnabled: totpEnabled ?? this.totpEnabled,
      twoFactorRequired: twoFactorRequired ?? this.twoFactorRequired,
      unreadNotificationCount:
          unreadNotificationCount ?? this.unreadNotificationCount,
    );
  }
}
