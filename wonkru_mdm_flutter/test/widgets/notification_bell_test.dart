import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';
import 'package:wonkru_mdm_flutter/Core/Init/dependency_injection.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/L.dart';
import 'package:wonkru_mdm_flutter/Core/Theme/app_theme.dart';
import 'package:wonkru_mdm_flutter/Logic/Controllers/admin_notifications_controller.dart';
import 'package:wonkru_mdm_flutter/Views/Layout/Widgets/notification_bell.dart';

/// Regression: `MenuAnchor` measures its child's intrinsic size, and a lazy
/// viewport (`ListView`) in the popup body throws
/// "RenderShrinkWrappingViewport does not support returning intrinsic
/// dimensions". This test catches that class of failure.
void main() {
  testWidgets('bell popup draws a full list without error', (tester) async {
    Get.testMode = true;
    Get.reset();
    await DependencyInjection.initCore();

    Get.find<AdminNotificationsController>().recent.assignAll([
      AdminNotification(
        userId: UuidValue.fromString('11111111-1111-4111-8111-111111111111'),
        type: 'device_offline',
        title: 'Device went offline',
        message: 'Test device has been offline for 10 minutes.',
        createdAt: DateTime.now().toUtc(),
      ),
      AdminNotification(
        userId: UuidValue.fromString('11111111-1111-4111-8111-111111111111'),
        type: 'security_info',
        title: 'Security alert',
        message: 'A read notification.',
        readAt: DateTime.now().toUtc(),
        createdAt: DateTime.now().toUtc(),
      ),
    ]);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(body: Center(child: NotificationBell())),
      ),
    );
    await tester.pump();

    await tester.tap(find.byIcon(LucideIcons.bell));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Device went offline'), findsOneWidget);
    expect(find.text('Security alert'), findsOneWidget);
    expect(find.text(L.common.viewAll), findsOneWidget);
  });
}
