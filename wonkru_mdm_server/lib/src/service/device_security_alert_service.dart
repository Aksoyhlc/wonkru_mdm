import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../util/json_utils.dart';
import '../util/device_label.dart';
import 'device_security_alert_draft.dart';
import 'system_alert_dispatcher.dart';

/// Detection and delivery are separate: [detect] only reads inside the sync
/// transaction, and [dispatch] runs after it closes, so a failed notification
/// write or mail send cannot poison the PostgreSQL sync transaction ("current
/// transaction is aborted").
class DeviceSecurityAlertService {
  const DeviceSecurityAlertService._();

  /// Lets tests simulate a dispatch failure; when null the real
  /// [SystemAlertDispatcher] is used.
  @visibleForTesting
  static DeviceSecurityAlertSender? debugSender;

  /// Compares the previous [DeviceStateCache] row with the new sync's
  /// `systemSettings.security`: newly enabled ADB, developer options or root
  /// (`becameTrue`) produce a warning line. When the device's policy defines
  /// `allowed_accessibility_apps`, enabled accessibility packages not in the
  /// list are reported too, independently of the previous state.
  ///
  /// Read-only; must run before `updateFromSync` so the previous flattened state
  /// is still readable. Unexpected errors are logged and return `null`.
  static Future<DeviceSecurityAlertDraft?> detect(
    Session session,
    DeviceSync current, {
    Transaction? transaction,
  }) async {
    try {
      return await _detect(session, current, transaction: transaction);
    } catch (error, stackTrace) {
      session.log(
        'DeviceSecurityAlertService: security alert could not be detected',
        level: LogLevel.error,
        exception: error,
        stackTrace: stackTrace,
        metadata: {'deviceId': current.deviceId, 'syncId': current.id},
      );
      return null;
    }
  }

  /// Delivers the draft outside the sync transaction. A failed delivery (no
  /// setting, no target, unexpected error) is logged and does not affect the
  /// caller's flow.
  static Future<void> dispatch(
    Session session,
    DeviceSecurityAlertDraft? draft,
  ) async {
    if (draft == null) {
      return;
    }

    try {
      final sender = debugSender ?? _defaultSender;
      final recipientCount = await sender(
        session,
        title: draft.title,
        message: draft.message,
        data: draft.data,
      );

      session.log(
        'DeviceSecurityAlertService: security alert dispatched',
        level: LogLevel.info,
        metadata: {
          'deviceId': draft.data['device_id'],
          'syncId': draft.data['device_sync_id'],
          'recipientCount': recipientCount,
        },
      );
    } catch (error, stackTrace) {
      session.log(
        'DeviceSecurityAlertService: security alert could not be dispatched',
        level: LogLevel.error,
        exception: error,
        stackTrace: stackTrace,
        metadata: {
          'deviceId': draft.data['device_id'],
          'syncId': draft.data['device_sync_id'],
        },
      );
    }
  }

  static Future<int> _defaultSender(
    Session session, {
    required String title,
    required String message,
    required Map<String, dynamic> data,
  }) {
    return SystemAlertDispatcher.dispatch(
      session,
      type: SystemAlertType.security_info,
      title: title,
      message: message,
      data: data,
    );
  }

  static Future<DeviceSecurityAlertDraft?> _detect(
    Session session,
    DeviceSync current, {
    Transaction? transaction,
  }) async {
    final device = await Device.db.findById(
      session,
      current.deviceId,
      transaction: transaction,
    );
    if (device == null) {
      return null;
    }

    final previous = await DeviceStateCache.db.findFirstRow(
      session,
      where: (t) => t.deviceId.equals(current.deviceId),
      transaction: transaction,
    );

    final newSecurity = asMap(decodeJsonMap(current.systemInfo)['security']);

    final lines = <String>[
      ..._collectSecurityRiskLines(previous, newSecurity),
      ...await _collectAccessibilityViolationLines(
        session,
        device,
        current,
        transaction: transaction,
      ),
    ];

    if (lines.isEmpty) {
      return null;
    }

    return DeviceSecurityAlertDraft(
      title: 'Security change: ${deviceShortLabel(device)}',
      message: lines.join('\n'),
      data: {'device_id': device.id, 'device_sync_id': current.id},
    );
  }

  /// Produces a line when `adbEnabled`, `developerOptionsEnabled` or `isRooted`
  /// turned positive; on the first sync (no previous row) nothing is reported.
  static List<String> _collectSecurityRiskLines(
    DeviceStateCache? previous,
    Map<String, dynamic> newSecurity,
  ) {
    if (previous == null) {
      return const [];
    }

    final lines = <String>[];

    if (_becameTrue(
      previous.adbEnabled,
      asBoolOrNull(newSecurity['adbEnabled']),
    )) {
      lines.add('USB debugging (ADB) was enabled.');
    }

    if (_becameTrue(
      previous.developerOptionsEnabled,
      asBoolOrNull(newSecurity['developerOptionsEnabled']),
    )) {
      lines.add('Developer options were turned on or enabled.');
    }

    if (_becameTrue(previous.isRooted, asBoolOrNull(newSecurity['isRooted']))) {
      lines.add('Root / security scan: isRooted is now positive.');
    }

    return lines;
  }

  /// Produces a line for each accessibility package the policy does not allow.
  /// Nothing is reported when `allowed_accessibility_apps` is not defined.
  static Future<List<String>> _collectAccessibilityViolationLines(
    Session session,
    Device device,
    DeviceSync current, {
    Transaction? transaction,
  }) async {
    final policyId = device.policyId;
    if (policyId == null) {
      return const [];
    }

    final policy = await Policy.db.findById(
      session,
      policyId,
      transaction: transaction,
    );
    if (policy == null) {
      return const [];
    }

    final allowedRaw = deepGet(
      decodeJsonMap(policy.securitySettings),
      'allowed_accessibility_apps',
    );
    if (allowedRaw == null) {
      return const [];
    }

    final allowed = _normalizePackageList(allowedRaw);
    final enabled = _enabledAccessibilityPackages(current.systemInfo);

    final violations = <String>[
      for (final package in enabled)
        if (!allowed.contains(package)) package,
    ]..sort();

    return [
      for (final package in violations)
        'Accessibility app not allowed by policy: $package',
    ];
  }

  static List<String> _enabledAccessibilityPackages(String? systemInfo) {
    final security = asMap(decodeJsonMap(systemInfo)['security']);
    final apps = asList(security['enabledAccessibilityApps']);

    final out = <String>[];
    for (final value in apps) {
      if (value is String && value.isNotEmpty && !out.contains(value)) {
        out.add(value);
      }
    }

    return out;
  }

  static List<String> _normalizePackageList(dynamic raw) {
    final out = <String>[];
    for (final value in asList(raw)) {
      if (value is! String) {
        continue;
      }
      final trimmed = value.trim();
      if (trimmed.isEmpty || out.contains(trimmed)) {
        continue;
      }
      out.add(trimmed);
    }

    return out;
  }

  static bool _becameTrue(bool? oldValue, bool? newValue) =>
      newValue == true && oldValue != true;
}
