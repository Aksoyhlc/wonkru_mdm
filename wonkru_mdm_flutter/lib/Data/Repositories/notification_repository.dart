import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../Client/serverpod_client.dart';

class NotificationRepository {
  const NotificationRepository._();

  static Future<DeviceNotificationPage> list(AdminListRequest request) =>
      serverpodClient.adminDeviceNotification.list(request);

  static Future<DeviceNotification> get(int notificationId) =>
      serverpodClient.adminDeviceNotification.get(notificationId);

  static Future<List<DeviceNotificationDeliveryRow>> deliveries(
    int notificationId,
  ) => serverpodClient.adminDeviceNotification.deliveries(notificationId);

  static Future<AdminDeviceNotificationCreateResponse> create(
    AdminDeviceNotificationCreateRequest request,
  ) => serverpodClient.adminDeviceNotification.create(request);

  static Future<int> delete(List<int> notificationIds) =>
      serverpodClient.adminDeviceNotification.delete(notificationIds);
}
