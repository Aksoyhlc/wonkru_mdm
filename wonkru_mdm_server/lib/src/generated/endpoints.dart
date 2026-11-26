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
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'package:wonkru_core_server/wonkru_core_server.dart' as _i3xu12wm;
import 'package:wonkru_mdm_server/src/generated/admin_api/admin_activity_list_request.dart'
    as _ipiyhf09;
import 'package:wonkru_mdm_server/src/generated/admin_api/admin_application_version_upload_request.dart'
    as _ivbxurvq;
import 'package:wonkru_mdm_server/src/generated/admin_api/admin_certificate_upload_request.dart'
    as _izh03dre;
import 'package:wonkru_mdm_server/src/generated/admin_api/admin_device_log_list_request.dart'
    as _i2r3a4ym;
import 'package:wonkru_mdm_server/src/generated/admin_api/admin_device_notification_create_request.dart'
    as _izf533kh;
import 'package:wonkru_mdm_server/src/generated/admin_api/admin_device_sync_list_request.dart'
    as _i984zrr9;
import 'package:wonkru_mdm_server/src/generated/admin_api/admin_device_update_request.dart'
    as _i0vrgf27;
import 'package:wonkru_mdm_server/src/generated/admin_api/admin_file_upload_request.dart'
    as _ivhgylnk;
import 'package:wonkru_mdm_server/src/generated/admin_api/admin_list_request.dart'
    as _iun8px3q;
import 'package:wonkru_mdm_server/src/generated/admin_api/admin_user_create_request.dart'
    as _igdl1q7x;
import 'package:wonkru_mdm_server/src/generated/admin_api/admin_user_update_request.dart'
    as _i5p1f42v;
import 'package:wonkru_mdm_server/src/generated/admin_api/application_list_request.dart'
    as _il7ppouo;
import 'package:wonkru_mdm_server/src/generated/admin_api/device_list_request.dart'
    as _ixpy838w;
import 'package:wonkru_mdm_server/src/generated/admin_api/file_list_request.dart'
    as _im3mpfy1;
import 'package:wonkru_mdm_server/src/generated/admin_api/policy_list_request.dart'
    as _iqv70toq;
import 'package:wonkru_mdm_server/src/generated/admin_api/settings_form_state.dart'
    as _ih6qc3n9;
import 'package:wonkru_mdm_server/src/generated/application.dart' as _i35eig3v;
import 'package:wonkru_mdm_server/src/generated/application_version.dart'
    as _ic9xexs6;
import 'package:wonkru_mdm_server/src/generated/certificate.dart' as _itddulum;
import 'package:wonkru_mdm_server/src/generated/device_group.dart' as _icxjfp0y;
import 'package:wonkru_mdm_server/src/generated/device_log.dart' as _i9dez887;
import 'package:wonkru_mdm_server/src/generated/file_asset.dart' as _is6yrpk8;
import 'package:wonkru_mdm_server/src/generated/file_group.dart' as _ihxn1rh8;
import 'package:wonkru_mdm_server/src/generated/future_calls.dart' as _i5rerwb2;
import 'package:wonkru_mdm_server/src/generated/policy.dart' as _itxiaegj;
import 'package:wonkru_mdm_server/src/generated/policy_application.dart'
    as _isdxdq62;
import 'package:wonkru_mdm_server/src/generated/policy_certificate.dart'
    as _if8k345z;
import 'package:wonkru_mdm_server/src/generated/policy_file.dart' as _icygockk;
import 'package:wonkru_mdm_server/src/generated/provisioning_profile.dart'
    as _irseq64g;
import '../auth/email_idp_endpoint.dart' as _iuc1hd5t;
import '../auth/jwt_refresh_endpoint.dart' as _inwq3ztq;
import '../endpoints/admin/admin_activity_endpoint.dart' as _iqa79f2q;
import '../endpoints/admin/admin_application_endpoint.dart' as _i2txz65b;
import '../endpoints/admin/admin_auth_endpoint.dart' as _iazi0h28;
import '../endpoints/admin/admin_certificate_endpoint.dart' as _icqq9pcl;
import '../endpoints/admin/admin_dashboard_endpoint.dart' as _icp3w19w;
import '../endpoints/admin/admin_device_endpoint.dart' as _ig0gclcz;
import '../endpoints/admin/admin_device_group_endpoint.dart' as _iunk9o1q;
import '../endpoints/admin/admin_device_log_endpoint.dart' as _icph55ao;
import '../endpoints/admin/admin_device_notification_endpoint.dart'
    as _iwao0r1y;
import '../endpoints/admin/admin_device_sync_endpoint.dart' as _iq50owlr;
import '../endpoints/admin/admin_file_endpoint.dart' as _id62v6m9;
import '../endpoints/admin/admin_file_group_endpoint.dart' as _idjh74va;
import '../endpoints/admin/admin_notification_endpoint.dart' as _iqalvzeu;
import '../endpoints/admin/admin_policy_endpoint.dart' as _iaqc6piq;
import '../endpoints/admin/admin_provisioning_profile_endpoint.dart'
    as _i920pv4s;
import '../endpoints/admin/admin_settings_endpoint.dart' as _ijaqwc84;
import '../endpoints/admin/admin_upload_endpoint.dart' as _iq8ac3b5;
import '../endpoints/admin/admin_user_endpoint.dart' as _iub49862;
import '../endpoints/device_endpoint.dart' as _ipl99gaq;
export 'future_calls.dart' show ServerpodFutureCallsGetter;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    initializeOwnEndpoints(server);
    modules['serverpod_auth_core'] = _iacs.Endpoints()
      ..initializeOwnEndpoints(server);
    modules['serverpod_auth_idp'] = _iais.Endpoints()
      ..initializeOwnEndpoints(server);
    modules['wonkru_core'] = _i3xu12wm.Endpoints()
      ..initializeOwnEndpoints(server);
  }

  @override
  void initializeOwnEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'emailIdp': _iuc1hd5t.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _inwq3ztq.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'adminActivity': _iqa79f2q.AdminActivityEndpoint()
        ..initialize(
          server,
          'adminActivity',
          null,
        ),
      'adminApplication': _i2txz65b.AdminApplicationEndpoint()
        ..initialize(
          server,
          'adminApplication',
          null,
        ),
      'adminAuth': _iazi0h28.AdminAuthEndpoint()
        ..initialize(
          server,
          'adminAuth',
          null,
        ),
      'adminCertificate': _icqq9pcl.AdminCertificateEndpoint()
        ..initialize(
          server,
          'adminCertificate',
          null,
        ),
      'adminDashboard': _icp3w19w.AdminDashboardEndpoint()
        ..initialize(
          server,
          'adminDashboard',
          null,
        ),
      'adminDevice': _ig0gclcz.AdminDeviceEndpoint()
        ..initialize(
          server,
          'adminDevice',
          null,
        ),
      'adminDeviceGroup': _iunk9o1q.AdminDeviceGroupEndpoint()
        ..initialize(
          server,
          'adminDeviceGroup',
          null,
        ),
      'adminDeviceLog': _icph55ao.AdminDeviceLogEndpoint()
        ..initialize(
          server,
          'adminDeviceLog',
          null,
        ),
      'adminDeviceNotification': _iwao0r1y.AdminDeviceNotificationEndpoint()
        ..initialize(
          server,
          'adminDeviceNotification',
          null,
        ),
      'adminDeviceSync': _iq50owlr.AdminDeviceSyncEndpoint()
        ..initialize(
          server,
          'adminDeviceSync',
          null,
        ),
      'adminFile': _id62v6m9.AdminFileEndpoint()
        ..initialize(
          server,
          'adminFile',
          null,
        ),
      'adminFileGroup': _idjh74va.AdminFileGroupEndpoint()
        ..initialize(
          server,
          'adminFileGroup',
          null,
        ),
      'adminNotification': _iqalvzeu.AdminNotificationEndpoint()
        ..initialize(
          server,
          'adminNotification',
          null,
        ),
      'adminPolicy': _iaqc6piq.AdminPolicyEndpoint()
        ..initialize(
          server,
          'adminPolicy',
          null,
        ),
      'adminProvisioningProfile': _i920pv4s.AdminProvisioningProfileEndpoint()
        ..initialize(
          server,
          'adminProvisioningProfile',
          null,
        ),
      'adminSettings': _ijaqwc84.AdminSettingsEndpoint()
        ..initialize(
          server,
          'adminSettings',
          null,
        ),
      'adminUpload': _iq8ac3b5.AdminUploadEndpoint()
        ..initialize(
          server,
          'adminUpload',
          null,
        ),
      'adminUser': _iub49862.AdminUserEndpoint()
        ..initialize(
          server,
          'adminUser',
          null,
        ),
      'device': _ipl99gaq.DeviceEndpoint()
        ..initialize(
          server,
          'device',
          null,
        ),
    };
    connectors['emailIdp'] = _is.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint).login(
                    session,
                    email: params['email'],
                    password: params['password'],
                  ),
        ),
        'startRegistration': _is.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _is.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _is.ParameterDescription(
              name: 'accountRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _is.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _is.ParameterDescription(
              name: 'registrationToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _is.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _is.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _is.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _is.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _is.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'newPassword': _is.ParameterDescription(
              name: 'newPassword',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _is.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _is.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _is.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _is.ParameterDescription(
              name: 'refreshToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['jwtRefresh'] as _inwq3ztq.JwtRefreshEndpoint)
                      .refreshAccessToken(
                        session,
                        refreshToken: params['refreshToken'],
                      ),
        ),
      },
    );
    connectors['adminActivity'] = _is.EndpointConnector(
      name: 'adminActivity',
      endpoint: endpoints['adminActivity']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_ipiyhf09.AdminActivityListRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminActivity']
                          as _iqa79f2q.AdminActivityEndpoint)
                      .list(
                        session,
                        params['request'],
                      ),
        ),
        'actions': _is.MethodConnector(
          name: 'actions',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminActivity']
                          as _iqa79f2q.AdminActivityEndpoint)
                      .actions(session),
        ),
      },
    );
    connectors['adminApplication'] = _is.EndpointConnector(
      name: 'adminApplication',
      endpoint: endpoints['adminApplication']!,
      methodConnectors: {
        'listApplications': _is.MethodConnector(
          name: 'listApplications',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_il7ppouo.ApplicationListRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminApplication']
                          as _i2txz65b.AdminApplicationEndpoint)
                      .listApplications(
                        session,
                        params['request'],
                      ),
        ),
        'export': _is.MethodConnector(
          name: 'export',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_il7ppouo.ApplicationListRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminApplication']
                          as _i2txz65b.AdminApplicationEndpoint)
                      .export(
                        session,
                        params['request'],
                      ),
        ),
        'getApplication': _is.MethodConnector(
          name: 'getApplication',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminApplication']
                          as _i2txz65b.AdminApplicationEndpoint)
                      .getApplication(
                        session,
                        params['id'],
                      ),
        ),
        'createApplication': _is.MethodConnector(
          name: 'createApplication',
          params: {
            'application': _is.ParameterDescription(
              name: 'application',
              type: _is.getType<_i35eig3v.Application>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminApplication']
                          as _i2txz65b.AdminApplicationEndpoint)
                      .createApplication(
                        session,
                        params['application'],
                      ),
        ),
        'updateApplication': _is.MethodConnector(
          name: 'updateApplication',
          params: {
            'application': _is.ParameterDescription(
              name: 'application',
              type: _is.getType<_i35eig3v.Application>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminApplication']
                          as _i2txz65b.AdminApplicationEndpoint)
                      .updateApplication(
                        session,
                        params['application'],
                      ),
        ),
        'deleteApplication': _is.MethodConnector(
          name: 'deleteApplication',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminApplication']
                          as _i2txz65b.AdminApplicationEndpoint)
                      .deleteApplication(
                        session,
                        params['id'],
                      ),
        ),
        'deleteApplications': _is.MethodConnector(
          name: 'deleteApplications',
          params: {
            'ids': _is.ParameterDescription(
              name: 'ids',
              type: _is.getType<List<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminApplication']
                          as _i2txz65b.AdminApplicationEndpoint)
                      .deleteApplications(
                        session,
                        params['ids'],
                      ),
        ),
        'listVersions': _is.MethodConnector(
          name: 'listVersions',
          params: {
            'applicationId': _is.ParameterDescription(
              name: 'applicationId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_iun8px3q.AdminListRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminApplication']
                          as _i2txz65b.AdminApplicationEndpoint)
                      .listVersions(
                        session,
                        params['applicationId'],
                        params['request'],
                      ),
        ),
        'getVersion': _is.MethodConnector(
          name: 'getVersion',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminApplication']
                          as _i2txz65b.AdminApplicationEndpoint)
                      .getVersion(
                        session,
                        params['id'],
                      ),
        ),
        'createVersion': _is.MethodConnector(
          name: 'createVersion',
          params: {
            'version': _is.ParameterDescription(
              name: 'version',
              type: _is.getType<_ic9xexs6.ApplicationVersion>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminApplication']
                          as _i2txz65b.AdminApplicationEndpoint)
                      .createVersion(
                        session,
                        params['version'],
                      ),
        ),
        'updateVersion': _is.MethodConnector(
          name: 'updateVersion',
          params: {
            'version': _is.ParameterDescription(
              name: 'version',
              type: _is.getType<_ic9xexs6.ApplicationVersion>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminApplication']
                          as _i2txz65b.AdminApplicationEndpoint)
                      .updateVersion(
                        session,
                        params['version'],
                      ),
        ),
        'deleteVersion': _is.MethodConnector(
          name: 'deleteVersion',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminApplication']
                          as _i2txz65b.AdminApplicationEndpoint)
                      .deleteVersion(
                        session,
                        params['id'],
                      ),
        ),
        'uploadVersion': _is.MethodConnector(
          name: 'uploadVersion',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is
                  .getType<_ivbxurvq.AdminApplicationVersionUploadRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminApplication']
                          as _i2txz65b.AdminApplicationEndpoint)
                      .uploadVersion(
                        session,
                        params['request'],
                      ),
        ),
      },
    );
    connectors['adminAuth'] = _is.EndpointConnector(
      name: 'adminAuth',
      endpoint: endpoints['adminAuth']!,
      methodConnectors: {
        'me': _is.MethodConnector(
          name: 'me',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminAuth'] as _iazi0h28.AdminAuthEndpoint)
                  .me(session),
        ),
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminAuth'] as _iazi0h28.AdminAuthEndpoint).login(
                    session,
                    params['email'],
                    params['password'],
                  ),
        ),
        'bootstrap': _is.MethodConnector(
          name: 'bootstrap',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminAuth'] as _iazi0h28.AdminAuthEndpoint)
                  .bootstrap(
                    session,
                    email: params['email'],
                    password: params['password'],
                    name: params['name'],
                  ),
        ),
        'startTotpSetup': _is.MethodConnector(
          name: 'startTotpSetup',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminAuth'] as _iazi0h28.AdminAuthEndpoint)
                  .startTotpSetup(session),
        ),
        'confirmTotpSetup': _is.MethodConnector(
          name: 'confirmTotpSetup',
          params: {
            'code': _is.ParameterDescription(
              name: 'code',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminAuth'] as _iazi0h28.AdminAuthEndpoint)
                  .confirmTotpSetup(
                    session,
                    params['code'],
                  ),
        ),
        'verifyTotp': _is.MethodConnector(
          name: 'verifyTotp',
          params: {
            'code': _is.ParameterDescription(
              name: 'code',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminAuth'] as _iazi0h28.AdminAuthEndpoint)
                  .verifyTotp(
                    session,
                    params['code'],
                  ),
        ),
        'disableTotp': _is.MethodConnector(
          name: 'disableTotp',
          params: {
            'code': _is.ParameterDescription(
              name: 'code',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminAuth'] as _iazi0h28.AdminAuthEndpoint)
                  .disableTotp(
                    session,
                    params['code'],
                  ),
        ),
        'changePassword': _is.MethodConnector(
          name: 'changePassword',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'newPassword': _is.ParameterDescription(
              name: 'newPassword',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminAuth'] as _iazi0h28.AdminAuthEndpoint)
                  .changePassword(
                    session,
                    params['email'],
                    params['newPassword'],
                  ),
        ),
        'changeEmail': _is.MethodConnector(
          name: 'changeEmail',
          params: {
            'currentEmail': _is.ParameterDescription(
              name: 'currentEmail',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'newEmail': _is.ParameterDescription(
              name: 'newEmail',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminAuth'] as _iazi0h28.AdminAuthEndpoint)
                  .changeEmail(
                    session,
                    params['currentEmail'],
                    params['newEmail'],
                  ),
        ),
      },
    );
    connectors['adminCertificate'] = _is.EndpointConnector(
      name: 'adminCertificate',
      endpoint: endpoints['adminCertificate']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_iun8px3q.AdminListRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminCertificate']
                          as _icqq9pcl.AdminCertificateEndpoint)
                      .list(
                        session,
                        params['request'],
                      ),
        ),
        'get': _is.MethodConnector(
          name: 'get',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminCertificate']
                          as _icqq9pcl.AdminCertificateEndpoint)
                      .get(
                        session,
                        params['id'],
                      ),
        ),
        'parse': _is.MethodConnector(
          name: 'parse',
          params: {
            'certificateData': _is.ParameterDescription(
              name: 'certificateData',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminCertificate']
                          as _icqq9pcl.AdminCertificateEndpoint)
                      .parse(
                        session,
                        params['certificateData'],
                        password: params['password'],
                      ),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'certificate': _is.ParameterDescription(
              name: 'certificate',
              type: _is.getType<_itddulum.Certificate>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminCertificate']
                          as _icqq9pcl.AdminCertificateEndpoint)
                      .create(
                        session,
                        params['certificate'],
                      ),
        ),
        'update': _is.MethodConnector(
          name: 'update',
          params: {
            'certificate': _is.ParameterDescription(
              name: 'certificate',
              type: _is.getType<_itddulum.Certificate>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminCertificate']
                          as _icqq9pcl.AdminCertificateEndpoint)
                      .update(
                        session,
                        params['certificate'],
                      ),
        ),
        'delete': _is.MethodConnector(
          name: 'delete',
          params: {
            'certificateIds': _is.ParameterDescription(
              name: 'certificateIds',
              type: _is.getType<List<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminCertificate']
                          as _icqq9pcl.AdminCertificateEndpoint)
                      .delete(
                        session,
                        params['certificateIds'],
                      ),
        ),
        'uploadFile': _is.MethodConnector(
          name: 'uploadFile',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_izh03dre.AdminCertificateUploadRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminCertificate']
                          as _icqq9pcl.AdminCertificateEndpoint)
                      .uploadFile(
                        session,
                        params['request'],
                      ),
        ),
        'downloadUrl': _is.MethodConnector(
          name: 'downloadUrl',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminCertificate']
                          as _icqq9pcl.AdminCertificateEndpoint)
                      .downloadUrl(
                        session,
                        params['id'],
                      ),
        ),
      },
    );
    connectors['adminDashboard'] = _is.EndpointConnector(
      name: 'adminDashboard',
      endpoint: endpoints['adminDashboard']!,
      methodConnectors: {
        'deviceStats': _is.MethodConnector(
          name: 'deviceStats',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDashboard']
                          as _icp3w19w.AdminDashboardEndpoint)
                      .deviceStats(session),
        ),
        'alertStats': _is.MethodConnector(
          name: 'alertStats',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDashboard']
                          as _icp3w19w.AdminDashboardEndpoint)
                      .alertStats(session),
        ),
        'deviceDistribution': _is.MethodConnector(
          name: 'deviceDistribution',
          params: {
            'filter': _is.ParameterDescription(
              name: 'filter',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDashboard']
                          as _icp3w19w.AdminDashboardEndpoint)
                      .deviceDistribution(
                        session,
                        params['filter'],
                      ),
        ),
        'syncTrend': _is.MethodConnector(
          name: 'syncTrend',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDashboard']
                          as _icp3w19w.AdminDashboardEndpoint)
                      .syncTrend(session),
        ),
      },
    );
    connectors['adminDevice'] = _is.EndpointConnector(
      name: 'adminDevice',
      endpoint: endpoints['adminDevice']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_ixpy838w.DeviceListRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDevice'] as _ig0gclcz.AdminDeviceEndpoint)
                      .list(
                        session,
                        params['request'],
                      ),
        ),
        'export': _is.MethodConnector(
          name: 'export',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_ixpy838w.DeviceListRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDevice'] as _ig0gclcz.AdminDeviceEndpoint)
                      .export(
                        session,
                        params['request'],
                      ),
        ),
        'get': _is.MethodConnector(
          name: 'get',
          params: {
            'deviceId': _is.ParameterDescription(
              name: 'deviceId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDevice'] as _ig0gclcz.AdminDeviceEndpoint)
                      .get(
                        session,
                        params['deviceId'],
                      ),
        ),
        'reportPdf': _is.MethodConnector(
          name: 'reportPdf',
          params: {
            'deviceId': _is.ParameterDescription(
              name: 'deviceId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'locale': _is.ParameterDescription(
              name: 'locale',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDevice'] as _ig0gclcz.AdminDeviceEndpoint)
                      .reportPdf(
                        session,
                        params['deviceId'],
                        params['locale'],
                      ),
        ),
        'stateCache': _is.MethodConnector(
          name: 'stateCache',
          params: {
            'deviceId': _is.ParameterDescription(
              name: 'deviceId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDevice'] as _ig0gclcz.AdminDeviceEndpoint)
                      .stateCache(
                        session,
                        params['deviceId'],
                      ),
        ),
        'groupIds': _is.MethodConnector(
          name: 'groupIds',
          params: {
            'deviceId': _is.ParameterDescription(
              name: 'deviceId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDevice'] as _ig0gclcz.AdminDeviceEndpoint)
                      .groupIds(
                        session,
                        params['deviceId'],
                      ),
        ),
        'applications': _is.MethodConnector(
          name: 'applications',
          params: {
            'deviceId': _is.ParameterDescription(
              name: 'deviceId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDevice'] as _ig0gclcz.AdminDeviceEndpoint)
                      .applications(
                        session,
                        params['deviceId'],
                      ),
        ),
        'reports': _is.MethodConnector(
          name: 'reports',
          params: {
            'deviceId': _is.ParameterDescription(
              name: 'deviceId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDevice'] as _ig0gclcz.AdminDeviceEndpoint)
                      .reports(
                        session,
                        params['deviceId'],
                        limit: params['limit'],
                      ),
        ),
        'update': _is.MethodConnector(
          name: 'update',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_i0vrgf27.AdminDeviceUpdateRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDevice'] as _ig0gclcz.AdminDeviceEndpoint)
                      .update(
                        session,
                        params['request'],
                      ),
        ),
        'delete': _is.MethodConnector(
          name: 'delete',
          params: {
            'deviceIds': _is.ParameterDescription(
              name: 'deviceIds',
              type: _is.getType<List<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDevice'] as _ig0gclcz.AdminDeviceEndpoint)
                      .delete(
                        session,
                        params['deviceIds'],
                      ),
        ),
        'assignPolicy': _is.MethodConnector(
          name: 'assignPolicy',
          params: {
            'deviceIds': _is.ParameterDescription(
              name: 'deviceIds',
              type: _is.getType<List<int>>(),
              nullable: false,
            ),
            'policyId': _is.ParameterDescription(
              name: 'policyId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDevice'] as _ig0gclcz.AdminDeviceEndpoint)
                      .assignPolicy(
                        session,
                        params['deviceIds'],
                        params['policyId'],
                      ),
        ),
        'assignGroups': _is.MethodConnector(
          name: 'assignGroups',
          params: {
            'deviceIds': _is.ParameterDescription(
              name: 'deviceIds',
              type: _is.getType<List<int>>(),
              nullable: false,
            ),
            'groupIds': _is.ParameterDescription(
              name: 'groupIds',
              type: _is.getType<List<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDevice'] as _ig0gclcz.AdminDeviceEndpoint)
                      .assignGroups(
                        session,
                        params['deviceIds'],
                        params['groupIds'],
                      ),
        ),
        'sendPolicyUpdate': _is.MethodConnector(
          name: 'sendPolicyUpdate',
          params: {
            'deviceIds': _is.ParameterDescription(
              name: 'deviceIds',
              type: _is.getType<List<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDevice'] as _ig0gclcz.AdminDeviceEndpoint)
                      .sendPolicyUpdate(
                        session,
                        params['deviceIds'],
                      ),
        ),
        'sendCommand': _is.MethodConnector(
          name: 'sendCommand',
          params: {
            'deviceIds': _is.ParameterDescription(
              name: 'deviceIds',
              type: _is.getType<List<int>>(),
              nullable: false,
            ),
            'action': _is.ParameterDescription(
              name: 'action',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'paramsJson': _is.ParameterDescription(
              name: 'paramsJson',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDevice'] as _ig0gclcz.AdminDeviceEndpoint)
                      .sendCommand(
                        session,
                        params['deviceIds'],
                        params['action'],
                        params['paramsJson'],
                      ),
        ),
        'bulkStatus': _is.MethodConnector(
          name: 'bulkStatus',
          params: {
            'bulkId': _is.ParameterDescription(
              name: 'bulkId',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDevice'] as _ig0gclcz.AdminDeviceEndpoint)
                      .bulkStatus(
                        session,
                        params['bulkId'],
                      ),
        ),
        'bulkCommands': _is.MethodConnector(
          name: 'bulkCommands',
          params: {
            'bulkId': _is.ParameterDescription(
              name: 'bulkId',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDevice'] as _ig0gclcz.AdminDeviceEndpoint)
                      .bulkCommands(
                        session,
                        params['bulkId'],
                      ),
        ),
        'commands': _is.MethodConnector(
          name: 'commands',
          params: {
            'deviceId': _is.ParameterDescription(
              name: 'deviceId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_iun8px3q.AdminListRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDevice'] as _ig0gclcz.AdminDeviceEndpoint)
                      .commands(
                        session,
                        params['deviceId'],
                        params['request'],
                      ),
        ),
        'recentCommands': _is.MethodConnector(
          name: 'recentCommands',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_iun8px3q.AdminListRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDevice'] as _ig0gclcz.AdminDeviceEndpoint)
                      .recentCommands(
                        session,
                        params['request'],
                      ),
        ),
        'duplicatePolicy': _is.MethodConnector(
          name: 'duplicatePolicy',
          params: {
            'deviceId': _is.ParameterDescription(
              name: 'deviceId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDevice'] as _ig0gclcz.AdminDeviceEndpoint)
                      .duplicatePolicy(
                        session,
                        params['deviceId'],
                      ),
        ),
      },
    );
    connectors['adminDeviceGroup'] = _is.EndpointConnector(
      name: 'adminDeviceGroup',
      endpoint: endpoints['adminDeviceGroup']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_iun8px3q.AdminListRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDeviceGroup']
                          as _iunk9o1q.AdminDeviceGroupEndpoint)
                      .list(
                        session,
                        params['request'],
                      ),
        ),
        'get': _is.MethodConnector(
          name: 'get',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDeviceGroup']
                          as _iunk9o1q.AdminDeviceGroupEndpoint)
                      .get(
                        session,
                        params['id'],
                      ),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'deviceGroup': _is.ParameterDescription(
              name: 'deviceGroup',
              type: _is.getType<_icxjfp0y.DeviceGroup>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDeviceGroup']
                          as _iunk9o1q.AdminDeviceGroupEndpoint)
                      .create(
                        session,
                        params['deviceGroup'],
                      ),
        ),
        'update': _is.MethodConnector(
          name: 'update',
          params: {
            'deviceGroup': _is.ParameterDescription(
              name: 'deviceGroup',
              type: _is.getType<_icxjfp0y.DeviceGroup>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDeviceGroup']
                          as _iunk9o1q.AdminDeviceGroupEndpoint)
                      .update(
                        session,
                        params['deviceGroup'],
                      ),
        ),
        'delete': _is.MethodConnector(
          name: 'delete',
          params: {
            'deviceGroupIds': _is.ParameterDescription(
              name: 'deviceGroupIds',
              type: _is.getType<List<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDeviceGroup']
                          as _iunk9o1q.AdminDeviceGroupEndpoint)
                      .delete(
                        session,
                        params['deviceGroupIds'],
                      ),
        ),
      },
    );
    connectors['adminDeviceLog'] = _is.EndpointConnector(
      name: 'adminDeviceLog',
      endpoint: endpoints['adminDeviceLog']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_i2r3a4ym.AdminDeviceLogListRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDeviceLog']
                          as _icph55ao.AdminDeviceLogEndpoint)
                      .list(
                        session,
                        params['request'],
                      ),
        ),
        'get': _is.MethodConnector(
          name: 'get',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDeviceLog']
                          as _icph55ao.AdminDeviceLogEndpoint)
                      .get(
                        session,
                        params['id'],
                      ),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'log': _is.ParameterDescription(
              name: 'log',
              type: _is.getType<_i9dez887.DeviceLog>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDeviceLog']
                          as _icph55ao.AdminDeviceLogEndpoint)
                      .create(
                        session,
                        params['log'],
                      ),
        ),
        'delete': _is.MethodConnector(
          name: 'delete',
          params: {
            'logIds': _is.ParameterDescription(
              name: 'logIds',
              type: _is.getType<List<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDeviceLog']
                          as _icph55ao.AdminDeviceLogEndpoint)
                      .delete(
                        session,
                        params['logIds'],
                      ),
        ),
        'stats': _is.MethodConnector(
          name: 'stats',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDeviceLog']
                          as _icph55ao.AdminDeviceLogEndpoint)
                      .stats(session),
        ),
        'levelDistribution': _is.MethodConnector(
          name: 'levelDistribution',
          params: {
            'period': _is.ParameterDescription(
              name: 'period',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDeviceLog']
                          as _icph55ao.AdminDeviceLogEndpoint)
                      .levelDistribution(
                        session,
                        params['period'],
                      ),
        ),
        'trend': _is.MethodConnector(
          name: 'trend',
          params: {
            'period': _is.ParameterDescription(
              name: 'period',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDeviceLog']
                          as _icph55ao.AdminDeviceLogEndpoint)
                      .trend(
                        session,
                        params['period'],
                      ),
        ),
        'export': _is.MethodConnector(
          name: 'export',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_i2r3a4ym.AdminDeviceLogListRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDeviceLog']
                          as _icph55ao.AdminDeviceLogEndpoint)
                      .export(
                        session,
                        params['request'],
                      ),
        ),
      },
    );
    connectors['adminDeviceNotification'] = _is.EndpointConnector(
      name: 'adminDeviceNotification',
      endpoint: endpoints['adminDeviceNotification']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_iun8px3q.AdminListRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDeviceNotification']
                          as _iwao0r1y.AdminDeviceNotificationEndpoint)
                      .list(
                        session,
                        params['request'],
                      ),
        ),
        'get': _is.MethodConnector(
          name: 'get',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDeviceNotification']
                          as _iwao0r1y.AdminDeviceNotificationEndpoint)
                      .get(
                        session,
                        params['id'],
                      ),
        ),
        'deliveries': _is.MethodConnector(
          name: 'deliveries',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDeviceNotification']
                          as _iwao0r1y.AdminDeviceNotificationEndpoint)
                      .deliveries(
                        session,
                        params['id'],
                      ),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is
                  .getType<_izf533kh.AdminDeviceNotificationCreateRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDeviceNotification']
                          as _iwao0r1y.AdminDeviceNotificationEndpoint)
                      .create(
                        session,
                        params['request'],
                      ),
        ),
        'delete': _is.MethodConnector(
          name: 'delete',
          params: {
            'notificationIds': _is.ParameterDescription(
              name: 'notificationIds',
              type: _is.getType<List<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDeviceNotification']
                          as _iwao0r1y.AdminDeviceNotificationEndpoint)
                      .delete(
                        session,
                        params['notificationIds'],
                      ),
        ),
      },
    );
    connectors['adminDeviceSync'] = _is.EndpointConnector(
      name: 'adminDeviceSync',
      endpoint: endpoints['adminDeviceSync']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_i984zrr9.AdminDeviceSyncListRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDeviceSync']
                          as _iq50owlr.AdminDeviceSyncEndpoint)
                      .list(
                        session,
                        params['request'],
                      ),
        ),
        'export': _is.MethodConnector(
          name: 'export',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_i984zrr9.AdminDeviceSyncListRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDeviceSync']
                          as _iq50owlr.AdminDeviceSyncEndpoint)
                      .export(
                        session,
                        params['request'],
                      ),
        ),
        'get': _is.MethodConnector(
          name: 'get',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDeviceSync']
                          as _iq50owlr.AdminDeviceSyncEndpoint)
                      .get(
                        session,
                        params['id'],
                      ),
        ),
        'applications': _is.MethodConnector(
          name: 'applications',
          params: {
            'syncId': _is.ParameterDescription(
              name: 'syncId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_iun8px3q.AdminListRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminDeviceSync']
                          as _iq50owlr.AdminDeviceSyncEndpoint)
                      .applications(
                        session,
                        params['syncId'],
                        params['request'],
                      ),
        ),
      },
    );
    connectors['adminFile'] = _is.EndpointConnector(
      name: 'adminFile',
      endpoint: endpoints['adminFile']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_im3mpfy1.FileListRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminFile'] as _id62v6m9.AdminFileEndpoint).list(
                    session,
                    params['request'],
                  ),
        ),
        'get': _is.MethodConnector(
          name: 'get',
          params: {
            'fileId': _is.ParameterDescription(
              name: 'fileId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminFile'] as _id62v6m9.AdminFileEndpoint).get(
                    session,
                    params['fileId'],
                  ),
        ),
        'groupIds': _is.MethodConnector(
          name: 'groupIds',
          params: {
            'fileId': _is.ParameterDescription(
              name: 'fileId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminFile'] as _id62v6m9.AdminFileEndpoint)
                  .groupIds(
                    session,
                    params['fileId'],
                  ),
        ),
        'groupMembersForFiles': _is.MethodConnector(
          name: 'groupMembersForFiles',
          params: {
            'fileIds': _is.ParameterDescription(
              name: 'fileIds',
              type: _is.getType<List<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminFile'] as _id62v6m9.AdminFileEndpoint)
                  .groupMembersForFiles(
                    session,
                    params['fileIds'],
                  ),
        ),
        'downloadUrl': _is.MethodConnector(
          name: 'downloadUrl',
          params: {
            'fileId': _is.ParameterDescription(
              name: 'fileId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminFile'] as _id62v6m9.AdminFileEndpoint)
                  .downloadUrl(
                    session,
                    params['fileId'],
                  ),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'file': _is.ParameterDescription(
              name: 'file',
              type: _is.getType<_is6yrpk8.FileAsset>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminFile'] as _id62v6m9.AdminFileEndpoint)
                  .create(
                    session,
                    params['file'],
                  ),
        ),
        'update': _is.MethodConnector(
          name: 'update',
          params: {
            'file': _is.ParameterDescription(
              name: 'file',
              type: _is.getType<_is6yrpk8.FileAsset>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminFile'] as _id62v6m9.AdminFileEndpoint)
                  .update(
                    session,
                    params['file'],
                  ),
        ),
        'delete': _is.MethodConnector(
          name: 'delete',
          params: {
            'fileIds': _is.ParameterDescription(
              name: 'fileIds',
              type: _is.getType<List<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminFile'] as _id62v6m9.AdminFileEndpoint)
                  .delete(
                    session,
                    params['fileIds'],
                  ),
        ),
        'assignGroups': _is.MethodConnector(
          name: 'assignGroups',
          params: {
            'fileIds': _is.ParameterDescription(
              name: 'fileIds',
              type: _is.getType<List<int>>(),
              nullable: false,
            ),
            'fileGroupIds': _is.ParameterDescription(
              name: 'fileGroupIds',
              type: _is.getType<List<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminFile'] as _id62v6m9.AdminFileEndpoint)
                  .assignGroups(
                    session,
                    params['fileIds'],
                    params['fileGroupIds'],
                  ),
        ),
        'uploadFile': _is.MethodConnector(
          name: 'uploadFile',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_ivhgylnk.AdminFileUploadRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminFile'] as _id62v6m9.AdminFileEndpoint)
                  .uploadFile(
                    session,
                    params['request'],
                  ),
        ),
      },
    );
    connectors['adminFileGroup'] = _is.EndpointConnector(
      name: 'adminFileGroup',
      endpoint: endpoints['adminFileGroup']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_iun8px3q.AdminListRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminFileGroup']
                          as _idjh74va.AdminFileGroupEndpoint)
                      .list(
                        session,
                        params['request'],
                      ),
        ),
        'get': _is.MethodConnector(
          name: 'get',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminFileGroup']
                          as _idjh74va.AdminFileGroupEndpoint)
                      .get(
                        session,
                        params['id'],
                      ),
        ),
        'fileIds': _is.MethodConnector(
          name: 'fileIds',
          params: {
            'fileGroupId': _is.ParameterDescription(
              name: 'fileGroupId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminFileGroup']
                          as _idjh74va.AdminFileGroupEndpoint)
                      .fileIds(
                        session,
                        params['fileGroupId'],
                      ),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'fileGroup': _is.ParameterDescription(
              name: 'fileGroup',
              type: _is.getType<_ihxn1rh8.FileGroup>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminFileGroup']
                          as _idjh74va.AdminFileGroupEndpoint)
                      .create(
                        session,
                        params['fileGroup'],
                      ),
        ),
        'update': _is.MethodConnector(
          name: 'update',
          params: {
            'fileGroup': _is.ParameterDescription(
              name: 'fileGroup',
              type: _is.getType<_ihxn1rh8.FileGroup>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminFileGroup']
                          as _idjh74va.AdminFileGroupEndpoint)
                      .update(
                        session,
                        params['fileGroup'],
                      ),
        ),
        'delete': _is.MethodConnector(
          name: 'delete',
          params: {
            'fileGroupIds': _is.ParameterDescription(
              name: 'fileGroupIds',
              type: _is.getType<List<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminFileGroup']
                          as _idjh74va.AdminFileGroupEndpoint)
                      .delete(
                        session,
                        params['fileGroupIds'],
                      ),
        ),
        'assignFiles': _is.MethodConnector(
          name: 'assignFiles',
          params: {
            'fileGroupId': _is.ParameterDescription(
              name: 'fileGroupId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'fileIds': _is.ParameterDescription(
              name: 'fileIds',
              type: _is.getType<List<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminFileGroup']
                          as _idjh74va.AdminFileGroupEndpoint)
                      .assignFiles(
                        session,
                        params['fileGroupId'],
                        params['fileIds'],
                      ),
        ),
      },
    );
    connectors['adminNotification'] = _is.EndpointConnector(
      name: 'adminNotification',
      endpoint: endpoints['adminNotification']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_iun8px3q.AdminListRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminNotification']
                          as _iqalvzeu.AdminNotificationEndpoint)
                      .list(
                        session,
                        params['request'],
                      ),
        ),
        'unreadCount': _is.MethodConnector(
          name: 'unreadCount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminNotification']
                          as _iqalvzeu.AdminNotificationEndpoint)
                      .unreadCount(session),
        ),
        'markRead': _is.MethodConnector(
          name: 'markRead',
          params: {
            'ids': _is.ParameterDescription(
              name: 'ids',
              type: _is.getType<List<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminNotification']
                          as _iqalvzeu.AdminNotificationEndpoint)
                      .markRead(
                        session,
                        params['ids'],
                      ),
        ),
        'markAllRead': _is.MethodConnector(
          name: 'markAllRead',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminNotification']
                          as _iqalvzeu.AdminNotificationEndpoint)
                      .markAllRead(session),
        ),
      },
    );
    connectors['adminPolicy'] = _is.EndpointConnector(
      name: 'adminPolicy',
      endpoint: endpoints['adminPolicy']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_iqv70toq.PolicyListRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminPolicy'] as _iaqc6piq.AdminPolicyEndpoint)
                      .list(
                        session,
                        params['request'],
                      ),
        ),
        'export': _is.MethodConnector(
          name: 'export',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_iqv70toq.PolicyListRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminPolicy'] as _iaqc6piq.AdminPolicyEndpoint)
                      .export(
                        session,
                        params['request'],
                      ),
        ),
        'sendToDevices': _is.MethodConnector(
          name: 'sendToDevices',
          params: {
            'policyId': _is.ParameterDescription(
              name: 'policyId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminPolicy'] as _iaqc6piq.AdminPolicyEndpoint)
                      .sendToDevices(
                        session,
                        params['policyId'],
                      ),
        ),
        'get': _is.MethodConnector(
          name: 'get',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminPolicy'] as _iaqc6piq.AdminPolicyEndpoint)
                      .get(
                        session,
                        params['id'],
                      ),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'policy': _is.ParameterDescription(
              name: 'policy',
              type: _is.getType<_itxiaegj.Policy>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminPolicy'] as _iaqc6piq.AdminPolicyEndpoint)
                      .create(
                        session,
                        params['policy'],
                      ),
        ),
        'update': _is.MethodConnector(
          name: 'update',
          params: {
            'policy': _is.ParameterDescription(
              name: 'policy',
              type: _is.getType<_itxiaegj.Policy>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminPolicy'] as _iaqc6piq.AdminPolicyEndpoint)
                      .update(
                        session,
                        params['policy'],
                      ),
        ),
        'delete': _is.MethodConnector(
          name: 'delete',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminPolicy'] as _iaqc6piq.AdminPolicyEndpoint)
                      .delete(
                        session,
                        params['id'],
                      ),
        ),
        'setDefault': _is.MethodConnector(
          name: 'setDefault',
          params: {
            'policyId': _is.ParameterDescription(
              name: 'policyId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminPolicy'] as _iaqc6piq.AdminPolicyEndpoint)
                      .setDefault(
                        session,
                        params['policyId'],
                      ),
        ),
        'duplicate': _is.MethodConnector(
          name: 'duplicate',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'newName': _is.ParameterDescription(
              name: 'newName',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminPolicy'] as _iaqc6piq.AdminPolicyEndpoint)
                      .duplicate(
                        session,
                        params['id'],
                        newName: params['newName'],
                      ),
        ),
        'preview': _is.MethodConnector(
          name: 'preview',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminPolicy'] as _iaqc6piq.AdminPolicyEndpoint)
                      .preview(
                        session,
                        params['id'],
                      ),
        ),
        'applications': _is.MethodConnector(
          name: 'applications',
          params: {
            'policyId': _is.ParameterDescription(
              name: 'policyId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminPolicy'] as _iaqc6piq.AdminPolicyEndpoint)
                      .applications(
                        session,
                        params['policyId'],
                      ),
        ),
        'files': _is.MethodConnector(
          name: 'files',
          params: {
            'policyId': _is.ParameterDescription(
              name: 'policyId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminPolicy'] as _iaqc6piq.AdminPolicyEndpoint)
                      .files(
                        session,
                        params['policyId'],
                      ),
        ),
        'certificates': _is.MethodConnector(
          name: 'certificates',
          params: {
            'policyId': _is.ParameterDescription(
              name: 'policyId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminPolicy'] as _iaqc6piq.AdminPolicyEndpoint)
                      .certificates(
                        session,
                        params['policyId'],
                      ),
        ),
        'attachApplication': _is.MethodConnector(
          name: 'attachApplication',
          params: {
            'entry': _is.ParameterDescription(
              name: 'entry',
              type: _is.getType<_isdxdq62.PolicyApplication>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminPolicy'] as _iaqc6piq.AdminPolicyEndpoint)
                      .attachApplication(
                        session,
                        params['entry'],
                      ),
        ),
        'updateApplication': _is.MethodConnector(
          name: 'updateApplication',
          params: {
            'entry': _is.ParameterDescription(
              name: 'entry',
              type: _is.getType<_isdxdq62.PolicyApplication>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminPolicy'] as _iaqc6piq.AdminPolicyEndpoint)
                      .updateApplication(
                        session,
                        params['entry'],
                      ),
        ),
        'detachApplication': _is.MethodConnector(
          name: 'detachApplication',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminPolicy'] as _iaqc6piq.AdminPolicyEndpoint)
                      .detachApplication(
                        session,
                        params['id'],
                      ),
        ),
        'reorderApplications': _is.MethodConnector(
          name: 'reorderApplications',
          params: {
            'policyId': _is.ParameterDescription(
              name: 'policyId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'entryIds': _is.ParameterDescription(
              name: 'entryIds',
              type: _is.getType<List<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminPolicy'] as _iaqc6piq.AdminPolicyEndpoint)
                      .reorderApplications(
                        session,
                        params['policyId'],
                        params['entryIds'],
                      ),
        ),
        'attachFile': _is.MethodConnector(
          name: 'attachFile',
          params: {
            'entry': _is.ParameterDescription(
              name: 'entry',
              type: _is.getType<_icygockk.PolicyFile>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminPolicy'] as _iaqc6piq.AdminPolicyEndpoint)
                      .attachFile(
                        session,
                        params['entry'],
                      ),
        ),
        'updateFile': _is.MethodConnector(
          name: 'updateFile',
          params: {
            'entry': _is.ParameterDescription(
              name: 'entry',
              type: _is.getType<_icygockk.PolicyFile>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminPolicy'] as _iaqc6piq.AdminPolicyEndpoint)
                      .updateFile(
                        session,
                        params['entry'],
                      ),
        ),
        'detachFile': _is.MethodConnector(
          name: 'detachFile',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminPolicy'] as _iaqc6piq.AdminPolicyEndpoint)
                      .detachFile(
                        session,
                        params['id'],
                      ),
        ),
        'attachCertificate': _is.MethodConnector(
          name: 'attachCertificate',
          params: {
            'entry': _is.ParameterDescription(
              name: 'entry',
              type: _is.getType<_if8k345z.PolicyCertificate>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminPolicy'] as _iaqc6piq.AdminPolicyEndpoint)
                      .attachCertificate(
                        session,
                        params['entry'],
                      ),
        ),
        'updateCertificate': _is.MethodConnector(
          name: 'updateCertificate',
          params: {
            'entry': _is.ParameterDescription(
              name: 'entry',
              type: _is.getType<_if8k345z.PolicyCertificate>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminPolicy'] as _iaqc6piq.AdminPolicyEndpoint)
                      .updateCertificate(
                        session,
                        params['entry'],
                      ),
        ),
        'detachCertificate': _is.MethodConnector(
          name: 'detachCertificate',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminPolicy'] as _iaqc6piq.AdminPolicyEndpoint)
                      .detachCertificate(
                        session,
                        params['id'],
                      ),
        ),
      },
    );
    connectors['adminProvisioningProfile'] = _is.EndpointConnector(
      name: 'adminProvisioningProfile',
      endpoint: endpoints['adminProvisioningProfile']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_iun8px3q.AdminListRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminProvisioningProfile']
                          as _i920pv4s.AdminProvisioningProfileEndpoint)
                      .list(
                        session,
                        params['request'],
                      ),
        ),
        'get': _is.MethodConnector(
          name: 'get',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminProvisioningProfile']
                          as _i920pv4s.AdminProvisioningProfileEndpoint)
                      .get(
                        session,
                        params['id'],
                      ),
        ),
        'defaultConfig': _is.MethodConnector(
          name: 'defaultConfig',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminProvisioningProfile']
                          as _i920pv4s.AdminProvisioningProfileEndpoint)
                      .defaultConfig(session),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'profile': _is.ParameterDescription(
              name: 'profile',
              type: _is.getType<_irseq64g.ProvisioningProfile>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminProvisioningProfile']
                          as _i920pv4s.AdminProvisioningProfileEndpoint)
                      .create(
                        session,
                        params['profile'],
                      ),
        ),
        'update': _is.MethodConnector(
          name: 'update',
          params: {
            'profile': _is.ParameterDescription(
              name: 'profile',
              type: _is.getType<_irseq64g.ProvisioningProfile>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminProvisioningProfile']
                          as _i920pv4s.AdminProvisioningProfileEndpoint)
                      .update(
                        session,
                        params['profile'],
                      ),
        ),
        'delete': _is.MethodConnector(
          name: 'delete',
          params: {
            'profileIds': _is.ParameterDescription(
              name: 'profileIds',
              type: _is.getType<List<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminProvisioningProfile']
                          as _i920pv4s.AdminProvisioningProfileEndpoint)
                      .delete(
                        session,
                        params['profileIds'],
                      ),
        ),
      },
    );
    connectors['adminSettings'] = _is.EndpointConnector(
      name: 'adminSettings',
      endpoint: endpoints['adminSettings']!,
      methodConnectors: {
        'get': _is.MethodConnector(
          name: 'get',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminSettings']
                          as _ijaqwc84.AdminSettingsEndpoint)
                      .get(session),
        ),
        'getMdmApkUrl': _is.MethodConnector(
          name: 'getMdmApkUrl',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminSettings']
                          as _ijaqwc84.AdminSettingsEndpoint)
                      .getMdmApkUrl(session),
        ),
        'save': _is.MethodConnector(
          name: 'save',
          params: {
            'state': _is.ParameterDescription(
              name: 'state',
              type: _is.getType<_ih6qc3n9.SettingsFormState>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminSettings']
                          as _ijaqwc84.AdminSettingsEndpoint)
                      .save(
                        session,
                        params['state'],
                      ),
        ),
        'getTimezone': _is.MethodConnector(
          name: 'getTimezone',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminSettings']
                          as _ijaqwc84.AdminSettingsEndpoint)
                      .getTimezone(session),
        ),
        'getEnrollmentKey': _is.MethodConnector(
          name: 'getEnrollmentKey',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminSettings']
                          as _ijaqwc84.AdminSettingsEndpoint)
                      .getEnrollmentKey(session),
        ),
        'rotateEnrollmentKey': _is.MethodConnector(
          name: 'rotateEnrollmentKey',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminSettings']
                          as _ijaqwc84.AdminSettingsEndpoint)
                      .rotateEnrollmentKey(session),
        ),
        'sendSmtpTestMail': _is.MethodConnector(
          name: 'sendSmtpTestMail',
          params: {
            'state': _is.ParameterDescription(
              name: 'state',
              type: _is.getType<_ih6qc3n9.SettingsFormState>(),
              nullable: false,
            ),
            'recipient': _is.ParameterDescription(
              name: 'recipient',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminSettings']
                          as _ijaqwc84.AdminSettingsEndpoint)
                      .sendSmtpTestMail(
                        session,
                        params['state'],
                        params['recipient'],
                      ),
        ),
      },
    );
    connectors['adminUpload'] = _is.EndpointConnector(
      name: 'adminUpload',
      endpoint: endpoints['adminUpload']!,
      methodConnectors: {
        'getUploadDescription': _is.MethodConnector(
          name: 'getUploadDescription',
          params: {
            'purpose': _is.ParameterDescription(
              name: 'purpose',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'fileName': _is.ParameterDescription(
              name: 'fileName',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'sizeBytes': _is.ParameterDescription(
              name: 'sizeBytes',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'disk': _is.ParameterDescription(
              name: 'disk',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminUpload'] as _iq8ac3b5.AdminUploadEndpoint)
                      .getUploadDescription(
                        session,
                        params['purpose'],
                        params['fileName'],
                        params['sizeBytes'],
                        disk: params['disk'],
                      ),
        ),
        'verifyUpload': _is.MethodConnector(
          name: 'verifyUpload',
          params: {
            'storageId': _is.ParameterDescription(
              name: 'storageId',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'path': _is.ParameterDescription(
              name: 'path',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminUpload'] as _iq8ac3b5.AdminUploadEndpoint)
                      .verifyUpload(
                        session,
                        params['storageId'],
                        params['path'],
                      ),
        ),
        'fileChecksum': _is.MethodConnector(
          name: 'fileChecksum',
          params: {
            'storageId': _is.ParameterDescription(
              name: 'storageId',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'path': _is.ParameterDescription(
              name: 'path',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminUpload'] as _iq8ac3b5.AdminUploadEndpoint)
                      .fileChecksum(
                        session,
                        params['storageId'],
                        params['path'],
                      ),
        ),
        'publicDownloadUrl': _is.MethodConnector(
          name: 'publicDownloadUrl',
          params: {
            'path': _is.ParameterDescription(
              name: 'path',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminUpload'] as _iq8ac3b5.AdminUploadEndpoint)
                      .publicDownloadUrl(
                        session,
                        params['path'],
                      ),
        ),
      },
    );
    connectors['adminUser'] = _is.EndpointConnector(
      name: 'adminUser',
      endpoint: endpoints['adminUser']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_iun8px3q.AdminListRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminUser'] as _iub49862.AdminUserEndpoint).list(
                    session,
                    params['request'],
                  ),
        ),
        'get': _is.MethodConnector(
          name: 'get',
          params: {
            'authUserId': _is.ParameterDescription(
              name: 'authUserId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminUser'] as _iub49862.AdminUserEndpoint).get(
                    session,
                    params['authUserId'],
                  ),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_igdl1q7x.AdminUserCreateRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminUser'] as _iub49862.AdminUserEndpoint)
                  .create(
                    session,
                    params['request'],
                  ),
        ),
        'update': _is.MethodConnector(
          name: 'update',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_i5p1f42v.AdminUserUpdateRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminUser'] as _iub49862.AdminUserEndpoint)
                  .update(
                    session,
                    params['request'],
                  ),
        ),
        'delete': _is.MethodConnector(
          name: 'delete',
          params: {
            'authUserIds': _is.ParameterDescription(
              name: 'authUserIds',
              type: _is.getType<List<_is.UuidValue>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminUser'] as _iub49862.AdminUserEndpoint)
                  .delete(
                    session,
                    params['authUserIds'],
                  ),
        ),
      },
    );
    connectors['device'] = _is.EndpointConnector(
      name: 'device',
      endpoint: endpoints['device']!,
      methodConnectors: {
        'register': _is.MethodConnector(
          name: 'register',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_i3xu12wm.DeviceRegisterRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['device'] as _ipl99gaq.DeviceEndpoint).register(
                    session,
                    params['request'],
                  ),
        ),
        'config': _is.MethodConnector(
          name: 'config',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_i3xu12wm.DeviceConfigRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['device'] as _ipl99gaq.DeviceEndpoint).config(
                    session,
                    params['request'],
                  ),
        ),
        'sync': _is.MethodConnector(
          name: 'sync',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_i3xu12wm.DeviceSyncRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['device'] as _ipl99gaq.DeviceEndpoint).sync(
                session,
                params['request'],
              ),
        ),
        'report': _is.MethodConnector(
          name: 'report',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_i3xu12wm.DeviceReportRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['device'] as _ipl99gaq.DeviceEndpoint).report(
                    session,
                    params['request'],
                  ),
        ),
        'log': _is.MethodConnector(
          name: 'log',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_i3xu12wm.DeviceLogRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['device'] as _ipl99gaq.DeviceEndpoint).log(
                session,
                params['request'],
              ),
        ),
        'policyChange': _is.MethodConnector(
          name: 'policyChange',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_i3xu12wm.DevicePolicyChangeRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['device'] as _ipl99gaq.DeviceEndpoint)
                  .policyChange(
                    session,
                    params['request'],
                  ),
        ),
        'passwordCheck': _is.MethodConnector(
          name: 'passwordCheck',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_i3xu12wm.DevicePasswordCheckRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['device'] as _ipl99gaq.DeviceEndpoint)
                  .passwordCheck(
                    session,
                    params['request'],
                  ),
        ),
        'notificationAck': _is.MethodConnector(
          name: 'notificationAck',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_i3xu12wm.DeviceNotificationAckRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['device'] as _ipl99gaq.DeviceEndpoint)
                  .notificationAck(
                    session,
                    params['request'],
                  ),
        ),
        'uploadFile': _is.MethodConnector(
          name: 'uploadFile',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_i3xu12wm.DeviceFileUploadRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['device'] as _ipl99gaq.DeviceEndpoint).uploadFile(
                    session,
                    params['request'],
                  ),
        ),
        'connect': _is.MethodStreamConnector(
          name: 'connect',
          params: {
            'token': _is.ParameterDescription(
              name: 'token',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          streamParams: {
            'inbound':
                _is.StreamParameterDescription<_i3xu12wm.DeviceStreamMessage>(
                  name: 'inbound',
                  nullable: false,
                ),
          },
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['device'] as _ipl99gaq.DeviceEndpoint).connect(
                session,
                params['token'],
                streamParams['inbound']!.cast<_i3xu12wm.DeviceStreamMessage>(),
              ),
        ),
      },
    );
  }

  @override
  _is.FutureCallDispatch? get futureCalls {
    return _i5rerwb2.FutureCalls();
  }
}
