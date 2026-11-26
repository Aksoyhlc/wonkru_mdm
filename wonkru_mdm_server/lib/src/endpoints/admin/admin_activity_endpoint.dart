import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../util/page_params.dart';
import '../../service/admin_activity_service.dart';
import '../../service/admin_auth_service.dart';
import '../../service/admin_scope_service.dart';

/// Audit trail; records are immutable by design — there is no edit or delete.
class AdminActivityEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {AdminScopeService.admin};

  static const maxPerPage = PageParams.maxPerPage;

  Future<AdminActivityPage> list(
    Session session,
    AdminActivityListRequest request,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final params = PageParams.from(request.page, request.perPage);

    return AdminActivityService.list(
      session,
      page: params.page,
      perPage: params.perPage,
      search: request.search,
      sortBy: request.sortBy,
      sortDesc: request.sortDesc,
      actorUserId: request.actorUserId,
      action: request.action,
      from: request.from,
      to: request.to,
    );
  }

  Future<List<String>> actions(Session session) async {
    await AdminAuthService.requireAdmin(session);

    return AdminActivityService.distinctActions(session);
  }
}
