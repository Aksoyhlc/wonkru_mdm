import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';
import 'package:wonkrumdm/Core/Managers/Stream/command_journal.dart';
import 'package:wonkrumdm/Core/Managers/Stream/device_stream_manager.dart';
import 'package:wonkrumdm/Core/Services/enrollment_recovery.dart';

void main() {
  test('repeated connect calls open a single subscription', () async {
    var opened = 0;
    Stream<DeviceStreamMessage>? outboundSeen;
    final upstream = StreamController<DeviceStreamMessage>();
    addTearDown(upstream.close);

    final manager = DeviceStreamManager(
      tokenProvider: () => 'test-token',
      heartbeatPayload: () => <String, dynamic>{'battery_level': 0},
      journal: CommandJournal(load: () => const [], save: (_) {}),
      openStream: (token, outbound) {
        opened++;
        outboundSeen = outbound;
        return upstream.stream;
      },
    );

    // The first call is still pending, so the second must return early;
    // otherwise the stream is orphaned, since the server registry keeps one
    // controller per uuid.
    final first = manager.connect();
    final second = manager.connect();
    await Future.wait([first, second]);

    expect(opened, 1);
    expect(manager.rxConnected.value, isFalse);
    expect(manager.rxConnecting.value, isTrue);
    expect(outboundSeen, isNotNull);

    await manager.connect();
    expect(opened, 1);

    upstream.add(
      DeviceStreamMessage(type: 'welcome', sentAt: DateTime.now().toUtc()),
    );
    await pumpEventQueue();
    expect(manager.rxConnected.value, isTrue);
    expect(manager.rxConnecting.value, isFalse);

    await manager.connect();
    expect(opened, 1);

    manager.disconnect();
    expect(manager.rxConnecting.value, isFalse);
  });

  test('rxConnecting does not stay stuck when there is no token', () async {
    final manager = DeviceStreamManager(
      tokenProvider: () => null,
      heartbeatPayload: () => <String, dynamic>{},
      openStream: (token, outbound) => Stream<DeviceStreamMessage>.empty(),
      // Real recovery touches the network and plugins; this test only asserts flags.
      recoverEnrollment: () async => RecoveryOutcome.recovered,
    );

    await manager.connect();

    expect(manager.rxConnected.value, isFalse);
    expect(manager.rxConnecting.value, isFalse);

    manager.disconnect();
  });

  test('re-enrollment is triggered when there is no token', () async {
    var recoveryCalls = 0;
    final manager = DeviceStreamManager(
      tokenProvider: () => null,
      heartbeatPayload: () => <String, dynamic>{},
      openStream: (token, outbound) => Stream<DeviceStreamMessage>.empty(),
      recoverEnrollment: () async {
        recoveryCalls++;
        return RecoveryOutcome.recovered;
      },
    );

    await manager.connect();
    // Recovery is invoked with `unawaited`, so count it once the microtask runs.
    await Future<void>.delayed(Duration.zero);

    expect(recoveryCalls, 1);

    manager.disconnect();
  });
}
