import 'dart:async';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:wonkru_core_server/wonkru_core_server.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';

import '../support/settings_form_fixture.dart';
import 'support/admin_fixture.dart';
import 'test_tools/serverpod_test_tools.dart';

/// Calls **every** panel method found through the dispatcher with unauthorized
/// sessions.
///
/// `requiredScopes` only checks the JWT scope, which stays in the token until
/// the next login. A disabled admin, a deleted profile or a session that has
/// not passed 2FA is therefore only stopped by the `requireAdmin` call inside
/// the method. Removing that call turns this test red, and new methods are
/// covered automatically.
///
/// Parameters are generated from their type by [_sample]. An unrecognized type
/// deliberately fails the test: a new request model must add its sample too.
void main() {
  /// Methods intentionally callable without a session.
  const openMethods = {
    'adminAuth.me',
    'adminAuth.bootstrap',
    'adminAuth.login',
  };

  /// Methods that must work before 2FA verification (the code is the proof).
  const twoFactorExempt = {
    'adminAuth.me',
    'adminAuth.bootstrap',
    'adminAuth.login',
    'adminAuth.verifyTotp',
    'adminAuth.disableTotp',
  };

  withServerpod('Given every admin endpoint method', (
    sessionBuilder,
    endpoints,
  ) {
    Map<String, MethodConnector> adminMethods() {
      final dispatch = sessionBuilder.build().server.endpoints;
      return {
        for (final connector in dispatch.connectors.values.where(
          (c) => c.name.startsWith('admin'),
        ))
          for (final method in connector.methodConnectors.values)
            if (method is MethodConnector)
              '${connector.name}.${method.name}': method,
      };
    }

    Future<Object?> invoke(
      String name,
      MethodConnector method,
      TestSessionBuilder builder,
    ) {
      final params = {
        for (final entry in method.params.entries)
          entry.key: entry.value.nullable
              ? null
              : _sample(entry.value.type, '$name(${entry.key})'),
      };
      return method.call(builder.build(), params);
    }

    /// Calls every method with the [builderFor] session and returns
    /// `"name: what happened"` for each method not rejected with [reason].
    Future<List<String>> violations({
      required Set<String> skip,
      required AuthenticationFailureReason reason,
      required Future<TestSessionBuilder> Function() builderFor,
    }) async {
      final found = <String>[];
      for (final MapEntry(key: name, value: method) in adminMethods().entries) {
        if (skip.contains(name)) continue;
        try {
          await invoke(name, method, await builderFor());
          found.add('$name: ran');
        } on NotAuthorizedException catch (e) {
          final actual = e.reason;
          if (actual != reason) found.add('$name: $actual');
        } catch (e) {
          found.add('$name: before authorization ${e.runtimeType} ($e)');
        }
      }
      return found;
    }

    test('the panel has no stream method and the dispatcher is read', () {
      final dispatch = sessionBuilder.build().server.endpoints;
      final streams = [
        for (final connector in dispatch.connectors.values.where(
          (c) => c.name.startsWith('admin'),
        ))
          for (final method in connector.methodConnectors.values)
            if (method is! MethodConnector) '${connector.name}.${method.name}',
      ];
      expect(streams, isEmpty, reason: 'stream methods are out of scope for this test');
      expect(adminMethods().length, greaterThan(100));
    });

    test('a sessionless call is rejected on every method', () async {
      expect(
        await violations(
          skip: openMethods,
          reason: AuthenticationFailureReason.unauthenticated,
          builderFor: () async => sessionBuilder,
        ),
        isEmpty,
      );
    });

    test('a session with the admin scope but no profile is rejected', () async {
      expect(
        await violations(
          skip: openMethods,
          reason: AuthenticationFailureReason.insufficientAccess,
          builderFor: () async =>
              adminSessionFor(sessionBuilder, nextTestUserId()),
        ),
        isEmpty,
      );
    });

    test('a session with the admin scope but a disabled profile is rejected', () async {
      final disabled = await createAdmin(
        sessionBuilder.build(),
        sessionBuilder,
        status: AdminAccountStatus.disabled,
      );
      expect(
        await violations(
          skip: openMethods,
          reason: AuthenticationFailureReason.insufficientAccess,
          builderFor: () async => disabled.builder,
        ),
        isEmpty,
      );
    });

    test('rejected when 2FA is enabled but unverified in this session', () async {
      final session = sessionBuilder.build();
      final admin = await createAdmin(session, sessionBuilder);
      await AdminProfile.db.updateRow(
        session,
        admin.profile
          ..totpSecret = 'encrypted-secret'
          ..recoveryCodes = '[]',
      );
      expect(
        await violations(
          skip: twoFactorExempt,
          reason: AuthenticationFailureReason.insufficientAccess,
          builderFor: () async => adminSessionFor(
            sessionBuilder,
            admin.userId,
            authId: 'unverified-session',
          ),
        ),
        isEmpty,
      );
    });
  });
}

Object _sample(Type type, String where) {
  final samples = <Type, Object Function()>{
    int: () => 1,
    String: () => 'sample',
    bool: () => false,
    UuidValue: () => UuidValue.fromString(
      '00000000-0000-4000-8000-00000000abcd',
    ),
    ByteData: () => ByteData(0),
    List<int>: () => <int>[1],
    List<UuidValue>: () => [
      UuidValue.fromString('00000000-0000-4000-8000-00000000abcd'),
    ],
    AdminListRequest: AdminListRequest.new,
    AdminActivityListRequest: AdminActivityListRequest.new,
    DeviceListRequest: DeviceListRequest.new,
    ApplicationListRequest: ApplicationListRequest.new,
    PolicyListRequest: PolicyListRequest.new,
    FileListRequest: FileListRequest.new,
    AdminDeviceSyncListRequest: AdminDeviceSyncListRequest.new,
    AdminDeviceLogListRequest: AdminDeviceLogListRequest.new,
    SettingsFormState: validSettingsForm,
    ProvisioningProfile: () => ProvisioningProfile(name: 'p', config: '{}'),
    Policy: () => Policy(id: 1, name: 'p'),
    PolicyFile: () => PolicyFile(
      policyId: 1,
      fileId: 1,
      usageType: FileOperationType.values.first,
    ),
    PolicyCertificate: () => PolicyCertificate(policyId: 1, certificateId: 1),
    PolicyApplication: () => PolicyApplication(
      policyId: 1,
      applicationId: 1,
      action: PolicyApplicationAction.values.first,
    ),
    FileGroup: () => FileGroup(id: 1, name: 'g'),
    FileAsset: () => FileAsset(id: 1, name: 'f', filePath: 'f', sizeBytes: 1),
    DeviceGroup: () => DeviceGroup(id: 1, name: 'g'),
    Certificate: () => Certificate(
      id: 1,
      name: 'c',
      certificateType: CertificateType.values.first,
      certificateData: '',
      format: CertificateFormat.values.first,
    ),
    Application: () => Application(id: 1, packageName: 'a.b', appName: 'a'),
    ApplicationVersion: () => ApplicationVersion(
      id: 1,
      applicationId: 1,
      versionName: '1',
      versionCode: 1,
    ),
    AdminUserCreateRequest: () => AdminUserCreateRequest(
      email: 'new@example.com',
      password: 'password-123',
      status: AdminAccountStatus.active,
      blocked: false,
    ),
    AdminUserUpdateRequest: () => AdminUserUpdateRequest(
      authUserId: UuidValue.fromString('00000000-0000-4000-8000-00000000abcd'),
      email: 'x@example.com',
      status: AdminAccountStatus.active,
      blocked: false,
    ),
    AdminDeviceUpdateRequest: () => AdminDeviceUpdateRequest(deviceId: 1),
    AdminFileUploadRequest: () =>
        AdminFileUploadRequest(fileName: 'a.txt', byteData: ByteData(0)),
    AdminCertificateUploadRequest: () =>
        AdminCertificateUploadRequest(fileName: 'a.p12', byteData: ByteData(0)),
    AdminApplicationVersionUploadRequest: () =>
        AdminApplicationVersionUploadRequest(
          applicationId: 1,
          fileName: 'a.apk',
          byteData: ByteData(0),
          versionName: '1',
          versionCode: 1,
        ),
    AdminDeviceNotificationCreateRequest: () =>
        AdminDeviceNotificationCreateRequest(
          title: 't',
          message: 'm',
          type: 'normal',
          deviceIds: const [1],
        ),
    DeviceLog: () => DeviceLog(deviceId: 1, message: 'm'),
  };
  final factory = samples[type];
  if (factory == null) {
    fail('$where: no sample for $type; add one to _sample.');
  }
  return factory();
}
