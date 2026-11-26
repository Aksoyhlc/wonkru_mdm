import 'package:serverpod/protocol.dart' as serverpod_protocol;
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/server/health/future_calls_health_indicator.dart';
import 'package:wonkru_mdm_server/src/server/health/smtp_health_indicator.dart';
import 'package:wonkru_mdm_server/src/service/setting_service.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given health indicators', (sessionBuilder, endpoints) {
    Future<int> insertFutureCall({
      required String identifier,
      required DateTime time,
    }) async {
      final session = sessionBuilder.build();
      final entry = await serverpod_protocol.FutureCallEntry.db.insertRow(
        session,
        serverpod_protocol.FutureCallEntry(
          name: 'DeviceCommandTimeoutMarkTimeoutsFutureCall',
          time: time,
          serverId: 'test-server',
          identifier: identifier,
        ),
      );
      return entry.id!;
    }

    Future<void> saveSetting(String key, String value) async {
      final session = sessionBuilder.build();
      await SettingService.save(session, key, value);
    }

    group('FutureCallsHealthIndicator', () {
      test('a single overdue recurring call returns pass (below threshold)', () async {
        await insertFutureCall(
          identifier: 'device-command-timeouts',
          time: DateTime.now().toUtc().subtract(const Duration(minutes: 45)),
        );

        final result = await FutureCallsHealthIndicator(
          sessionFactory: () async => sessionBuilder.build(),
        ).check();

        expect(result.status, HealthStatus.pass);
        expect(result.observedValue, 1);
      });

      test('many overdue recurring calls return fail', () async {
        for (var i = 0; i < 6; i++) {
          await insertFutureCall(
            identifier: 'device-command-timeouts',
            time: DateTime.now().toUtc().subtract(
              Duration(minutes: 45 + i),
            ),
          );
        }

        final result = await FutureCallsHealthIndicator(
          sessionFactory: () async => sessionBuilder.build(),
        ).check();

        expect(result.status, HealthStatus.fail);
        expect(result.observedValue, 6);
      });

      test('a not-yet-due recurring call returns pass', () async {
        await insertFutureCall(
          identifier: 'device-command-timeouts',
          time: DateTime.now().toUtc().add(const Duration(minutes: 5)),
        );

        final result = await FutureCallsHealthIndicator(
          sessionFactory: () async => sessionBuilder.build(),
        ).check();

        expect(result.status, HealthStatus.pass);
        expect(result.observedValue, 0);
      });

      test('an overdue call with an unknown identifier is ignored', () async {
        await insertFutureCall(
          identifier: 'some-other-call',
          time: DateTime.now().toUtc().subtract(const Duration(hours: 2)),
        );

        final result = await FutureCallsHealthIndicator(
          sessionFactory: () async => sessionBuilder.build(),
        ).check();

        expect(result.status, HealthStatus.pass);
      });
    });

    group('SmtpHealthIndicator', () {
      test('returns pass when there is no setting (disabled)', () async {
        final result = await SmtpHealthIndicator(
          sessionFactory: () async => sessionBuilder.build(),
        ).check();

        expect(result.status, HealthStatus.pass);
        expect(result.observedValue, 'disabled');
      });

      test('returns fail when enabled but host is empty', () async {
        await saveSetting('smtp_enabled', '1');
        await saveSetting('smtp_host', '');

        final result = await SmtpHealthIndicator(
          sessionFactory: () async => sessionBuilder.build(),
        ).check();

        expect(result.status, HealthStatus.fail);
        expect(result.observedValue, 'invalid');
        expect(result.output, contains('smtp_host'));
      });

      test('returns pass when enabled and host is set', () async {
        await saveSetting('smtp_enabled', '1');
        await saveSetting('smtp_host', 'smtp.example.com');

        final result = await SmtpHealthIndicator(
          sessionFactory: () async => sessionBuilder.build(),
        ).check();

        expect(result.status, HealthStatus.pass);
        expect(result.observedValue, 'configured');
      });
    });
  });
}
