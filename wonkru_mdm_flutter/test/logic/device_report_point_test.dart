import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';
import 'package:wonkru_mdm_flutter/Data/Models/device_report_point.dart';

DeviceReport _report(String payload, {DateTime? createdAt}) => DeviceReport(
  deviceId: 1,
  type: 'impossibleSpeed',
  payload: payload,
  createdAt: createdAt,
);

void main() {
  group('DeviceReportPoint.fromReport', () {
    test('when the payload uses snake_case keys then they are read.', () {
      final point = DeviceReportPoint.fromReport(
        _report(
          '{"battery_level":85,"free_storage_bytes":50,'
          '"total_storage_bytes":100,"online":true,'
          '"collected_at":"2026-01-02T03:04:05Z"}',
        ),
      );

      expect(point.batteryLevel, 85);
      expect(point.freeStoragePercent, 50);
      expect(point.online, isTrue);
      expect(point.moment?.toUtc(), DateTime.utc(2026, 1, 2, 3, 4, 5));
    });

    test('when the payload nests the values then they are read.', () {
      final point = DeviceReportPoint.fromReport(
        _report(
          '{"battery_info":{"level":42},'
          '"storage_info":{"usagePercentage":30}}',
        ),
      );

      expect(point.batteryLevel, 42);
      expect(point.freeStoragePercent, 70);
    });

    test('when the payload uses camelCase keys then they are read.', () {
      final point = DeviceReportPoint.fromReport(
        _report('{"batteryLevel":10,"freeStoragePercent":25,"isOnline":"yes"}'),
      );

      expect(point.batteryLevel, 10);
      expect(point.freeStoragePercent, 25);
      expect(point.online, isTrue);
    });

    test('when values are out of range then they are clamped.', () {
      final point = DeviceReportPoint.fromReport(
        _report('{"battery_level":150,"storage_info":{"usagePercentage":120}}'),
      );

      expect(point.batteryLevel, 100);
      expect(point.freeStoragePercent, 0);
    });

    test('when the payload is malformed then only createdAt remains.', () {
      final createdAt = DateTime.utc(2026, 5, 6, 7, 8);
      final point = DeviceReportPoint.fromReport(
        _report('not-json', createdAt: createdAt),
      );

      expect(point.batteryLevel, isNull);
      expect(point.freeStoragePercent, isNull);
      expect(point.online, isNull);
      expect(point.moment, createdAt);
      expect(point.type, 'impossibleSpeed');
    });

    test(
      'when the payload has no storage fields then free storage is null.',
      () {
        final point = DeviceReportPoint.fromReport(
          _report('{"battery_level":50}'),
        );

        expect(point.batteryLevel, 50);
        expect(point.freeStoragePercent, isNull);
      },
    );
  });
}
