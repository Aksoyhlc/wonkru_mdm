import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class PolicyVersionService {
  const PolicyVersionService._();

  static Future<void> bump(
    Session session,
    Policy policy, {
    Transaction? transaction,
  }) async {
    policy.version = policy.version + 1;
    await Policy.db.updateRow(session, policy, transaction: transaction);
  }

  static Future<void> bumpForIds(
    Session session,
    Iterable<int?> ids, {
    Transaction? transaction,
  }) async {
    for (final id in ids.whereType<int>().toSet()) {
      final policy = await Policy.db.findById(
        session,
        id,
        transaction: transaction,
      );
      if (policy != null) {
        await bump(session, policy, transaction: transaction);
      }
    }
  }

  static Future<void> bumpForPolicyId(
    Session session,
    int? policyId, {
    Transaction? transaction,
  }) async {
    if (policyId == null) {
      return;
    }
    await bumpForIds(session, [policyId], transaction: transaction);
  }

  static Future<void> bumpForApplication(
    Session session,
    int applicationId, {
    Transaction? transaction,
  }) async {
    await bumpForIds(
      session,
      await policyIdsForApplication(
        session,
        applicationId,
        transaction: transaction,
      ),
      transaction: transaction,
    );
  }

  static Future<void> bumpForFile(
    Session session,
    int fileId, {
    Transaction? transaction,
  }) async {
    await bumpForIds(
      session,
      await policyIdsForFile(session, fileId, transaction: transaction),
      transaction: transaction,
    );
  }

  static Future<void> bumpForCertificate(
    Session session,
    int certificateId, {
    Transaction? transaction,
  }) async {
    await bumpForIds(
      session,
      await policyIdsForCertificate(
        session,
        certificateId,
        transaction: transaction,
      ),
      transaction: transaction,
    );
  }

  static Future<List<int>> policyIdsForApplication(
    Session session,
    int applicationId, {
    Transaction? transaction,
  }) async {
    final rows = await PolicyApplication.db.find(
      session,
      where: (t) => t.applicationId.equals(applicationId),
      transaction: transaction,
    );
    return {for (final row in rows) row.policyId}.toList();
  }

  static Future<List<int>> policyIdsForTargetVersion(
    Session session,
    int versionId, {
    Transaction? transaction,
  }) async {
    final rows = await PolicyApplication.db.find(
      session,
      where: (t) => t.targetVersionId.equals(versionId),
      transaction: transaction,
    );
    return {for (final row in rows) row.policyId}.toList();
  }

  static Future<List<int>> policyIdsForFile(
    Session session,
    int fileId, {
    Transaction? transaction,
  }) async {
    final rows = await PolicyFile.db.find(
      session,
      where: (t) => t.fileId.equals(fileId),
      transaction: transaction,
    );
    return {for (final row in rows) row.policyId}.toList();
  }

  static Future<List<int>> policyIdsForCertificate(
    Session session,
    int certificateId, {
    Transaction? transaction,
  }) async {
    final rows = await PolicyCertificate.db.find(
      session,
      where: (t) => t.certificateId.equals(certificateId),
      transaction: transaction,
    );
    return {for (final row in rows) row.policyId}.toList();
  }
}
