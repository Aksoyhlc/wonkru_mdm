import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:wonkru_core_server/wonkru_core_server.dart' hide LogLevel;

import '../generated/protocol.dart';
import '../util/json_utils.dart';
import 'device_application_sync_service.dart';
import 'device_connection_registry.dart';

/// Commands are persisted as `device_commands` rows before they are pushed, so
/// an offline device receives them when it reconnects.
class DeviceCommandService {
  const DeviceCommandService._();

  static const statusPending = DeviceCommandStatus.pending;

  static const statusSent = DeviceCommandStatus.sent;

  static const statusAcked = DeviceCommandStatus.acked;

  static const statusTimeout = DeviceCommandStatus.timeout;

  static const statusError = DeviceCommandStatus.error;

  /// A connected agent acks most commands within seconds; two minutes tolerate
  /// a slow round trip and brief drops.
  static const defaultTimeout = Duration(minutes: 2);

  static const longTimeout = Duration(minutes: 15);

  static const longRunningActions = <DeviceAction>{
    DeviceAction.get_current_location,
    DeviceAction.device_data,
    DeviceAction.get_installed_apps,
    DeviceAction.get_logs,
    DeviceAction.uninstall_app,
    DeviceAction.clear_app_data,
    DeviceAction.update_policy,
    DeviceAction.policy_change,
  };

  static const pendingExpiry = Duration(days: 7);

  static const maxDeliveryAttempts = 3;

  static Duration timeoutFor(DeviceAction action) =>
      longRunningActions.contains(action) ? longTimeout : defaultTimeout;

  /// Validates [action] and builds the dispatch parameters.
  ///
  /// Fills in the action's default parameters and requires the package name for
  /// actions that carry one. Throws [DeviceCommandValidationException] for an
  /// unknown action, a non-bulk action sent to several devices, or a missing
  /// required parameter.
  static ({DeviceAction action, Map<String, String> params}) prepare(
    String action,
    String? paramsJson, {
    required int deviceCount,
  }) {
    final DeviceAction deviceAction;
    try {
      deviceAction = DeviceAction.fromJson(action);
    } on ArgumentError {
      throw DeviceCommandValidationException(
        message: 'Unknown action "$action".',
      );
    }

    final metadata = DeviceActionMetadata.forAction(deviceAction);
    if (deviceCount > 1 && !metadata.isBulkAction) {
      throw DeviceCommandValidationException(
        message: 'Action "$action" cannot be sent to multiple devices.',
      );
    }

    final params = _decodeParams(paramsJson);
    for (final entry in metadata.defaultParams.entries) {
      params.putIfAbsent(entry.key, () => entry.value);
    }

    final packageParamKey = metadata.packageParamKey;
    if (packageParamKey != null) {
      final packageName = (params[packageParamKey] ?? '').trim();
      if (packageName.isEmpty) {
        throw DeviceCommandValidationException(
          message:
              'The "$packageParamKey" parameter is required for "$action".',
        );
      }
      params[packageParamKey] = packageName;
    }

    return (action: deviceAction, params: params);
  }

  /// Stringifies every value so the stored JSON keeps the agent's contract.
  static Map<String, String> _decodeParams(String? paramsJson) {
    final trimmed = paramsJson?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return {};
    }

    final decoded = jsonDecode(trimmed);
    if (decoded is! Map) {
      throw DeviceCommandValidationException(
        message: 'paramsJson must be a JSON object.',
      );
    }

    return {
      for (final entry in decoded.entries)
        '${entry.key}': entry.value == null ? '' : '${entry.value}',
    };
  }

  /// Devices without a uuid can never be reached over the stream, so they are
  /// skipped; the caller flushes the queued rows (see [flushAllFor]) when it
  /// wants an immediate push.
  static Future<int> enqueue(
    Session session,
    List<int> deviceIds,
    DeviceAction action,
    Map<String, dynamic> params, {
    String? bulkId,
  }) async {
    final ids = deviceIds.toSet();
    if (ids.isEmpty) {
      return 0;
    }

    final devices = await Device.db.find(
      session,
      where: (t) => t.id.inSet(ids),
    );

    final now = DateTime.now().toUtc();
    final rows = <DeviceCommand>[];
    for (final device in devices) {
      final deviceId = device.id;
      final uuid = device.uuid;
      if (deviceId == null || uuid == null || uuid.isEmpty) {
        continue;
      }

      rows.add(
        DeviceCommand(
          deviceId: deviceId,
          commandId: const Uuid().v7(),
          bulkId: bulkId,
          action: action,
          params: params.isEmpty ? null : jsonEncode(params),
          status: statusPending,
          attempts: 0,
          createdAt: now,
        ),
      );
    }

    if (rows.isEmpty) {
      return 0;
    }

    await DeviceCommand.db.insert(session, rows);
    return rows.length;
  }

  /// Pushes every `pending` command of [device] over its open stream.
  ///
  /// Each row is claimed through a conditional update (`pending` → `sent`,
  /// attempt counter incremented) before sending, so two concurrent flushes
  /// never send the same command twice; a failed send reverts the row.
  ///
  /// [redeliverSent] is only set on reconnect: unacked `sent` commands below
  /// [maxDeliveryAttempts] are resent with the same `commandId`, which the
  /// agent uses to deduplicate.
  static Future<int> flushPending(
    Session session,
    Device device, {
    bool redeliverSent = false,
  }) async {
    final deviceId = device.id;
    final uuid = device.uuid;
    if (deviceId == null || uuid == null || uuid.isEmpty) {
      return 0;
    }

    final registry = DeviceConnectionRegistry.instance;
    if (!registry.isOnline(uuid)) {
      return 0;
    }

    final now = DateTime.now().toUtc();
    final pendingCutoff = now.subtract(pendingExpiry);

    final candidates = await DeviceCommand.db.find(
      session,
      where: (t) {
        final pending =
            t.status.equals(statusPending) &
            (t.createdAt.equals(null) | (t.createdAt > pendingCutoff));
        final unacked =
            t.status.equals(statusSent) & (t.attempts < maxDeliveryAttempts);
        return t.deviceId.equals(deviceId) &
            (redeliverSent ? (pending | unacked) : pending);
      },
      orderBy: (t) => t.id,
    );

    var sent = 0;
    for (final command in candidates) {
      final claimed = await _claim(session, command, now);
      if (!claimed) {
        continue;
      }

      final delivered = registry.send(
        uuid,
        DeviceStreamMessage(
          type: 'command',
          commandId: command.commandId,
          payload: _commandPayload(command),
          sentAt: now,
        ),
      );

      // The device dropped mid-flush; the claimed row is put back and the
      // remaining commands are retried on the next connect.
      if (!delivered) {
        await _release(session, command);
        break;
      }

      sent++;
    }

    return sent;
  }

  /// Moves [command] to `sent` only if its id, status and attempt count still
  /// match; returns `false` when another flush already changed the row.
  static Future<bool> _claim(
    Session session,
    DeviceCommand command,
    DateTime now,
  ) async {
    final updated = await DeviceCommand.db.updateWhere(
      session,
      where: (t) =>
          t.id.equals(command.id!) &
          t.status.equals(command.status) &
          t.attempts.equals(command.attempts),
      columnValues: (t) => [
        t.status(statusSent),
        t.sentAt(now),
        t.attempts(command.attempts + 1),
      ],
    );
    return updated.isNotEmpty;
  }

  /// Reverts a row claimed by [_claim] but not delivered, unless an ack arrived
  /// in the meantime (its status is no longer `sent`).
  static Future<void> _release(Session session, DeviceCommand command) async {
    await DeviceCommand.db.updateWhere(
      session,
      where: (t) =>
          t.id.equals(command.id!) &
          t.status.equals(statusSent) &
          t.attempts.equals(command.attempts + 1),
      columnValues: (t) => [
        t.status(command.status),
        t.sentAt(command.sentAt),
        t.attempts(command.attempts),
      ],
    );
  }

  /// Offline devices are left untouched so their queue survives until they
  /// connect again.
  static Future<int> flushAllFor(
    Session session,
    List<int> deviceIds,
  ) async {
    final ids = deviceIds.toSet();
    if (ids.isEmpty) {
      return 0;
    }

    final devices = await Device.db.find(
      session,
      where: (t) => t.id.inSet(ids),
    );

    var sent = 0;
    for (final device in devices) {
      sent += await flushPending(session, device);
    }

    return sent;
  }

  /// A late ack after `timeout` reflects reality and is accepted; `acked` and
  /// `error` are terminal, so a repeat ack does not overwrite them.
  static const _ackableStatuses = <DeviceCommandStatus>{
    statusPending,
    statusSent,
    statusTimeout,
  };

  static Future<bool> acknowledge(
    Session session,
    String commandId, {
    required int deviceId,
    String? response,
    bool error = false,
  }) async {
    final normalized = commandId.trim();
    if (normalized.isEmpty) {
      return false;
    }

    final command = await DeviceCommand.db.findFirstRow(
      session,
      where: (t) =>
          t.commandId.equals(normalized) & t.deviceId.equals(deviceId),
    );
    if (command == null) {
      return false;
    }

    final updated = await DeviceCommand.db.updateWhere(
      session,
      where: (t) => t.id.equals(command.id!) & t.status.inSet(_ackableStatuses),
      columnValues: (t) => [
        t.status(error ? statusError : statusAcked),
        t.response(response),
        t.ackedAt(DateTime.now().toUtc()),
      ],
    );

    if (!error &&
        updated.isNotEmpty &&
        command.action == DeviceAction.get_installed_apps) {
      await _storeInstalledApps(session, deviceId, response);
    }

    return true;
  }

  /// A malformed response does not fail the ack: the error is logged and the
  /// command stays `acked`.
  static Future<void> _storeInstalledApps(
    Session session,
    int deviceId,
    String? response,
  ) async {
    try {
      final decoded = response == null ? null : jsonDecode(response);
      final apps = asList(asMap(decoded)['apps']);
      if (apps.isEmpty) {
        return;
      }
      await session.db.transaction(
        (transaction) => DeviceApplicationSyncService.upsert(
          session,
          transaction: transaction,
          deviceId: deviceId,
          apps: apps,
        ),
      );
    } catch (exception, stackTrace) {
      session.log(
        'Installed apps from command ack could not be stored',
        level: LogLevel.error,
        exception: exception,
        stackTrace: stackTrace,
        metadata: {'deviceId': deviceId},
      );
    }
  }

  /// The update is conditional on the status still matching, so a concurrent
  /// ack is not overwritten.
  static Future<int> markTimeouts(
    Session session, {
    Duration? timeout,
  }) async {
    final now = DateTime.now().toUtc();
    var closed = 0;

    Future<void> closeSent(
      Duration after,
      Expression Function(DeviceCommandTable t)? actionFilter,
    ) async {
      final cutoff = now.subtract(after);
      final updated = await DeviceCommand.db.updateWhere(
        session,
        where: (t) {
          final stale = t.status.equals(statusSent) & (t.sentAt < cutoff);
          return actionFilter == null ? stale : stale & actionFilter(t);
        },
        columnValues: (t) => [t.status(statusTimeout)],
      );
      closed += updated.length;
    }

    if (timeout != null) {
      await closeSent(timeout, null);
    } else {
      await closeSent(
        longTimeout,
        (t) => t.action.inSet(longRunningActions),
      );
      await closeSent(
        defaultTimeout,
        (t) => t.action.notInSet(longRunningActions),
      );
    }

    final pendingCutoff = now.subtract(pendingExpiry);
    final expired = await DeviceCommand.db.updateWhere(
      session,
      where: (t) =>
          t.status.equals(statusPending) & (t.createdAt < pendingCutoff),
      columnValues: (t) => [t.status(statusTimeout)],
    );
    closed += expired.length;

    return closed;
  }

  /// Stream payload shape the agent understands:
  /// `{"action": ..., "params": {...}}`.
  static String _commandPayload(DeviceCommand command) {
    final raw = command.params;
    Map<String, dynamic> params = const {};
    if (raw != null && raw.isNotEmpty) {
      final decoded = jsonDecode(raw);
      if (decoded is Map) {
        params = Map<String, dynamic>.from(decoded);
      }
    }

    return jsonEncode({'action': command.action.name, 'params': params});
  }
}
