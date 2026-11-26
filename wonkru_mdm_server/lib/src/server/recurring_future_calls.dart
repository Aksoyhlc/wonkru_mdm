import 'dart:io';

import '../future_calls/admin_two_factor_cleanup_future_call.dart';
import '../future_calls/device_offline_alert_future_call.dart';
import '../generated/serverpod.dart';

/// Registers the server's recurring future calls.
///
/// Serverpod has no idempotent "ensure scheduled": every registration appends a
/// new chain, so each identifier is cancelled first. A failure to schedule one
/// job is logged and does not stop the others or block startup.
class RecurringFutureCalls {
  const RecurringFutureCalls._();

  static const _deviceCommandTimeouts = 'device-command-timeouts';
  static const _deviceOfflineAlerts = 'device-offline-alerts';
  static const _adminTotpCleanup = 'admin-totp-cleanup';

  static Future<void> scheduleAll(Serverpod pod) async {
    await _schedule(
      pod,
      _deviceCommandTimeouts,
      (identifier) => pod.futureCalls
          .callRecurring(identifier: identifier)
          .every(const Duration(minutes: 1))
          .deviceCommandTimeout
          .markTimeouts(),
    );

    await _schedule(
      pod,
      _deviceOfflineAlerts,
      (identifier) => pod.futureCalls
          .callRecurring(identifier: identifier)
          .every(DeviceOfflineAlertFutureCall.interval)
          .deviceOfflineAlert
          .markOfflineDevices(),
    );

    await _schedule(
      pod,
      _adminTotpCleanup,
      (identifier) => pod.futureCalls
          .callRecurring(identifier: identifier)
          .every(AdminTwoFactorCleanupFutureCall.interval)
          .adminTwoFactorCleanup
          .purgeExpiredVerifications(),
    );
  }

  static Future<void> _schedule(
    Serverpod pod,
    String identifier,
    Future<void> Function(String identifier) register,
  ) async {
    try {
      await pod.futureCalls.cancel(identifier);
      await register(identifier);
    } catch (error, stackTrace) {
      stderr.writeln('$identifier: could not schedule recurring call: $error');
      stderr.writeln(stackTrace);
    }
  }
}
