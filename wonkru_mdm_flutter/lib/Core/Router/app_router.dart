import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../Core/L10n/L.dart';
import '../../Logic/Controllers/auth_controller.dart';
import '../../Views/Layout/app_shell.dart';
import '../../Views/Pages/Activity/admin_activity_page.dart';
import '../../Views/Pages/AdminNotifications/admin_notifications_page.dart';
import '../../Views/Pages/Applications/application_versions_route.dart';
import '../../Views/Pages/Applications/applications_page.dart';
import '../../Views/Pages/Auth/Widgets/access_denied_view.dart';
import '../../Views/Pages/Auth/login_page.dart';
import '../../Views/Pages/Certificates/certificates_page.dart';
import '../../Views/Pages/Dashboard/dashboard_page.dart';
import '../../Views/Pages/DeviceGroups/device_groups_page.dart';
import '../../Views/Pages/DeviceLogs/device_logs_page.dart';
import '../../Views/Pages/DeviceSyncs/device_sync_detail_page.dart';
import '../../Views/Pages/DeviceSyncs/device_syncs_page.dart';
import '../../Views/Pages/Devices/device_detail_page.dart';
import '../../Views/Pages/Devices/devices_page.dart';
import '../../Views/Pages/FileGroups/file_groups_page.dart';
import '../../Views/Pages/Files/files_page.dart';
import '../../Views/Pages/Notifications/notifications_page.dart';
import '../../Views/Pages/Policies/policies_page.dart';
import '../../Views/Pages/Policies/policy_editor_page.dart';
import '../../Views/Pages/Profile/profile_page.dart';
import '../../Views/Pages/ProvisioningProfiles/provisioning_profile_editor_page.dart';
import '../../Views/Pages/ProvisioningProfiles/provisioning_profiles_page.dart';
import '../../Views/Pages/Settings/settings_page.dart';
import '../../Views/Pages/Users/users_page.dart';
import '../../Views/Widgets/EmptyState/error_panel.dart';
import '../../Views/Widgets/Loading/app_loader.dart';
import '../Constants/Enums/auth_enums.dart';
import '../Theme/design.dart';
import 'app_routes.dart';

GoRouter createAppRouter({String initialLocation = AppRoutes.splash}) {
  final auth = Get.find<AuthController>();

  return GoRouter(
    initialLocation: initialLocation,
    refreshListenable: _AuthRefresh(auth),
    redirect: (context, state) => _redirect(auth, state),
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, _) => const Scaffold(body: Center(child: AppLoader(size: 28))),
      ),
      GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginPage()),
      GoRoute(
        path: AppRoutes.noAccess,
        builder: (_, _) => const AccessDeniedView(),
      ),
      GoRoute(
        path: AppRoutes.error,
        builder: (_, _) => Scaffold(
          body: Obx(
            () => ErrorPanel(
              message: auth.errorMessage.value ?? L.common.connectionError,
              onRetry: auth.init,
            ),
          ),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, navigationShell) => AppShell(navigationShell: navigationShell),
        branches: [
          _branch(AppRoutes.dashboard, (_, _) => const DashboardPage()),
          _branch(
            AppRoutes.devices,
            (_, _) => const DevicesPage(),
            routes: [
              GoRoute(
                path: ':id',
                pageBuilder: (context, state) => _fadePage(
                  context,
                  state,
                  DeviceDetailPage(
                    deviceId: _id(state) ?? 0,
                    initialTab: state.uri.queryParameters['tab'],
                  ),
                ),
              ),
            ],
          ),
          _branch(
            AppRoutes.policies,
            (_, _) => const PoliciesPage(),
            routes: [
              GoRoute(
                path: AppRoutes.newSegment,
                pageBuilder: (context, state) => _fadePage(context, state, const PolicyEditorPage()),
              ),
              GoRoute(
                path: ':id',
                pageBuilder: (context, state) => _fadePage(
                  context,
                  state,
                  PolicyEditorPage(policyId: _id(state)),
                ),
              ),
            ],
          ),
          _branch(
            AppRoutes.applications,
            (_, _) => const ApplicationsPage(),
            routes: [
              GoRoute(
                path: ':id/versions',
                pageBuilder: (context, state) => _fadePage(
                  context,
                  state,
                  ApplicationVersionsRoute(
                    applicationId: _id(state) ?? 0,
                    application: state.extra is Application ? state.extra as Application : null,
                    openUploadOnStart: state.uri.queryParameters['upload'] == '1',
                  ),
                ),
              ),
            ],
          ),
          _branch(AppRoutes.certificates, (_, _) => const CertificatesPage()),
          _branch(AppRoutes.files, (_, _) => const FilesPage()),
          _branch(AppRoutes.fileGroups, (_, _) => const FileGroupsPage()),
          _branch(AppRoutes.deviceGroups, (_, _) => const DeviceGroupsPage()),
          _branch(AppRoutes.deviceLogs, (_, _) => const DeviceLogsPage()),
          _branch(
            AppRoutes.deviceSyncs,
            (_, _) => const DeviceSyncsPage(),
            routes: [
              GoRoute(
                path: ':id',
                pageBuilder: (context, state) => _fadePage(
                  context,
                  state,
                  DeviceSyncDetailPage(syncId: _id(state) ?? 0),
                ),
              ),
            ],
          ),
          _branch(AppRoutes.notifications, (_, _) => const NotificationsPage()),
          _branch(
            AppRoutes.adminNotifications,
            (_, _) => const AdminNotificationsPage(),
          ),
          _branch(
            AppRoutes.provisioningProfiles,
            (_, _) => const ProvisioningProfilesPage(),
            routes: [
              GoRoute(
                path: AppRoutes.newSegment,
                pageBuilder: (context, state) => _fadePage(
                  context,
                  state,
                  const ProvisioningProfileEditorPage(),
                ),
              ),
              GoRoute(
                path: ':id',
                pageBuilder: (context, state) => _fadePage(
                  context,
                  state,
                  ProvisioningProfileEditorPage(profileId: _id(state)),
                ),
              ),
            ],
          ),
          _branch(AppRoutes.settings, (_, _) => const SettingsPage()),
          _branch(AppRoutes.users, (_, _) => const UsersPage()),
          _branch(AppRoutes.activity, (_, _) => const ActivityPage()),
          _branch(AppRoutes.profile, (_, _) => const ProfilePage()),
        ],
      ),
    ],
  );
}

CustomTransitionPage<void> _fadePage(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    transitionDuration: AppMotion.of(context, AppMotion.base),
    reverseTransitionDuration: AppMotion.of(context, AppMotion.base),
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return AnimatedBuilder(
        animation: animation,
        child: child,
        builder: (context, child) {
          final reduced = AppMotion.reduced(context);
          final curve = animation.status == AnimationStatus.reverse ? AppMotion.exit : AppMotion.enter;
          final value = reduced ? 1.0 : curve.transform(animation.value);
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, -AppMotion.distance * (1 - value)),
              child: child,
            ),
          );
        },
      );
    },
  );
}

StatefulShellBranch _branch(
  String path,
  Widget Function(BuildContext, GoRouterState) builder, {
  List<RouteBase> routes = const [],
}) => StatefulShellBranch(
  routes: [GoRoute(path: path, builder: builder, routes: routes)],
);

int? _id(GoRouterState state) => int.tryParse(state.pathParameters['id'] ?? '');

String? _redirect(AuthController auth, GoRouterState state) {
  final location = state.matchedLocation;
  final target = _isEntryRoute(location) ? _returnTarget(state.uri.queryParameters['from']) : state.uri.toString();

  String? entryRedirect(String path) {
    if (location == path) return null;
    return Uri(
      path: path,
      queryParameters: target == null ? null : {'from': target},
    ).toString();
  }

  switch (auth.status.value) {
    case AuthStatus.loading:
      return entryRedirect(AppRoutes.splash);
    case AuthStatus.signedOut:
      return entryRedirect(AppRoutes.login);
    case AuthStatus.awaitingTwoFactor:
      return entryRedirect(AppRoutes.login);
    case AuthStatus.noAccess:
      return entryRedirect(AppRoutes.noAccess);
    case AuthStatus.failed:
      return entryRedirect(AppRoutes.error);
    case AuthStatus.ready:
      if (!_isEntryRoute(location)) return null;
      return target ?? AppRoutes.dashboard;
  }
}

/// Only accepts in-panel targets; prevents a redirect loop back to the entry
/// screens.
String? _returnTarget(String? value) {
  if (value == null || value.isEmpty) return null;
  final uri = Uri.tryParse(value);
  if (uri == null || uri.hasScheme || uri.hasAuthority || !uri.path.startsWith('/') || _isEntryRoute(uri.path)) {
    return null;
  }
  return uri.toString();
}

bool _isEntryRoute(String location) => const {
  AppRoutes.splash,
  AppRoutes.login,
  AppRoutes.noAccess,
  AppRoutes.error,
}.contains(location);

class _AuthRefresh extends ChangeNotifier {
  _AuthRefresh(AuthController auth) {
    _worker = ever(auth.status, (_) => notifyListeners());
  }

  late final Worker _worker;

  @override
  void dispose() {
    _worker.dispose();
    super.dispose();
  }
}
