import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'policy_version_service.dart';

/// The policy payload embeds every file the policy ships, so attaching,
/// changing or removing one invalidates it. Serverpod has no model events, so
/// these methods bump the owning policy explicitly around each `PolicyFile`
/// write.
class PolicyFileService {
  const PolicyFileService._();

  /// Creates or updates [entry].
  ///
  /// Rows with a file match by file id; file-less (deletion) rows match by
  /// destination path, so a policy never carries the same file or path twice.
  /// A relative destination resolves to the process root on the device and the
  /// download fails with "Read-only file system", so it is rejected.
  static Future<PolicyFile> attach(Session session, PolicyFile entry) async {
    final destinationPath = entry.destinationPath?.trim();
    if (destinationPath != null &&
        destinationPath.isNotEmpty &&
        !destinationPath.startsWith('/')) {
      throw AdminPolicyValidationException(
        message: 'Destination path must be absolute: $destinationPath',
        field: 'files.destinationPath',
      );
    }
    entry.destinationPath = destinationPath == null || destinationPath.isEmpty
        ? null
        : destinationPath;

    return session.db.transaction((transaction) async {
      final fileId = entry.fileId;
      final PolicyFile? existing;
      if (fileId != null) {
        existing = await PolicyFile.db.findFirstRow(
          session,
          where: (t) =>
              t.policyId.equals(entry.policyId) & t.fileId.equals(fileId),
          transaction: transaction,
        );
      } else {
        final path = entry.destinationPath;
        existing = path == null
            ? null
            : await PolicyFile.db.findFirstRow(
                session,
                where: (t) =>
                    t.policyId.equals(entry.policyId) &
                    t.destinationPath.equals(path),
                transaction: transaction,
              );
      }

      final now = DateTime.now().toUtc();

      if (existing != null) {
        existing
          ..usageType = entry.usageType
          ..destinationPath = entry.destinationPath
          ..replaceIfExists = entry.replaceIfExists
          ..openAfterDownload = entry.openAfterDownload
          ..updatedAt = now;

        final saved = await PolicyFile.db.updateRow(
          session,
          existing,
          transaction: transaction,
        );

        await bumpPolicy(session, saved.policyId, transaction: transaction);
        return saved;
      }

      entry
        ..id = null
        ..createdAt = now
        ..updatedAt = now;

      final saved = await PolicyFile.db.insertRow(
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
  static Future<PolicyFile> update(Session session, PolicyFile entry) async {
    final entryId = entry.id;
    if (entryId == null) {
      throw Exception('A policy file id is required.');
    }

    return session.db.transaction((transaction) async {
      final stored = await PolicyFile.db.findById(
        session,
        entryId,
        transaction: transaction,
      );
      if (stored == null) {
        throw Exception('Policy file $entryId does not exist.');
      }

      entry
        ..policyId = stored.policyId
        ..createdAt = stored.createdAt
        ..updatedAt = DateTime.now().toUtc();

      final saved = await PolicyFile.db.updateRow(
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
      final stored = await PolicyFile.db.findById(
        session,
        entryId,
        transaction: transaction,
      );
      if (stored == null) {
        return;
      }

      affectedPolicyId = stored.policyId;

      await PolicyFile.db.deleteRow(session, stored, transaction: transaction);
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
