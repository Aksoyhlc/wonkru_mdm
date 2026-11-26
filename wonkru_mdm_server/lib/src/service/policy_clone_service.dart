import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'policy_application_service.dart';
import 'policy_service.dart';
import 'policy_slug_service.dart';

/// The copy carries the source policy's settings and its applications,
/// certificates and files; it is never the default policy and starts at version
/// 1.
class PolicyCloneService {
  const PolicyCloneService._();

  /// From `p.policy_copy_suffix`.
  static const copySuffix = ' (Copy)';

  /// From `r.device`; used when a device has no code and no name.
  static const deviceLabel = 'Device';

  /// From `p.policy`.
  static const policyLabel = 'Policy';

  static Future<Policy> duplicate(
    Session session,
    Policy policy, {
    String? newName,
    Transaction? transaction,
  }) async {
    final sourceId = policy.id;
    if (sourceId == null) {
      throw ArgumentError.value(
        policy,
        'policy',
        'Only a stored policy can be duplicated.',
      );
    }

    final name = newName ?? '${policy.name}$copySuffix';

    // The related rows are read first, because every lookup runs against the
    // source id.
    final applications = await PolicyApplication.db.find(
      session,
      where: (t) => t.policyId.equals(sourceId),
      orderByList: (t) => [t.sort.asc()],
      transaction: transaction,
    );

    final certificates = await PolicyCertificate.db.find(
      session,
      where: (t) => t.policyId.equals(sourceId),
      transaction: transaction,
    );

    final files = await PolicyFile.db.find(
      session,
      where: (t) => t.policyId.equals(sourceId),
      transaction: transaction,
    );

    final copy = _copyRow(
      policy,
      name,
      await PolicySlugService.unique(session, name, transaction: transaction),
    );

    // Normalises the sync settings; a policy with no previous row starts at
    // version 1.
    await PolicyService.applySavingRules(copy);

    final inserted = await Policy.db.insertRow(
      session,
      copy,
      transaction: transaction,
    );
    final copyId = inserted.id!;

    await _copyApplications(
      session,
      applications,
      copyId,
      transaction: transaction,
    );
    await _copyCertificates(
      session,
      certificates,
      copyId,
      transaction: transaction,
    );
    await _copyFiles(session, files, copyId, transaction: transaction);

    return inserted;
  }

  static Policy _copyRow(Policy policy, String name, String slug) => Policy(
    name: name,
    slug: slug,
    description: policy.description,
    activeTimeRanges: policy.activeTimeRanges,
    isActive: policy.isActive,
    defaultPolicy: false,
    adminPassword: policy.adminPassword,
    batterySettings: policy.batterySettings,
    storageSettings: policy.storageSettings,
    audioSettings: policy.audioSettings,
    displaySettings: policy.displaySettings,
    securitySettings: policy.securitySettings,
    restrictionSettings: policy.restrictionSettings,
    launcher: policy.launcher,
    syncSettings: policy.syncSettings,
    otherSettings: policy.otherSettings,
  );

  static String slugify(String value) => PolicySlugService.slugify(value);

  /// The copy has no devices yet and never leaves version 1, so the version bump
  /// is not repeated here.
  static Future<void> _copyApplications(
    Session session,
    List<PolicyApplication> source,
    int policyId, {
    Transaction? transaction,
  }) async {
    for (final entry in source) {
      final copy = PolicyApplication(
        policyId: policyId,
        sort: await PolicyApplicationService.nextSort(
          session,
          policyId,
          transaction: transaction,
        ),
        applicationId: entry.applicationId,
        targetVersionId: entry.targetVersionId,
        action: entry.action,
        showLauncher: entry.showLauncher,
        customAppName: entry.customAppName,
        updatePolicy: entry.updatePolicy,
        startAfterInstall: entry.startAfterInstall,
        runOnBoot: entry.runOnBoot,
        uninstallBlock: entry.uninstallBlock,
      );

      await PolicyApplication.db.insertRow(
        session,
        copy,
        transaction: transaction,
      );
    }
  }

  static Future<void> _copyCertificates(
    Session session,
    List<PolicyCertificate> source,
    int policyId, {
    Transaction? transaction,
  }) async {
    for (final entry in source) {
      await PolicyCertificate.db.insertRow(
        session,
        PolicyCertificate(
          policyId: policyId,
          certificateId: entry.certificateId,
          action: entry.action,
        ),
        transaction: transaction,
      );
    }
  }

  static Future<void> _copyFiles(
    Session session,
    List<PolicyFile> source,
    int policyId, {
    Transaction? transaction,
  }) async {
    for (final entry in source) {
      await PolicyFile.db.insertRow(
        session,
        PolicyFile(
          policyId: policyId,
          fileId: entry.fileId,
          usageType: entry.usageType,
          destinationPath: entry.destinationPath,
          replaceIfExists: entry.replaceIfExists,
          openAfterDownload: entry.openAfterDownload,
        ),
        transaction: transaction,
      );
    }
  }

  static String devicePolicyName(Device device) {
    final code = device.code;
    final name = device.name;

    final base = code.isNotEmpty
        ? code
        : name != null && name.isNotEmpty
        ? name
        : '$deviceLabel-${device.id}';

    return '$base - $policyLabel';
  }
}
