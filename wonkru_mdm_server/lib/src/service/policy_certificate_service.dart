import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'policy_version_service.dart';

/// The policy payload embeds every certificate the policy installs, so
/// attaching, changing or removing one invalidates it. Serverpod has no model
/// events, so these methods bump the owning policy explicitly around each
/// `PolicyCertificate` write.
class PolicyCertificateService {
  const PolicyCertificateService._();

  static Future<PolicyCertificate> attach(
    Session session,
    PolicyCertificate entry,
  ) async {
    return session.db.transaction((transaction) async {
      final now = DateTime.now().toUtc();
      entry
        ..id = null
        ..createdAt = now
        ..updatedAt = now;

      final saved = await PolicyCertificate.db.insertRow(
        session,
        entry,
        transaction: transaction,
      );

      await bumpPolicy(session, saved.policyId, transaction: transaction);
      return saved;
    });
  }

  /// Updates [entry]; its policy is pinned so it cannot be moved to another
  /// policy, which would leave the target policy's devices stale.
  static Future<PolicyCertificate> update(
    Session session,
    PolicyCertificate entry,
  ) async {
    final entryId = entry.id;
    if (entryId == null) {
      throw Exception('A policy certificate id is required.');
    }

    return session.db.transaction((transaction) async {
      final stored = await PolicyCertificate.db.findById(
        session,
        entryId,
        transaction: transaction,
      );
      if (stored == null) {
        throw Exception('Policy certificate $entryId does not exist.');
      }

      entry
        ..policyId = stored.policyId
        ..createdAt = stored.createdAt
        ..updatedAt = DateTime.now().toUtc();

      final saved = await PolicyCertificate.db.updateRow(
        session,
        entry,
        transaction: transaction,
      );

      await bumpPolicy(session, saved.policyId, transaction: transaction);
      return saved;
    });
  }

  /// Deletes the entry and returns the policy it belonged to, or null when the
  /// row was already gone.
  static Future<int?> detach(Session session, int entryId) async {
    int? affectedPolicyId;

    await session.db.transaction((transaction) async {
      final stored = await PolicyCertificate.db.findById(
        session,
        entryId,
        transaction: transaction,
      );
      if (stored == null) {
        return;
      }

      affectedPolicyId = stored.policyId;

      await PolicyCertificate.db.deleteRow(
        session,
        stored,
        transaction: transaction,
      );
      await bumpPolicy(session, stored.policyId, transaction: transaction);
    });

    return affectedPolicyId;
  }

  /// The id is passed in because the row may already be gone.
  static Future<void> bumpPolicy(
    Session session,
    int? policyId, {
    Transaction? transaction,
  }) => PolicyVersionService.bumpForPolicyId(
    session,
    policyId,
    transaction: transaction,
  );
}
