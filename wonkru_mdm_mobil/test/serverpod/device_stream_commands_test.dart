import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:wonkrumdm/Core/Managers/Stream/command_outcome.dart';

import 'support/stream_harness.dart';

void main() {
  group('sequential processing', () {
    test('commands are processed one by one in arrival order', () async {
      final gates = <String, Completer<void>>{
        'a': Completer<void>(),
        'b': Completer<void>(),
      };
      final started = <String>[];
      var running = 0;
      var maxRunning = 0;
      final harness = StreamHarness(
        handler: (payload, _) async {
          final action = (jsonDecode(payload) as Map)['action'] as String;
          started.add(action);
          running++;
          if (running > maxRunning) maxRunning = running;
          await gates[action]!.future;
          running--;
          return const CommandOutcome(<String, dynamic>{'status': 'success'});
        },
      );
      addTearDown(harness.dispose);
      await harness.connectAndWelcome();

      harness.command('c1', action: 'a');
      harness.command('c2', action: 'b');
      await pumpEventQueue();

      expect(started, ['a']);
      gates['a']!.complete();
      await pumpEventQueue();
      expect(started, ['a', 'b']);
      expect(harness.ackIds, ['c1']);

      gates['b']!.complete();
      await harness.settle();
      expect(harness.ackIds, ['c1', 'c2']);
      expect(maxRunning, 1);
    });

    test('queue keeps going on handler throw; error ack is sent', () async {
      var calls = 0;
      final harness = StreamHarness(
        handler: (payload, _) async {
          calls++;
          if (calls == 1) throw StateError('boom');
          return const CommandOutcome(<String, dynamic>{'status': 'success'});
        },
      );
      addTearDown(harness.dispose);
      await harness.connectAndWelcome();

      harness.command('c1');
      harness.command('c2');
      await harness.settle();

      expect(harness.ackIds, ['c1', 'c2']);
      expect(jsonDecode(harness.acks[0].payload!)['success'], isFalse);
      expect(jsonDecode(harness.acks[1].payload!)['success'], isTrue);
    });
  });

  group('commandId duplicate filter', () {
    test(
      'a completed command is not re-run; the stored ack is sent again',
      () async {
        var calls = 0;
        final harness = StreamHarness(
          handler: (payload, _) async {
            calls++;
            return CommandOutcome(<String, dynamic>{
              'status': 'success',
              'n': calls,
            });
          },
        );
        addTearDown(harness.dispose);
        await harness.connectAndWelcome();

        harness.command('c1');
        await harness.settle();
        harness.command('c1');
        await harness.settle();

        expect(calls, 1);
        expect(harness.ackIds, ['c1', 'c1']);
        expect(harness.acks[1].payload, harness.acks[0].payload);
      },
    );

    test(
      'a duplicate while still processing is skipped (one run, one ack)',
      () async {
        final gate = Completer<void>();
        var calls = 0;
        final harness = StreamHarness(
          handler: (payload, _) async {
            calls++;
            await gate.future;
            return const CommandOutcome(<String, dynamic>{'status': 'success'});
          },
        );
        addTearDown(harness.dispose);
        await harness.connectAndWelcome();

        harness.command('c1');
        await pumpEventQueue();
        harness.command('c1');
        await pumpEventQueue();
        gate.complete();
        await harness.settle();

        expect(calls, 1);
        expect(harness.ackIds, ['c1']);
      },
    );

    test(
      'the filter works even if the app restarts (persistent journal)',
      () async {
        final store = <Map<String, dynamic>>[];
        var calls = 0;
        Future<CommandOutcome> handler(String payload, DateTime _) async {
          calls++;
          return const CommandOutcome(<String, dynamic>{
            'status': 'success',
            'first': true,
          });
        }

        final first = StreamHarness(store: store, handler: handler);
        await first.connectAndWelcome();
        first.command('c1');
        await first.settle();
        first.dispose();

        final second = StreamHarness(store: store, handler: handler);
        addTearDown(second.dispose);
        await second.connectAndWelcome();
        second.command('c1');
        await second.settle();

        expect(calls, 1);
        expect(second.ackIds, ['c1']);
        expect(jsonDecode(second.acks.single.payload!)['first'], isTrue);
      },
    );

    test('a half-finished command is not re-run; error ack sent', () async {
      // A previous process started the command but died before writing its ack.
      final store = <Map<String, dynamic>>[
        {'id': 'c9'},
      ];
      var calls = 0;
      final harness = StreamHarness(
        store: store,
        handler: (payload, _) async {
          calls++;
          return const CommandOutcome(<String, dynamic>{'status': 'success'});
        },
      );
      addTearDown(harness.dispose);
      await harness.connectAndWelcome();

      harness.command('c9');
      await harness.settle();

      expect(calls, 0);
      final ack = jsonDecode(harness.acks.single.payload!) as Map;
      expect(ack['success'], isFalse);
      expect(ack['duplicate'], isTrue);
    });
  });

  group('work after ack (reboot)', () {
    test(
      'afterAck runs after the ack is written and journaled',
      () async {
        late StreamHarness harness;
        bool? ackPersistedBeforeReboot;
        harness = StreamHarness(
          postAckDelay: const Duration(milliseconds: 500),
          handler: (payload, _) async => CommandOutcome(
            const <String, dynamic>{'status': 'success'},
            afterAck: () async {
              // The process may die here: the ack has been sent, so its result
              // must already be persisted.
              harness.events.add('reboot');
              ackPersistedBeforeReboot = harness.store.single['ack'] is String;
            },
          ),
        );
        addTearDown(harness.dispose);
        await harness.connectAndWelcome();

        harness.command('r1', action: 'reboot');
        await pumpEventQueue();
        expect(harness.events.where((e) => e != 'heartbeat:null'), ['ack:r1']);

        await harness.settle();
        expect(harness.events.where((e) => e != 'heartbeat:null'), [
          'ack:r1',
          'reboot',
        ]);
        expect(ackPersistedBeforeReboot, isTrue);
      },
    );

    test('a command arriving again after reboot does not restart', () async {
      final store = <Map<String, dynamic>>[];
      var reboots = 0;
      Future<CommandOutcome> handler(String payload, DateTime _) async =>
          CommandOutcome(const <String, dynamic>{
            'status': 'success',
          }, afterAck: () async => reboots++);

      final before = StreamHarness(store: store, handler: handler);
      await before.connectAndWelcome();
      before.command('r1', action: 'reboot');
      await before.settle();
      before.dispose();

      final after = StreamHarness(store: store, handler: handler);
      addTearDown(after.dispose);
      await after.connectAndWelcome();
      after.command('r1', action: 'reboot');
      await after.settle();

      expect(reboots, 1);
      expect(after.ackIds, ['r1']);
    });
  });

  group('connection state', () {
    test('heartbeat and connected state start with welcome', () async {
      final harness = StreamHarness();
      addTearDown(harness.dispose);

      await harness.manager.connect();
      await pumpEventQueue();
      expect(harness.manager.rxConnected.value, isFalse);
      expect(harness.manager.rxConnecting.value, isTrue);
      expect(harness.received, isEmpty);

      harness.welcome();
      await pumpEventQueue();
      expect(harness.manager.rxConnected.value, isTrue);
      expect(harness.manager.rxConnecting.value, isFalse);
      expect(harness.received.map((m) => m.type), ['heartbeat']);
    });

    test('the connecting state ends when welcome times out', () async {
      final harness = StreamHarness(
        welcomeTimeout: const Duration(milliseconds: 20),
      );
      addTearDown(harness.dispose);

      await harness.manager.connect();
      expect(harness.manager.rxConnecting.value, isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(harness.manager.rxConnected.value, isFalse);
      expect(harness.manager.rxConnecting.value, isFalse);
    });

    test('with no welcome, the first command confirms connection', () async {
      final harness = StreamHarness();
      addTearDown(harness.dispose);

      await harness.manager.connect();
      harness.command('c1');
      await harness.settle();

      expect(harness.manager.rxConnected.value, isTrue);
      expect(harness.ackIds, ['c1']);
    });

    test(
      'after an error the old subscription is inert; no double processing',
      () async {
        var calls = 0;
        final harness = StreamHarness(
          handler: (payload, _) async {
            calls++;
            return const CommandOutcome(<String, dynamic>{'status': 'success'});
          },
        );
        addTearDown(harness.dispose);
        await harness.connectAndWelcome();

        await harness.drop();
        harness.command('lost');
        await pumpEventQueue();
        expect(calls, 0);

        await harness.connectAndWelcome();
        harness.command('c1');
        await harness.settle();

        expect(calls, 1);
        expect(harness.ackIds, ['c1']);
      },
    );
  });
}
