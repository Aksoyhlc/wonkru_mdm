import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/server/health/future_calls_health_indicator.dart';
import 'package:wonkru_mdm_server/src/server/health/health_config_builder.dart';
import 'package:wonkru_mdm_server/src/server/health/smtp_health_indicator.dart';
import 'package:wonkru_mdm_server/src/server/health/smtp_health_settings.dart';
import 'package:wonkru_mdm_server/src/server/health/storage_health_indicator.dart';

/// Health indicators take no session, so they run without a database by
/// injecting stubs.
void main() {
  group('StorageHealthIndicator', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('wonkru_health_');
    });

    tearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('returns pass on a writable root and cleans up the probe file', () async {
      final indicator = StorageHealthIndicator(roots: [tempDir]);

      final result = await indicator.check();

      expect(result.status, HealthStatus.pass);
      expect(result.name, 'storage:local');
      expect(result.componentType, HealthComponentType.datastore.name);
      expect(result.observedUnit, 'ms');
      expect(result.observedValue, isA<double>());
      expect(File('${tempDir.path}/.health_probe').existsSync(), isFalse);
    });

    test('creates a not-yet-existing root and returns pass', () async {
      final missing = Directory('${tempDir.path}/new-root');
      expect(missing.existsSync(), isFalse);

      final result = await StorageHealthIndicator(roots: [missing]).check();

      expect(result.status, HealthStatus.pass);
      expect(missing.existsSync(), isTrue);
    });

    test('returns fail if the root path is a file', () async {
      final file = File('${tempDir.path}/not-a-dir')..writeAsStringSync('x');

      final result = await StorageHealthIndicator(
        roots: [Directory(file.path)],
      ).check();

      expect(result.status, HealthStatus.fail);
      expect(result.output, contains('not writable'));
    });

    test('returns fail if one of the roots is not writable', () async {
      final file = File('${tempDir.path}/blocker')..writeAsStringSync('x');

      final result = await StorageHealthIndicator(
        roots: [tempDir, Directory(file.path)],
      ).check();

      expect(result.status, HealthStatus.fail);
    });
  });

  group('SmtpHealthIndicator', () {
    SmtpHealthSettings settings({
      bool enabled = true,
      String host = 'smtp.example.com',
      int port = 587,
      String fromAddress = 'no-reply@example.com',
    }) => SmtpHealthSettings(
      enabled: enabled,
      host: host,
      port: port,
      fromAddress: fromAddress,
    );

    test('returns pass when SMTP is disabled', () async {
      final indicator = SmtpHealthIndicator(
        settingsReader: () async => settings(enabled: false, host: ''),
      );

      final result = await indicator.check();

      expect(result.status, HealthStatus.pass);
      expect(result.name, 'smtp:configuration');
      expect(result.componentType, HealthComponentType.component.name);
      expect(result.observedValue, 'disabled');
    });

    test('returns pass when SMTP is enabled and the configuration is valid', () async {
      final indicator = SmtpHealthIndicator(
        settingsReader: () async => settings(),
      );

      final result = await indicator.check();

      expect(result.status, HealthStatus.pass);
      expect(result.observedValue, 'configured');
    });

    test('returns fail when SMTP is enabled but host is empty', () async {
      final indicator = SmtpHealthIndicator(
        settingsReader: () async => settings(host: '   '),
      );

      final result = await indicator.check();

      expect(result.status, HealthStatus.fail);
      expect(result.observedValue, 'invalid');
      expect(result.output, contains('smtp_host'));
    });

    test('returns fail when SMTP is enabled but the port is out of range', () async {
      final indicator = SmtpHealthIndicator(
        settingsReader: () async => settings(port: 70000),
      );

      final result = await indicator.check();

      expect(result.status, HealthStatus.fail);
      expect(result.output, contains('smtp_port'));
    });

    test('returns fail when SMTP is enabled but the sender address is empty', () async {
      final indicator = SmtpHealthIndicator(
        settingsReader: () async => settings(fromAddress: ''),
      );

      final result = await indicator.check();

      expect(result.status, HealthStatus.fail);
      expect(result.output, contains('smtp_from_address'));
    });

    test('returns pass when settings cannot be read (optional dependency)', () async {
      final indicator = SmtpHealthIndicator(
        settingsReader: () async => throw StateError('db down'),
      );

      final result = await indicator.check();

      expect(result.status, HealthStatus.pass);
      expect(result.observedValue, 'unknown');
      expect(result.output, contains('unavailable'));
    });

    test('returns pass when there is no settings source', () async {
      final result = await SmtpHealthIndicator().check();

      expect(result.status, HealthStatus.pass);
      expect(result.observedValue, 'unknown');
    });

    test('validate collects the missing pieces', () {
      expect(
        SmtpHealthIndicator.validate(
          settings(host: '', port: 0, fromAddress: ''),
        ),
        hasLength(3),
      );
      expect(SmtpHealthIndicator.validate(settings()), isEmpty);
    });
  });

  group('FutureCallsHealthIndicator', () {
    test('returns pass when there are no overdue calls', () async {
      final indicator = FutureCallsHealthIndicator(overdueProbe: () async => 0);

      final result = await indicator.check();

      expect(result.status, HealthStatus.pass);
      expect(result.name, 'future_calls:overdue');
      expect(result.componentType, HealthComponentType.system.name);
      expect(result.observedUnit, 'calls');
      expect(result.observedValue, 0);
    });

    test('a single overdue row (running/restart) returns pass', () async {
      // Serverpod inserts the new recurring row before running the call and
      // deletes the old one afterwards, so a single past-dated row can be
      // healthy; the indicator must not raise a false alarm.
      final result = await FutureCallsHealthIndicator(
        overdueProbe: () async => 1,
      ).check();

      expect(result.status, HealthStatus.pass);
      expect(result.observedValue, 1);
    });

    test('returns pass at the threshold', () async {
      final result = await FutureCallsHealthIndicator(
        overdueProbe: () async => 2,
      ).check();

      expect(result.status, HealthStatus.pass);
      expect(result.observedValue, 2);
    });

    test('returns fail when the threshold is exceeded', () async {
      final indicator = FutureCallsHealthIndicator(overdueProbe: () async => 3);

      final result = await indicator.check();

      expect(result.status, HealthStatus.fail);
      expect(result.observedValue, 3);
      expect(result.output, contains('overdue'));
    });

    test('returns fail when there are many overdue rows', () async {
      final result = await FutureCallsHealthIndicator(
        overdueProbe: () async => 12,
      ).check();

      expect(result.status, HealthStatus.fail);
      expect(result.observedValue, 12);
    });

    test('returns fail if the probe throws', () async {
      final indicator = FutureCallsHealthIndicator(
        overdueProbe: () async => throw StateError('query failed'),
      );

      final result = await indicator.check();

      expect(result.status, HealthStatus.fail);
      expect(result.output, contains('could not be inspected'));
    });

    test('returns fail when there is no probe source (mandatory subsystem)', () async {
      final result = await FutureCallsHealthIndicator().check();

      expect(result.status, HealthStatus.fail);
    });
  });

  group('buildHealthConfig', () {
    test(
      'registers three custom readiness indicators without copying the built-ins',
      () {
        final config = buildHealthConfig(
          sessionFactory: () async => throw UnimplementedError(),
        );

        expect(
          config.additionalReadinessIndicators.map(
            (indicator) => indicator.name,
          ),
          ['storage:local', 'future_calls:overdue', 'smtp:configuration'],
        );
        // Serverpod adds the built-in database (and Redis) indicators, so they
        // must not be registered again here.
        expect(
          config.additionalReadinessIndicators
              .whereType<DatabaseHealthIndicator>(),
          isEmpty,
        );
        expect(config.additionalStartupIndicators, isEmpty);
      },
    );
  });
}
