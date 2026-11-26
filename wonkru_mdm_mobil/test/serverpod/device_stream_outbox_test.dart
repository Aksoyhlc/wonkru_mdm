import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:wonkrumdm/Core/Managers/Stream/command_outcome.dart';

import 'support/stream_harness.dart';

void main() {
  /// Handler that waits on the gate: commands are received while connected, and
  /// their acks are produced only after the connection drops.
  StreamHarness gatedHarness(
    Completer<void> gate, {
    List<Map<String, dynamic>>? store,
  }) {
    return StreamHarness(
      store: store,
      handler: (payload, _) async {
        await gate.future;
        return const CommandOutcome(<String, dynamic>{'status': 'success'});
      },
    );
  }

  test(
    'while the stream is closed the ack is queued and sent in order once welcome arrives',
    () async {
      final gate = Completer<void>();
      final harness = gatedHarness(gate);
      addTearDown(harness.dispose);

      await harness.connectAndWelcome();
      expect(harness.manager.rxConnected.value, isTrue);

      harness.command('c1');
      harness.command('c2');
      await pumpEventQueue();

      await harness.drop();
      expect(harness.manager.rxConnected.value, isFalse);

      gate.complete();
      await harness.settle();
      expect(harness.acks, isEmpty);

      // The stream is open but the server has not welcomed yet, so no ack is sent.
      await harness.manager.connect();
      await pumpEventQueue();
      expect(harness.acks, isEmpty);

      harness.welcome();
      await pumpEventQueue();
      expect(harness.ackIds, ['c1', 'c2']);
    },
  );

  test('when the queue exceeds 100 messages the oldest is dropped', () async {
    final gate = Completer<void>();
    final harness = gatedHarness(gate);
    addTearDown(harness.dispose);

    await harness.connectAndWelcome();
    for (var i = 1; i <= 101; i++) {
      harness.command('c${i.toString().padLeft(3, '0')}');
    }
    await pumpEventQueue();
    await harness.drop();

    gate.complete();
    await harness.settle();

    await harness.connectAndWelcome();
    final acks = harness.acks;

    expect(acks.length, 100);
    expect(acks.first.commandId, 'c002');
    expect(acks.last.commandId, 'c101');
  });

  test(
    'a pending ack is delivered on the next connection even if the app restarts',
    () async {
      final store = <Map<String, dynamic>>[];
      final gate = Completer<void>();
      final first = gatedHarness(gate, store: store);

      await first.connectAndWelcome();
      first.command('c1');
      await pumpEventQueue();
      await first.drop();
      gate.complete();
      await first.settle();
      first.dispose();
      expect(first.acks, isEmpty);
      expect(store.single['pending'], isTrue);

      final second = StreamHarness(store: store);
      addTearDown(second.dispose);
      await second.connectAndWelcome();

      expect(second.ackIds, ['c1']);
      expect(store.single.containsKey('pending'), isFalse);
    },
  );
}
