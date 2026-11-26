import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:wonkru_core_server/wonkru_core_server.dart'
    show DeviceAction, NotificationDeliveryStatus, NotificationType;

import '../generated/protocol.dart';
import 'device_command_service.dart';
import 'device_group_service.dart';

class DeviceNotificationService {
  const DeviceNotificationService._();

  static const statusSent = NotificationDeliveryStatus.sent;

  static const statusPending = NotificationDeliveryStatus.pending;

  static const statusFailed = NotificationDeliveryStatus.failed;

  static const statusReceived = NotificationDeliveryStatus.received;

  static Future<AdminDeviceNotificationCreateResponse> create(
    Session session,
    AdminDeviceNotificationCreateRequest request,
  ) async {
    final uuid = const Uuid().v7();
    final extra = _extra(request.extra, uuid);
    final deviceIds = request.deviceIds.toSet();
    final now = DateTime.now().toUtc();

    final notification = await DeviceNotification.db.insertRow(
      session,
      DeviceNotification(
        uuid: uuid,
        title: request.title,
        message: request.message,
        type: NotificationType.fromJson(request.type),
        extra: extra.isEmpty ? null : jsonEncode(extra),
        sentAt: deviceIds.isEmpty ? null : now,
        createdAt: now,
        updatedAt: now,
      ),
    );

    if (deviceIds.isEmpty) {
      return AdminDeviceNotificationCreateResponse(
        notification: notification,
        deliveries: const [],
      );
    }

    final devices = await Device.db.find(
      session,
      where: (t) => t.id.inSet(deviceIds),
    );

    for (final device in devices) {
      await _deliver(session, notification, device, now);
    }

    return AdminDeviceNotificationCreateResponse(
      notification: notification,
      deliveries: await deliveries(session, notification.id!),
    );
  }

  static Future<List<DeviceNotificationDeliveryRow>> deliveries(
    Session session,
    int notificationId, {
    Transaction? transaction,
  }) async {
    final rows = await DeviceNotificationDevice.db.find(
      session,
      where: (t) => t.deviceNotificationId.equals(notificationId),
      orderBy: (t) => t.id,
      transaction: transaction,
    );

    if (rows.isEmpty) {
      return const [];
    }

    final deviceIds = rows.map((row) => row.deviceId).toSet();
    final devices = await Device.db.find(
      session,
      where: (t) => t.id.inSet(deviceIds),
      transaction: transaction,
    );
    final byId = {for (final device in devices) device.id!: device};

    final groupNames = await DeviceGroupService.groupNamesForDevices(
      session,
      deviceIds,
      transaction: transaction,
    );

    return [
      for (final row in rows)
        DeviceNotificationDeliveryRow(
          delivery: row,
          device: byId[row.deviceId],
          groupNames: groupNames[row.deviceId] ?? const [],
        ),
    ];
  }

  static Future<Map<int, int>> deviceCounts(
    Session session,
    Iterable<int> notificationIds, {
    Transaction? transaction,
  }) async {
    final ids = notificationIds.toSet();
    if (ids.isEmpty) {
      return const {};
    }

    final rows = await DeviceNotificationDevice.db.find(
      session,
      where: (t) => t.deviceNotificationId.inSet(ids),
      transaction: transaction,
    );

    final counts = {for (final id in ids) id: 0};
    for (final row in rows) {
      final notificationId = row.deviceNotificationId;
      counts[notificationId] = (counts[notificationId] ?? 0) + 1;
    }

    return counts;
  }

  /// A device without a uuid can never be reached, so its row is recorded as
  /// failed. A queueing failure leaves the row at `pending`.
  static Future<void> _deliver(
    Session session,
    DeviceNotification notification,
    Device device,
    DateTime now,
  ) async {
    final deviceUuid = device.uuid;
    final reachable = deviceUuid != null && deviceUuid.isNotEmpty;

    final delivery = await DeviceNotificationDevice.db.insertRow(
      session,
      DeviceNotificationDevice(
        deviceNotificationId: notification.id!,
        deviceId: device.id!,
        status: reachable ? statusPending : statusFailed,
        createdAt: now,
        updatedAt: now,
      ),
    );

    if (!reachable) {
      delivery
        ..sentAt = now
        ..updatedAt = now;
      await DeviceNotificationDevice.db.updateRow(session, delivery);

      return;
    }

    try {
      final queued = await DeviceCommandService.enqueue(
        session,
        [device.id!],
        DeviceAction.send_notification,
        {
          'title': notification.title,
          'body': notification.message,
          if (notification.uuid != null) 'notification_uuid': notification.uuid,
          'type': notification.type.name,
        },
      );
      if (queued == 0) {
        return;
      }

      // Write `sent` before flushing: a fast device may ack during the flush
      // and set the row to `received`, which a later write must not overwrite.
      delivery
        ..status = statusSent
        ..sentAt = now
        ..updatedAt = now;
      await DeviceNotificationDevice.db.updateRow(session, delivery);

      await DeviceCommandService.flushAllFor(session, [device.id!]);
    } catch (exception, stackTrace) {
      session.log(
        'Notification queueing failed',
        level: LogLevel.error,
        exception: exception,
        stackTrace: stackTrace,
        metadata: {
          'notificationId': notification.id,
          'deviceId': device.id,
          'uuid': deviceUuid,
        },
      );

      return;
    }

    await markSentUnlessReceived(session, delivery.id!, now);
  }

  /// Marks the delivery `sent` unless the device already acked it (`received`).
  ///
  /// Public so a test can verify that a late write racing a fast device's ack
  /// does not overwrite the acked row.
  static Future<void> markSentUnlessReceived(
    Session session,
    int deliveryId,
    DateTime now,
  ) async {
    final delivery = await DeviceNotificationDevice.db.findById(
      session,
      deliveryId,
    );
    if (delivery == null || delivery.status == statusReceived) {
      return;
    }

    delivery
      ..status = statusSent
      ..sentAt = now
      ..updatedAt = now;
    await DeviceNotificationDevice.db.updateRow(session, delivery);
  }

  static Map<String, dynamic> _extra(
    Map<String, String>? extra,
    String uuid,
  ) {
    final merged = <String, dynamic>{'notification_uuid': uuid};

    for (final entry in extra?.entries ?? const <MapEntry<String, String>>[]) {
      final key = entry.key.trim();
      if (key.isNotEmpty) {
        merged[key] = entry.value;
      }
    }

    return merged;
  }
}
