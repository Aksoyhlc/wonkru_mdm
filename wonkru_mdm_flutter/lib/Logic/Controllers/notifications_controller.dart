import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../Core/Constants/Enums/alert_enums.dart';
import '../../Core/Constants/Enums/notification_enums.dart';
import '../../Core/L10n/L.dart';
import '../../Data/Models/list_query.dart';
import '../../Data/Models/list_query_request.dart';
import '../../Data/Models/paged_result.dart';
import '../../Data/Repositories/notification_repository.dart';
import 'Base/paged_table_controller.dart';

class NotificationsController
    extends PagedTableController<DeviceNotificationRow> {
  NotificationsController() : super(pageSize: 25);

  @override
  Future<PagedResult<DeviceNotificationRow>> fetch(ListQuery query) async {
    final page = await NotificationRepository.list(buildRequest(query));

    return PagedResult(items: page.items, total: page.total);
  }

  static AdminListRequest buildRequest(ListQuery query) =>
      query.toAdminListRequest();

  static AdminDeviceNotificationCreateRequest buildCreateRequest({
    required String title,
    required String message,
    required String type,
    required Map<String, String> extra,
    required List<int> deviceIds,
  }) {
    final cleaned = <String, String>{
      for (final entry in extra.entries)
        if (entry.key.trim().isNotEmpty) entry.key.trim(): entry.value,
    };
    final normalizedType = type.trim().isEmpty
        ? NotificationType.normal.name
        : type.trim();

    return AdminDeviceNotificationCreateRequest(
      title: title.trim(),
      message: message.trim(),
      type: normalizedType,
      extra: cleaned.isEmpty ? null : cleaned,
      deviceIds: deviceIds,
    );
  }

  Future<int> create(AdminDeviceNotificationCreateRequest request) async {
    final response = await reloadAfter(
      () => NotificationRepository.create(request),
    );
    return response.deliveries.length;
  }

  Future<void> deleteRow(int notificationId) =>
      reloadAfter(() => NotificationRepository.delete([notificationId]));

  Future<int> deleteSelected() =>
      applyToSelected(NotificationRepository.delete);

  Future<List<DeviceNotificationDeliveryRow>> deliveries(int notificationId) =>
      NotificationRepository.deliveries(notificationId);

  static String typeLabel(String? type) {
    final value = type?.trim();
    if (value == null || value.isEmpty) return NotificationType.normal.label;
    return notificationTypeFromValue(value)?.label ?? value;
  }

  static String deliveryStatusLabel(NotificationDeliveryStatus status) =>
      switch (status) {
        NotificationDeliveryStatus.sent => L.common.statusSent,
        NotificationDeliveryStatus.received => L.common.statusReceived,
        NotificationDeliveryStatus.pending => L.common.statusPending,
        NotificationDeliveryStatus.failed => L.common.statusFailed,
      };

  static UiAlertTone deliveryStatusTone(NotificationDeliveryStatus status) =>
      switch (status) {
        NotificationDeliveryStatus.sent ||
        NotificationDeliveryStatus.received => UiAlertTone.success,
        NotificationDeliveryStatus.pending => UiAlertTone.warning,
        NotificationDeliveryStatus.failed => UiAlertTone.danger,
      };
}
