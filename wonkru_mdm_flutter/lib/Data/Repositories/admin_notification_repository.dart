import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../Client/serverpod_client.dart';

/// Rows produced by the alert infrastructure (offline device, security,
/// policy update); distinct from device notifications.
class AdminNotificationRepository {
  const AdminNotificationRepository._();

  static Future<AdminNotificationPage> list(AdminListRequest request) =>
      serverpodClient.adminNotification.list(request);

  static Future<int> unreadCount() =>
      serverpodClient.adminNotification.unreadCount();

  static Future<int> markRead(List<int> ids) =>
      serverpodClient.adminNotification.markRead(ids);

  static Future<int> markAllRead() =>
      serverpodClient.adminNotification.markAllRead();
}
