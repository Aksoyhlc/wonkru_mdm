import 'package:serverpod/serverpod.dart';

import '../../service/admin_activity_service.dart';

/// Audit writes never break the main operation; the service swallows its own
/// errors.
mixin AdminAudit on Endpoint {
  /// [actorUserId] defaults to the session user; callers without a session
  /// (e.g. failed logins) pass the identity explicitly.
  Future<void> audit(
    Session session, {
    required String action,
    String? targetType,
    Object? targetId,
    Map<String, Object?>? data,
    UuidValue? actorUserId,
    String? actorEmail,
    String? actorName,
  }) {
    return AdminActivityService.record(
      session,
      action: action,
      targetType: targetType,
      targetId: targetId,
      data: data,
      actorUserId: actorUserId,
      actorEmail: actorEmail,
      actorName: actorName,
    );
  }
}
