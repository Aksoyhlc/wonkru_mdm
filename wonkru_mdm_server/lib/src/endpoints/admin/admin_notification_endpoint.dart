import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../util/page_params.dart';
import '../../service/admin_auth_service.dart';
import '../../service/admin_scope_service.dart';
import '../../service/admin_notification_service.dart';

class AdminNotificationEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {AdminScopeService.admin};

  static const maxPerPage = PageParams.maxPerPage;

  Future<AdminNotificationPage> list(
    Session session,
    AdminListRequest request,
  ) async {
    final profile = await AdminAuthService.requireAdmin(session);

    final params = PageParams.from(request.page, request.perPage);

    return AdminNotificationService.list(
      session,
      page: params.page,
      perPage: params.perPage,
      userId: profile.userId,
    );
  }

  Future<int> unreadCount(Session session) async {
    final profile = await AdminAuthService.requireAdmin(session);

    return AdminNotificationService.unreadCount(session, profile.userId);
  }

  /// Notifications owned by another user are silently skipped.
  Future<int> markRead(Session session, List<int> ids) async {
    final profile = await AdminAuthService.requireAdmin(session);

    return AdminNotificationService.markRead(session, ids, profile.userId);
  }

  Future<int> markAllRead(Session session) async {
    final profile = await AdminAuthService.requireAdmin(session);

    return AdminNotificationService.markAllRead(session, profile.userId);
  }
}
