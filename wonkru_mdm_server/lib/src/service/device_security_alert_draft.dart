import 'package:serverpod/serverpod.dart';

/// Security alert produced by [DeviceSecurityAlertService.detect] and awaiting
/// delivery.
///
/// Detection runs inside the sync transaction but delivery is deliberately kept
/// outside it, so the result is carried as a draft.
class DeviceSecurityAlertDraft {
  const DeviceSecurityAlertDraft({
    required this.title,
    required this.message,
    required this.data,
  });

  final String title;

  /// Notification body; lines are joined with `\n`.
  final String message;

  /// Extra data written to the `admin_notifications.data` column.
  final Map<String, dynamic> data;
}

/// Sends a security alert; tests inject a failing sender through
/// [DeviceSecurityAlertService.debugSender].
typedef DeviceSecurityAlertSender =
    Future<int> Function(
      Session session, {
      required String title,
      required String message,
      required Map<String, dynamic> data,
    });
