import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:wonkrumdm/Core/Constants/Enums/config_apply_result.dart';
import 'package:wonkrumdm/Core/Managers/Stream/command_processor.dart';
import 'package:wonkrumdm/Core/Managers/device_action_manager.dart';

/// The real `DeviceActionManager` is invoked; without a device token or network
/// in the test environment its actions return error envelopes. Policy
/// application is faked via `policyApplierOverride`.
void main() {
  const updatePolicy = '{"action":"update_policy","params":{}}';

  tearDown(() => DeviceActionManager().policyApplierOverride = null);

  group('update_policy / policy_change acks the real result', () {
    test('ack is not produced until policy application finishes', () async {
      final gate = Completer<ConfigApplyResult>();
      DeviceActionManager().policyApplierOverride = () => gate.future;

      var done = false;
      final pending = CommandProcessor.instance
          .processCommand(updatePolicy)
          .then((o) {
            done = true;
            return o;
          });
      await pumpEventQueue();
      expect(done, isFalse, reason: 'ack was produced early');

      gate.complete(ConfigApplyResult.applied);
      final outcome = await pending;
      expect(outcome.ack['success'], isTrue);
      expect(outcome.ack['policy_result'], 'applied');
      expect(outcome.afterAck, isNull);
    });

    test('ack fails when the policy cannot be fetched', () async {
      DeviceActionManager().policyApplierOverride = () async =>
          ConfigApplyResult.fetchFailed;

      final ack = (await CommandProcessor.instance.processCommand(
        updatePolicy,
      )).ack;
      expect(ack['success'], isFalse);
      expect(ack['status'], 'error');
      expect(ack['policy_result'], 'fetchFailed');
    });

    test(
      'commands received before application are merged, later ones re-applied',
      () async {
        var calls = 0;
        DeviceActionManager().policyApplierOverride = () async {
          calls++;
          return ConfigApplyResult.applied;
        };
        final receivedEarly = DateTime.now();
        await Future<void>.delayed(const Duration(milliseconds: 2));

        final first = await CommandProcessor.instance.processCommand(
          updatePolicy,
          receivedAt: DateTime.now(),
        );
        final covered = await CommandProcessor.instance.processCommand(
          updatePolicy,
          receivedAt: receivedEarly,
        );
        final fresh = await CommandProcessor.instance.processCommand(
          updatePolicy,
          receivedAt: DateTime.now(),
        );

        expect(first.ack['success'], isTrue);
        expect(covered.ack['success'], isTrue);
        expect(
          (covered.ack['message'] as String).toLowerCase(),
          contains('debounced'),
        );
        expect(fresh.ack['success'], isTrue);
        expect(calls, 2);
      },
    );

    test('a failed application does not merge the next command', () async {
      var calls = 0;
      DeviceActionManager().policyApplierOverride = () async {
        calls++;
        return ConfigApplyResult.fetchFailed;
      };
      final receivedEarly = DateTime.now();
      await Future<void>.delayed(const Duration(milliseconds: 2));

      await CommandProcessor.instance.processCommand(
        updatePolicy,
        receivedAt: DateTime.now(),
      );
      final retry = await CommandProcessor.instance.processCommand(
        updatePolicy,
        receivedAt: receivedEarly,
      );

      expect(calls, 2);
      expect(retry.ack['success'], isFalse);
    });

    test('concurrent policy commands are applied sequentially', () async {
      var running = 0;
      var maxRunning = 0;
      DeviceActionManager().policyApplierOverride = () async {
        running++;
        if (running > maxRunning) maxRunning = running;
        await Future<void>.delayed(const Duration(milliseconds: 5));
        running--;
        return ConfigApplyResult.applied;
      };

      await Future.wait([
        CommandProcessor.instance.processCommand(
          updatePolicy,
          receivedAt: DateTime.now(),
        ),
        CommandProcessor.instance.processCommand(
          '{"action":"policy_change","params":{"policy_id":"7"}}',
          receivedAt: DateTime.now(),
        ),
      ]);

      expect(maxRunning, 1);
    });

    test('policy_change applies the latest policy without RPC', () async {
      var calls = 0;
      DeviceActionManager().policyApplierOverride = () async {
        calls++;
        return ConfigApplyResult.applied;
      };

      final ack = (await CommandProcessor.instance.processCommand(
        '{"action":"policy_change","params":{"policy_id":"7"}}',
        receivedAt: DateTime.now(),
      )).ack;

      expect(calls, 1);
      expect(ack['success'], isTrue);
      expect(ack['expected_policy_id'], 7);
    });
  });

  group('policyAckFor mapping', () {
    test('results counted as successful', () {
      for (final r in [
        ConfigApplyResult.applied,
        ConfigApplyResult.inactive,
        ConfigApplyResult.throttled,
      ]) {
        final (ok, data) = DeviceActionManager.policyAckFor(r);
        expect(ok, isTrue, reason: r.name);
        expect(data['policy_result'], r.name);
        expect(data['message'], isA<String>());
      }
    });

    test('results counted as failed', () {
      for (final r in [
        ConfigApplyResult.partial,
        ConfigApplyResult.busy,
        ConfigApplyResult.fetchFailed,
        ConfigApplyResult.noPolicy,
        ConfigApplyResult.invalidPolicy,
        ConfigApplyResult.failed,
      ]) {
        final (ok, data) = DeviceActionManager.policyAckFor(r);
        expect(ok, isFalse, reason: r.name);
        expect(data['policy_result'], r.name);
      }
    });

    test('a partial application carries the failing managers', () {
      final (_, data) = DeviceActionManager.policyAckFor(
        ConfigApplyResult.partial,
        failedManagers: ['AppManager'],
      );
      expect(data['failed_managers'], ['AppManager']);
    });
  });

  test(
    'reboot: error ack without verified ownership, no restart',
    () async {
      // No native bridge in the test environment, so the precondition check must
      // fail and the post-ack work (reboot) must never be scheduled.
      final outcome = await CommandProcessor.instance.processCommand(
        '{"action":"reboot","params":{}}',
      );
      expect(outcome.ack['success'], isFalse);
      expect(outcome.afterAck, isNull);
    },
  );

  test('an unknown action returns an error envelope', () async {
    final result = await CommandProcessor.instance.processMessage(
      '{"action":"no_such_action"}',
    );

    expect(result, isNotNull);
    expect(result!['success'], false);
    expect(result['status'], 'error');
    expect(result['message'], contains('no_such_action'));
  });

  test('the envelope always carries an explicit success bool', () async {
    final messages = <String>[
      '{"action":"no_such_action"}',
      '{"action":""}',
      '{"action":"policy_change","params":{"policy_id":42}}',
      'this is not valid json',
    ];

    for (final message in messages) {
      final result = await CommandProcessor.instance.processMessage(message);
      expect(result, isNotNull, reason: 'envelope must not be null: $message');
      expect(
        result!.containsKey('success'),
        isTrue,
        reason: 'no success field: $message',
      );
      expect(
        result['success'],
        isA<bool>(),
        reason: 'success is not a bool: $message',
      );
    }
  });

  test('policy_change with an int policy_id uses the network path', () async {
    final asInt = await CommandProcessor.instance.processMessage(
      jsonEncode({
        'action': 'policy_change',
        'params': {'policy_id': 42},
      }),
    );
    final asString = await CommandProcessor.instance.processMessage(
      jsonEncode({
        'action': 'policy_change',
        'params': {'policy_id': '42'},
      }),
    );

    expect(asInt, isNotNull);
    expect(asInt!['success'], isA<bool>());
    // An int is carried through `toString()` in `_policyChange`; the
    // "Invalid policy_id" message only appears for non-numeric values.
    expect(asInt['message'], isNot(contains('Invalid policy_id')));
    expect(asInt['message'], asString!['message']);
  });

  test('policy_change with a non-numeric policy_id is invalid', () async {
    final result = await CommandProcessor.instance.processMessage(
      jsonEncode({
        'action': 'policy_change',
        'params': {'policy_id': 'abc'},
      }),
    );

    expect(result, isNotNull);
    expect(result!['success'], false);
    expect(result['message'], contains('Invalid policy_id'));
  });
}
