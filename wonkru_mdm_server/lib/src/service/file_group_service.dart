import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class FileGroupService {
  const FileGroupService._();

  static Future<void> syncFileGroups(
    Session session,
    int fileId,
    Iterable<int> fileGroupIds, {
    Transaction? transaction,
  }) async {
    final wanted = fileGroupIds.toSet();

    final memberships = await FileGroupMember.db.find(
      session,
      where: (t) => t.fileId.equals(fileId),
      transaction: transaction,
    );

    for (final membership in memberships) {
      if (!wanted.contains(membership.fileGroupId)) {
        await FileGroupMember.db.deleteRow(
          session,
          membership,
          transaction: transaction,
        );
      }
    }

    final current = {
      for (final membership in memberships) membership.fileGroupId,
    };

    for (final groupId in wanted) {
      if (current.contains(groupId)) {
        continue;
      }

      final now = DateTime.now().toUtc();
      await FileGroupMember.db.insertRow(
        session,
        FileGroupMember(
          fileId: fileId,
          fileGroupId: groupId,
          createdAt: now,
          updatedAt: now,
        ),
        transaction: transaction,
      );
    }
  }

  static Future<void> syncGroupFiles(
    Session session,
    int fileGroupId,
    Iterable<int> fileIds, {
    Transaction? transaction,
  }) async {
    final wanted = fileIds.toSet();

    final memberships = await FileGroupMember.db.find(
      session,
      where: (t) => t.fileGroupId.equals(fileGroupId),
      transaction: transaction,
    );

    for (final membership in memberships) {
      if (!wanted.contains(membership.fileId)) {
        await FileGroupMember.db.deleteRow(
          session,
          membership,
          transaction: transaction,
        );
      }
    }

    final current = {for (final membership in memberships) membership.fileId};

    for (final fileId in wanted) {
      if (current.contains(fileId)) {
        continue;
      }

      final now = DateTime.now().toUtc();
      await FileGroupMember.db.insertRow(
        session,
        FileGroupMember(
          fileId: fileId,
          fileGroupId: fileGroupId,
          createdAt: now,
          updatedAt: now,
        ),
        transaction: transaction,
      );
    }
  }

  static Future<List<int>> groupIdsForFile(
    Session session,
    int fileId, {
    Transaction? transaction,
  }) async {
    final memberships = await FileGroupMember.db.find(
      session,
      where: (t) => t.fileId.equals(fileId),
      transaction: transaction,
    );

    return [for (final membership in memberships) membership.fileGroupId];
  }

  static Future<Set<int>> fileIdsInGroups(
    Session session,
    Iterable<int> fileGroupIds, {
    Transaction? transaction,
  }) async {
    final ids = fileGroupIds.toSet();
    if (ids.isEmpty) {
      return const {};
    }

    final memberships = await FileGroupMember.db.find(
      session,
      where: (t) => t.fileGroupId.inSet(ids),
      transaction: transaction,
    );

    return {for (final membership in memberships) membership.fileId};
  }

  /// Every requested id is present in the result, so a group without members
  /// reports zero.
  static Future<Map<int, int>> fileCounts(
    Session session,
    Iterable<int> fileGroupIds, {
    Transaction? transaction,
  }) async {
    final ids = fileGroupIds.toSet();
    if (ids.isEmpty) {
      return const {};
    }

    final memberships = await FileGroupMember.db.find(
      session,
      where: (t) => t.fileGroupId.inSet(ids),
      transaction: transaction,
    );

    final counts = {for (final id in ids) id: 0};
    for (final membership in memberships) {
      final groupId = membership.fileGroupId;
      counts[groupId] = (counts[groupId] ?? 0) + 1;
    }

    return counts;
  }
}
