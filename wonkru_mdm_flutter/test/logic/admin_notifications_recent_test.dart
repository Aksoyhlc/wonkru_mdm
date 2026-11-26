import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_flutter/Logic/Controllers/admin_notifications_controller.dart';

void main() {
  test('buildRecentRequest sets the first page and the given limit', () {
    final request = AdminNotificationsController.buildRecentRequest(6);

    expect(request.page, 1);
    expect(request.perPage, 6);
    expect(request.search, isNull);
  });

  test('buildRecentRequest carries the limit as-is', () {
    expect(AdminNotificationsController.buildRecentRequest(12).perPage, 12);
  });

  test('the popup requests 6 notifications by default', () {
    expect(AdminNotificationsController.recentLimit, 6);
  });
}
