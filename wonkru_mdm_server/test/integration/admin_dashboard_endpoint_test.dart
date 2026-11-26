import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/service/dashboard_service.dart';
import 'package:wonkru_mdm_server/src/service/setting_service.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given AdminDashboardEndpoint', (sessionBuilder, endpoints) {
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

    var deviceSequence = 0;

    Future<Device> createDevice(
      Session session, {
      DateTime? lastSeenAt,
      int? batteryLevel,
      int? totalStorageBytes,
      int? freeStorageBytes,
      bool isLauncherMode = false,
      bool isRooted = false,
      String? manufacturer,
      String? model,
      String? androidVersion,
    }) {
      deviceSequence += 1;

      return Device.db.insertRow(
        session,
        Device(
          code: 'DEV$deviceSequence',
          uuid: 'uuid-$deviceSequence',
          lastSeenAt: lastSeenAt,
          batteryLevel: batteryLevel,
          totalStorageBytes: totalStorageBytes,
          freeStorageBytes: freeStorageBytes,
          isLauncherMode: isLauncherMode,
          isRooted: isRooted,
          manufacturer: manufacturer,
          model: model,
          androidVersion: androidVersion,
        ),
      );
    }

    group('deviceStats', () {
      test('when devices were seen at different times then they are counted '
          'against the offline timeout.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final now = DateTime.now().toUtc();

        await createDevice(session, lastSeenAt: now);
        await createDevice(
          session,
          lastSeenAt: now.subtract(const Duration(minutes: 10)),
        );
        await createDevice(session);

        final stats = await endpoints.adminDashboard.deviceStats(adminBuilder);

        expect(stats.totalDevices, 3);
        expect(stats.onlineDevices, 1);
        expect(stats.offlineDevices, 2);
        expect(stats.onlineMinutes, 5);
      });

      test('when devices sit on either side of the online threshold then '
          'only the fresher one is online.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final now = DateTime.now().toUtc();
        // Default threshold is 5 minutes: seen 4:30 ago is online, 5:30 ago is
        // not. This test breaks if the threshold shifts to 4 or 6 minutes.
        await createDevice(
          session,
          lastSeenAt: now.subtract(const Duration(minutes: 4, seconds: 30)),
        );
        await createDevice(
          session,
          lastSeenAt: now.subtract(const Duration(minutes: 5, seconds: 30)),
        );

        final stats = await endpoints.adminDashboard.deviceStats(adminBuilder);

        expect(stats.onlineDevices, 1);
        expect(stats.offlineDevices, 1);
      });

      test('when the offline timeout is raised then a quieter device counts '
          'as online.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        await SettingService.save(session, 'offline_timeout', '30');
        await createDevice(
          session,
          lastSeenAt: DateTime.now().toUtc().subtract(
            const Duration(minutes: 10),
          ),
        );

        final stats = await endpoints.adminDashboard.deviceStats(adminBuilder);

        expect(stats.onlineMinutes, 30);
        expect(stats.onlineDevices, 1);
        expect(stats.offlineDevices, 0);
      });

      test('when no devices exist then every count is zero.', () async {
        await createProfile();

        final stats = await endpoints.adminDashboard.deviceStats(adminBuilder);

        expect(stats.totalDevices, 0);
        expect(stats.onlineDevices, 0);
        expect(stats.offlineDevices, 0);
      });
    });

    group('alertStats', () {
      test('when battery levels are reported then only the low ones are '
          'counted.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        await createDevice(session, batteryLevel: 19);
        await createDevice(session, batteryLevel: 20);
        await createDevice(session);

        final stats = await endpoints.adminDashboard.alertStats(adminBuilder);

        expect(stats.criticalBatteryDevices, 1);
      });

      test('when storage is reported then only devices below ten percent are '
          'counted.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        await createDevice(
          session,
          totalStorageBytes: 1000,
          freeStorageBytes: 99,
        );
        await createDevice(
          session,
          totalStorageBytes: 1000,
          freeStorageBytes: 100,
        );
        await createDevice(
          session,
          totalStorageBytes: 0,
          freeStorageBytes: 0,
        );
        await createDevice(session, totalStorageBytes: 1000);

        final stats = await endpoints.adminDashboard.alertStats(adminBuilder);

        expect(stats.criticalStorageDevices, 1);
      });

      test('when devices run the launcher or are rooted then they are '
          'counted.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        await createDevice(session, isLauncherMode: true, isRooted: true);
        await createDevice(session, isLauncherMode: true);

        final stats = await endpoints.adminDashboard.alertStats(adminBuilder);

        expect(stats.launcherModeDevices, 2);
        expect(stats.rootedDevices, 1);
      });
    });

    group('deviceDistribution', () {
      test('when devices share a manufacturer then the busiest slice comes '
          'first.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        await createDevice(session, manufacturer: 'samsung');
        await createDevice(session, manufacturer: 'samsung');
        await createDevice(session, manufacturer: 'samsung');
        await createDevice(session, manufacturer: 'xiaomi');
        await createDevice(session, manufacturer: 'xiomi');
        await createDevice(session, manufacturer: 'xiomi');
        await createDevice(session);

        final chart = await endpoints.adminDashboard.deviceDistribution(
          adminBuilder,
          'manufacturer',
        );

        expect(chart.labels, ['samsung', 'xiomi', 'xiaomi']);
        expect(chart.values, [3, 2, 1]);
        expect(chart.colors, hasLength(3));
        expect(chart.colors!.first, DashboardService.distributionPalette.first);
      });

      test('when the filter changes then the column changes.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        await createDevice(session, model: 'SM-T500', androidVersion: '13');
        await createDevice(session, model: 'SM-T500', androidVersion: '14');

        final chart = await endpoints.adminDashboard.deviceDistribution(
          adminBuilder,
          'android_version',
        );

        expect(chart.labels, ['13', '14']);
        expect(chart.values, [1, 1]);
      });

      test(
        'when the filter is unknown then the manufacturer is used.',
        () async {
          await createProfile();

          final session = sessionBuilder.build();
          await createDevice(
            session,
            manufacturer: 'samsung',
            model: 'SM-T500',
          );

          final chart = await endpoints.adminDashboard.deviceDistribution(
            adminBuilder,
            'nonsense',
          );

          expect(chart.labels, ['samsung']);
        },
      );

      test(
        'when no device carries the column then the chart is empty.',
        () async {
          await createProfile();

          final session = sessionBuilder.build();
          await createDevice(session);

          final chart = await endpoints.adminDashboard.deviceDistribution(
            adminBuilder,
            'model',
          );

          expect(chart.labels, isEmpty);
          expect(chart.values, isEmpty);
          expect(chart.colors, isEmpty);
        },
      );
    });

    group('syncTrend', () {
      test(
        'when a sync arrives today then only the last bucket counts it.',
        () async {
          await createProfile();

          final session = sessionBuilder.build();
          final device = await createDevice(session);

          await DeviceSync.db.insertRow(
            session,
            DeviceSync(
              deviceId: device.id!,
              collectedAt: DateTime.now().toUtc(),
            ),
          );

          final chart = await endpoints.adminDashboard.syncTrend(adminBuilder);

          expect(chart.labels, hasLength(DashboardService.syncTrendDays + 1));
          expect(chart.values, hasLength(DashboardService.syncTrendDays + 1));
          expect(chart.values.last, 1);
          expect(
            chart.values.take(DashboardService.syncTrendDays),
            everyElement(0),
          );
          expect(chart.labels.last, _dayLabel(DateTime.now().toUtc()));
          expect(chart.colors, isNull);
        },
      );

      test('when syncs sit on either side of the window start then only the '
          'one inside lands in the oldest bucket.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final device = await createDevice(session);
        final now = DateTime.now().toUtc();
        final windowStart = DateTime.utc(
          now.year,
          now.month,
          now.day,
        ).subtract(const Duration(days: DashboardService.syncTrendDays));

        for (final moment in [
          windowStart.add(const Duration(minutes: 1)),
          windowStart.subtract(const Duration(minutes: 1)),
        ]) {
          await DeviceSync.db.insertRow(
            session,
            DeviceSync(
              deviceId: device.id!,
              collectedAt: moment,
              createdAt: moment,
            ),
          );
        }

        final chart = await endpoints.adminDashboard.syncTrend(adminBuilder);

        expect(chart.values, hasLength(DashboardService.syncTrendDays + 1));
        expect(chart.values.first, 1);
        expect(chart.values.skip(1), everyElement(0));
        expect(chart.labels.first, _dayLabel(windowStart));
      });

      test(
        'when a sync is older than the window then it is left out.',
        () async {
          await createProfile();

          final session = sessionBuilder.build();
          final device = await createDevice(session);

          final old = DateTime.now().toUtc().subtract(const Duration(days: 40));

          await DeviceSync.db.insertRow(
            session,
            DeviceSync(deviceId: device.id!, collectedAt: old, createdAt: old),
          );

          final chart = await endpoints.adminDashboard.syncTrend(adminBuilder);

          expect(chart.values, everyElement(0));
        },
      );
    });
  });
}

String _dayLabel(DateTime day) {
  final dayOfMonth = day.day.toString().padLeft(2, '0');
  final month = day.month.toString().padLeft(2, '0');

  return '$dayOfMonth $month';
}
