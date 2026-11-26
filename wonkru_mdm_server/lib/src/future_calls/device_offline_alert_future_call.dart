import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../service/admin_settings_service.dart';
import '../service/setting_service.dart';
import '../service/smtp_mail_service.dart';
import '../service/system_alert_dispatcher.dart';
import '../util/app_date_time.dart';
import '../util/device_label.dart';

class DeviceOfflineAlertFutureCall extends FutureCall {
  static const interval = Duration(minutes: 15);

  /// Never throws; errors are logged and the scheduled chain continues.
  Future<void> markOfflineDevices(Session session) async {
    try {
      await _sweep(session);
    } catch (error, stackTrace) {
      session.log(
        'DeviceOfflineAlert: offline alert sweep failed',
        level: LogLevel.error,
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }

  @visibleForTesting
  static SystemAlertMailSender debugMailSender = SmtpMailService.send;

  /// Repeat-prevention markers: a `device_id → ISO-8601` map in the `settings`
  /// table, so no new table/column is needed. Mail-only routing writes no in-app
  /// row, which is why the notification table alone is not enough.
  static const markerKey = 'device_offline_alert_last_sent';

  static Future<void> _sweep(Session session) async {
    final SettingsFormState state;
    try {
      state = await AdminSettingsService.read(session);
    } catch (error, stackTrace) {
      session.log(
        'DeviceOfflineAlert: settings could not be read, sweep skipped',
        level: LogLevel.error,
        exception: error,
        stackTrace: stackTrace,
      );
      return;
    }

    final now = DateTime.now().toUtc();
    final threshold = now.subtract(
      Duration(minutes: state.deviceAlertsOfflineMinutes),
    );
    final duplicateSince = now.subtract(
      Duration(hours: state.deviceAlertsDuplicatePreventionHours),
    );

    // Never-seen devices also count as offline.
    final devices = await Device.db.find(
      session,
      where: (t) => (t.lastSeenAt < threshold) | t.lastSeenAt.equals(null),
      orderBy: (t) => t.id,
    );

    if (devices.isEmpty) {
      session.log(
        'DeviceOfflineAlert: no offline device past the threshold',
        level: LogLevel.debug,
        metadata: {'offlineMinutes': state.deviceAlertsOfflineMinutes},
      );
      return;
    }

    final alreadyAlerted = <int>{
      ...await _recentlyAlertedDeviceIds(session, duplicateSince),
      ...await _recentlyAlertedFromMarker(session, duplicateSince),
    };

    final pending = [
      for (final device in devices)
        if (device.id != null && !alreadyAlerted.contains(device.id)) device,
    ];

    if (pending.isEmpty) {
      session.log(
        'DeviceOfflineAlert: all offline devices were alerted recently',
        level: LogLevel.debug,
        metadata: {'offlineDevices': devices.length},
      );
      return;
    }

    // Settings and the recipient list are fixed for the sweep: computed once so
    // the ~43-query settings read and the `AdminProfile` query are not repeated
    // per dispatch.
    Future<SettingsFormState> readSettings(
      Session session, {
      Transaction? transaction,
    }) async => state;
    final recipients = await _resolveRecipients(session);

    var dispatched = 0;
    final deliveredIds = <int>{};
    for (final device in pending) {
      final deviceId = device.id!;
      final offlineSince = device.lastSeenAt ?? device.createdAt ?? now;
      final minutes = now.difference(offlineSince).inMinutes;
      final deviceName = deviceShortLabel(device);
      final title = 'Device offline';
      final message =
          '$deviceName was last seen at ${formatDateTime(offlineSince)} '
          '(~$minutes min ago).';

      try {
        final delivered = await SystemAlertDispatcher.dispatch(
          session,
          type: SystemAlertType.device_offline,
          title: title,
          message: message,
          data: {
            'device_id': deviceId,
            'offline_since': offlineSince.toIso8601String(),
            'minutes': minutes,
          },
          userIds: recipients,
          readSettings: readSettings,
          mailSender: debugMailSender,
        );
        // Mark only devices that were actually delivered; skipped routes such as
        // sms-only must be retried on every sweep.
        if (delivered > 0) {
          deliveredIds.add(deviceId);
          dispatched++;
        }
      } catch (error, stackTrace) {
        // One device's dispatch failure must not block the others.
        session.log(
          'DeviceOfflineAlert: alert could not be dispatched',
          level: LogLevel.error,
          exception: error,
          stackTrace: stackTrace,
          metadata: {'deviceId': deviceId},
        );
      }
    }

    if (deliveredIds.isNotEmpty) {
      await _persistMarker(session, duplicateSince, deliveredIds, now);
    }

    session.log(
      'DeviceOfflineAlert: offline device sweep completed',
      metadata: {
        'offlineDevices': devices.length,
        'dispatched': dispatched,
        'duplicatePreventionHours': state.deviceAlertsDuplicatePreventionHours,
      },
    );
  }

  /// Resolves the alert recipients once.
  ///
  /// Future calls have no authenticated user in the session, so all admins who
  /// can reach the panel are returned in id order, matching
  /// [SystemAlertDispatcher]'s behaviour in that case.
  static Future<List<UuidValue>> _resolveRecipients(Session session) async {
    final admins = await AdminProfile.db.find(
      session,
      where: (t) => t.status.equals(AdminAccountStatus.active),
      orderBy: (t) => t.id,
    );

    return [for (final admin in admins) admin.userId];
  }

  /// Reads `device_id` from existing [AdminNotification] `data` JSON instead of
  /// adding a marker column or migration.
  static Future<Set<int>> _recentlyAlertedDeviceIds(
    Session session,
    DateTime duplicateSince,
  ) async {
    final rows = await AdminNotification.db.find(
      session,
      where: (t) =>
          t.type.equals(SystemAlertType.device_offline.name) &
          (t.createdAt >= duplicateSince),
      orderBy: (t) => t.id,
    );

    final ids = <int>{};
    for (final row in rows) {
      final deviceId = _deviceIdFromData(row.data);
      if (deviceId != null) {
        ids.add(deviceId);
      }
    }

    return ids;
  }

  /// Mail-only routing writes no notification row, so
  /// [_recentlyAlertedDeviceIds] is not enough; this is the real repeat guard.
  static Future<Set<int>> _recentlyAlertedFromMarker(
    Session session,
    DateTime duplicateSince,
  ) async {
    final marker = await _readMarker(session);

    return {
      for (final entry in marker.entries)
        if (!entry.value.isBefore(duplicateSince)) entry.key,
    };
  }

  static Future<Map<int, DateTime>> _readMarker(Session session) async {
    final raw = await SettingService.raw(session, markerKey);
    if (raw == null || raw.isEmpty) {
      return {};
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) {
        return {};
      }

      final marker = <int, DateTime>{};
      for (final entry in decoded.entries) {
        final deviceId = int.tryParse('${entry.key}');
        final at = DateTime.tryParse('${entry.value}');
        if (deviceId != null && at != null) {
          marker[deviceId] = at.toUtc();
        }
      }
      return marker;
    } on FormatException {
      return {};
    }
  }

  /// A failed marker write still leaves the sweep complete: the error is logged
  /// and the chain continues.
  static Future<void> _persistMarker(
    Session session,
    DateTime duplicateSince,
    Set<int> deliveredIds,
    DateTime now,
  ) async {
    try {
      final marker = await _readMarker(session);

      final updated = <String, String>{
        for (final entry in marker.entries)
          if (!entry.value.isBefore(duplicateSince))
            '${entry.key}': entry.value.toIso8601String(),
        for (final deviceId in deliveredIds) '$deviceId': now.toIso8601String(),
      };

      await SettingService.save(session, markerKey, jsonEncode(updated));
    } catch (error, stackTrace) {
      session.log(
        'DeviceOfflineAlert: alert marker could not be persisted',
        level: LogLevel.error,
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// The value may be a number or a numeric string; both are accepted.
  static int? _deviceIdFromData(String? data) {
    if (data == null || data.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(data);
      if (decoded is! Map) {
        return null;
      }

      final value = decoded['device_id'];
      if (value is int) {
        return value;
      }
      if (value is String) {
        return int.tryParse(value);
      }
    } on FormatException {
      return null;
    }

    return null;
  }
}
