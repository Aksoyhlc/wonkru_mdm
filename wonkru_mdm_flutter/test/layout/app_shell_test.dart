import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_flutter/Core/Constants/Enums/auth_enums.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/L.dart';
import 'package:wonkru_mdm_flutter/Core/Router/app_routes.dart';
import 'package:wonkru_mdm_flutter/Views/Layout/Widgets/sidebar.dart';
import 'package:wonkru_mdm_flutter/Views/Layout/app_shell.dart';

import '../auth/auth_routing_test.dart';

void useSurface(WidgetTester tester, Size size) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);
}

void main() {
  group('wide screen', () {
    testWidgets('sidebar is always visible', (tester) async {
      useSurface(tester, const Size(1400, 900));
      final router = await pumpRouter(tester, AuthStatus.ready);

      expect(find.byType(AppShell), findsOneWidget);
      expect(find.byType(Sidebar), findsOneWidget);
      expect(find.text(L.common.navDashboard), findsWidgets);
      expect(locationOf(router), AppRoutes.dashboard);
    });

    testWidgets('sidebar section selection changes the address', (
      tester,
    ) async {
      useSurface(tester, const Size(1400, 900));
      final router = await pumpRouter(tester, AuthStatus.ready);

      await tester.tap(find.text(L.common.navCertificates).first);
      await tester.pumpAndSettle();

      expect(locationOf(router), AppRoutes.certificates);
    });
  });

  group('narrow screen', () {
    testWidgets('sidebar is closed on start', (tester) async {
      useSurface(tester, const Size(412, 915));
      await pumpRouter(tester, AuthStatus.ready);

      expect(find.byType(AppShell), findsOneWidget);
      expect(find.byType(Sidebar), findsNothing);
      expect(find.byType(Drawer), findsNothing);
    });

    testWidgets('menu button opens the drawer, selection closes it', (
      tester,
    ) async {
      useSurface(tester, const Size(412, 915));
      final router = await pumpRouter(tester, AuthStatus.ready);

      await tester.tap(find.byTooltip(L.common.menu));
      await tester.pumpAndSettle();
      expect(find.byType(Sidebar), findsOneWidget);

      await tester.tap(find.text(L.common.navCertificates).first);
      await tester.pumpAndSettle();

      expect(locationOf(router), AppRoutes.certificates);
      expect(find.byType(Sidebar), findsNothing);
    });
  });
}
