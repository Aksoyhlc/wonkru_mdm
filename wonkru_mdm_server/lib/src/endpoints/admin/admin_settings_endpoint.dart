import 'package:serverpod/serverpod.dart';
import '../../service/smtp_test_service.dart';

import '../../generated/protocol.dart';
import '../../service/admin_auth_service.dart';
import '../../service/admin_scope_service.dart';
import '../../service/admin_settings_service.dart';
import '../../service/enrollment_key_service.dart';
import '../../service/mdm_agent_service.dart';
import '../../service/timezone_service.dart';
import 'admin_audit.dart';

class AdminSettingsEndpoint extends Endpoint with AdminAudit {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {AdminScopeService.admin};

  Future<SettingsFormState> get(Session session) async {
    await AdminAuthService.requireAdmin(session);

    return AdminSettingsService.read(session);
  }

  Future<String?> getMdmApkUrl(Session session) async {
    await AdminAuthService.requireAdmin(session);
    return (await MdmAgentService.download(session))?.url;
  }

  Future<void> save(Session session, SettingsFormState state) async {
    await AdminAuthService.requireAdmin(session);

    await AdminSettingsService.persist(session, state);

    await audit(
      session,
      action: 'settings.update',
      targetType: 'settings',
    );
  }

  /// Null when no timezone has been set.
  Future<String?> getTimezone(Session session) async {
    await AdminAuthService.requireAdmin(session);

    return TimezoneService.name(session);
  }

  /// Kept out of the settings form, which never writes this secret.
  Future<String> getEnrollmentKey(Session session) async {
    await AdminAuthService.requireAdmin(session);

    final key = await EnrollmentKeyService.current(session);
    await audit(
      session,
      action: 'settings.enrollment_key_view',
      targetType: 'settings',
    );
    return key;
  }

  /// Registered devices keep working; only new enrollments with the old key are
  /// rejected.
  Future<String> rotateEnrollmentKey(Session session) async {
    await AdminAuthService.requireAdmin(session);

    session.log('Device enrollment key rotated.');
    final key = await EnrollmentKeyService.rotate(session);

    await audit(
      session,
      action: 'settings.rotate_enrollment_key',
      targetType: 'settings',
    );

    return key;
  }

  Future<List<SmtpTestNotice>> sendSmtpTestMail(
    Session session,
    SettingsFormState state,
    String? recipient,
  ) async {
    await AdminAuthService.requireAdmin(session);

    final notices = await SmtpTestService.send(
      state,
      recipient,
    );
    await audit(
      session,
      action: 'settings.smtp_test',
      targetType: 'settings',
    );
    return notices;
  }
}
