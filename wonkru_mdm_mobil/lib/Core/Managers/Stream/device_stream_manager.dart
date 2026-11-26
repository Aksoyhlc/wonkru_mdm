import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Managers/battery_manager.dart';
import 'package:wonkrumdm/Core/Services/enrollment_recovery.dart';
import 'package:wonkrumdm/Data/DataSources/Remote/serverpod_gateway.dart';
import 'package:wonkrumdm/Core/Utils/device_identity_helper.dart';
import 'package:wonkrumdm/Logic/Common/device_controller.dart';

import 'ack_envelope.dart';
import 'command_journal.dart';
import 'command_outcome.dart';
import 'command_processor.dart';

const _tag = 'DeviceStreamManager';

typedef DeviceStreamOpener =
    Stream<DeviceStreamMessage> Function(
      String token,
      Stream<DeviceStreamMessage> outbound,
    );

typedef EnrollmentRecoveryRunner = Future<RecoveryOutcome> Function();

typedef DeviceCommandHandler =
    Future<CommandOutcome> Function(String payload, DateTime receivedAt);

/// The device's single persistent command stream with the server.
///
/// The server pushes `welcome` and `command`, the device sends
/// `heartbeat`/`ack`; the connected state is settled by `welcome`. Commands run
/// in order, a repeated `commandId` is filtered through [CommandJournal] and its
/// stored ack is resent. A dropped connection is retried after 20s, and a 60s
/// watchdog rebuilds a stuck stream.
class DeviceStreamManager extends GetxService {
  DeviceStreamManager({
    DeviceStreamOpener? openStream,
    String? Function()? tokenProvider,
    Map<String, dynamic> Function()? heartbeatPayload,
    EnrollmentRecoveryRunner? recoverEnrollment,
    DeviceCommandHandler? commandHandler,
    CommandJournal? journal,
    Duration welcomeTimeout = const Duration(seconds: 30),
    Duration postAckDelay = const Duration(seconds: 3),
  }) : _openStream = openStream,
       _tokenProvider = tokenProvider ?? DeviceIdentityHelper.getToken,
       _heartbeatPayload = heartbeatPayload,
       _recoverEnrollment =
           recoverEnrollment ?? EnrollmentRecovery.recoverMissingEnrollment,
       _commandHandler = commandHandler ?? _defaultCommandHandler,
       _journal = journal ?? CommandJournal(),
       _welcomeTimeout = welcomeTimeout,
       _postAckDelay = postAckDelay;

  static Future<CommandOutcome> _defaultCommandHandler(
    String payload,
    DateTime receivedAt,
  ) =>
      CommandProcessor.instance.processCommand(payload, receivedAt: receivedAt);

  static DeviceStreamManager get to => Get.find<DeviceStreamManager>();

  final DeviceStreamOpener? _openStream;
  final String? Function() _tokenProvider;
  final Map<String, dynamic> Function()? _heartbeatPayload;
  final EnrollmentRecoveryRunner _recoverEnrollment;
  final DeviceCommandHandler _commandHandler;
  final CommandJournal _journal;

  /// If `welcome` does not arrive within this, the stream is dropped and
  /// rebuilt.
  final Duration _welcomeTimeout;

  /// Wait before the post-ack job (e.g. reboot), which can kill the process.
  final Duration _postAckDelay;

  /// Bound on acks queued while the stream is down; the oldest is dropped past
  /// it. The queue is kept persistent by [CommandJournal].
  static const _maxQueuedOutbound = 100;
  final List<DeviceStreamMessage> _queuedOutbound = [];
  bool _pendingRestored = false;

  Future<void> _commandChain = Future<void>.value();

  /// Ids of commands queued or being processed.
  final Set<String> _inFlightCommandIds = {};

  /// Connection generation; drops late events from a previous subscription.
  int _epoch = 0;
  Timer? _welcomeTimer;

  final logs = <String>[].obs;
  final rxConnected = false.obs;
  final rxConnecting = false.obs;

  DateTime? _lastHeartbeatAt;
  DateTime? get lastHeartbeatAt => _lastHeartbeatAt;

  StreamSubscription<DeviceStreamMessage>? _subscription;
  StreamController<DeviceStreamMessage>? _outbound;
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;
  Timer? _watchdogTimer;
  bool _isDisconnecting = false;

  /// Guards against two concurrent `connect()` calls opening two streams. Set
  /// before the first `await`, cleared in `finally`.
  bool _connectInFlight = false;

  /// Suppresses the normal 20s reconnect while re-enrollment runs; otherwise a
  /// stream opened with the old token races the recovery.
  bool _recoveringUnauthenticated = false;

  void _log(String message) {
    final line =
        'STREAM ${DateTime.now().toString().substring(11, 19)} $message';
    logs.add(line);
    if (logs.length > 500) logs.removeAt(0);
    WLog.d(_tag, message);
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }

  Future<void> connect() async {
    if (rxConnected.value || rxConnecting.value) return;

    // The watchdog and the 20s reconnect timer can fire together; the server
    // holds one controller per uuid, so a second stream would orphan the first.
    if (_connectInFlight) return;
    _connectInFlight = true;
    // Connected is confirmed by the server's `welcome`; until it (or a
    // timeout/error) arrives the state stays "connecting".
    rxConnecting.value = true;

    try {
      final token = _tokenProvider();
      if (token == null || token.isEmpty) {
        rxConnecting.value = false;
        _log('No token; stream not opened');
        // A missing token leaves the device unenrolled until IT intervenes, so
        // retry enrollment; on success it restarts the stream itself.
        WLog.w(_tag, 'No token; retrying enrollment');
        unawaited(
          _recoverEnrollment().then((outcome) {
            // A rejected enrollment key must not loop; the device waits until a
            // new key is entered.
            if (outcome == RecoveryOutcome.enrollmentRejected) {
              _log('Enrollment key rejected; re-enrollment stopped');
              return;
            }
            if (outcome == RecoveryOutcome.failed ||
                outcome == RecoveryOutcome.notApplicable) {
              _scheduleReconnect();
            }
          }),
        );
        return;
      }

      _cancelTimers();

      _epoch++;
      await _subscription?.cancel();
      _subscription = null;
      await _outbound?.close();
      _outbound = null;

      _restorePendingAcks();

      final epoch = ++_epoch;
      final outbound = StreamController<DeviceStreamMessage>();
      _outbound = outbound;

      final stream = (_openStream ?? _defaultOpenStream)(
        token,
        outbound.stream,
      );
      // Each callback carries its generation: a late event from a cancelled
      // subscription must not disturb the new connection.
      _subscription = stream.listen(
        (message) {
          if (epoch == _epoch) _onServerMessage(message);
        },
        onError: (Object error, StackTrace stack) {
          if (epoch != _epoch) return;
          _log('Stream error: $error');
          if (EnrollmentRecovery.isUnauthenticated(error)) {
            WLog.e(_tag, 'Stream token rejected', error: error, stackTrace: stack);
            // Leave this error to a running recovery; do not start another
            // timer (it would race the old token).
            if (EnrollmentRecovery.isRunning) {
              _onDisconnected(scheduleReconnect: false);
              return;
            }
            // Token rejected: reset identity and hand over to re-enrollment
            // instead of looping every 20s with the old token. Recovery
            // restarts the stream when it finishes.
            _recoveringUnauthenticated = true;
            _onDisconnected();
            unawaited(
              EnrollmentRecovery.handle(error).then((outcome) {
                _recoveringUnauthenticated = false;
                // Only a real failure falls back to the normal 20s loop;
                // success or a concurrent recovery rebuilds the stream.
                if (outcome == RecoveryOutcome.failed) _scheduleReconnect();
              }),
            );
            return;
          }
          _onDisconnected();
        },
        onDone: () {
          if (epoch == _epoch) _onDisconnected();
        },
        cancelOnError: false,
      );

      _log('Stream opened, waiting for server welcome');
      // The server pushes `welcome` right after token validation; if it never
      // comes the stream is half-open, and the watchdog will not fire
      // (rxConnecting), so drop and reconnect here.
      _welcomeTimer = Timer(_welcomeTimeout, () {
        if (epoch != _epoch || rxConnected.value) return;
        _log('Server welcome did not arrive; stream will be rebuilt');
        _onDisconnected();
      });
      _watchdogTimer = Timer.periodic(
        const Duration(seconds: 60),
        (_) => checkConnectionOrReconnect(),
      );
    } catch (e, st) {
      WLog.e(_tag, 'Stream setup failed', error: e, stackTrace: st);
      _log('Could not connect; retrying in 20s');
      _epoch++;
      _cancelTimers();
      await _subscription?.cancel();
      _subscription = null;
      await _outbound?.close();
      _outbound = null;
      rxConnected.value = false;
      rxConnecting.value = false;
      _scheduleReconnect();
    } finally {
      _connectInFlight = false;
    }
  }

  void _markConnected() {
    if (rxConnected.value) return;
    _welcomeTimer?.cancel();
    _welcomeTimer = null;
    rxConnected.value = true;
    rxConnecting.value = false;
    _log('Connection established');
    _flushQueuedOutbound();
    _sendHeartbeat();
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(
      const Duration(seconds: 60),
      (_) => _sendHeartbeat(),
    );
  }

  void _cancelTimers() {
    _reconnectTimer?.cancel();
    _heartbeatTimer?.cancel();
    _watchdogTimer?.cancel();
    _welcomeTimer?.cancel();
    _welcomeTimer = null;
  }

  Stream<DeviceStreamMessage> _defaultOpenStream(
    String token,
    Stream<DeviceStreamMessage> outbound,
  ) {
    return ServerpodGateway.instance.init().device.connect(token, outbound);
  }

  void checkConnectionOrReconnect() {
    if (_isDisconnecting) return;
    if (rxConnected.value || rxConnecting.value) return;
    _log('Watchdog: no connection, reconnecting');
    connect();
  }

  Future<void> restart() async {
    _log('Restarting stream');
    disconnect();
    await connect();
  }

  void disconnect() {
    _isDisconnecting = true;
    _epoch++;
    _cancelTimers();
    _subscription?.cancel();
    _subscription = null;
    _outbound?.close();
    _outbound = null;
    rxConnected.value = false;
    rxConnecting.value = false;
    _isDisconnecting = false;
    _log('Connection closed');
  }

  void clearLogs() => logs.clear();

  void _onDisconnected({bool scheduleReconnect = true}) {
    if (_isDisconnecting) return;
    // Invalidate this generation's callbacks so the `onDone` after `onError`
    // does not schedule a second reconnect.
    _epoch++;
    rxConnected.value = false;
    rxConnecting.value = false;
    _heartbeatTimer?.cancel();
    _watchdogTimer?.cancel();
    _welcomeTimer?.cancel();
    _welcomeTimer = null;
    // Cancel the subscription, not just drop the reference, or a failed stream
    // keeps receiving commands.
    final subscription = _subscription;
    _subscription = null;
    unawaited(subscription?.cancel());
    // Close `_outbound` so later acks queue instead of silently writing to a
    // closed controller.
    final outbound = _outbound;
    _outbound = null;
    outbound?.close();
    if (!scheduleReconnect) return;
    if (_recoveringUnauthenticated) {
      _log(
        'Recovery after token rejection still running; reconnect postponed',
      );
      return;
    }
    _log('Connection dropped; retrying in 20s');
    _scheduleReconnect();
  }

  /// Schedules a single delayed reconnect; avoids stacking timers on repeated
  /// drops.
  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 20), connect);
  }

  void _sendHeartbeat() {
    _lastHeartbeatAt = DateTime.now();
    final payload = jsonEncode(
      (_heartbeatPayload ?? _defaultHeartbeatPayload)(),
    );
    _send(
      DeviceStreamMessage(
        type: 'heartbeat',
        payload: payload,
        sentAt: DateTime.now().toUtc(),
      ),
    );
  }

  Map<String, dynamic> _defaultHeartbeatPayload() => <String, dynamic>{
    'battery_level': BatteryManager().level,
    'policy_version': DeviceController.to.config.value.version,
  };

  void _onServerMessage(DeviceStreamMessage message) {
    switch (message.type) {
      case 'welcome':
        _log('Server welcomed (welcome)');
        _markConnected();
      case 'command':
        // The server sends `welcome` before commands, but a command also
        // proves the stream is live.
        _markConnected();
        _enqueueCommand(message);
      default:
        _log('Unknown message type: ${message.type}');
    }
  }

  /// Queues a command; commands run one at a time in arrival order. A repeated
  /// `commandId` still queued or in flight is skipped: its first copy sends the
  /// ack.
  void _enqueueCommand(DeviceStreamMessage message) {
    final id = message.commandId;
    final receivedAt = DateTime.now();
    if (id != null && id.isNotEmpty && !_inFlightCommandIds.add(id)) {
      _log('Duplicate command (still processing), skipped: $id');
      return;
    }
    _commandChain = _commandChain.then((_) async {
      try {
        await _handleCommand(message, receivedAt);
      } catch (e, st) {
        WLog.e(_tag, 'Command queue error', error: e, stackTrace: st);
      } finally {
        if (id != null) _inFlightCommandIds.remove(id);
      }
    });
  }

  @visibleForTesting
  Future<void> get commandsIdle => _commandChain;

  Future<void> _handleCommand(
    DeviceStreamMessage message,
    DateTime receivedAt,
  ) async {
    final id = message.commandId;
    final hasId = id != null && id.isNotEmpty;
    _log('Command received: $id');

    if (hasId && _journal.contains(id)) {
      final stored = _journal.ackFor(id);
      if (stored != null) {
        _log('Duplicate command, resending stored ack: $id');
        _sendAck(id, stored);
        return;
      }
      // Started but never acked: the process died mid-command. Re-running could
      // loop; close it as an error.
      WLog.w(_tag, 'Interrupted command redelivered, not run: $id');
      final payload = encodeAckPayload(<String, dynamic>{
        'success': false,
        'status': 'error',
        'message': 'Command was interrupted in a previous run',
        'duplicate': true,
      });
      _journal.complete(id, payload);
      _sendAck(id, payload);
      return;
    }

    if (hasId) _journal.markStarted(id);

    CommandOutcome outcome;
    try {
      outcome = await _commandHandler(message.payload ?? '{}', receivedAt);
    } catch (e, st) {
      WLog.e(_tag, 'Command processing error', error: e, stackTrace: st);
      outcome = const CommandOutcome(<String, dynamic>{
        'status': 'error',
        'message': 'Command could not be processed',
      });
    }

    final payload = encodeAckPayload(outcome.ack);
    if (hasId) _journal.complete(id, payload);
    _sendAck(message.commandId, payload);

    final afterAck = outcome.afterAck;
    if (afterAck != null) {
      // Give the ack time to reach the websocket and the journal to hit disk;
      // the job (e.g. reboot) may kill the process.
      await Future<void>.delayed(_postAckDelay);
      await afterAck();
    }
  }

  void _sendAck(String? commandId, String payload) {
    final message = DeviceStreamMessage(
      type: 'ack',
      commandId: commandId,
      payload: payload,
      sentAt: DateTime.now().toUtc(),
    );
    final controller = _outbound;
    if (!rxConnected.value || controller == null || controller.isClosed) {
      _queueOutbound(message);
      return;
    }
    controller.add(message);
  }

  /// Transient messages like heartbeat; dropped while disconnected (a fresh
  /// heartbeat goes out on connect).
  void _send(DeviceStreamMessage message) {
    final controller = _outbound;
    if (!rxConnected.value || controller == null || controller.isClosed) {
      return;
    }
    controller.add(message);
  }

  /// Queues an unsent ack and marks it pending persistently; past the bound the
  /// oldest is dropped.
  void _queueOutbound(DeviceStreamMessage message) {
    _queuedOutbound.add(message);
    final id = message.commandId;
    if (id != null && id.isNotEmpty) _journal.setPending(id, true);
    WLog.w(
      _tag,
      'Stream closed, message queued '
      '(type=${message.type}, commandId=${message.commandId}, queue=${_queuedOutbound.length})',
    );

    if (_queuedOutbound.length > _maxQueuedOutbound) {
      final dropped = _queuedOutbound.removeAt(0);
      final droppedId = dropped.commandId;
      if (droppedId != null && droppedId.isNotEmpty) {
        _journal.setPending(droppedId, false);
      }
      WLog.w(
        _tag,
        'Queue full, oldest message dropped '
        '(type=${dropped.type}, commandId=${dropped.commandId})',
      );
    }
  }

  /// Moves acks unsent in a previous run (once) to the head of the queue.
  void _restorePendingAcks() {
    if (_pendingRestored) return;
    _pendingRestored = true;
    final queuedIds = _queuedOutbound.map((m) => m.commandId).toSet();
    final restored = <DeviceStreamMessage>[
      for (final (id, ack) in _journal.pendingAcks())
        if (!queuedIds.contains(id))
          DeviceStreamMessage(
            type: 'ack',
            commandId: id,
            payload: ack,
            sentAt: DateTime.now().toUtc(),
          ),
    ];
    if (restored.isEmpty) return;
    _queuedOutbound.insertAll(0, restored);
    while (_queuedOutbound.length > _maxQueuedOutbound) {
      final dropped = _queuedOutbound.removeAt(0);
      final droppedId = dropped.commandId;
      if (droppedId != null) _journal.setPending(droppedId, false);
    }
    WLog.i(
      _tag,
      '${restored.length} pending acks loaded from a previous run',
    );
  }

  void _flushQueuedOutbound() {
    final controller = _outbound;
    if (controller == null || controller.isClosed || _queuedOutbound.isEmpty) {
      return;
    }

    final pending = List<DeviceStreamMessage>.of(_queuedOutbound);
    _queuedOutbound.clear();
    for (final message in pending) {
      controller.add(message);
      final id = message.commandId;
      if (id != null && id.isNotEmpty) _journal.setPending(id, false);
    }
    WLog.w(_tag, '${pending.length} pending messages sent to the stream');
  }
}
