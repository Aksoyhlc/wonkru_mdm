import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'policy_version_service.dart';

/// Keeps the `is_default` flag consistent per application and bumps the
/// policies that pin the affected version.
class ApplicationVersionService {
  const ApplicationVersionService._();

  static Future<void> clearOtherDefaults(
    Session session,
    ApplicationVersion version, {
    Transaction? transaction,
  }) async {
    if (!version.isDefault) {
      return;
    }

    final others = await ApplicationVersion.db.find(
      session,
      where: (t) =>
          t.applicationId.equals(version.applicationId) &
          t.isDefault.equals(true),
      transaction: transaction,
    );

    for (final other in others) {
      if (other.id == version.id) {
        continue;
      }
      other.isDefault = false;
      await ApplicationVersion.db.updateRow(
        session,
        other,
        transaction: transaction,
      );
    }
  }

  static Future<void> onCreated(
    Session session,
    ApplicationVersion version, {
    Transaction? transaction,
  }) async {
    final versions = await ApplicationVersion.db.find(
      session,
      where: (t) => t.applicationId.equals(version.applicationId),
      transaction: transaction,
    );

    final hasDefault = versions.any((row) => row.isDefault);
    if (versions.length == 1 || !hasDefault) {
      version.isDefault = true;
      await ApplicationVersion.db.updateRow(
        session,
        version,
        transaction: transaction,
      );
    }

    await bumpTargetVersionPolicies(session, version, transaction: transaction);
  }

  // [becameNonDefault] must be true when this update cleared `is_default`.
  static Future<void> onUpdated(
    Session session,
    ApplicationVersion version, {
    required bool becameNonDefault,
    Transaction? transaction,
  }) async {
    if (!version.isDefault && becameNonDefault) {
      final others = await ApplicationVersion.db.find(
        session,
        where: (t) =>
            t.applicationId.equals(version.applicationId) &
            t.isDefault.equals(true),
        transaction: transaction,
      );

      if (others.isEmpty) {
        final candidates = await ApplicationVersion.db.find(
          session,
          where: (t) => t.applicationId.equals(version.applicationId),
          orderByList: (t) => [t.createdAt.desc()],
          transaction: transaction,
        );

        for (final candidate in candidates) {
          if (candidate.id == version.id) {
            continue;
          }
          candidate.isDefault = true;
          await ApplicationVersion.db.updateRow(
            session,
            candidate,
            transaction: transaction,
          );
          break;
        }
      }
    }

    await bumpTargetVersionPolicies(session, version, transaction: transaction);
  }

  static Future<void> onDeleting(
    Session session,
    ApplicationVersion version, {
    Transaction? transaction,
  }) async {
    await bumpTargetVersionPolicies(session, version, transaction: transaction);

    final references = await PolicyApplication.db.find(
      session,
      where: (t) => t.targetVersionId.equals(version.id!),
      transaction: transaction,
    );

    for (final reference in references) {
      reference.targetVersionId = null;
      await PolicyApplication.db.updateRow(
        session,
        reference,
        transaction: transaction,
      );
    }
  }

  static Future<void> onDeleted(
    Session session,
    ApplicationVersion version, {
    Transaction? transaction,
  }) async {
    if (!version.isDefault) {
      return;
    }

    final candidates = await ApplicationVersion.db.find(
      session,
      where: (t) => t.applicationId.equals(version.applicationId),
      orderByList: (t) => [t.createdAt.desc()],
      transaction: transaction,
    );

    for (final candidate in candidates) {
      if (candidate.id == version.id) {
        continue;
      }
      candidate.isDefault = true;
      await ApplicationVersion.db.updateRow(
        session,
        candidate,
        transaction: transaction,
      );
      break;
    }
  }

  static Future<void> bumpTargetVersionPolicies(
    Session session,
    ApplicationVersion version, {
    Transaction? transaction,
  }) async {
    final id = version.id;
    if (id == null) {
      return;
    }

    final policyIds = await PolicyVersionService.policyIdsForTargetVersion(
      session,
      id,
      transaction: transaction,
    );
    await PolicyVersionService.bumpForIds(
      session,
      policyIds,
      transaction: transaction,
    );
  }
}
