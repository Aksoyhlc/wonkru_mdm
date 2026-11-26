import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:wonkru_core_server/wonkru_core_server.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'support/device_enrollment.dart';

void main() {
  withServerpod('Given authorization audit', (sessionBuilder, endpoints) {
    // Authenticated but without a panel profile: `requireLogin` lets this
    // session through, so any rejection must come from `requireAdmin`.
    final nonAdminBuilder = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        '33333333-3333-4333-8333-333333333333',
        {Scope('admin')},
      ),
    );

    group('panel endpoints', () {
      /// Both variants fail server-side with `NotAuthorizedException` — the
      /// first from `requireLogin`, the second from
      /// `AdminAuthService.requireAdmin`. The test client maps them to
      /// `unauthenticated` → [ServerpodUnauthenticatedException] and
      /// `insufficientAccess` → [ServerpodInsufficientAccessException].
      void expectDenied(
        String label,
        Future<void> Function() anonymous,
        Future<void> Function() nonAdmin,
      ) {
        test('$label rejects an unauthenticated call', () async {
          await expectLater(
            anonymous(),
            throwsA(isA<ServerpodUnauthenticatedException>()),
          );
        });

        test('$label rejects a session without panel authorization', () async {
          await expectLater(
            nonAdmin(),
            throwsA(isA<ServerpodInsufficientAccessException>()),
          );
        });
      }

      expectDenied(
        'adminDevice.list',
        () => endpoints.adminDevice.list(sessionBuilder, DeviceListRequest()),
        () => endpoints.adminDevice.list(nonAdminBuilder, DeviceListRequest()),
      );

      expectDenied(
        'adminPolicy.list',
        () => endpoints.adminPolicy.list(sessionBuilder, PolicyListRequest()),
        () => endpoints.adminPolicy.list(nonAdminBuilder, PolicyListRequest()),
      );

      expectDenied(
        'adminSettings.get',
        () => endpoints.adminSettings.get(sessionBuilder),
        () => endpoints.adminSettings.get(nonAdminBuilder),
      );

      expectDenied(
        'adminUser.list',
        () => endpoints.adminUser.list(sessionBuilder, AdminListRequest()),
        () => endpoints.adminUser.list(nonAdminBuilder, AdminListRequest()),
      );

      expectDenied(
        'adminDashboard.deviceStats',
        () => endpoints.adminDashboard.deviceStats(sessionBuilder),
        () => endpoints.adminDashboard.deviceStats(nonAdminBuilder),
      );

      expectDenied(
        'adminUpload.getUploadDescription',
        () => endpoints.adminUpload.getUploadDescription(
          sessionBuilder,
          'file',
          'audit.txt',
          null,
        ),
        () => endpoints.adminUpload.getUploadDescription(
          nonAdminBuilder,
          'file',
          'audit.txt',
          null,
        ),
      );
    });

    // Audited in the groups below; the registry test stops a new device RPC
    // from passing unnoticed without being added here.
    final auditedDeviceMethods = <String>{'register', 'connect'};

    group('device endpoints', () {
      late String ownUuid;
      late String foreignToken;

      setUp(() async {
        final own = await endpoints.device.register(
          sessionBuilder,
          await enrolled(sessionBuilder, model: 'audit-owner'),
        );
        final foreign = await endpoints.device.register(
          sessionBuilder,
          await enrolled(sessionBuilder, model: 'audit-foreign'),
        );
        ownUuid = own.uuid;
        foreignToken = foreign.token;
      });

      void expectRejected(
        String label,
        Future<void> Function(String token) call,
      ) {
        auditedDeviceMethods.add(label.substring('device.'.length));
        test('$label rejects with an empty token', () async {
          await expectLater(
            call(''),
            throwsA(isA<DeviceUnauthenticatedException>()),
          );
        });

        // Valid token for another device: the registration is still valid, so
        // this is an identity mismatch, not a re-registration prompt.
        test('$label rejects with a foreign token', () async {
          await expectLater(
            call(foreignToken),
            throwsA(isA<DeviceIdentityMismatchException>()),
          );
        });
      }

      test('device.register does not require a token', () async {
        final registered = await endpoints.device.register(
          sessionBuilder,
          await enrolled(sessionBuilder, model: 'audit-register'),
        );

        expect(registered.uuid, isNotEmpty);
        expect(registered.token, isNotEmpty);
      });

      expectRejected(
        'device.config',
        (token) => endpoints.device.config(
          sessionBuilder,
          DeviceConfigRequest(deviceUuid: ownUuid, token: token),
        ),
      );

      expectRejected(
        'device.sync',
        (token) => endpoints.device.sync(
          sessionBuilder,
          DeviceSyncRequest(
            deviceUuid: ownUuid,
            token: token,
            payload: '{}',
          ),
        ),
      );

      expectRejected(
        'device.report',
        (token) => endpoints.device.report(
          sessionBuilder,
          DeviceReportRequest(
            deviceUuid: ownUuid,
            token: token,
            type: 'audit',
            payload: '{}',
          ),
        ),
      );

      expectRejected(
        'device.log',
        (token) => endpoints.device.log(
          sessionBuilder,
          DeviceLogRequest(
            deviceUuid: ownUuid,
            token: token,
            entries: const <DeviceLogEntry>[],
          ),
        ),
      );

      expectRejected(
        'device.policyChange',
        (token) => endpoints.device.policyChange(
          sessionBuilder,
          DevicePolicyChangeRequest(
            deviceUuid: ownUuid,
            token: token,
            policyId: 1,
          ),
        ),
      );

      expectRejected(
        'device.passwordCheck',
        (token) => endpoints.device.passwordCheck(
          sessionBuilder,
          DevicePasswordCheckRequest(
            deviceUuid: ownUuid,
            token: token,
            password: 'audit',
          ),
        ),
      );

      expectRejected(
        'device.notificationAck',
        (token) => endpoints.device.notificationAck(
          sessionBuilder,
          DeviceNotificationAckRequest(
            deviceUuid: ownUuid,
            token: token,
            notificationUuid: 'audit',
          ),
        ),
      );

      expectRejected(
        'device.uploadFile',
        (token) => endpoints.device.uploadFile(
          sessionBuilder,
          DeviceFileUploadRequest(
            deviceUuid: ownUuid,
            token: token,
            fileName: 'audit.bin',
            byteData: ByteData(0),
          ),
        ),
      );
    });

    group('server registry', () {
      test('the removed policy endpoint is not registered', () {
        final dispatch = sessionBuilder.build().server.endpoints;

        expect(
          dispatch.getConnectorByName('policy'),
          isNull,
          reason: 'The removed PolicyEndpoint must not be registered again.',
        );

        // Guard against a false positive: the live endpoints must still be
        // registered.
        expect(dispatch.getConnectorByName('device'), isNotNull);
        expect(
          dispatch.getConnectorByName('adminPolicy'),
          isNotNull,
          reason: 'The panel policy endpoint must stay up.',
        );
      });

      test('every device RPC is listed in the token audit', () {
        final dispatch = sessionBuilder.build().server.endpoints;
        final methods = dispatch
            .getConnectorByName('device')!
            .methodConnectors
            .keys
            .toSet();

        expect(
          methods.difference(auditedDeviceMethods),
          isEmpty,
          reason:
              'New device endpoints must be tried with an empty/foreign token '
              'in the "device endpoints" group '
              '(connect: device_stream_integrity_test).',
        );
      });

      test('every panel endpoint requires a session', () {
        final dispatch = sessionBuilder.build().server.endpoints;
        final panelConnectors = dispatch.connectors.values.where(
          (connector) =>
              connector.name.startsWith('admin') &&
              connector.name != 'adminAuth',
        );

        expect(panelConnectors, isNotEmpty);
        for (final connector in panelConnectors) {
          expect(
            connector.endpoint.requireLogin,
            isTrue,
            reason: '${connector.name} appears callable without a session.',
          );
        }
      });
    });
  });
}
