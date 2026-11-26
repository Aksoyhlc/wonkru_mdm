import 'package:test/test.dart';
import 'package:wonkru_core_server/src/generated/protocol.dart';

/// Verifies the wire values of the shared protocol enums.
///
/// All are `serialized: byName`, so both the JSON name (`toJson`) and `.name`
/// must match the agent's wire values exactly.
void main() {
  group('Given the shared protocol enums', () {
    test('when serializing DeviceAction then values match the wire contract', () {
      for (final value in DeviceAction.values) {
        expect(DeviceAction.fromJson(value.toJson()), value);
      }
      expect(DeviceAction.send_notification.toJson(), 'send_notification');
      expect(
        DeviceAction.get_current_location.toJson(),
        'get_current_location',
      );
    });

    test(
      'when serializing DeviceCommandStatus then values match the queue',
      () {
        for (final value in DeviceCommandStatus.values) {
          expect(DeviceCommandStatus.fromJson(value.toJson()), value);
        }
        expect(
          DeviceCommandStatus.values.map((e) => e.toJson()),
          ['pending', 'sent', 'acked', 'timeout', 'error'],
        );
      },
    );

    test(
      'when serializing DeviceReportType then agent values are kept',
      () {
        for (final value in DeviceReportType.values) {
          expect(DeviceReportType.fromJson(value.toJson()), value);
        }
        expect(
          DeviceReportType.wifi_network_changed.toJson(),
          'wifi_network_changed',
        );
        expect(DeviceReportType.impossibleSpeed.toJson(), 'impossibleSpeed');
      },
    );

    test('when serializing LogLevel then the DTO names are kept', () {
      for (final value in LogLevel.values) {
        expect(LogLevel.fromJson(value.toJson()), value);
      }
      expect(
        LogLevel.values.map((e) => e.toJson()),
        ['verbose', 'debug', 'info', 'warning', 'error', 'fatal'],
      );
    });

    test('when serializing NotificationType then normal is kept', () {
      for (final value in NotificationType.values) {
        expect(NotificationType.fromJson(value.toJson()), value);
      }
      expect(NotificationType.normal.toJson(), 'normal');
    });

    test(
      'when serializing NotificationDeliveryStatus then states are kept',
      () {
        for (final value in NotificationDeliveryStatus.values) {
          expect(NotificationDeliveryStatus.fromJson(value.toJson()), value);
        }
        expect(
          NotificationDeliveryStatus.values.map((e) => e.toJson()),
          ['pending', 'sent', 'received', 'failed'],
        );
      },
    );

    test('when serializing CertificateAction then actions are kept', () {
      for (final value in CertificateAction.values) {
        expect(CertificateAction.fromJson(value.toJson()), value);
      }
      expect(
        CertificateAction.values.map((e) => e.toJson()),
        ['install', 'uninstall'],
      );
    });

    test('when serializing CertificateType then uppercase values are kept', () {
      for (final value in CertificateType.values) {
        expect(CertificateType.fromJson(value.toJson()), value);
      }
      expect(
        CertificateType.values.map((e) => e.toJson()),
        ['CA', 'CLIENT', 'SERVER', 'USER', 'PKCS12'],
      );
    });

    test('when serializing CertificateFormat then formats are kept', () {
      for (final value in CertificateFormat.values) {
        expect(CertificateFormat.fromJson(value.toJson()), value);
      }
      expect(
        CertificateFormat.values.map((e) => e.toJson()),
        ['PEM', 'DER', 'PKCS12', 'PKCS7'],
      );
    });

    test('when serializing FileOperationType then operations are kept', () {
      for (final value in FileOperationType.values) {
        expect(FileOperationType.fromJson(value.toJson()), value);
      }
      expect(
        FileOperationType.values.map((e) => e.toJson()),
        ['download', 'delete', 'open'],
      );
    });

    test('when serializing PolicyApplicationAction then actions are kept', () {
      for (final value in PolicyApplicationAction.values) {
        expect(PolicyApplicationAction.fromJson(value.toJson()), value);
      }
      expect(
        PolicyApplicationAction.values.map((e) => e.toJson()),
        ['install', 'remove', 'configure'],
      );
    });

    test('when serializing AppAutoUpdatePolicy then policies are kept', () {
      for (final value in AppAutoUpdatePolicy.values) {
        expect(AppAutoUpdatePolicy.fromJson(value.toJson()), value);
      }
      expect(
        AppAutoUpdatePolicy.values.map((e) => e.toJson()),
        ['always', 'wifi_only', 'never'],
      );
    });

    test('when serializing PermissionPolicy then policies are kept', () {
      for (final value in PermissionPolicy.values) {
        expect(PermissionPolicy.fromJson(value.toJson()), value);
      }
      expect(
        PermissionPolicy.values.map((e) => e.toJson()),
        ['prompt', 'grant', 'deny'],
      );
    });
  });
}
