import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/endpoints/admin/admin_device_sync_endpoint.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/service/device_sync_service.dart';

import 'support/matchers.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given AdminDeviceSyncEndpoint', (sessionBuilder, endpoints) {
    const adminUserId = '11111111-1111-4111-8111-111111111111';

    final adminBuilder = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        adminUserId,
        {Scope('admin')},
      ),
    );

    Future<void> createProfile() async {
      final session = sessionBuilder.build();
      await AdminProfile.db.insertRow(
        session,
        AdminProfile(
          userId: UuidValue.fromString(adminUserId),
          status: AdminAccountStatus.active,
        ),
      );
    }

    Future<Policy> createPolicy(Session session, String name) {
      return Policy.db.insertRow(session, Policy(name: name));
    }

    Future<Device> createDevice(
      Session session, {
      required String code,
      String? name,
      int? policyId,
      int? policyVersion,
      String? brand,
      String? androidVersion,
      int? batteryLevel,
    }) {
      return Device.db.insertRow(
        session,
        Device(
          code: code,
          uuid: 'uuid-$code',
          name: name,
          policyId: policyId,
          policyVersion: policyVersion,
          brand: brand,
          androidVersion: androidVersion,
          batteryLevel: batteryLevel,
        ),
      );
    }

    Future<DeviceSync> createSync(
      Session session, {
      required int deviceId,
      String? syncType,
      DateTime? collectedAt,
      String? appsInfo,
      String? deviceInfo,
      String? batteryInfo,
    }) {
      return DeviceSync.db.insertRow(
        session,
        DeviceSync(
          deviceId: deviceId,
          collectedAt: collectedAt ?? DateTime.now().toUtc(),
          syncType: syncType,
          appsInfo: appsInfo,
          deviceInfo: deviceInfo,
          batteryInfo: batteryInfo,
        ),
      );
    }

    Future<DeviceApplication> createApplication(
      Session session, {
      required int deviceId,
      required String appName,
      required String packageName,
      String? versionName,
      int? versionCode,
      bool isSystemApp = false,
    }) {
      return DeviceApplication.db.insertRow(
        session,
        DeviceApplication(
          deviceId: deviceId,
          appName: appName,
          packageName: packageName,
          versionName: versionName,
          versionCode: versionCode,
          isSystemApp: isSystemApp,
        ),
      );
    }

    group('list', () {
      test('when a snapshot exists then the device, policy and app count '
          'columns are resolved.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final policy = await createPolicy(session, 'Warehouse policy');
        final device = await createDevice(
          session,
          code: 'DEV001',
          name: 'Warehouse tablet',
          policyId: policy.id,
          policyVersion: 4,
          brand: 'samsung',
          androidVersion: '13',
          batteryLevel: 42,
        );
        await createSync(
          session,
          deviceId: device.id!,
          syncType: 'full',
          appsInfo: jsonEncode({'totalInstalled': 12}),
        );

        final page = await endpoints.adminDeviceSync.list(
          adminBuilder,
          AdminDeviceSyncListRequest(),
        );

        final row = page.items.single;
        expect(page.total, 1);
        expect(row.deviceCode, 'DEV001');
        expect(row.deviceName, 'Warehouse tablet');
        expect(row.policyName, 'Warehouse policy');
        expect(row.policyVersion, 4);
        expect(row.brand, 'samsung');
        expect(row.androidVersion, '13');
        expect(row.batteryLevel, 42);
        expect(row.appsCount, 12);
      });

      test('when the snapshot has no payload then the app count is '
          'zero.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final device = await createDevice(session, code: 'DEV001');
        await createSync(session, deviceId: device.id!);

        final page = await endpoints.adminDeviceSync.list(
          adminBuilder,
          AdminDeviceSyncListRequest(),
        );

        expect(page.items.single.appsCount, 0);
        expect(page.items.single.policyName, isNull);
      });

      test(
        'when several snapshots exist then the newest comes first.',
        () async {
          await createProfile();

          final session = sessionBuilder.build();
          final device = await createDevice(session, code: 'DEV001');
          final base = DateTime.now().toUtc();

          await createSync(
            session,
            deviceId: device.id!,
            syncType: 'older',
            collectedAt: base.subtract(const Duration(hours: 2)),
          );
          await createSync(
            session,
            deviceId: device.id!,
            syncType: 'newest',
            collectedAt: base,
          );

          final page = await endpoints.adminDeviceSync.list(
            adminBuilder,
            AdminDeviceSyncListRequest(),
          );

          expect(
            page.items.map((row) => row.deviceSync.syncType),
            ['newest', 'older'],
          );
        },
      );

      test('when a device filter is given then only its snapshots are '
          'returned.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final first = await createDevice(session, code: 'DEV001');
        final second = await createDevice(session, code: 'DEV002');

        await createSync(session, deviceId: first.id!);
        await createSync(session, deviceId: second.id!);

        final page = await endpoints.adminDeviceSync.list(
          adminBuilder,
          AdminDeviceSyncListRequest(deviceId: second.id),
        );

        expect(page.total, 1);
        expect(page.items.single.deviceCode, 'DEV002');
      });

      test('when a search is given then the device code is matched.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final first = await createDevice(session, code: 'ALPHA01');
        final second = await createDevice(session, code: 'BRAVO02');

        await createSync(session, deviceId: first.id!);
        await createSync(session, deviceId: second.id!);

        final page = await endpoints.adminDeviceSync.list(
          adminBuilder,
          AdminDeviceSyncListRequest(search: 'BRAVO'),
        );

        expect(page.total, 1);
        expect(page.items.single.deviceCode, 'BRAVO02');
      });

      test('when perPage is above the maximum then it is clamped.', () async {
        await createProfile();

        final page = await endpoints.adminDeviceSync.list(
          adminBuilder,
          AdminDeviceSyncListRequest(perPage: 100000),
        );

        expect(page.perPage, AdminDeviceSyncEndpoint.maxPerPage);
      });

      test('when a collected-at range is given then only snapshots in it '
          'are returned.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final device = await createDevice(session, code: 'DEV001');
        final base = DateTime.now().toUtc();

        await createSync(
          session,
          deviceId: device.id!,
          syncType: 'inside',
          collectedAt: base,
        );
        await createSync(
          session,
          deviceId: device.id!,
          syncType: 'too-old',
          collectedAt: base.subtract(const Duration(days: 10)),
        );
        await createSync(
          session,
          deviceId: device.id!,
          syncType: 'too-new',
          collectedAt: base.add(const Duration(days: 10)),
        );

        final page = await endpoints.adminDeviceSync.list(
          adminBuilder,
          AdminDeviceSyncListRequest(
            from: base.subtract(const Duration(days: 1)),
            to: base.add(const Duration(days: 1)),
          ),
        );

        expect(page.total, 1);
        expect(page.items.single.deviceSync.syncType, 'inside');
      });
    });

    group('export', () {
      test('when the export is asked for then the columns follow the '
          'exporter.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final policy = await createPolicy(session, 'Warehouse policy');
        final device = await createDevice(
          session,
          code: 'DEV001',
          name: 'Warehouse tablet',
          policyId: policy.id,
          androidVersion: '13',
          batteryLevel: 42,
        );
        final sync = await createSync(
          session,
          deviceId: device.id!,
          appsInfo: jsonEncode({'totalInstalled': 7}),
        );

        final bytes = await endpoints.adminDeviceSync.export(
          adminBuilder,
          AdminDeviceSyncListRequest(),
        );
        final lines = utf8
            .decode(bytes.buffer.asUint8List())
            .trim()
            .split('\n');

        expect(lines, hasLength(2));
        expect(lines.first, DeviceSyncService.exportHeaders.join(','));
        // Each value must be in its own column: contains('7') would also match a 7 in an id or date.
        final row = Map.fromIterables(
          DeviceSyncService.exportHeaders,
          lines.last.split(','),
        );
        expect(row, {
          'id': '${sync.id}',
          'device_code': 'DEV001',
          'device_name': 'Warehouse tablet',
          'collected_at': matches(
            RegExp(r'^\d{2}\.\d{2}\.\d{4} \d{2}:\d{2}$'),
          ),
          'battery_level': '42',
          'android_version': '13',
          'policy_name': 'Warehouse policy',
          'apps_count': '7',
        });
      });

      test('when a field carries a separator then it is quoted.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final device = await createDevice(
          session,
          code: 'DEV001',
          name: 'Warehouse, tablet',
        );
        await createSync(session, deviceId: device.id!);

        final bytes = await endpoints.adminDeviceSync.export(
          adminBuilder,
          AdminDeviceSyncListRequest(),
        );
        final lines = utf8
            .decode(bytes.buffer.asUint8List())
            .trim()
            .split('\n');

        expect(lines.last, contains('"Warehouse, tablet"'));
      });

      test('when a device filter is given then only its snapshots are '
          'exported.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final first = await createDevice(session, code: 'DEV001');
        final second = await createDevice(session, code: 'DEV002');
        await createSync(session, deviceId: first.id!);
        await createSync(session, deviceId: second.id!);

        final bytes = await endpoints.adminDeviceSync.export(
          adminBuilder,
          AdminDeviceSyncListRequest(deviceId: second.id),
        );
        final lines = utf8
            .decode(bytes.buffer.asUint8List())
            .trim()
            .split('\n');

        expect(lines, hasLength(2));
        expect(lines.last, contains('DEV002'));
      });
    });

    group('get', () {
      test('when the snapshot exists then its payload is parsed into the '
          'state.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final device = await createDevice(session, code: 'DEV001');
        final sync = await createSync(
          session,
          deviceId: device.id!,
          appsInfo: jsonEncode({'totalInstalled': 7}),
          batteryInfo: jsonEncode({'level': 88, 'state': 'charging'}),
          deviceInfo: jsonEncode({
            'model': 'SM-T500',
            'brand': 'samsung',
            'version': {'release': '13', 'sdkInt': 33},
          }),
        );

        final detail = await endpoints.adminDeviceSync.get(
          adminBuilder,
          sync.id!,
        );

        expect(detail.row.deviceCode, 'DEV001');
        expect(detail.state.model, 'SM-T500');
        expect(detail.state.androidVersion, '13');
        expect(detail.state.sdkInt, 33);
        expect(detail.state.batteryLevel, 88);
        expect(detail.state.batteryState, 'charging');
        expect(detail.state.totalInstalledApps, 7);
      });

      test('when the snapshot does not exist then it is rejected.', () async {
        await createProfile();

        await expectLater(
          endpoints.adminDeviceSync.get(adminBuilder, 987654),
          throwsExceptionWith('Device sync 987654 does not exist.'),
        );
      });
    });

    group('applications', () {
      test('when the device has applications then they come '
          'alphabetically.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final device = await createDevice(session, code: 'DEV001');
        final sync = await createSync(session, deviceId: device.id!);

        await createApplication(
          session,
          deviceId: device.id!,
          appName: 'Zebra',
          packageName: 'com.zebra',
        );
        await createApplication(
          session,
          deviceId: device.id!,
          appName: 'Alpha',
          packageName: 'com.alpha',
          versionName: '1.2.3',
          versionCode: 12,
        );

        final page = await endpoints.adminDeviceSync.applications(
          adminBuilder,
          sync.id!,
          AdminListRequest(),
        );

        expect(page.total, 2);
        expect(page.items.map((app) => app.appName), ['Alpha', 'Zebra']);
      });

      test('when another device has applications then they are not '
          'listed.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final first = await createDevice(session, code: 'DEV001');
        final second = await createDevice(session, code: 'DEV002');
        final sync = await createSync(session, deviceId: first.id!);

        await createApplication(
          session,
          deviceId: first.id!,
          appName: 'Mine',
          packageName: 'com.mine',
        );
        await createApplication(
          session,
          deviceId: second.id!,
          appName: 'Theirs',
          packageName: 'com.theirs',
        );

        final page = await endpoints.adminDeviceSync.applications(
          adminBuilder,
          sync.id!,
          AdminListRequest(),
        );

        expect(page.items.single.appName, 'Mine');
      });

      test('when a search and a sort column are given then both are '
          'applied.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final device = await createDevice(session, code: 'DEV001');
        final sync = await createSync(session, deviceId: device.id!);

        await createApplication(
          session,
          deviceId: device.id!,
          appName: 'Chrome',
          packageName: 'com.chrome',
          versionName: '1.0.0',
        );
        await createApplication(
          session,
          deviceId: device.id!,
          appName: 'Chrome Beta',
          packageName: 'com.chrome.beta',
          versionName: '2.0.0',
        );
        await createApplication(
          session,
          deviceId: device.id!,
          appName: 'Gallery',
          packageName: 'com.gallery',
          versionName: '9.9.9',
        );

        final page = await endpoints.adminDeviceSync.applications(
          adminBuilder,
          sync.id!,
          AdminListRequest(search: 'Chrome', sortBy: 'versionName'),
        );

        expect(page.total, 2);
        expect(page.items.map((app) => app.versionName), ['1.0.0', '2.0.0']);
      });

      test('when the snapshot does not exist then the applications are '
          'rejected.', () async {
        await createProfile();

        await expectLater(
          endpoints.adminDeviceSync.applications(
            adminBuilder,
            987654,
            AdminListRequest(),
          ),
          throwsExceptionWith('Device sync 987654 does not exist.'),
        );
      });
    });
  });
}
