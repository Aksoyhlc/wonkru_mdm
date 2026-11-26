import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../service/admin_auth_service.dart';
import '../../service/admin_scope_service.dart';
import '../../service/dashboard_service.dart';

/// Log cards and the log level chart live in the device log endpoint, not here.
class AdminDashboardEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {AdminScopeService.admin};

  Future<DashboardDeviceStats> deviceStats(Session session) async {
    await AdminAuthService.requireAdmin(session);

    return DashboardService.deviceStats(session);
  }

  Future<DashboardAlertStats> alertStats(Session session) async {
    await AdminAuthService.requireAdmin(session);

    return DashboardService.alertStats(session);
  }

  /// [filter] is one of `manufacturer`, `model` and `android_version`; anything
  /// else falls back to the manufacturer.
  Future<DashboardChart> deviceDistribution(
    Session session,
    String filter,
  ) async {
    await AdminAuthService.requireAdmin(session);

    return DashboardService.deviceDistribution(session, filter);
  }

  /// Covers the last 30 days.
  Future<DashboardChart> syncTrend(Session session) async {
    await AdminAuthService.requireAdmin(session);

    return DashboardService.syncTrend(session);
  }
}
