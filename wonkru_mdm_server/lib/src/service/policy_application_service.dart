import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'policy_version_service.dart';

class PolicyApplicationService {
  const PolicyApplicationService._();

  /// Creates [pivot], appending it to the policy when no sort order is supplied.
  static Future<PolicyApplication> attach(
    Session session,
    PolicyApplication pivot,
  ) async {
    return session.db.transaction((transaction) async {
      final now = DateTime.now().toUtc();
      pivot
        ..id = null
        ..createdAt = now
        ..updatedAt = now;
      if (pivot.sort <= 0) {
        pivot.sort = await nextSort(
          session,
          pivot.policyId,
          transaction: transaction,
        );
      }

      final saved = await PolicyApplication.db.insertRow(
        session,
        pivot,
        transaction: transaction,
      );

      await bumpPolicy(session, saved.policyId, transaction: transaction);
      return saved;
    });
  }

  /// Updates [pivot]; its policy is pinned so it cannot be moved to another
  /// policy, which would leave the target policy's devices stale.
  static Future<PolicyApplication> update(
    Session session,
    PolicyApplication pivot,
  ) async {
    final pivotId = pivot.id;
    if (pivotId == null) {
      throw Exception('A policy application id is required.');
    }

    return session.db.transaction((transaction) async {
      final stored = await PolicyApplication.db.findById(
        session,
        pivotId,
        transaction: transaction,
      );
      if (stored == null) {
        throw Exception('Policy application $pivotId does not exist.');
      }

      pivot
        ..policyId = stored.policyId
        ..createdAt = stored.createdAt
        ..updatedAt = DateTime.now().toUtc();

      final saved = await PolicyApplication.db.updateRow(
        session,
        pivot,
        transaction: transaction,
      );

      await bumpPolicy(session, saved.policyId, transaction: transaction);
      return saved;
    });
  }

  /// Deletes the pivot and returns the policy it belonged to, or null when the
  /// row was already gone.
  static Future<int?> detach(Session session, int pivotId) async {
    int? affectedPolicyId;

    await session.db.transaction((transaction) async {
      final stored = await PolicyApplication.db.findById(
        session,
        pivotId,
        transaction: transaction,
      );
      if (stored == null) {
        return;
      }

      affectedPolicyId = stored.policyId;

      await PolicyApplication.db.deleteRow(
        session,
        stored,
        transaction: transaction,
      );
      await bumpPolicy(session, stored.policyId, transaction: transaction);
    });

    return affectedPolicyId;
  }

  /// Rewrites the sort order of [policyId]'s entries to match [entryIds].
  static Future<void> reorder(
    Session session,
    int policyId,
    List<int> entryIds,
  ) async {
    await session.db.transaction((transaction) async {
      for (var index = 0; index < entryIds.length; index++) {
        final entry = await PolicyApplication.db.findById(
          session,
          entryIds[index],
          transaction: transaction,
        );
        if (entry == null || entry.policyId != policyId) {
          continue;
        }

        entry
          ..sort = index + 1
          ..updatedAt = DateTime.now().toUtc();
        await PolicyApplication.db.updateRow(
          session,
          entry,
          transaction: transaction,
        );
      }

      await bumpPolicy(session, policyId, transaction: transaction);
    });
  }

  /// When no sort order is supplied, the entry is appended to the policy.
  static Future<int> nextSort(
    Session session,
    int policyId, {
    Transaction? transaction,
  }) async {
    final last = await PolicyApplication.db.findFirstRow(
      session,
      where: (t) => t.policyId.equals(policyId),
      orderByList: (t) => [t.sort.desc()],
      transaction: transaction,
    );

    return (last?.sort ?? 0) + 1;
  }

  /// Adding, reordering or removing an entry changes the policy payload, so the
  /// owning policy is bumped in every case.
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
