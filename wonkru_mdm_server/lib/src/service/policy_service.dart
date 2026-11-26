import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../generated/endpoints.dart' show ServerpodFutureCallsGetter;
import '../generated/protocol.dart';
import '../util/json_utils.dart';
import '../util/password_hasher.dart';
import 'policy_payload_normalizer.dart';
import 'setting_service.dart';

/// Serverpod has no model-event hook, so the admin flows must call these helpers
/// explicitly around every policy write.
class PolicyService {
  const PolicyService._();

  /// Fields that never count as a meaningful change when deciding whether to
  /// bump the policy version.
  static const ignoredSavingFields = <String>{
    'id',
    'version',
    'createdAt',
    'updatedAt',
    'deletedAt',
  };

  static const _defaultFullSyncCron = '0 * * * *';
  static const _defaultMaxIntervalMinutes = 60;

  /// Delay between a version bump and the push to the policy's devices, giving
  /// the surrounding transaction time to commit.
  static const pushDelay = Duration(seconds: 5);

  static const deviceUpdateCheckDelaySettingKey =
      'policy_devices_updated_check_delay_minutes';

  static const defaultDeviceUpdateCheckDelayMinutes = 30;

  static const maxDeviceUpdateCheckDelayMinutes = 10080;

  static String deviceUpdateCheckIdentifier(int policyId) =>
      'check-policy-devices-updated-$policyId';

  /// Only `full_sync_cron` and `max_interval_minutes` survive; missing values
  /// fall back to the defaults.
  static void normalizeSyncSettings(Policy policy) {
    final raw = policy.syncSettings;
    if (raw == null || raw.isEmpty) {
      return;
    }

    final decoded = decodeJsonMap(raw);

    policy.syncSettings = jsonEncode({
      'full_sync_cron': decoded['full_sync_cron'] ?? _defaultFullSyncCron,
      'max_interval_minutes':
          decoded['max_interval_minutes'] ?? _defaultMaxIntervalMinutes,
    });
  }

  /// `min_brightness > max_brightness` is a range the device cannot apply. The
  /// panel blocks it too; this catches records arriving from manual or older
  /// clients. Only create/update call it, so cloning copies an invalid range
  /// as-is.
  static void validateSettings(Policy policy) {
    final display = decodeJsonMap(policy.displaySettings);
    final min = PolicyPayloadNormalizer.integer(display['min_brightness']);
    final max = PolicyPayloadNormalizer.integer(display['max_brightness']);
    if (min != null && max != null && min > max) {
      throw AdminPolicyValidationException(
        message:
            'min_brightness ($min) must not be greater than '
            'max_brightness ($max).',
        field: 'display_settings.min_brightness',
      );
    }
  }

  /// Any change outside [ignoredSavingFields] bumps the version, which is what
  /// makes the agent pick the policy up again.
  static Future<void> applySavingRules(
    Policy policy, {
    Policy? previous,
  }) async {
    normalizeSyncSettings(policy);
    await _applyAdminPasswordRules(policy);

    if (previous == null) {
      policy.version = 1;
      return;
    }

    if (_hasMeaningfulChange(policy, previous)) {
      policy.version = previous.version + 1;
    } else {
      policy.version = previous.version;
    }
  }

  /// The panel sends the password in clear text (write-only field), so it is
  /// hashed here before it reaches the database. A value that already carries a
  /// PHC hash is kept untouched, so cloning copies the stored hash without
  /// hashing it twice.
  static Future<void> _applyAdminPasswordRules(Policy policy) async {
    final value = policy.adminPassword;
    if (value == null || value.trim().isEmpty) {
      policy.adminPassword = null;
      return;
    }

    if (_isHashed(value)) {
      return;
    }

    policy.adminPassword = await PasswordHasher.hash(value);
  }

  static bool _isHashed(String value) => PasswordHasher.isHashed(value);

  /// Removes the policy's application entries and moves its devices to the
  /// default policy; when the removed policy *is* the default, the devices are
  /// left without a policy instead.
  static Future<void> onDeleting(
    Session session,
    Policy policy, {
    Transaction? transaction,
  }) async {
    final policyId = policy.id;
    if (policyId == null) {
      return;
    }

    final applications = await PolicyApplication.db.find(
      session,
      where: (t) => t.policyId.equals(policyId),
      transaction: transaction,
    );

    for (final application in applications) {
      await PolicyApplication.db.deleteRow(
        session,
        application,
        transaction: transaction,
      );
    }

    final defaultPolicyId = await SettingService.getInt(
      session,
      SettingService.defaultPolicyKey,
      transaction: transaction,
    );
    final deletingDefault = policyId == defaultPolicyId;
    final targetPolicyId = deletingDefault ? null : defaultPolicyId;

    // Clearing the setting keeps new registrations from being assigned to the
    // deleted policy.
    if (deletingDefault) {
      await SettingService.save(
        session,
        SettingService.defaultPolicyKey,
        null,
        transaction: transaction,
      );
    }

    // Only `policyId` is written; the rest of the device row is not overwritten
    // with a stale copy.
    await Device.db.updateWhere(
      session,
      where: (t) => t.policyId.equals(policyId),
      columnValues: (t) => [t.policyId(targetPolicyId)],
      transaction: transaction,
    );
  }

  /// Nothing is pushed when the version did not move, so [previous] must be the
  /// row as stored before the write.
  ///
  /// Two jobs are queued: the push itself after a short delay, which gives the
  /// surrounding transaction time to commit, and a later check that reports the
  /// devices which never picked the new version up.
  static Future<void> onUpdated(
    Session session,
    Policy policy, {
    required Policy previous,
  }) async {
    final policyId = policy.id;
    if (policyId == null || !versionChanged(policy, previous)) {
      return;
    }

    final futureCalls = session.serverpod.futureCalls;

    await futureCalls
        .callWithDelay(pushDelay)
        .sendPolicy
        .send(SendPolicyCall(policyId: policyId));

    final configuredDelay =
        await SettingService.getInt(
          session,
          deviceUpdateCheckDelaySettingKey,
          fallback: defaultDeviceUpdateCheckDelayMinutes,
        ) ??
        defaultDeviceUpdateCheckDelayMinutes;
    final delayMinutes = configuredDelay
        .clamp(0, maxDeviceUpdateCheckDelayMinutes)
        .toInt();

    final check = CheckPolicyDevicesCall(
      policyId: policyId,
      expectedVersion: policy.version,
    );

    // Scoping the identifier to the policy keeps a single pending check per
    // policy.
    final identifier = deviceUpdateCheckIdentifier(policyId);
    await futureCalls.cancel(identifier);
    await futureCalls
        .callWithDelay(Duration(minutes: delayMinutes))
        .checkPolicyDevicesUpdated
        .check(check);
  }

  static bool versionChanged(Policy current, Policy previous) =>
      current.version != previous.version;

  static bool _hasMeaningfulChange(Policy current, Policy previous) {
    final currentContent = _content(current);
    final previousContent = _content(previous);

    for (final key in {...currentContent.keys, ...previousContent.keys}) {
      if (currentContent[key] != previousContent[key]) {
        return true;
      }
    }

    return false;
  }

  static Map<String, dynamic> _content(Policy policy) {
    final json = policy.toJson();
    json.removeWhere(
      (key, value) =>
          key == '__className__' || ignoredSavingFields.contains(key),
    );
    return json;
  }
}
