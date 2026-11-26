import 'package:get/get.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../Core/Constants/Enums/alert_enums.dart';
import '../../Core/Constants/Enums/system_alert_enums.dart';
import '../../Core/L10n/L.dart';
import '../../Data/Models/list_query.dart';
import '../../Data/Models/list_query_request.dart';
import '../../Data/Models/paged_result.dart';
import '../../Data/Repositories/admin_notification_repository.dart';
import '../../Data/Repositories/auth_repository.dart';
import 'Base/paged_table_controller.dart';

/// Also feeds the shell's unread badge: [unreadCount] is updated from the
/// `unreadNotificationCount` field of `me()`. Separate from the device
/// notifications page ([NotificationsController]).
class AdminNotificationsController extends PagedTableController<AdminNotification> {
  AdminNotificationsController() : super(pageSize: 25);

  final unreadCount = 0.obs;

  final unreadLoaded = false.obs;

  final recent = <AdminNotification>[].obs;

  final recentLoading = false.obs;

  final recentError = RxnString();

  static const recentLimit = 6;

  Future<void> loadRecent({int limit = recentLimit}) async {
    recentLoading.value = true;
    recentError.value = null;
    try {
      final page = await AdminNotificationRepository.list(
        buildRecentRequest(limit),
      );
      recent.assignAll(page.items);
    } catch (_) {
      recentError.value = L.common.notificationsLoadFailed;
    } finally {
      recentLoading.value = false;
    }
  }

  static AdminListRequest buildRecentRequest(int limit) => buildRequest(ListQuery(page: 0, pageSize: limit));

  @override
  Future<PagedResult<AdminNotification>> fetch(ListQuery query) async {
    final page = await AdminNotificationRepository.list(buildRequest(query));

    return PagedResult(items: page.items, total: page.total);
  }

  static AdminListRequest buildRequest(ListQuery query) => query.toAdminListRequest();

  Future<void> refreshUnread() async {
    try {
      final info = await AuthRepository.me();
      unreadCount.value = info.unreadNotificationCount;
      unreadLoaded.value = true;
    } catch (_) {}
  }

  Future<int> markRead(List<int> ids) => _updateRead(() => AdminNotificationRepository.markRead(ids));

  Future<int> markAllRead() => _updateRead(AdminNotificationRepository.markAllRead);

  Future<int> _updateRead(Future<int> Function() action) => reloadAfter(() async {
    final updated = await action();
    await refreshUnread();
    return updated;
  });

  static String typeLabel(String? type) {
    final value = type?.trim();
    if (value == null || value.isEmpty) return L.common.notification;
    return systemAlertTypeFromValue(value)?.label ?? value;
  }

  static UiAlertTone typeTone(String? type) => switch (type) {
    'device_offline' => UiAlertTone.warning,
    'policy_update_pending' => UiAlertTone.info,
    'security_info' => UiAlertTone.danger,
    _ => UiAlertTone.info,
  };

  static bool isRead(AdminNotification row) => row.readAt != null;
}
