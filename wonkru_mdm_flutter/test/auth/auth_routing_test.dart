import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:wonkru_mdm_flutter/Core/Constants/Enums/auth_enums.dart';
import 'package:wonkru_mdm_flutter/Core/Init/dependency_injection.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/L.dart';
import 'package:wonkru_mdm_flutter/Core/Router/app_router.dart';
import 'package:wonkru_mdm_flutter/Core/Router/app_routes.dart';
import 'package:wonkru_mdm_flutter/Core/Theme/app_theme.dart';
import 'package:wonkru_mdm_flutter/Logic/Controllers/auth_controller.dart';
import 'package:wonkru_mdm_flutter/Views/Layout/app_shell.dart';
import 'package:wonkru_mdm_flutter/Views/Pages/Auth/Widgets/access_denied_view.dart';

class _FakeAuthController extends AuthController {
  _FakeAuthController(this._target);

  final AuthStatus _target;

  @override
  Future<void> init() async {
    needsBootstrap.value = _target == AuthStatus.noAccess;
    status.value = _target;
  }
}

class _FakeTwoFactorAuthController extends AuthController {
  @override
  Future<void> init() async {
    status.value = AuthStatus.awaitingTwoFactor;
  }

  @override
  Future<bool> signIn(String email, String password) async {
    await init();
    return true;
  }
}

/// Overrides the network calls so the controller's real `bootstrap` body is
/// exercised.
class _FakeBootstrapAuthController extends AuthController {
  _FakeBootstrapAuthController({this.failBootstrap = false});

  final bool failBootstrap;
  int requestCalls = 0;

  @override
  Future<void> init() async {
    needsBootstrap.value = true;
    status.value = AuthStatus.noAccess;
  }

  @override
  Future<void> requestBootstrap(String email, String password) async {
    requestCalls++;
    if (failBootstrap) throw Exception('bootstrap failed');
  }
}

Future<GoRouter> pumpRouter(
  WidgetTester tester,
  AuthStatus target, {
  String at = AppRoutes.splash,
}) async {
  return pumpRouterWith(tester, _FakeAuthController(target), at: at);
}

Future<GoRouter> pumpRouterWith(
  WidgetTester tester,
  AuthController auth, {
  String at = AppRoutes.splash,
}) async {
  Get.testMode = true;
  Get.reset();
  // initCore leaves an already-registered AuthController in place.
  Get.put<AuthController>(auth, permanent: true);
  await DependencyInjection.initCore();
  await auth.init();

  final router = createAppRouter(initialLocation: at);
  await tester.pumpWidget(
    MaterialApp.router(
      theme: AppTheme.light(),
      routerConfig: router,
    ),
  );
  await tester.pumpAndSettle();
  return router;
}

String locationOf(GoRouter router) =>
    router.routerDelegate.currentConfiguration.uri.toString();

void main() {
  testWidgets('noAccess routes to the access denied screen', (tester) async {
    final router = await pumpRouter(tester, AuthStatus.noAccess);

    expect(find.byType(AccessDeniedView), findsOneWidget);
    expect(find.byType(AppShell), findsNothing);
    expect(locationOf(router), AppRoutes.noAccess);
  });

  testWidgets('ready opens the shell and the location becomes /dashboard', (
    tester,
  ) async {
    final router = await pumpRouter(tester, AuthStatus.ready);

    expect(find.byType(AppShell), findsOneWidget);
    expect(find.text(L.common.navDashboard), findsWidgets);
    expect(locationOf(router), AppRoutes.dashboard);
  });

  testWidgets('failed shows the retry panel', (tester) async {
    final router = await pumpRouter(tester, AuthStatus.failed);

    expect(find.text(L.common.retry), findsOneWidget);
    expect(find.byType(AppShell), findsNothing);
    expect(locationOf(router), AppRoutes.error);
  });

  testWidgets('a deep link is kept for after sign-in while signed out', (
    tester,
  ) async {
    final router = await pumpRouter(
      tester,
      AuthStatus.signedOut,
      at: AppRoutes.device(42),
    );

    expect(
      locationOf(router),
      '${AppRoutes.login}?from=${Uri.encodeComponent(AppRoutes.device(42))}',
    );
  });

  testWidgets('a section route can be opened directly', (tester) async {
    final router = await pumpRouter(
      tester,
      AuthStatus.ready,
      at: AppRoutes.certificates,
    );

    expect(find.byType(AppShell), findsOneWidget);
    expect(locationOf(router), AppRoutes.certificates);
  });

  testWidgets(
    'the code step is shown in a session awaiting 2FA, the shell does not open',
    (
      tester,
    ) async {
      final router = await pumpRouterWith(
        tester,
        _FakeTwoFactorAuthController(),
        at: AppRoutes.devices,
      );

      expect(find.text(L.common.twoFactorTitle), findsOneWidget);
      expect(find.byType(AppShell), findsNothing);
      expect(locationOf(router), startsWith(AppRoutes.login));
    },
  );

  testWidgets(
    'if 2FA is on after sign-in the sign-in card switches to the code step',
    (
      tester,
    ) async {
      final auth = _FakeTwoFactorAuthController();
      await pumpRouterWith(tester, auth, at: AppRoutes.login);

      expect(find.text(L.common.verificationCode), findsOneWidget);
      expect(find.text(L.common.signIn), findsNothing);

      await auth.signIn('admin@example.com', 'secret-password');
      await tester.pumpAndSettle();

      expect(find.text(L.common.verify), findsOneWidget);
    },
  );

  testWidgets('a successful bootstrap redirects to sign-in', (tester) async {
    final auth = _FakeBootstrapAuthController();
    final router = await pumpRouterWith(
      tester,
      auth,
      at: AppRoutes.noAccess,
    );

    final ok = await auth.bootstrap('a@example.com', 'password');
    await tester.pumpAndSettle();

    expect(ok, isTrue);
    expect(auth.requestCalls, 1);
    expect(auth.status.value, AuthStatus.signedOut);
    expect(auth.needsBootstrap.value, isFalse);
    expect(find.byType(AccessDeniedView), findsNothing);
    expect(locationOf(router), startsWith(AppRoutes.login));

    // Let the notification timer complete so it isn't left pending.
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('the state does not change when bootstrap fails', (tester) async {
    final auth = _FakeBootstrapAuthController(failBootstrap: true);
    final router = await pumpRouterWith(
      tester,
      auth,
      at: AppRoutes.noAccess,
    );

    final ok = await auth.bootstrap('a@example.com', 'password');
    await tester.pumpAndSettle();

    expect(ok, isFalse);
    expect(auth.status.value, AuthStatus.noAccess);
    expect(auth.needsBootstrap.value, isTrue);
    expect(locationOf(router), AppRoutes.noAccess);
  });
}
