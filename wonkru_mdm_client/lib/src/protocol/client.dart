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
import 'dart:async' as _ida;
import 'dart:typed_data' as _idt;
import 'package:http/http.dart' as _i85jenna;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:wonkru_core_client/wonkru_core_client.dart' as _inc4d0tr;
import 'package:wonkru_mdm_client/src/protocol/admin_api/admin_activity_list_request.dart'
    as _i69t897n;
import 'package:wonkru_mdm_client/src/protocol/admin_api/admin_activity_page.dart'
    as _ir3y0ko1;
import 'package:wonkru_mdm_client/src/protocol/admin_api/admin_application_version_upload_request.dart'
    as _i81blv6l;
import 'package:wonkru_mdm_client/src/protocol/admin_api/admin_certificate_upload_request.dart'
    as _i9y0kxlv;
import 'package:wonkru_mdm_client/src/protocol/admin_api/admin_certificate_upload_response.dart'
    as _ij1lnrmh;
import 'package:wonkru_mdm_client/src/protocol/admin_api/admin_device_log_list_request.dart'
    as _iuxpvtnr;
import 'package:wonkru_mdm_client/src/protocol/admin_api/admin_device_notification_create_request.dart'
    as _i4pee3j5;
import 'package:wonkru_mdm_client/src/protocol/admin_api/admin_device_notification_create_response.dart'
    as _iy7z1xzx;
import 'package:wonkru_mdm_client/src/protocol/admin_api/admin_device_sync_list_request.dart'
    as _iugkxpta;
import 'package:wonkru_mdm_client/src/protocol/admin_api/admin_device_update_request.dart'
    as _itxd895z;
import 'package:wonkru_mdm_client/src/protocol/admin_api/admin_file_upload_request.dart'
    as _icvb5aok;
import 'package:wonkru_mdm_client/src/protocol/admin_api/admin_file_upload_response.dart'
    as _ikfp951m;
import 'package:wonkru_mdm_client/src/protocol/admin_api/admin_list_request.dart'
    as _iotoy16a;
import 'package:wonkru_mdm_client/src/protocol/admin_api/admin_notification_page.dart'
    as _ib5g3yc9;
import 'package:wonkru_mdm_client/src/protocol/admin_api/admin_session_info.dart'
    as _ifqi1m2e;
import 'package:wonkru_mdm_client/src/protocol/admin_api/admin_totp_setup.dart'
    as _iug0x1zq;
import 'package:wonkru_mdm_client/src/protocol/admin_api/admin_upload_description.dart'
    as _is9v76kn;
import 'package:wonkru_mdm_client/src/protocol/admin_api/admin_user_create_request.dart'
    as _iykzrnoy;
import 'package:wonkru_mdm_client/src/protocol/admin_api/admin_user_page.dart'
    as _iqj1i8oi;
import 'package:wonkru_mdm_client/src/protocol/admin_api/admin_user_row.dart'
    as _iqofvu41;
import 'package:wonkru_mdm_client/src/protocol/admin_api/admin_user_update_request.dart'
    as _ipk345zj;
import 'package:wonkru_mdm_client/src/protocol/admin_api/application_list_request.dart'
    as _i5eso2ur;
import 'package:wonkru_mdm_client/src/protocol/admin_api/application_page.dart'
    as _ilxqrkg7;
import 'package:wonkru_mdm_client/src/protocol/admin_api/application_version_page.dart'
    as _i80f3t09;
import 'package:wonkru_mdm_client/src/protocol/admin_api/certificate_info.dart'
    as _i75prltj;
import 'package:wonkru_mdm_client/src/protocol/admin_api/certificate_page.dart'
    as _iwu83rlx;
import 'package:wonkru_mdm_client/src/protocol/admin_api/dashboard_alert_stats.dart'
    as _iz8i6rlp;
import 'package:wonkru_mdm_client/src/protocol/admin_api/dashboard_chart.dart'
    as _ia8zfw1d;
import 'package:wonkru_mdm_client/src/protocol/admin_api/dashboard_device_stats.dart'
    as _i0cjr4a1;
import 'package:wonkru_mdm_client/src/protocol/admin_api/device_application_page.dart'
    as _i5cll6dk;
import 'package:wonkru_mdm_client/src/protocol/admin_api/device_command_bulk_status.dart'
    as _inm65q16;
import 'package:wonkru_mdm_client/src/protocol/admin_api/device_command_page.dart'
    as _idkbjv17;
import 'package:wonkru_mdm_client/src/protocol/admin_api/device_group_page.dart'
    as _itvv1e3b;
import 'package:wonkru_mdm_client/src/protocol/admin_api/device_list_request.dart'
    as _i1z5ebq2;
import 'package:wonkru_mdm_client/src/protocol/admin_api/device_log_level_slice.dart'
    as _ijgatwl3;
import 'package:wonkru_mdm_client/src/protocol/admin_api/device_log_page.dart'
    as _i075mhxc;
import 'package:wonkru_mdm_client/src/protocol/admin_api/device_log_row.dart'
    as _i5ee539x;
import 'package:wonkru_mdm_client/src/protocol/admin_api/device_log_stats.dart'
    as _i0axnghi;
import 'package:wonkru_mdm_client/src/protocol/admin_api/device_log_trend.dart'
    as _ii8v9or1;
import 'package:wonkru_mdm_client/src/protocol/admin_api/device_notification_delivery_row.dart'
    as _igielq3j;
import 'package:wonkru_mdm_client/src/protocol/admin_api/device_notification_page.dart'
    as _ina9wh29;
import 'package:wonkru_mdm_client/src/protocol/admin_api/device_page.dart'
    as _ij7bnw1h;
import 'package:wonkru_mdm_client/src/protocol/admin_api/device_sync_detail.dart'
    as _izayv5t4;
import 'package:wonkru_mdm_client/src/protocol/admin_api/device_sync_page.dart'
    as _ienego1y;
import 'package:wonkru_mdm_client/src/protocol/admin_api/file_group_page.dart'
    as _iu6c0tg9;
import 'package:wonkru_mdm_client/src/protocol/admin_api/file_list_request.dart'
    as _ii8zkkz6;
import 'package:wonkru_mdm_client/src/protocol/admin_api/file_page.dart'
    as _iwb1rs8m;
import 'package:wonkru_mdm_client/src/protocol/admin_api/policy_list_request.dart'
    as _i72oj68w;
import 'package:wonkru_mdm_client/src/protocol/admin_api/policy_page.dart'
    as _in46iyup;
import 'package:wonkru_mdm_client/src/protocol/admin_api/provisioning_profile_page.dart'
    as _ia0jvsvu;
import 'package:wonkru_mdm_client/src/protocol/admin_api/settings_form_state.dart'
    as _i0qnb0xz;
import 'package:wonkru_mdm_client/src/protocol/admin_api/smtp_test_notice.dart'
    as _ibzn59jo;
import 'package:wonkru_mdm_client/src/protocol/application.dart' as _ik8msm9l;
import 'package:wonkru_mdm_client/src/protocol/application_version.dart'
    as _i4qexbc5;
import 'package:wonkru_mdm_client/src/protocol/certificate.dart' as _iwvtj5a4;
import 'package:wonkru_mdm_client/src/protocol/device.dart' as _i60wy96o;
import 'package:wonkru_mdm_client/src/protocol/device_application.dart'
    as _i1ww50jj;
import 'package:wonkru_mdm_client/src/protocol/device_command.dart'
    as _i001a4i1;
import 'package:wonkru_mdm_client/src/protocol/device_group.dart' as _ijw86xpg;
import 'package:wonkru_mdm_client/src/protocol/device_log.dart' as _id6xyz4c;
import 'package:wonkru_mdm_client/src/protocol/device_notification.dart'
    as _ie2lwq2y;
import 'package:wonkru_mdm_client/src/protocol/device_report.dart' as _i9f6b1zs;
import 'package:wonkru_mdm_client/src/protocol/device_state_cache.dart'
    as _i3hrj2kt;
import 'package:wonkru_mdm_client/src/protocol/file_asset.dart' as _imf89v3x;
import 'package:wonkru_mdm_client/src/protocol/file_group.dart' as _i0vpywrl;
import 'package:wonkru_mdm_client/src/protocol/file_group_member.dart'
    as _ivpkm2mv;
import 'package:wonkru_mdm_client/src/protocol/policy.dart' as _i2x41jtq;
import 'package:wonkru_mdm_client/src/protocol/policy_application.dart'
    as _ixu9efec;
import 'package:wonkru_mdm_client/src/protocol/policy_certificate.dart'
    as _i5kzc7q6;
import 'package:wonkru_mdm_client/src/protocol/policy_file.dart' as _if9818ly;
import 'package:wonkru_mdm_client/src/protocol/provisioning_profile.dart'
    as _i5ip6bji;
import 'protocol.dart' as _il2as5qe;

/// {@category Endpoint}
class EndpointEmailIdp extends _iaic.EndpointEmailIdpBase {
  EndpointEmailIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _ida.Future<_isc.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _ida.Future<String> verifyRegistrationCode({
    required _isc.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _ida.Future<_iacc.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _ida.Future<_isc.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _ida.Future<String> verifyPasswordResetCode({
    required _isc.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// {@category Endpoint}
class EndpointJwtRefresh extends _iacc.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// If [refreshToken] is omitted, cookie-mode web clients fall back to the
  /// configured HttpOnly refresh cookie. When neither source is present this
  /// throws [RefreshTokenNotFoundException], the same public "no usable refresh
  /// credential" exception used for unknown refresh tokens.
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _ida.Future<_iacc.AuthSuccess> refreshAccessToken({String? refreshToken}) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'jwtRefresh',
        'refreshAccessToken',
        {'refreshToken': refreshToken},
        authenticated: false,
      );
}

/// Audit trail; records are immutable by design — there is no edit or delete.
/// {@category Endpoint}
class EndpointAdminActivity extends _isc.EndpointRef {
  EndpointAdminActivity(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'adminActivity';

  _ida.Future<_ir3y0ko1.AdminActivityPage> list(
    _i69t897n.AdminActivityListRequest request,
  ) => caller.callServerEndpoint<_ir3y0ko1.AdminActivityPage>(
    'adminActivity',
    'list',
    {'request': request},
  );

  _ida.Future<List<String>> actions() =>
      caller.callServerEndpoint<List<String>>(
        'adminActivity',
        'actions',
        {},
      );
}

/// Every write runs in a transaction with its service call so policy versions
/// stay in step, rolling both back on failure.
/// {@category Endpoint}
class EndpointAdminApplication extends _isc.EndpointRef {
  EndpointAdminApplication(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'adminApplication';

  _ida.Future<_ilxqrkg7.ApplicationPage> listApplications(
    _i5eso2ur.ApplicationListRequest request,
  ) => caller.callServerEndpoint<_ilxqrkg7.ApplicationPage>(
    'adminApplication',
    'listApplications',
    {'request': request},
  );

  /// The CSV is built from every matching row, not just the current page.
  _ida.Future<_idt.ByteData> export(_i5eso2ur.ApplicationListRequest request) =>
      caller.callServerEndpoint<_idt.ByteData>(
        'adminApplication',
        'export',
        {'request': request},
      );

  _ida.Future<_ik8msm9l.Application> getApplication(int id) =>
      caller.callServerEndpoint<_ik8msm9l.Application>(
        'adminApplication',
        'getApplication',
        {'id': id},
      );

  /// A package name may only be registered once; a clash throws
  /// [ApplicationConflictException] carrying the existing row.
  _ida.Future<_ik8msm9l.Application> createApplication(
    _ik8msm9l.Application application,
  ) => caller.callServerEndpoint<_ik8msm9l.Application>(
    'adminApplication',
    'createApplication',
    {'application': application},
  );

  _ida.Future<_ik8msm9l.Application> updateApplication(
    _ik8msm9l.Application application,
  ) => caller.callServerEndpoint<_ik8msm9l.Application>(
    'adminApplication',
    'updateApplication',
    {'application': application},
  );

  _ida.Future<void> deleteApplication(int id) =>
      caller.callServerEndpoint<void>(
        'adminApplication',
        'deleteApplication',
        {'id': id},
      );

  /// Deletes each application in its own transaction, so one failure leaves the
  /// others deleted; returns the count removed.
  _ida.Future<int> deleteApplications(List<int> ids) =>
      caller.callServerEndpoint<int>(
        'adminApplication',
        'deleteApplications',
        {'ids': ids},
      );

  _ida.Future<_i80f3t09.ApplicationVersionPage> listVersions(
    int applicationId,
    _iotoy16a.AdminListRequest request,
  ) => caller.callServerEndpoint<_i80f3t09.ApplicationVersionPage>(
    'adminApplication',
    'listVersions',
    {
      'applicationId': applicationId,
      'request': request,
    },
  );

  _ida.Future<_i4qexbc5.ApplicationVersion> getVersion(int id) =>
      caller.callServerEndpoint<_i4qexbc5.ApplicationVersion>(
        'adminApplication',
        'getVersion',
        {'id': id},
      );

  /// The APK's manifest package must match the application it joins (unreadable
  /// manifests pass). `(applicationId, versionCode)` is unique, so a clash throws
  /// [ApplicationConflictException].
  _ida.Future<_i4qexbc5.ApplicationVersion> createVersion(
    _i4qexbc5.ApplicationVersion version,
  ) => caller.callServerEndpoint<_i4qexbc5.ApplicationVersion>(
    'adminApplication',
    'createVersion',
    {'version': version},
  );

  _ida.Future<_i4qexbc5.ApplicationVersion> updateVersion(
    _i4qexbc5.ApplicationVersion version,
  ) => caller.callServerEndpoint<_i4qexbc5.ApplicationVersion>(
    'adminApplication',
    'updateVersion',
    {'version': version},
  );

  /// Unpins the entries on this version, then hands the default flag to the
  /// newest remaining version.
  _ida.Future<void> deleteVersion(int id) => caller.callServerEndpoint<void>(
    'adminApplication',
    'deleteVersion',
    {'id': id},
  );

  /// Stores an uploaded APK and creates or refreshes its version. Upserts on
  /// `(applicationId, versionCode)`: re-uploading replaces the file.
  _ida.Future<_i4qexbc5.ApplicationVersion> uploadVersion(
    _i81blv6l.AdminApplicationVersionUploadRequest request,
  ) => caller.callServerEndpoint<_i4qexbc5.ApplicationVersion>(
    'adminApplication',
    'uploadVersion',
    {'request': request},
  );
}

/// The panel's entry point. The auth session comes from Serverpod; panel access
/// is decided through [AdminProfile].
/// {@category Endpoint}
class EndpointAdminAuth extends _isc.EndpointRef {
  EndpointAdminAuth(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'adminAuth';

  /// `status` is null when there is no session or no active profile.
  /// [needsBootstrap] is true only while no [AdminProfile] exists at all, so the
  /// panel offers first-admin setup once.
  _ida.Future<_ifqi1m2e.AdminSessionInfo> me() =>
      caller.callServerEndpoint<_ifqi1m2e.AdminSessionInfo>(
        'adminAuth',
        'me',
        {},
      );

  /// Wraps the IDP login so every attempt (success or failure) is audited with
  /// the client IP; login is rate limited per client IP.
  _ida.Future<_iacc.AuthSuccess> login(
    String email,
    String password,
  ) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'adminAuth',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Callable only while no [AdminProfile] exists, so first setup needs no
  /// sign-up flow; the user, email account, profile and admin scope are created
  /// in one transaction. Rate limited per client IP.
  _ida.Future<_ifqi1m2e.AdminSessionInfo> bootstrap({
    required String email,
    required String password,
    String? name,
  }) => caller.callServerEndpoint<_ifqi1m2e.AdminSessionInfo>(
    'adminAuth',
    'bootstrap',
    {
      'email': email,
      'password': password,
      'name': name,
    },
  );

  /// The secret is stored encrypted; the account is inactive until
  /// [confirmTotpSetup] produces the recovery codes.
  _ida.Future<_iug0x1zq.AdminTotpSetup> startTotpSetup() =>
      caller.callServerEndpoint<_iug0x1zq.AdminTotpSetup>(
        'adminAuth',
        'startTotpSetup',
        {},
      );

  /// The recovery codes are shown in plaintext only in this response.
  _ida.Future<List<String>> confirmTotpSetup(String code) =>
      caller.callServerEndpoint<List<String>>(
        'adminAuth',
        'confirmTotpSetup',
        {'code': code},
      );

  /// Skips 2FA enforcement (the panel is unreachable until 2FA is verified);
  /// repeated failures lock the account and throw `AdminTotpException`.
  _ida.Future<bool> verifyTotp(String code) => caller.callServerEndpoint<bool>(
    'adminAuth',
    'verifyTotp',
    {'code': code},
  );

  _ida.Future<void> disableTotp(String code) => caller.callServerEndpoint<void>(
    'adminAuth',
    'disableTotp',
    {'code': code},
  );

  /// Only the account's own auth user may change the password; the current one
  /// is verified client-side via `emailIdp.login`. With 2FA on, an unverified
  /// session cannot change it and take over the account.
  _ida.Future<void> changePassword(
    String email,
    String newPassword,
  ) => caller.callServerEndpoint<void>(
    'adminAuth',
    'changePassword',
    {
      'email': email,
      'newPassword': newPassword,
    },
  );

  /// Ownership is checked against the account's auth user; a new address in use
  /// is rejected. With 2FA on the second step is mandatory (see [changePassword]).
  _ida.Future<void> changeEmail(
    String currentEmail,
    String newEmail,
  ) => caller.callServerEndpoint<void>(
    'adminAuth',
    'changeEmail',
    {
      'currentEmail': currentEmail,
      'newEmail': newEmail,
    },
  );
}

/// PKCS12 bundles carry private keys, so certificates live on the private disk
/// and are served only through signed, expiring URLs.
/// {@category Endpoint}
class EndpointAdminCertificate extends _isc.EndpointRef {
  EndpointAdminCertificate(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'adminCertificate';

  _ida.Future<_iwu83rlx.CertificatePage> list(
    _iotoy16a.AdminListRequest request,
  ) => caller.callServerEndpoint<_iwu83rlx.CertificatePage>(
    'adminCertificate',
    'list',
    {'request': request},
  );

  _ida.Future<_iwvtj5a4.Certificate> get(int id) =>
      caller.callServerEndpoint<_iwvtj5a4.Certificate>(
        'adminCertificate',
        'get',
        {'id': id},
      );

  _ida.Future<_i75prltj.CertificateInfo> parse(
    String certificateData, {
    String? password,
  }) => caller.callServerEndpoint<_i75prltj.CertificateInfo>(
    'adminCertificate',
    'parse',
    {
      'certificateData': certificateData,
      'password': password,
    },
  );

  _ida.Future<_iwvtj5a4.Certificate> create(
    _iwvtj5a4.Certificate certificate,
  ) => caller.callServerEndpoint<_iwvtj5a4.Certificate>(
    'adminCertificate',
    'create',
    {'certificate': certificate},
  );

  _ida.Future<_iwvtj5a4.Certificate> update(
    _iwvtj5a4.Certificate certificate,
  ) => caller.callServerEndpoint<_iwvtj5a4.Certificate>(
    'adminCertificate',
    'update',
    {'certificate': certificate},
  );

  _ida.Future<int> delete(List<int> certificateIds) =>
      caller.callServerEndpoint<int>(
        'adminCertificate',
        'delete',
        {'certificateIds': certificateIds},
      );

  _ida.Future<_ij1lnrmh.AdminCertificateUploadResponse> uploadFile(
    _i9y0kxlv.AdminCertificateUploadRequest request,
  ) => caller.callServerEndpoint<_ij1lnrmh.AdminCertificateUploadResponse>(
    'adminCertificate',
    'uploadFile',
    {'request': request},
  );

  _ida.Future<String?> downloadUrl(int id) =>
      caller.callServerEndpoint<String?>(
        'adminCertificate',
        'downloadUrl',
        {'id': id},
      );
}

/// Log cards and the log level chart live in the device log endpoint, not here.
/// {@category Endpoint}
class EndpointAdminDashboard extends _isc.EndpointRef {
  EndpointAdminDashboard(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'adminDashboard';

  _ida.Future<_i0cjr4a1.DashboardDeviceStats> deviceStats() =>
      caller.callServerEndpoint<_i0cjr4a1.DashboardDeviceStats>(
        'adminDashboard',
        'deviceStats',
        {},
      );

  _ida.Future<_iz8i6rlp.DashboardAlertStats> alertStats() =>
      caller.callServerEndpoint<_iz8i6rlp.DashboardAlertStats>(
        'adminDashboard',
        'alertStats',
        {},
      );

  /// [filter] is one of `manufacturer`, `model` and `android_version`; anything
  /// else falls back to the manufacturer.
  _ida.Future<_ia8zfw1d.DashboardChart> deviceDistribution(String filter) =>
      caller.callServerEndpoint<_ia8zfw1d.DashboardChart>(
        'adminDashboard',
        'deviceDistribution',
        {'filter': filter},
      );

  /// Covers the last 30 days.
  _ida.Future<_ia8zfw1d.DashboardChart> syncTrend() =>
      caller.callServerEndpoint<_ia8zfw1d.DashboardChart>(
        'adminDashboard',
        'syncTrend',
        {},
      );
}

/// {@category Endpoint}
class EndpointAdminDevice extends _isc.EndpointRef {
  EndpointAdminDevice(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'adminDevice';

  _ida.Future<_ij7bnw1h.DevicePage> list(_i1z5ebq2.DeviceListRequest request) =>
      caller.callServerEndpoint<_ij7bnw1h.DevicePage>(
        'adminDevice',
        'list',
        {'request': request},
      );

  /// Exports every matching row, not just the current page.
  _ida.Future<_idt.ByteData> export(_i1z5ebq2.DeviceListRequest request) =>
      caller.callServerEndpoint<_idt.ByteData>(
        'adminDevice',
        'export',
        {'request': request},
      );

  _ida.Future<_i60wy96o.Device> get(int deviceId) =>
      caller.callServerEndpoint<_i60wy96o.Device>(
        'adminDevice',
        'get',
        {'deviceId': deviceId},
      );

  /// [locale] is `tr` or `en`; an empty or unknown value falls back to Turkish.
  _ida.Future<_idt.ByteData> reportPdf(
    int deviceId,
    String? locale,
  ) => caller.callServerEndpoint<_idt.ByteData>(
    'adminDevice',
    'reportPdf',
    {
      'deviceId': deviceId,
      'locale': locale,
    },
  );

  /// Latest sync state, or null when the device has never synced.
  _ida.Future<_i3hrj2kt.DeviceStateCache?> stateCache(int deviceId) =>
      caller.callServerEndpoint<_i3hrj2kt.DeviceStateCache?>(
        'adminDevice',
        'stateCache',
        {'deviceId': deviceId},
      );

  _ida.Future<List<int>> groupIds(int deviceId) =>
      caller.callServerEndpoint<List<int>>(
        'adminDevice',
        'groupIds',
        {'deviceId': deviceId},
      );

  _ida.Future<List<_i1ww50jj.DeviceApplication>> applications(int deviceId) =>
      caller.callServerEndpoint<List<_i1ww50jj.DeviceApplication>>(
        'adminDevice',
        'applications',
        {'deviceId': deviceId},
      );

  _ida.Future<List<_i9f6b1zs.DeviceReport>> reports(
    int deviceId, {
    required int limit,
  }) => caller.callServerEndpoint<List<_i9f6b1zs.DeviceReport>>(
    'adminDevice',
    'reports',
    {
      'deviceId': deviceId,
      'limit': limit,
    },
  );

  /// An emptied policy falls back to the default policy.
  _ida.Future<_i60wy96o.Device> update(
    _itxd895z.AdminDeviceUpdateRequest request,
  ) => caller.callServerEndpoint<_i60wy96o.Device>(
    'adminDevice',
    'update',
    {'request': request},
  );

  _ida.Future<int> delete(List<int> deviceIds) =>
      caller.callServerEndpoint<int>(
        'adminDevice',
        'delete',
        {'deviceIds': deviceIds},
      );

  /// Moves the selected devices onto [policyId]; pushing is up to [sendPolicyUpdate].
  _ida.Future<int> assignPolicy(
    List<int> deviceIds,
    int policyId,
  ) => caller.callServerEndpoint<int>(
    'adminDevice',
    'assignPolicy',
    {
      'deviceIds': deviceIds,
      'policyId': policyId,
    },
  );

  _ida.Future<int> assignGroups(
    List<int> deviceIds,
    List<int> groupIds,
  ) => caller.callServerEndpoint<int>(
    'adminDevice',
    'assignGroups',
    {
      'deviceIds': deviceIds,
      'groupIds': groupIds,
    },
  );

  _ida.Future<int> sendPolicyUpdate(List<int> deviceIds) =>
      caller.callServerEndpoint<int>(
        'adminDevice',
        'sendPolicyUpdate',
        {'deviceIds': deviceIds},
      );

  _ida.Future<_inm65q16.DeviceCommandBulkStatus> sendCommand(
    List<int> deviceIds,
    String action,
    String? paramsJson,
  ) => caller.callServerEndpoint<_inm65q16.DeviceCommandBulkStatus>(
    'adminDevice',
    'sendCommand',
    {
      'deviceIds': deviceIds,
      'action': action,
      'paramsJson': paramsJson,
    },
  );

  /// A send is terminal once `pending + sent` reaches zero.
  _ida.Future<_inm65q16.DeviceCommandBulkStatus> bulkStatus(String bulkId) =>
      caller.callServerEndpoint<_inm65q16.DeviceCommandBulkStatus>(
        'adminDevice',
        'bulkStatus',
        {'bulkId': bulkId},
      );

  _ida.Future<List<_i001a4i1.DeviceCommand>> bulkCommands(String bulkId) =>
      caller.callServerEndpoint<List<_i001a4i1.DeviceCommand>>(
        'adminDevice',
        'bulkCommands',
        {'bulkId': bulkId},
      );

  _ida.Future<_idkbjv17.DeviceCommandPage> commands(
    int deviceId,
    _iotoy16a.AdminListRequest request,
  ) => caller.callServerEndpoint<_idkbjv17.DeviceCommandPage>(
    'adminDevice',
    'commands',
    {
      'deviceId': deviceId,
      'request': request,
    },
  );

  _ida.Future<_idkbjv17.DeviceCommandPage> recentCommands(
    _iotoy16a.AdminListRequest request,
  ) => caller.callServerEndpoint<_idkbjv17.DeviceCommandPage>(
    'adminDevice',
    'recentCommands',
    {'request': request},
  );

  _ida.Future<_i2x41jtq.Policy> duplicatePolicy(int deviceId) =>
      caller.callServerEndpoint<_i2x41jtq.Policy>(
        'adminDevice',
        'duplicatePolicy',
        {'deviceId': deviceId},
      );
}

/// Group membership lives in the `device_device_group` pivot (cascades on
/// delete); writes never bump a policy version.
/// {@category Endpoint}
class EndpointAdminDeviceGroup extends _isc.EndpointRef {
  EndpointAdminDeviceGroup(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'adminDeviceGroup';

  /// No device-count sort: it needs a join the query builder cannot express.
  _ida.Future<_itvv1e3b.DeviceGroupPage> list(
    _iotoy16a.AdminListRequest request,
  ) => caller.callServerEndpoint<_itvv1e3b.DeviceGroupPage>(
    'adminDeviceGroup',
    'list',
    {'request': request},
  );

  _ida.Future<_ijw86xpg.DeviceGroup> get(int id) =>
      caller.callServerEndpoint<_ijw86xpg.DeviceGroup>(
        'adminDeviceGroup',
        'get',
        {'id': id},
      );

  _ida.Future<_ijw86xpg.DeviceGroup> create(
    _ijw86xpg.DeviceGroup deviceGroup,
  ) => caller.callServerEndpoint<_ijw86xpg.DeviceGroup>(
    'adminDeviceGroup',
    'create',
    {'deviceGroup': deviceGroup},
  );

  _ida.Future<_ijw86xpg.DeviceGroup> update(
    _ijw86xpg.DeviceGroup deviceGroup,
  ) => caller.callServerEndpoint<_ijw86xpg.DeviceGroup>(
    'adminDeviceGroup',
    'update',
    {'deviceGroup': deviceGroup},
  );

  /// Deleting a group clears `groupId` on devices via the `SetNull` relation.
  _ida.Future<int> delete(List<int> deviceGroupIds) =>
      caller.callServerEndpoint<int>(
        'adminDeviceGroup',
        'delete',
        {'deviceGroupIds': deviceGroupIds},
      );
}

/// {@category Endpoint}
class EndpointAdminDeviceLog extends _isc.EndpointRef {
  EndpointAdminDeviceLog(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'adminDeviceLog';

  _ida.Future<_i075mhxc.DeviceLogPage> list(
    _iuxpvtnr.AdminDeviceLogListRequest request,
  ) => caller.callServerEndpoint<_i075mhxc.DeviceLogPage>(
    'adminDeviceLog',
    'list',
    {'request': request},
  );

  _ida.Future<_i5ee539x.DeviceLogRow> get(int id) =>
      caller.callServerEndpoint<_i5ee539x.DeviceLogRow>(
        'adminDeviceLog',
        'get',
        {'id': id},
      );

  _ida.Future<_id6xyz4c.DeviceLog> create(_id6xyz4c.DeviceLog log) =>
      caller.callServerEndpoint<_id6xyz4c.DeviceLog>(
        'adminDeviceLog',
        'create',
        {'log': log},
      );

  _ida.Future<int> delete(List<int> logIds) => caller.callServerEndpoint<int>(
    'adminDeviceLog',
    'delete',
    {'logIds': logIds},
  );

  _ida.Future<_i0axnghi.DeviceLogStats> stats() =>
      caller.callServerEndpoint<_i0axnghi.DeviceLogStats>(
        'adminDeviceLog',
        'stats',
        {},
      );

  /// [period] is `24` hours, or `7` and `30` days.
  _ida.Future<List<_ijgatwl3.DeviceLogLevelSlice>> levelDistribution(
    String period,
  ) => caller.callServerEndpoint<List<_ijgatwl3.DeviceLogLevelSlice>>(
    'adminDeviceLog',
    'levelDistribution',
    {'period': period},
  );

  /// [period] is `24` hours, or `7` and `30` days.
  _ida.Future<_ii8v9or1.DeviceLogTrend> trend(String period) =>
      caller.callServerEndpoint<_ii8v9or1.DeviceLogTrend>(
        'adminDeviceLog',
        'trend',
        {'period': period},
      );

  /// Exports every matching row, not just the current page.
  _ida.Future<_idt.ByteData> export(
    _iuxpvtnr.AdminDeviceLogListRequest request,
  ) => caller.callServerEndpoint<_idt.ByteData>(
    'adminDeviceLog',
    'export',
    {'request': request},
  );
}

/// Sent messages are immutable: no update, only list/create/view/delete.
/// {@category Endpoint}
class EndpointAdminDeviceNotification extends _isc.EndpointRef {
  EndpointAdminDeviceNotification(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'adminDeviceNotification';

  _ida.Future<_ina9wh29.DeviceNotificationPage> list(
    _iotoy16a.AdminListRequest request,
  ) => caller.callServerEndpoint<_ina9wh29.DeviceNotificationPage>(
    'adminDeviceNotification',
    'list',
    {'request': request},
  );

  _ida.Future<_ie2lwq2y.DeviceNotification> get(int id) =>
      caller.callServerEndpoint<_ie2lwq2y.DeviceNotification>(
        'adminDeviceNotification',
        'get',
        {'id': id},
      );

  _ida.Future<List<_igielq3j.DeviceNotificationDeliveryRow>> deliveries(
    int id,
  ) => caller.callServerEndpoint<List<_igielq3j.DeviceNotificationDeliveryRow>>(
    'adminDeviceNotification',
    'deliveries',
    {'id': id},
  );

  _ida.Future<_iy7z1xzx.AdminDeviceNotificationCreateResponse> create(
    _i4pee3j5.AdminDeviceNotificationCreateRequest request,
  ) => caller
      .callServerEndpoint<_iy7z1xzx.AdminDeviceNotificationCreateResponse>(
        'adminDeviceNotification',
        'create',
        {'request': request},
      );

  _ida.Future<int> delete(List<int> notificationIds) =>
      caller.callServerEndpoint<int>(
        'adminDeviceNotification',
        'delete',
        {'notificationIds': notificationIds},
      );
}

/// {@category Endpoint}
class EndpointAdminDeviceSync extends _isc.EndpointRef {
  EndpointAdminDeviceSync(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'adminDeviceSync';

  _ida.Future<_ienego1y.DeviceSyncPage> list(
    _iugkxpta.AdminDeviceSyncListRequest request,
  ) => caller.callServerEndpoint<_ienego1y.DeviceSyncPage>(
    'adminDeviceSync',
    'list',
    {'request': request},
  );

  /// Exports every matching row, not just the current page.
  _ida.Future<_idt.ByteData> export(
    _iugkxpta.AdminDeviceSyncListRequest request,
  ) => caller.callServerEndpoint<_idt.ByteData>(
    'adminDeviceSync',
    'export',
    {'request': request},
  );

  _ida.Future<_izayv5t4.DeviceSyncDetail> get(int id) =>
      caller.callServerEndpoint<_izayv5t4.DeviceSyncDetail>(
        'adminDeviceSync',
        'get',
        {'id': id},
      );

  _ida.Future<_i5cll6dk.DeviceApplicationPage> applications(
    int syncId,
    _iotoy16a.AdminListRequest request,
  ) => caller.callServerEndpoint<_i5cll6dk.DeviceApplicationPage>(
    'adminDeviceSync',
    'applications',
    {
      'syncId': syncId,
      'request': request,
    },
  );
}

/// {@category Endpoint}
class EndpointAdminFile extends _isc.EndpointRef {
  EndpointAdminFile(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'adminFile';

  /// No display-name sort: it needs `COALESCE(custom_name, name)`, which the
  /// query builder cannot express.
  _ida.Future<_iwb1rs8m.FilePage> list(_ii8zkkz6.FileListRequest request) =>
      caller.callServerEndpoint<_iwb1rs8m.FilePage>(
        'adminFile',
        'list',
        {'request': request},
      );

  _ida.Future<_imf89v3x.FileAsset> get(int fileId) =>
      caller.callServerEndpoint<_imf89v3x.FileAsset>(
        'adminFile',
        'get',
        {'fileId': fileId},
      );

  _ida.Future<List<int>> groupIds(int fileId) =>
      caller.callServerEndpoint<List<int>>(
        'adminFile',
        'groupIds',
        {'fileId': fileId},
      );

  /// Fetched in one call for the visible rows, avoiding a query per row.
  _ida.Future<List<_ivpkm2mv.FileGroupMember>> groupMembersForFiles(
    List<int> fileIds,
  ) => caller.callServerEndpoint<List<_ivpkm2mv.FileGroupMember>>(
    'adminFile',
    'groupMembersForFiles',
    {'fileIds': fileIds},
  );

  /// Private files get a ten-minute signed URL named after the file; null when
  /// the file or its object is unreadable.
  _ida.Future<String?> downloadUrl(int fileId) =>
      caller.callServerEndpoint<String?>(
        'adminFile',
        'downloadUrl',
        {'fileId': fileId},
      );

  _ida.Future<_imf89v3x.FileAsset> create(_imf89v3x.FileAsset file) =>
      caller.callServerEndpoint<_imf89v3x.FileAsset>(
        'adminFile',
        'create',
        {'file': file},
      );

  _ida.Future<_imf89v3x.FileAsset> update(_imf89v3x.FileAsset file) =>
      caller.callServerEndpoint<_imf89v3x.FileAsset>(
        'adminFile',
        'update',
        {'file': file},
      );

  /// Deletes files, their bytes and the policies shipping them.
  _ida.Future<int> delete(List<int> fileIds) => caller.callServerEndpoint<int>(
    'adminFile',
    'delete',
    {'fileIds': fileIds},
  );

  _ida.Future<int> assignGroups(
    List<int> fileIds,
    List<int> fileGroupIds,
  ) => caller.callServerEndpoint<int>(
    'adminFile',
    'assignGroups',
    {
      'fileIds': fileIds,
      'fileGroupIds': fileGroupIds,
    },
  );

  _ida.Future<_ikfp951m.AdminFileUploadResponse> uploadFile(
    _icvb5aok.AdminFileUploadRequest request,
  ) => caller.callServerEndpoint<_ikfp951m.AdminFileUploadResponse>(
    'adminFile',
    'uploadFile',
    {'request': request},
  );
}

/// {@category Endpoint}
class EndpointAdminFileGroup extends _isc.EndpointRef {
  EndpointAdminFileGroup(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'adminFileGroup';

  _ida.Future<_iu6c0tg9.FileGroupPage> list(
    _iotoy16a.AdminListRequest request,
  ) => caller.callServerEndpoint<_iu6c0tg9.FileGroupPage>(
    'adminFileGroup',
    'list',
    {'request': request},
  );

  _ida.Future<_i0vpywrl.FileGroup> get(int id) =>
      caller.callServerEndpoint<_i0vpywrl.FileGroup>(
        'adminFileGroup',
        'get',
        {'id': id},
      );

  _ida.Future<List<int>> fileIds(int fileGroupId) =>
      caller.callServerEndpoint<List<int>>(
        'adminFileGroup',
        'fileIds',
        {'fileGroupId': fileGroupId},
      );

  _ida.Future<_i0vpywrl.FileGroup> create(_i0vpywrl.FileGroup fileGroup) =>
      caller.callServerEndpoint<_i0vpywrl.FileGroup>(
        'adminFileGroup',
        'create',
        {'fileGroup': fileGroup},
      );

  _ida.Future<_i0vpywrl.FileGroup> update(_i0vpywrl.FileGroup fileGroup) =>
      caller.callServerEndpoint<_i0vpywrl.FileGroup>(
        'adminFileGroup',
        'update',
        {'fileGroup': fileGroup},
      );

  _ida.Future<int> delete(List<int> fileGroupIds) =>
      caller.callServerEndpoint<int>(
        'adminFileGroup',
        'delete',
        {'fileGroupIds': fileGroupIds},
      );

  _ida.Future<int> assignFiles(
    int fileGroupId,
    List<int> fileIds,
  ) => caller.callServerEndpoint<int>(
    'adminFileGroup',
    'assignFiles',
    {
      'fileGroupId': fileGroupId,
      'fileIds': fileIds,
    },
  );
}

/// {@category Endpoint}
class EndpointAdminNotification extends _isc.EndpointRef {
  EndpointAdminNotification(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'adminNotification';

  _ida.Future<_ib5g3yc9.AdminNotificationPage> list(
    _iotoy16a.AdminListRequest request,
  ) => caller.callServerEndpoint<_ib5g3yc9.AdminNotificationPage>(
    'adminNotification',
    'list',
    {'request': request},
  );

  _ida.Future<int> unreadCount() => caller.callServerEndpoint<int>(
    'adminNotification',
    'unreadCount',
    {},
  );

  /// Notifications owned by another user are silently skipped.
  _ida.Future<int> markRead(List<int> ids) => caller.callServerEndpoint<int>(
    'adminNotification',
    'markRead',
    {'ids': ids},
  );

  _ida.Future<int> markAllRead() => caller.callServerEndpoint<int>(
    'adminNotification',
    'markAllRead',
    {},
  );
}

/// {@category Endpoint}
class EndpointAdminPolicy extends _isc.EndpointRef {
  EndpointAdminPolicy(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'adminPolicy';

  _ida.Future<_in46iyup.PolicyPage> list(_i72oj68w.PolicyListRequest request) =>
      caller.callServerEndpoint<_in46iyup.PolicyPage>(
        'adminPolicy',
        'list',
        {'request': request},
      );

  _ida.Future<_idt.ByteData> export(_i72oj68w.PolicyListRequest request) =>
      caller.callServerEndpoint<_idt.ByteData>(
        'adminPolicy',
        'export',
        {'request': request},
      );

  _ida.Future<int> sendToDevices(int policyId) =>
      caller.callServerEndpoint<int>(
        'adminPolicy',
        'sendToDevices',
        {'policyId': policyId},
      );

  _ida.Future<_i2x41jtq.Policy> get(int id) =>
      caller.callServerEndpoint<_i2x41jtq.Policy>(
        'adminPolicy',
        'get',
        {'id': id},
      );

  _ida.Future<_i2x41jtq.Policy> create(_i2x41jtq.Policy policy) =>
      caller.callServerEndpoint<_i2x41jtq.Policy>(
        'adminPolicy',
        'create',
        {'policy': policy},
      );

  _ida.Future<_i2x41jtq.Policy> update(_i2x41jtq.Policy policy) =>
      caller.callServerEndpoint<_i2x41jtq.Policy>(
        'adminPolicy',
        'update',
        {'policy': policy},
      );

  _ida.Future<void> delete(int id) => caller.callServerEndpoint<void>(
    'adminPolicy',
    'delete',
    {'id': id},
  );

  /// Saving invalidates both the previous and the new policy via [SettingService].
  _ida.Future<void> setDefault(int policyId) => caller.callServerEndpoint<void>(
    'adminPolicy',
    'setDefault',
    {'policyId': policyId},
  );

  _ida.Future<_i2x41jtq.Policy> duplicate(
    int id, {
    String? newName,
  }) => caller.callServerEndpoint<_i2x41jtq.Policy>(
    'adminPolicy',
    'duplicate',
    {
      'id': id,
      'newName': newName,
    },
  );

  _ida.Future<String> preview(int id) => caller.callServerEndpoint<String>(
    'adminPolicy',
    'preview',
    {'id': id},
  );

  _ida.Future<List<_ixu9efec.PolicyApplication>> applications(int policyId) =>
      caller.callServerEndpoint<List<_ixu9efec.PolicyApplication>>(
        'adminPolicy',
        'applications',
        {'policyId': policyId},
      );

  _ida.Future<List<_if9818ly.PolicyFile>> files(int policyId) =>
      caller.callServerEndpoint<List<_if9818ly.PolicyFile>>(
        'adminPolicy',
        'files',
        {'policyId': policyId},
      );

  _ida.Future<List<_i5kzc7q6.PolicyCertificate>> certificates(int policyId) =>
      caller.callServerEndpoint<List<_i5kzc7q6.PolicyCertificate>>(
        'adminPolicy',
        'certificates',
        {'policyId': policyId},
      );

  _ida.Future<_ixu9efec.PolicyApplication> attachApplication(
    _ixu9efec.PolicyApplication entry,
  ) => caller.callServerEndpoint<_ixu9efec.PolicyApplication>(
    'adminPolicy',
    'attachApplication',
    {'entry': entry},
  );

  _ida.Future<_ixu9efec.PolicyApplication> updateApplication(
    _ixu9efec.PolicyApplication entry,
  ) => caller.callServerEndpoint<_ixu9efec.PolicyApplication>(
    'adminPolicy',
    'updateApplication',
    {'entry': entry},
  );

  _ida.Future<void> detachApplication(int id) =>
      caller.callServerEndpoint<void>(
        'adminPolicy',
        'detachApplication',
        {'id': id},
      );

  _ida.Future<void> reorderApplications(
    int policyId,
    List<int> entryIds,
  ) => caller.callServerEndpoint<void>(
    'adminPolicy',
    'reorderApplications',
    {
      'policyId': policyId,
      'entryIds': entryIds,
    },
  );

  /// Upserts on the `(policyId, fileId)` unique index; a blind insert would raise
  /// a raw Postgres violation.
  _ida.Future<_if9818ly.PolicyFile> attachFile(_if9818ly.PolicyFile entry) =>
      caller.callServerEndpoint<_if9818ly.PolicyFile>(
        'adminPolicy',
        'attachFile',
        {'entry': entry},
      );

  _ida.Future<_if9818ly.PolicyFile> updateFile(_if9818ly.PolicyFile entry) =>
      caller.callServerEndpoint<_if9818ly.PolicyFile>(
        'adminPolicy',
        'updateFile',
        {'entry': entry},
      );

  _ida.Future<void> detachFile(int id) => caller.callServerEndpoint<void>(
    'adminPolicy',
    'detachFile',
    {'id': id},
  );

  _ida.Future<_i5kzc7q6.PolicyCertificate> attachCertificate(
    _i5kzc7q6.PolicyCertificate entry,
  ) => caller.callServerEndpoint<_i5kzc7q6.PolicyCertificate>(
    'adminPolicy',
    'attachCertificate',
    {'entry': entry},
  );

  _ida.Future<_i5kzc7q6.PolicyCertificate> updateCertificate(
    _i5kzc7q6.PolicyCertificate entry,
  ) => caller.callServerEndpoint<_i5kzc7q6.PolicyCertificate>(
    'adminPolicy',
    'updateCertificate',
    {'entry': entry},
  );

  _ida.Future<void> detachCertificate(int id) =>
      caller.callServerEndpoint<void>(
        'adminPolicy',
        'detachCertificate',
        {'id': id},
      );
}

/// {@category Endpoint}
class EndpointAdminProvisioningProfile extends _isc.EndpointRef {
  EndpointAdminProvisioningProfile(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'adminProvisioningProfile';

  _ida.Future<_ia0jvsvu.ProvisioningProfilePage> list(
    _iotoy16a.AdminListRequest request,
  ) => caller.callServerEndpoint<_ia0jvsvu.ProvisioningProfilePage>(
    'adminProvisioningProfile',
    'list',
    {'request': request},
  );

  _ida.Future<_i5ip6bji.ProvisioningProfile> get(int id) =>
      caller.callServerEndpoint<_i5ip6bji.ProvisioningProfile>(
        'adminProvisioningProfile',
        'get',
        {'id': id},
      );

  _ida.Future<String> defaultConfig() => caller.callServerEndpoint<String>(
    'adminProvisioningProfile',
    'defaultConfig',
    {},
  );

  _ida.Future<_i5ip6bji.ProvisioningProfile> create(
    _i5ip6bji.ProvisioningProfile profile,
  ) => caller.callServerEndpoint<_i5ip6bji.ProvisioningProfile>(
    'adminProvisioningProfile',
    'create',
    {'profile': profile},
  );

  _ida.Future<_i5ip6bji.ProvisioningProfile> update(
    _i5ip6bji.ProvisioningProfile profile,
  ) => caller.callServerEndpoint<_i5ip6bji.ProvisioningProfile>(
    'adminProvisioningProfile',
    'update',
    {'profile': profile},
  );

  _ida.Future<int> delete(List<int> profileIds) =>
      caller.callServerEndpoint<int>(
        'adminProvisioningProfile',
        'delete',
        {'profileIds': profileIds},
      );
}

/// {@category Endpoint}
class EndpointAdminSettings extends _isc.EndpointRef {
  EndpointAdminSettings(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'adminSettings';

  _ida.Future<_i0qnb0xz.SettingsFormState> get() =>
      caller.callServerEndpoint<_i0qnb0xz.SettingsFormState>(
        'adminSettings',
        'get',
        {},
      );

  _ida.Future<String?> getMdmApkUrl() => caller.callServerEndpoint<String?>(
    'adminSettings',
    'getMdmApkUrl',
    {},
  );

  _ida.Future<void> save(_i0qnb0xz.SettingsFormState state) =>
      caller.callServerEndpoint<void>(
        'adminSettings',
        'save',
        {'state': state},
      );

  /// Null when no timezone has been set.
  _ida.Future<String?> getTimezone() => caller.callServerEndpoint<String?>(
    'adminSettings',
    'getTimezone',
    {},
  );

  /// Kept out of the settings form, which never writes this secret.
  _ida.Future<String> getEnrollmentKey() => caller.callServerEndpoint<String>(
    'adminSettings',
    'getEnrollmentKey',
    {},
  );

  /// Registered devices keep working; only new enrollments with the old key are
  /// rejected.
  _ida.Future<String> rotateEnrollmentKey() =>
      caller.callServerEndpoint<String>(
        'adminSettings',
        'rotateEnrollmentKey',
        {},
      );

  _ida.Future<List<_ibzn59jo.SmtpTestNotice>> sendSmtpTestMail(
    _i0qnb0xz.SettingsFormState state,
    String? recipient,
  ) => caller.callServerEndpoint<List<_ibzn59jo.SmtpTestNotice>>(
    'adminSettings',
    'sendSmtpTestMail',
    {
      'state': state,
      'recipient': recipient,
    },
  );
}

/// The storage path is always derived server-side from the purpose; the client
/// cannot choose where a file lands.
/// {@category Endpoint}
class EndpointAdminUpload extends _isc.EndpointRef {
  EndpointAdminUpload(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'adminUpload';

  /// [disk] (`private` or `public`, default `private`) overrides storage for the
  /// `file` purpose only.
  _ida.Future<_is9v76kn.AdminUploadDescription> getUploadDescription(
    String purpose,
    String fileName,
    int? sizeBytes, {
    String? disk,
  }) => caller.callServerEndpoint<_is9v76kn.AdminUploadDescription>(
    'adminUpload',
    'getUploadDescription',
    {
      'purpose': purpose,
      'fileName': fileName,
      'sizeBytes': sizeBytes,
      'disk': disk,
    },
  );

  /// Only panel-managed folders are accepted, so a forged path cannot be probed.
  _ida.Future<bool> verifyUpload(
    String storageId,
    String path,
  ) => caller.callServerEndpoint<bool>(
    'adminUpload',
    'verifyUpload',
    {
      'storageId': storageId,
      'path': path,
    },
  );

  /// SHA-256 of a stored upload, or null when the storage keeps none.
  _ida.Future<String?> fileChecksum(
    String storageId,
    String path,
  ) => caller.callServerEndpoint<String?>(
    'adminUpload',
    'fileChecksum',
    {
      'storageId': storageId,
      'path': path,
    },
  );

  /// Private-only areas get a short-lived signed URL; null for unmanaged paths or
  /// missing files.
  _ida.Future<String?> publicDownloadUrl(String path) =>
      caller.callServerEndpoint<String?>(
        'adminUpload',
        'publicDownloadUrl',
        {'path': path},
      );
}

/// A panel user spans an auth user, an auth profile, an email account and an
/// [AdminProfile]; writes go through the auth module so the four stay in step.
/// {@category Endpoint}
class EndpointAdminUser extends _isc.EndpointRef {
  EndpointAdminUser(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'adminUser';

  _ida.Future<_iqj1i8oi.AdminUserPage> list(
    _iotoy16a.AdminListRequest request,
  ) => caller.callServerEndpoint<_iqj1i8oi.AdminUserPage>(
    'adminUser',
    'list',
    {'request': request},
  );

  _ida.Future<_iqofvu41.AdminUserRow> get(_isc.UuidValue authUserId) =>
      caller.callServerEndpoint<_iqofvu41.AdminUserRow>(
        'adminUser',
        'get',
        {'authUserId': authUserId},
      );

  _ida.Future<_iqofvu41.AdminUserRow> create(
    _iykzrnoy.AdminUserCreateRequest request,
  ) => caller.callServerEndpoint<_iqofvu41.AdminUserRow>(
    'adminUser',
    'create',
    {'request': request},
  );

  _ida.Future<_iqofvu41.AdminUserRow> update(
    _ipk345zj.AdminUserUpdateRequest request,
  ) => caller.callServerEndpoint<_iqofvu41.AdminUserRow>(
    'adminUser',
    'update',
    {'request': request},
  );

  /// [AdminProfile] is removed first; the rest cascades with the auth user.
  _ida.Future<int> delete(List<_isc.UuidValue> authUserIds) =>
      caller.callServerEndpoint<int>(
        'adminUser',
        'delete',
        {'authUserIds': authUserIds},
      );
}

/// {@category Endpoint}
class EndpointDevice extends _isc.EndpointRef {
  EndpointDevice(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'device';

  /// Requires the global enrollment key ([EnrollmentKeyService]); a missing or
  /// wrong key throws [DeviceEnrollmentRejectedException]. Oversized fields
  /// throw [DeviceRequestInvalidException]. The plaintext token is returned
  /// only here; the database keeps its SHA-256.
  _ida.Future<_inc4d0tr.DeviceRegisterResponse> register(
    _inc4d0tr.DeviceRegisterRequest request,
  ) => caller.callServerEndpoint<_inc4d0tr.DeviceRegisterResponse>(
    'device',
    'register',
    {'request': request},
  );

  /// The agent authenticates with the [token] returned by [register] and keeps
  /// the stream open. While it is open the device is tracked in
  /// [DeviceConnectionRegistry] so commands can be pushed over the websocket.
  /// Inbound `heartbeat`/`ack` messages refresh [Device.lastSeenAt].
  _ida.Stream<_inc4d0tr.DeviceStreamMessage> connect(
    String token,
    _ida.Stream<_inc4d0tr.DeviceStreamMessage> inbound,
  ) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_inc4d0tr.DeviceStreamMessage>,
        _inc4d0tr.DeviceStreamMessage
      >(
        'device',
        'connect',
        {'token': token},
        {'inbound': inbound},
      );

  _ida.Future<_inc4d0tr.DeviceConfigResponse> config(
    _inc4d0tr.DeviceConfigRequest request,
  ) => caller.callServerEndpoint<_inc4d0tr.DeviceConfigResponse>(
    'device',
    'config',
    {'request': request},
  );

  _ida.Future<_inc4d0tr.DeviceSyncResponse> sync(
    _inc4d0tr.DeviceSyncRequest request,
  ) => caller.callServerEndpoint<_inc4d0tr.DeviceSyncResponse>(
    'device',
    'sync',
    {'request': request},
  );

  _ida.Future<bool> report(_inc4d0tr.DeviceReportRequest request) =>
      caller.callServerEndpoint<bool>(
        'device',
        'report',
        {'request': request},
      );

  _ida.Future<int> log(_inc4d0tr.DeviceLogRequest request) =>
      caller.callServerEndpoint<int>(
        'device',
        'log',
        {'request': request},
      );

  /// Policy assignment is the server's job: the panel assigns `Device.policyId`
  /// when it sends the `policy_change` command. This RPC writes nothing: it
  /// returns `true` only when the requested policy is already the device's, so a
  /// device cannot move itself to another policy.
  _ida.Future<bool> policyChange(_inc4d0tr.DevicePolicyChangeRequest request) =>
      caller.callServerEndpoint<bool>(
        'device',
        'policyChange',
        {'request': request},
      );

  _ida.Future<bool> passwordCheck(
    _inc4d0tr.DevicePasswordCheckRequest request,
  ) => caller.callServerEndpoint<bool>(
    'device',
    'passwordCheck',
    {'request': request},
  );

  _ida.Future<bool> notificationAck(
    _inc4d0tr.DeviceNotificationAckRequest request,
  ) => caller.callServerEndpoint<bool>(
    'device',
    'notificationAck',
    {'request': request},
  );

  _ida.Future<_inc4d0tr.DeviceFileUploadResponse> uploadFile(
    _inc4d0tr.DeviceFileUploadRequest request,
  ) => caller.callServerEndpoint<_inc4d0tr.DeviceFileUploadResponse>(
    'device',
    'uploadFile',
    {'request': request},
  );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_core = _iacc.Caller(client);
    serverpod_auth_idp = _iaic.Caller(client);
    wonkru_core = _inc4d0tr.Caller(client);
  }

  late final _iacc.Caller serverpod_auth_core;

  late final _iaic.Caller serverpod_auth_idp;

  late final _inc4d0tr.Caller wonkru_core;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    adminActivity = EndpointAdminActivity(this);
    adminApplication = EndpointAdminApplication(this);
    adminAuth = EndpointAdminAuth(this);
    adminCertificate = EndpointAdminCertificate(this);
    adminDashboard = EndpointAdminDashboard(this);
    adminDevice = EndpointAdminDevice(this);
    adminDeviceGroup = EndpointAdminDeviceGroup(this);
    adminDeviceLog = EndpointAdminDeviceLog(this);
    adminDeviceNotification = EndpointAdminDeviceNotification(this);
    adminDeviceSync = EndpointAdminDeviceSync(this);
    adminFile = EndpointAdminFile(this);
    adminFileGroup = EndpointAdminFileGroup(this);
    adminNotification = EndpointAdminNotification(this);
    adminPolicy = EndpointAdminPolicy(this);
    adminProvisioningProfile = EndpointAdminProvisioningProfile(this);
    adminSettings = EndpointAdminSettings(this);
    adminUpload = EndpointAdminUpload(this);
    adminUser = EndpointAdminUser(this);
    device = EndpointDevice(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointAdminActivity adminActivity;

  late final EndpointAdminApplication adminApplication;

  late final EndpointAdminAuth adminAuth;

  late final EndpointAdminCertificate adminCertificate;

  late final EndpointAdminDashboard adminDashboard;

  late final EndpointAdminDevice adminDevice;

  late final EndpointAdminDeviceGroup adminDeviceGroup;

  late final EndpointAdminDeviceLog adminDeviceLog;

  late final EndpointAdminDeviceNotification adminDeviceNotification;

  late final EndpointAdminDeviceSync adminDeviceSync;

  late final EndpointAdminFile adminFile;

  late final EndpointAdminFileGroup adminFileGroup;

  late final EndpointAdminNotification adminNotification;

  late final EndpointAdminPolicy adminPolicy;

  late final EndpointAdminProvisioningProfile adminProvisioningProfile;

  late final EndpointAdminSettings adminSettings;

  late final EndpointAdminUpload adminUpload;

  late final EndpointAdminUser adminUser;

  late final EndpointDevice device;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'adminActivity': adminActivity,
    'adminApplication': adminApplication,
    'adminAuth': adminAuth,
    'adminCertificate': adminCertificate,
    'adminDashboard': adminDashboard,
    'adminDevice': adminDevice,
    'adminDeviceGroup': adminDeviceGroup,
    'adminDeviceLog': adminDeviceLog,
    'adminDeviceNotification': adminDeviceNotification,
    'adminDeviceSync': adminDeviceSync,
    'adminFile': adminFile,
    'adminFileGroup': adminFileGroup,
    'adminNotification': adminNotification,
    'adminPolicy': adminPolicy,
    'adminProvisioningProfile': adminProvisioningProfile,
    'adminSettings': adminSettings,
    'adminUpload': adminUpload,
    'adminUser': adminUser,
    'device': device,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_core': modules.serverpod_auth_core,
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'wonkru_core': modules.wonkru_core,
  };
}
