import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/endpoints/admin/admin_device_log_endpoint.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/service/device_log_service.dart';

import 'support/matchers.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given AdminDeviceLogEndpoint', (sessionBuilder, endpoints) {
    const adminUserId = '11111111-1111-4111-8111-111111111111';

    const verbose = 0;
    const warning = 3;
    const error = 4;
    const fatal = 5;

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

    Future<Device> createDevice(
      Session session, {
      required String code,
      String? name,
    }) {
      return Device.db.insertRow(
        session,
        Device(code: code, uuid: 'uuid-$code', name: name),
      );
    }

    Future<DeviceLog> createLog(
      Session session, {
      required int deviceId,
      String message = 'Something happened',
      int level = 2,
      DateTime? loggedAt,
      String? tag,
      String? stacktrace,
      String? sessionId,
      String? entryUuid,
    }) {
      return DeviceLog.db.insertRow(
        session,
        DeviceLog(
          deviceId: deviceId,
          message: message,
          level: level,
          loggedAt: loggedAt ?? DateTime.now().toUtc(),
          tag: tag,
          stacktrace: stacktrace,
          sessionId: sessionId,
          entryUuid: entryUuid,
        ),
      );
    }

    group('list', () {
      test('when logs exist then the device label is resolved and the newest '
          'entry comes first.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final device = await createDevice(
          session,
          code: 'DEV001',
          name: 'Warehouse tablet',
        );
        final named = await createDevice(session, code: 'DEV002');
        final base = DateTime.now().toUtc();

        await createLog(
          session,
          deviceId: named.id!,
          message: 'Older',
          loggedAt: base.subtract(const Duration(minutes: 5)),
        );
        await createLog(
          session,
          deviceId: device.id!,
          message: 'Newer',
          loggedAt: base,
        );

        final page = await endpoints.adminDeviceLog.list(
          adminBuilder,
          AdminDeviceLogListRequest(),
        );

        expect(page.total, 2);
        expect(page.items.map((row) => row.log.message), ['Newer', 'Older']);
        expect(page.items.first.deviceLabel, 'Warehouse tablet (DEV001)');
        expect(page.items.last.deviceLabel, 'DEV002');
      });

      test('when a level filter is given then only those levels are '
          'returned.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final device = await createDevice(session, code: 'DEV001');
        final base = DateTime.now().toUtc();

        await createLog(
          session,
          deviceId: device.id!,
          level: warning,
          loggedAt: base.subtract(const Duration(minutes: 2)),
        );
        await createLog(
          session,
          deviceId: device.id!,
          level: error,
          loggedAt: base.subtract(const Duration(minutes: 1)),
        );
        await createLog(
          session,
          deviceId: device.id!,
          level: fatal,
          loggedAt: base,
        );

        final page = await endpoints.adminDeviceLog.list(
          adminBuilder,
          AdminDeviceLogListRequest(levels: [error, fatal]),
        );

        expect(page.total, 2);
        expect(page.items.map((row) => row.log.level), [fatal, error]);
      });

      test('when a device filter is given then only its logs are '
          'returned.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final first = await createDevice(session, code: 'DEV001');
        final second = await createDevice(session, code: 'DEV002');

        await createLog(session, deviceId: first.id!, message: 'First');
        await createLog(session, deviceId: second.id!, message: 'Second');

        final page = await endpoints.adminDeviceLog.list(
          adminBuilder,
          AdminDeviceLogListRequest(deviceId: second.id),
        );

        expect(page.total, 1);
        expect(page.items.single.log.message, 'Second');
      });

      test('when a date range is given then it bounds the logged at '
          'column.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final device = await createDevice(session, code: 'DEV001');
        final now = DateTime.now().toUtc();

        await createLog(
          session,
          deviceId: device.id!,
          message: 'Inside',
          loggedAt: now.subtract(const Duration(hours: 2)),
        );
        await createLog(
          session,
          deviceId: device.id!,
          message: 'Before',
          loggedAt: now.subtract(const Duration(days: 3)),
        );

        final page = await endpoints.adminDeviceLog.list(
          adminBuilder,
          AdminDeviceLogListRequest(
            loggedFrom: now.subtract(const Duration(days: 1)),
            loggedUntil: now,
          ),
        );

        expect(page.total, 1);
        expect(page.items.single.log.message, 'Inside');
      });

      test('when the today period is given then only today is '
          'returned.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final device = await createDevice(session, code: 'DEV001');
        final now = DateTime.now().toUtc();

        await createLog(session, deviceId: device.id!, message: 'Today');
        await createLog(
          session,
          deviceId: device.id!,
          message: 'Two days ago',
          loggedAt: now.subtract(const Duration(days: 2)),
        );

        final page = await endpoints.adminDeviceLog.list(
          adminBuilder,
          AdminDeviceLogListRequest(period: 'today'),
        );

        expect(page.total, 1);
        expect(page.items.single.log.message, 'Today');
      });

      test('when the last 7 days period is given then older entries are '
          'dropped.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final device = await createDevice(session, code: 'DEV001');
        final now = DateTime.now().toUtc();

        await createLog(
          session,
          deviceId: device.id!,
          message: 'Recent',
          loggedAt: now.subtract(const Duration(days: 3)),
        );
        await createLog(
          session,
          deviceId: device.id!,
          message: 'Ancient',
          loggedAt: now.subtract(const Duration(days: 20)),
        );

        final page = await endpoints.adminDeviceLog.list(
          adminBuilder,
          AdminDeviceLogListRequest(period: 'last_7_days'),
        );

        expect(page.total, 1);
        expect(page.items.single.log.message, 'Recent');
      });

      test('when a session and a tag are given then both are '
          'matched.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final device = await createDevice(session, code: 'DEV001');

        await createLog(
          session,
          deviceId: device.id!,
          message: 'Wanted',
          sessionId: 'session-a',
          tag: 'SyncWorker',
        );
        await createLog(
          session,
          deviceId: device.id!,
          message: 'Other session',
          sessionId: 'session-b',
          tag: 'SyncWorker',
        );
        await createLog(
          session,
          deviceId: device.id!,
          message: 'Other tag',
          sessionId: 'session-a',
          tag: 'HeartBeat',
        );

        final page = await endpoints.adminDeviceLog.list(
          adminBuilder,
          AdminDeviceLogListRequest(sessionId: 'session-a', tag: 'SyncWorker'),
        );

        expect(page.total, 1);
        expect(page.items.single.log.message, 'Wanted');
      });

      test('when the stacktrace filter is set then entries are kept or '
          'dropped accordingly.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final device = await createDevice(session, code: 'DEV001');

        await createLog(
          session,
          deviceId: device.id!,
          message: 'With trace',
          stacktrace: 'at main()',
        );
        await createLog(session, deviceId: device.id!, message: 'Plain');

        final withTrace = await endpoints.adminDeviceLog.list(
          adminBuilder,
          AdminDeviceLogListRequest(hasStacktrace: true),
        );
        final withoutTrace = await endpoints.adminDeviceLog.list(
          adminBuilder,
          AdminDeviceLogListRequest(hasStacktrace: false),
        );

        expect(withTrace.items.single.log.message, 'With trace');
        expect(withoutTrace.items.single.log.message, 'Plain');
      });

      test('when a search is given then the message, the tag and the device '
          'name are matched.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final named = await createDevice(
          session,
          code: 'DEV001',
          name: 'Reception tablet',
        );
        final plain = await createDevice(session, code: 'DEV002');

        await createLog(session, deviceId: plain.id!, message: 'Disk full');
        await createLog(
          session,
          deviceId: plain.id!,
          message: 'Nothing to see',
          tag: 'SyncWorker',
        );
        await createLog(session, deviceId: named.id!, message: 'Booted');

        Future<int> totalFor(String search) async {
          final page = await endpoints.adminDeviceLog.list(
            adminBuilder,
            AdminDeviceLogListRequest(search: search),
          );

          return page.total;
        }

        expect(await totalFor('Disk'), 1);
        expect(await totalFor('SyncWorker'), 1);
        expect(await totalFor('Reception'), 1);
      });

      test('when a column is chosen then the list is ordered by it.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final device = await createDevice(session, code: 'DEV001');

        await createLog(session, deviceId: device.id!, level: fatal);
        await createLog(session, deviceId: device.id!, level: verbose);

        final page = await endpoints.adminDeviceLog.list(
          adminBuilder,
          AdminDeviceLogListRequest(sortBy: 'level'),
        );

        expect(page.items.map((row) => row.log.level), [verbose, fatal]);
      });

      test('when perPage is above the maximum then it is clamped.', () async {
        await createProfile();

        final page = await endpoints.adminDeviceLog.list(
          adminBuilder,
          AdminDeviceLogListRequest(perPage: 100000),
        );

        expect(page.perPage, AdminDeviceLogEndpoint.maxPerPage);
      });
    });

    group('get', () {
      test('when the log exists then it is returned with its device '
          'label.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final device = await createDevice(
          session,
          code: 'DEV001',
          name: 'Tablet',
        );
        final log = await createLog(session, deviceId: device.id!);

        final fetched = await endpoints.adminDeviceLog.get(
          adminBuilder,
          log.id!,
        );

        expect(fetched.log.id, log.id);
        expect(fetched.deviceLabel, 'Tablet (DEV001)');
      });

      test('when the log does not exist then it is rejected.', () async {
        await createProfile();

        await expectLater(
          endpoints.adminDeviceLog.get(adminBuilder, 987654),
          throwsExceptionWith('Device log 987654 does not exist.'),
        );
      });
    });

    group('create', () {
      test('when a log is written by hand then it is stamped.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final device = await createDevice(session, code: 'DEV001');

        final created = await endpoints.adminDeviceLog.create(
          adminBuilder,
          DeviceLog(
            id: 4242,
            deviceId: device.id!,
            message: 'Manual entry',
            level: error,
          ),
        );

        expect(created.id, isNot(4242));
        expect(created.createdAt, isNotNull);
        expect(created.updatedAt, isNotNull);
        expect(created.level, error);
      });

      test('when the message is empty then the create is rejected.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final device = await createDevice(session, code: 'DEV001');

        await expectLater(
          endpoints.adminDeviceLog.create(
            adminBuilder,
            DeviceLog(deviceId: device.id!, message: ''),
          ),
          throwsExceptionWith('A message is required to create a log entry.'),
        );
      });
    });

    group('delete', () {
      test('when logs are deleted then the rows go away.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final device = await createDevice(session, code: 'DEV001');
        final first = await createLog(session, deviceId: device.id!);
        final second = await createLog(session, deviceId: device.id!);

        final deleted = await endpoints.adminDeviceLog.delete(adminBuilder, [
          first.id!,
          second.id!,
        ]);

        expect(deleted, 2);
        expect(await DeviceLog.db.findById(session, first.id!), isNull);
      });

      test('when no log is given then nothing is deleted.', () async {
        await createProfile();

        expect(await endpoints.adminDeviceLog.delete(adminBuilder, []), 0);
      });
    });

    group('stats', () {
      test('when logs arrive then the window figures and the trend are '
          'reported.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final first = await createDevice(session, code: 'DEV001');
        final second = await createDevice(session, code: 'DEV002');
        final now = DateTime.now().toUtc();

        await createLog(session, deviceId: first.id!, level: warning);
        await createLog(
          session,
          deviceId: second.id!,
          level: error,
          loggedAt: now.subtract(const Duration(hours: 1)),
        );
        await createLog(
          session,
          deviceId: first.id!,
          level: fatal,
          loggedAt: now.subtract(const Duration(hours: 30)),
        );

        final stats = await endpoints.adminDeviceLog.stats(adminBuilder);

        expect(stats.totalLogs, 2);
        expect(stats.errorCount, 1);
        expect(stats.errorRate, 50);
        expect(stats.activeDevices, 2);
        expect(stats.hourlyTrend, hasLength(DeviceLogService.trendHours));
        expect(
          stats.hourlyTrend.reduce((left, right) => left + right),
          2,
        );
      });
    });

    group('levelDistribution', () {
      test('when the window is asked for then every level is '
          'reported.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final device = await createDevice(session, code: 'DEV001');

        await createLog(session, deviceId: device.id!, level: error);
        await createLog(session, deviceId: device.id!, level: error);
        await createLog(session, deviceId: device.id!, level: verbose);

        final slices = await endpoints.adminDeviceLog.levelDistribution(
          adminBuilder,
          '24',
        );

        expect(slices, hasLength(6));
        expect(slices.map((slice) => slice.label), [
          'VERBOSE',
          'DEBUG',
          'INFO',
          'WARNING',
          'ERROR',
          'FATAL',
        ]);
        expect(slices.first.color, DeviceLogService.levelColors.first);
        expect(slices[error].count, 2);
        expect(slices[verbose].count, 1);
        expect(slices[fatal].count, 0);
      });
    });

    group('trend', () {
      test('when the 24 hour window is asked for then the buckets are '
          'hourly.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final device = await createDevice(session, code: 'DEV001');
        final now = DateTime.now().toUtc();

        await createLog(session, deviceId: device.id!, level: error);
        await createLog(
          session,
          deviceId: device.id!,
          level: warning,
          loggedAt: now.subtract(const Duration(hours: 2)),
        );
        await createLog(
          session,
          deviceId: device.id!,
          level: error,
          loggedAt: now.subtract(const Duration(days: 3)),
        );

        final trend = await endpoints.adminDeviceLog.trend(adminBuilder, '24');

        expect(trend.labels, hasLength(24));
        expect(trend.totals, hasLength(24));
        expect(trend.totals.last, 1);
        expect(trend.errors.last, 1);
        expect(trend.totals.reduce((left, right) => left + right), 2);
        expect(trend.errors.reduce((left, right) => left + right), 1);
        expect(
          trend.labels.first,
          matches(RegExp(r'^\d{2}\.\d{2} \d{2}:\d{2}$')),
        );
      });

      test('when the 7 day window is asked for then the buckets are '
          'daily.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final device = await createDevice(session, code: 'DEV001');
        await createLog(session, deviceId: device.id!);

        final trend = await endpoints.adminDeviceLog.trend(adminBuilder, '7');

        expect(trend.labels, hasLength(7));
        expect(trend.totals.reduce((left, right) => left + right), 1);
      });
    });

    group('export', () {
      test('when the export is asked for then the columns follow the '
          'exporter.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final device = await createDevice(
          session,
          code: 'DEV001',
          name: 'Tablet',
        );
        await createLog(
          session,
          deviceId: device.id!,
          message: 'Disk full',
          level: error,
          tag: 'SyncWorker',
          entryUuid: 'entry-1',
          sessionId: 'session-a',
        );

        final bytes = await endpoints.adminDeviceLog.export(
          adminBuilder,
          AdminDeviceLogListRequest(),
        );
        final lines = utf8
            .decode(bytes.buffer.asUint8List())
            .trim()
            .split('\n');

        expect(lines, hasLength(2));
        expect(lines.first, DeviceLogService.exportHeaders.join(','));
        expect(lines.last, contains('Tablet (DEV001)'));
        expect(lines.last, contains('entry-1'));
        expect(lines.last, contains('session-a'));
        expect(lines.last, contains('ERROR'));
        expect(lines.last, contains('SyncWorker'));
      });

      test('when a field carries a separator then it is quoted.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final device = await createDevice(session, code: 'DEV001');
        await createLog(
          session,
          deviceId: device.id!,
          message: 'Disk "almost" full, retrying',
        );

        final bytes = await endpoints.adminDeviceLog.export(
          adminBuilder,
          AdminDeviceLogListRequest(),
        );
        final lines = utf8
            .decode(bytes.buffer.asUint8List())
            .trim()
            .split('\n');

        expect(lines.last, contains('"Disk ""almost"" full, retrying"'));
      });

      test('when a filter is given then only those rows are '
          'exported.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final device = await createDevice(session, code: 'DEV001');
        await createLog(session, deviceId: device.id!, level: error);
        await createLog(session, deviceId: device.id!, level: verbose);

        final bytes = await endpoints.adminDeviceLog.export(
          adminBuilder,
          AdminDeviceLogListRequest(levels: [error]),
        );
        final lines = utf8
            .decode(bytes.buffer.asUint8List())
            .trim()
            .split('\n');

        expect(lines, hasLength(2));
        expect(lines.last, contains('ERROR'));
      });
    });
  });
}
