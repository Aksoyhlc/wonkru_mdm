import 'dart:async';
import 'dart:convert';

import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Constants/Enums/device_action.dart';
import 'package:wonkrumdm/Core/Extensions/enum.dart';
import 'package:wonkrumdm/Core/Extensions/string.dart';
import 'package:wonkrumdm/Core/Managers/device_action_manager.dart';

import 'command_outcome.dart';

const _tag = 'CommandProcessor';

/// Decodes a server command (`{action, params}`), delegates to
/// [DeviceActionManager], and builds the ack body.
class CommandProcessor {
  static final CommandProcessor _instance = CommandProcessor._internal();

  static CommandProcessor get instance => _instance;

  CommandProcessor._internal();

  /// A policy command received before this is already covered by the config the
  /// last apply fetched; it is acked as success without re-applying. This
  /// coalesces bursts while keeping the newest change.
  DateTime? _lastPolicyApplyStartedAt;

  /// Serializes policy commands; a concurrent second call waits for the first.
  Future<void> _policyLock = Future<void>.value();

  Future<Map<String, dynamic>?> processMessage(String message) async {
    return (await processCommand(message)).ack;
  }

  /// Processes a command; [receivedAt] is when it reached the device (used for
  /// coalescing).
  Future<CommandOutcome> processCommand(String message, {DateTime? receivedAt}) async {
    final received = receivedAt ?? DateTime.now();
    try {
      WLog.v(_tag, 'Command received');

      final Map<String, dynamic> data = jsonDecode(message);
      String action = data['action'].toString();
      final params = (data['params'] ?? data) is Map
          ? Map<String, dynamic>.from(data['params'] ?? data)
          : <String, dynamic>{};

      if (action.isNullOrEmpty) {
        WLog.e(_tag, 'Command type/action is null');
        return CommandOutcome(_jsonNo('Command type/action is missing'));
      }

      final DeviceAction? deviceAction =
          DeviceAction.values.tryFromValue(action) ?? DeviceAction.values.tryFromValue(action.toLowerCase());

      if (deviceAction == null) {
        WLog.w(_tag, 'Unknown action: $action');
        return CommandOutcome(_jsonNo('Unknown action: $action'));
      }

      switch (deviceAction) {
        case DeviceAction.reboot:
          return await _prepareReboot(action);
        case DeviceAction.updatePolicy:
        case DeviceAction.policyChange:
          return CommandOutcome(await _runPolicyAction(deviceAction, action, params, received));
        default:
          return CommandOutcome(await _execute(deviceAction, action, params));
      }
    } catch (e, st) {
      // Do not leak the raw error to the panel; the detail is logged.
      WLog.e(_tag, 'Message processing error (payloadLength=${message.length})', error: e, stackTrace: st);
      return CommandOutcome(_jsonNo('Command could not be processed'));
    }
  }

  Future<CommandOutcome> _prepareReboot(String action) async {
    final actions = DeviceActionManager();
    final (ok, data) = await actions.checkRebootAllowed();
    if (!ok) {
      return CommandOutcome(_jsonNo(data['message']?.toString() ?? 'Failed to execute action: $action', data));
    }
    return CommandOutcome(_jsonOk('Reboot scheduled', {'action': action}), afterAck: actions.rebootAfterAck);
  }

  Future<Map<String, dynamic>> _runPolicyAction(
    DeviceAction deviceAction,
    String action,
    Map<String, dynamic> params,
    DateTime receivedAt,
  ) async {
    final previous = _policyLock;
    final done = Completer<void>();
    _policyLock = done.future;
    try {
      await previous;
      final lastStart = _lastPolicyApplyStartedAt;
      if (lastStart != null && receivedAt.isBefore(lastStart)) {
        WLog.d(_tag, '$action skipped (covered by an apply started after it was received)');
        return _jsonOk('$action skipped (debounced: covered by a newer apply)', {'action': action});
      }
      final startedAt = DateTime.now();
      final result = await _execute(deviceAction, action, params);
      if (result['success'] == true) _lastPolicyApplyStartedAt = startedAt;
      return result;
    } finally {
      done.complete();
    }
  }

  Future<Map<String, dynamic>> _execute(DeviceAction deviceAction, String action, Map<String, dynamic> params) async {
    final resultTuple = await DeviceActionManager().executeAction(deviceAction, params: params);

    final bool success = resultTuple?.$1 ?? false;
    final Map<String, dynamic> resultData = resultTuple?.$2 ?? {};

    if (success) {
      if (resultData.isNotEmpty) {
        return _jsonOk('Action $action executed successfully', {'action': action, ...resultData});
      }
      return _jsonOk('Action $action executed successfully');
    }
    return _jsonNo(resultData['message']?.toString() ?? 'Failed to execute action: $action', resultData);
  }

  Map<String, dynamic> _jsonOk(String message, [Map<String, dynamic>? extras]) {
    return {'success': true, 'status': 'success', 'message': message, ...?extras};
  }

  /// Error envelope; [extras] (e.g. `policy_result`) are kept, but
  /// `success`/`status` always stay the error values.
  Map<String, dynamic> _jsonNo(String message, [Map<String, dynamic>? extras]) {
    return {...?extras, 'success': false, 'status': 'error', 'message': message};
  }
}
