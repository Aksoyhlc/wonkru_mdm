import 'package:serverpod/serverpod.dart';

import 'policy_version_service.dart';

/// A certificate change alters every policy payload that installs it, so the
/// affected policies are bumped.
class CertificateService {
  const CertificateService._();

  static Future<void> bumpAffectedPolicies(
    Session session,
    int certificateId, {
    Transaction? transaction,
  }) async {
    await PolicyVersionService.bumpForCertificate(
      session,
      certificateId,
      transaction: transaction,
    );
  }
}
