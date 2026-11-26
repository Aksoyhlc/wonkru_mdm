import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';
import 'package:wonkrumdm/Core/Managers/Stream/command_journal.dart';
import 'package:wonkrumdm/Core/Managers/Stream/command_outcome.dart';
import 'package:wonkrumdm/Core/Managers/Stream/device_stream_manager.dart';

/// Harness for [DeviceStreamManager] without a server: passing the same
/// [store] to a second harness simulates an app restart.
class StreamHarness {
  StreamHarness({
    DeviceCommandHandler? handler,
    List<Map<String, dynamic>>? store,
    Duration welcomeTimeout = const Duration(seconds: 30),
    Duration postAckDelay = Duration.zero,
  }) : store = store ?? <Map<String, dynamic>>[] {
    manager = DeviceStreamManager(
      tokenProvider: () => 'test-token',
      heartbeatPayload: () => <String, dynamic>{'battery_level': 0},
      commandHandler: handler ?? _echoHandler,
      journal: CommandJournal(
        load: () => [for (final e in this.store) Map.of(e)],
        save: (entries) => this.store
          ..clear()
          ..addAll([for (final e in entries) Map.of(e)]),
      ),
      welcomeTimeout: welcomeTimeout,
      postAckDelay: postAckDelay,
      openStream: (token, outbound) {
        opened++;
        outbound.listen((m) {
          received.add(m);
          events.add('${m.type}:${m.commandId}');
        });
        return upstream.stream;
      },
    );
  }

  final List<Map<String, dynamic>> store;

  // Broadcast so a reconnect can open a second subscription to the same source.
  final upstream = StreamController<DeviceStreamMessage>.broadcast();
  final received = <DeviceStreamMessage>[];

  final events = <String>[];
  var opened = 0;
  late final DeviceStreamManager manager;

  static Future<CommandOutcome> _echoHandler(String payload, DateTime _) async {
    return CommandOutcome(<String, dynamic>{
      'success': true,
      'status': 'success',
      'echo': payload,
    });
  }

  Future<void> connectAndWelcome() async {
    await manager.connect();
    welcome();
    await pumpEventQueue();
  }

  void welcome() => upstream.add(
    DeviceStreamMessage(type: 'welcome', sentAt: DateTime.now().toUtc()),
  );

  void command(String id, {String action = 'noop'}) => upstream.add(
    DeviceStreamMessage(
      type: 'command',
      commandId: id,
      payload: jsonEncode({'action': action, 'params': <String, String>{}}),
      sentAt: DateTime.now().toUtc(),
    ),
  );

  Future<void> settle() async {
    await pumpEventQueue();
    await manager.commandsIdle;
    await pumpEventQueue();
  }

  Future<void> drop() async {
    upstream.addError(Exception('connection dropped'), StackTrace.empty);
    await pumpEventQueue();
  }

  List<DeviceStreamMessage> get acks =>
      received.where((m) => m.type == 'ack').toList();

  List<String?> get ackIds => acks.map((m) => m.commandId).toList();

  void dispose() => manager.disconnect();
}
