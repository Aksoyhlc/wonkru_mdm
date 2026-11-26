import 'package:test/test.dart';
import 'package:wonkru_mdm_server/src/service/alert_routing_settings.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';

void main() {
  group('SystemAlertType wire values', () {
    test('enum names are identical to the old .value values', () {
      expect(
        [
          for (final type in SystemAlertType.values) type.name,
        ],
        ['device_offline', 'policy_update_pending', 'security_info'],
      );
    });
  });

  group('normalizeRouting', () {
    test(
      'reads the old {type: [channels]} map and resolves the legacy key',
      () {
        final routing = AlertRoutingSettings.normalizeRouting({
          'type_channels': {
            'AdbRootEnabled': ['mail', 'sms'],
            'device_offline': ['mail'],
            'unknown_type': ['mail'],
          },
        });

        final byType = {
          for (final entry in routing) entry.type.name: entry.channels,
        };
        expect(byType['security_info'], ['mail', 'sms']);
        expect(byType['device_offline'], ['mail']);
        expect(byType['policy_update_pending'], ['database']);
        expect(byType.containsKey('unknown_type'), isFalse);
      },
    );

    test('an empty channel list falls back to the database channel', () {
      final routing = AlertRoutingSettings.normalizeRouting({
        'type_channels': {'device_offline': <String>[]},
      });

      final byType = {
        for (final entry in routing) entry.type.name: entry.channels,
      };
      expect(byType['device_offline'], ['database']);
    });

    test('when there is no setting every type is filled with database', () {
      final routing = AlertRoutingSettings.normalizeRouting(null);

      expect(routing, hasLength(SystemAlertType.values.length));
      for (final entry in routing) {
        expect(entry.channels, ['database']);
      }
    });
  });

  group('encodeRouting', () {
    test('preserves the on-disk {type: [channels]} format and all types', () {
      final stored = AlertRoutingSettings.encodeRouting([
        AlertTypeChannels(
          type: SystemAlertType.device_offline,
          channels: const ['mail'],
        ),
      ]);

      expect(stored, {
        'device_offline': ['mail'],
        'policy_update_pending': ['database'],
        'security_info': ['database'],
      });
    });

    test('filters out invalid/empty channels and falls back to the default', () {
      final stored = AlertRoutingSettings.encodeRouting([
        AlertTypeChannels(
          type: SystemAlertType.device_offline,
          channels: const ['mail', 'sms', 'telegram', 'mail'],
        ),
        AlertTypeChannels(
          type: SystemAlertType.security_info,
          channels: const [],
        ),
      ]);

      expect(stored['device_offline'], ['mail', 'sms']);
      expect(stored['security_info'], ['database']);
    });

    test('the old map -> typed list -> old map round trip is lossless', () {
      final legacy = {
        'type_channels': {
          'AdbRootEnabled': ['mail', 'sms'],
          'device_offline': ['mail'],
        },
      };

      final roundTripped = AlertRoutingSettings.encodeRouting(
        AlertRoutingSettings.normalizeRouting(legacy),
      );

      expect(roundTripped, {
        'device_offline': ['mail'],
        'policy_update_pending': ['database'],
        'security_info': ['mail', 'sms'],
      });
    });
  });
}
