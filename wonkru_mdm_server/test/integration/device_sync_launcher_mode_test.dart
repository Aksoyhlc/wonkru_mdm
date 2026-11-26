import 'dart:convert';

import 'package:test/test.dart';
import 'package:wonkru_core_server/wonkru_core_server.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'support/device_enrollment.dart';

void main() {
  withServerpod('DeviceEndpoint launcher-mode key compatibility', (
    sessionBuilder,
    endpoints,
  ) {
    Future<Device> syncWithBs(Map<String, dynamic> bs) async {
      final registered = await endpoints.device.register(
        sessionBuilder,
        await enrolled(sessionBuilder, model: 'launcher-test'),
      );

      await endpoints.device.sync(
        sessionBuilder,
        DeviceSyncRequest(
          deviceUuid: registered.uuid,
          token: registered.token,
          syncType: 'full',
          payload: jsonEncode({'bs': bs}),
        ),
      );

      final session = sessionBuilder.build();
      final device = await Device.db.findFirstRow(
        session,
        where: (t) => t.uuid.equals(registered.uuid),
      );
      return device!;
    }

    Future<DeviceStateCache> cacheFor(Device device) async {
      final session = sessionBuilder.build();
      final cache = await DeviceStateCache.db.findFirstRow(
        session,
        where: (t) => t.deviceId.equals(device.id!),
      );
      return cache!;
    }

    test(
      'device is marked as launcher mode when launcher_mode_enabled is true',
      () async {
        final device = await syncWithBs({'launcher_mode_enabled': true});

        expect(device.isLauncherMode, isTrue);
        expect((await cacheFor(device)).launcherModeEnabled, isTrue);
      },
    );

    test('legacy kiosk_enabled key is read as a fallback', () async {
      final device = await syncWithBs({'kiosk_enabled': true});

      expect(device.isLauncherMode, isTrue);
      expect((await cacheFor(device)).launcherModeEnabled, isTrue);
    });

    test(
      'launcher_mode_enabled false wins over kiosk_enabled true',
      () async {
        final device = await syncWithBs({
          'launcher_mode_enabled': false,
          'kiosk_enabled': true,
        });

        expect(device.isLauncherMode, isFalse);
        expect((await cacheFor(device)).launcherModeEnabled, isFalse);
      },
    );

    test(
      'neither key present means not launcher mode and empty cache',
      () async {
        final device = await syncWithBs({'flutter_alive_timestamp': 0});

        expect(device.isLauncherMode, isFalse);
        expect((await cacheFor(device)).launcherModeEnabled, isNull);
      },
    );
  });
}
