import 'dart:async';
import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:wonkru_core_server/wonkru_core_server.dart';
import 'package:wonkru_mdm_server/src/generated/protocol.dart';
import 'package:wonkru_mdm_server/src/service/device_connection_registry.dart';

import 'support/matchers.dart';
import 'test_tools/serverpod_test_tools.dart';

/// Pins each action's wire payload: action value, default parameter
/// combination and package parameter contract. The list must match
/// `DeviceAction.values`; bulk rules are checked per action.
void main() {
  final registry = DeviceConnectionRegistry.instance;

  setUp(registry.clear);
  tearDown(registry.clear);

  withServerpod('Given AdminDeviceEndpoint.sendCommand metadata', (
    sessionBuilder,
    endpoints,
  ) {
    const adminUserId = '33333333-3333-4333-8333-333333333333';

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
      Session session,
      String code,
      String uuid,
    ) {
      return Device.db.insertRow(session, Device(code: code, uuid: uuid));
    }

    List<DeviceStreamMessage> connectDevice(String uuid) {
      final controller = StreamController<DeviceStreamMessage>();
      addTearDown(controller.close);
      final received = <DeviceStreamMessage>[];
      final subscription = controller.stream.listen(received.add);
      addTearDown(subscription.cancel);
      registry.register(uuid, controller);
      return received;
    }

    Map<String, dynamic> payloadOf(DeviceStreamMessage message) =>
        jsonDecode(message.payload!) as Map<String, dynamic>;

    test('the golden list covers every DeviceAction exactly once', () {
      final golden = goldenPayloads.map((g) => g.action).toList();

      expect(golden.toSet(), hasLength(golden.length), reason: 'duplicate');
      expect(
        golden.toSet(),
        DeviceAction.values.map((a) => a.name).toSet(),
        reason: 'the new action\'s wire payload must be pinned here',
      );
    });

    for (final golden in goldenPayloads) {
      test('when ${golden.action} is sent then the payload keeps the legacy '
          'defaults.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final device = await createDevice(session, 'META', 'uuid-meta');
        final received = connectDevice('uuid-meta');
        final isPolicyChange = golden.action == 'policy_change';
        // `policy_change` needs a real policy; the empty default is rejected.
        final policy = isPolicyChange
            ? await Policy.db.insertRow(session, Policy(name: 'M'))
            : null;
        final paramsJson = isPolicyChange
            ? jsonEncode({'policy_id': policy!.id})
            : golden.packageParamKey == null
            ? null
            : jsonEncode({'package_name': 'com.example'});

        await endpoints.adminDevice.sendCommand(
          adminBuilder,
          [device.id!],
          golden.action,
          paramsJson,
        );
        await Future<void>.delayed(Duration.zero);

        final payload = payloadOf(received.single);
        expect(payload['action'], golden.action);
        expect(
          payload['params'],
          isPolicyChange
              ? {'policy_id': '${policy!.id}'}
              : golden.expectedParams,
        );
      });
    }

    test(
      'when a non-bulk action targets several devices then it is rejected.',
      () async {
        await createProfile();

        for (final action in nonBulkActions) {
          await expectLater(
            endpoints.adminDevice.sendCommand(
              adminBuilder,
              const [1, 2],
              action,
              null,
            ),
            throwsExceptionWith('cannot be sent to multiple devices'),
            reason: action,
          );
        }
      },
    );

    for (final golden in goldenPayloads.where(
      (g) => !nonBulkActions.contains(g.action),
    )) {
      test('when ${golden.action} targets several devices then it is queued '
          'for each.', () async {
        await createProfile();

        final session = sessionBuilder.build();
        final first = await createDevice(session, 'B1', 'uuid-b1');
        final second = await createDevice(session, 'B2', 'uuid-b2');
        connectDevice('uuid-b1');
        connectDevice('uuid-b2');
        final policy = golden.action == 'policy_change'
            ? await Policy.db.insertRow(session, Policy(name: 'B'))
            : null;

        final status = await endpoints.adminDevice.sendCommand(
          adminBuilder,
          [first.id!, second.id!],
          golden.action,
          policy != null
              ? jsonEncode({'policy_id': policy.id})
              : golden.packageParamKey == null
              ? null
              : jsonEncode({'package_name': 'com.example'}),
        );

        expect(status.total, 2);
      });
    }
  });
}

typedef GoldenPayload = ({
  String action,
  String? packageParamKey,
  Map<String, String> expectedParams,
});

final List<GoldenPayload> goldenPayloads = <GoldenPayload>[
  (
    action: 'send_notification',
    packageParamKey: null,
    expectedParams: {'title': '', 'body': ''},
  ),
  (
    action: 'enable_power_save',
    packageParamKey: null,
    expectedParams: <String, String>{},
  ),
  (
    action: 'reduce_brightness',
    packageParamKey: null,
    expectedParams: {'level': ''},
  ),
  (
    action: 'disable_wifi',
    packageParamKey: null,
    expectedParams: <String, String>{},
  ),
  (
    action: 'disable_bluetooth',
    packageParamKey: null,
    expectedParams: <String, String>{},
  ),
  (
    action: 'lock_device',
    packageParamKey: null,
    expectedParams: <String, String>{},
  ),
  (
    action: 'clear_cache',
    packageParamKey: null,
    expectedParams: <String, String>{},
  ),
  (
    action: 'disable_camera',
    packageParamKey: null,
    expectedParams: <String, String>{},
  ),
  (
    action: 'clear_app_data',
    packageParamKey: 'package_name',
    expectedParams: {'package_name': 'com.example'},
  ),
  (
    action: 'launch_app',
    packageParamKey: 'package_name',
    expectedParams: {'package_name': 'com.example'},
  ),
  (
    action: 'launch_intent',
    packageParamKey: null,
    expectedParams: {
      'intent_action': '',
      'intent_package': '',
      'intent_component': '',
      'intent_data': '',
      'intent_type': '',
      'intent_categories': '',
      'intent_flags': '',
    },
  ),
  (
    action: 'uninstall_app',
    packageParamKey: 'package_name',
    expectedParams: {'package_name': 'com.example'},
  ),
  (
    action: 'open_app_settings',
    packageParamKey: 'package_name',
    expectedParams: {'package_name': 'com.example'},
  ),
  (
    action: 'update_policy',
    packageParamKey: null,
    expectedParams: <String, String>{},
  ),
  (
    action: 'policy_change',
    packageParamKey: null,
    expectedParams: {'policy_id': ''},
  ),
  (
    action: 'get_installed_apps',
    packageParamKey: null,
    expectedParams: {'include_system_apps': '0'},
  ),
  (
    action: 'get_logs',
    packageParamKey: null,
    expectedParams: <String, String>{},
  ),
  (
    action: 'device_data',
    packageParamKey: null,
    expectedParams: <String, String>{},
  ),
  (
    action: 'get_current_location',
    packageParamKey: null,
    expectedParams: <String, String>{},
  ),
  (
    action: 'reboot',
    packageParamKey: null,
    expectedParams: <String, String>{},
  ),
];

const List<String> nonBulkActions = <String>[
  'launch_app',
  'uninstall_app',
  'get_installed_apps',
  'get_logs',
  'device_data',
  'get_current_location',
];
