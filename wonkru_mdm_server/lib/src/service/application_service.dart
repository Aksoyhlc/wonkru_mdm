import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'policy_version_service.dart';

/// The policy payload embeds each application together with its pinned version,
/// so any change to an application invalidates every policy referencing it.
class ApplicationService {
  const ApplicationService._();

  static Future<List<int>> affectedPolicyIds(
    Session session,
    int applicationId, {
    Transaction? transaction,
  }) => PolicyVersionService.policyIdsForApplication(
    session,
    applicationId,
    transaction: transaction,
  );

  static Future<void> bumpAffectedPolicies(
    Session session,
    int applicationId, {
    Transaction? transaction,
  }) async {
    await PolicyVersionService.bumpForApplication(
      session,
      applicationId,
      transaction: transaction,
    );
  }

  // Collect the affected policy ids before removing the application's policy
  // entries; afterwards the lookup would come back empty.
  static Future<void> onDeleting(
    Session session,
    int applicationId, {
    Transaction? transaction,
  }) async {
    final policyIds = await affectedPolicyIds(
      session,
      applicationId,
      transaction: transaction,
    );

    final entries = await PolicyApplication.db.find(
      session,
      where: (t) => t.applicationId.equals(applicationId),
      transaction: transaction,
    );

    for (final entry in entries) {
      await PolicyApplication.db.deleteRow(
        session,
        entry,
        transaction: transaction,
      );
    }

    await PolicyVersionService.bumpForIds(
      session,
      policyIds,
      transaction: transaction,
    );
  }
}
