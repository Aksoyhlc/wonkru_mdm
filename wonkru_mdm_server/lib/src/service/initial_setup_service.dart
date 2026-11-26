import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';

import '../enums/storage_area.dart';
import '../generated/protocol.dart';
import 'mdm_agent_service.dart';
import 'policy_service.dart';
import 'provisioning_profile_service.dart';
import 'setting_service.dart';

class InitialSetupService {
  const InitialSetupService._();

  static const _setupKey = 'initial_setup_completed';
  static const _assets = 'assets/agent';
  static const _starterName = 'Starter';
  static const _starterSlug = 'starter';

  static Future<void> initialize(Session session) async {
    final manifest = File('$_assets/wonkru-mdm-apk.json');
    final now = DateTime.now().toUtc();

    await session.db.transaction((transaction) async {
      // Serialize startup on the same database when two server instances boot.
      await session.db.unsafeQuery(
        'SELECT 1 FROM pg_advisory_xact_lock(57219531)',
        transaction: transaction,
      );
      final firstSetup =
          await SettingService.raw(
            session,
            _setupKey,
            transaction: transaction,
          ) ==
          null;
      if (firstSetup) {
        await _createDefaults(session, now, transaction);
        await SettingService.save(
          session,
          _setupKey,
          'true',
          transaction: transaction,
        );
      }
      if (await manifest.exists()) {
        await _importAgent(session, manifest, now, transaction);
      }
      if (!firstSetup) {
        await _upgradeUntouchedStarter(session, now, transaction);
      }
    });
  }

  static Future<void> _createDefaults(
    Session session,
    DateTime now,
    Transaction transaction,
  ) async {
    if (await Policy.db.count(session, transaction: transaction) == 0) {
      final starter = _applyStarterSettings(
        Policy(
          name: _starterName,
          slug: _starterSlug,
          defaultPolicy: true,
          createdAt: now,
          updatedAt: now,
        ),
      );
      await PolicyService.applySavingRules(starter);
      final policy = await Policy.db.insertRow(
        session,
        starter,
        transaction: transaction,
      );
      final existing = await Setting.db.findFirstRow(
        session,
        where: (t) => t.name.equals(SettingService.defaultPolicyKey),
        transaction: transaction,
      );
      final policyId = policy.id.toString();
      if (existing == null) {
        await Setting.db.insertRow(
          session,
          Setting(name: SettingService.defaultPolicyKey, value: policyId),
          transaction: transaction,
        );
      } else {
        await Setting.db.updateRow(
          session,
          existing..value = policyId,
          transaction: transaction,
        );
      }
    }

    if (await ProvisioningProfile.db.count(session, transaction: transaction) ==
        0) {
      final profile = await ProvisioningProfile.db.insertRow(
        session,
        ProvisioningProfile(
          name: 'Wonkru MDM',
          config: ProvisioningProfileService.initialTemplate(),
          createdAt: now,
          updatedAt: now,
        ),
        transaction: transaction,
      );
      await SettingService.save(
        session,
        ProvisioningProfileService.initialProfileSetting,
        profile.id.toString(),
        transaction: transaction,
      );
    }
  }

  static Policy _applyStarterSettings(Policy policy) => policy
    ..adminPassword = Platform.environment['STARTER_ADMIN_PASSWORD']
    ..syncSettings = jsonEncode({
      'full_sync_cron': '0 * * * *',
      'max_interval_minutes': 60,
    })
    ..batterySettings = jsonEncode({
      'enabled': true,
      'low_battery_threshold': 20,
      'critical_battery_threshold': 15,
    })
    ..storageSettings = jsonEncode({
      'enabled': true,
      'warning_threshold': 80,
      'critical_threshold': 90,
    })
    ..audioSettings = jsonEncode({
      'min_volume': 20,
      'max_volume': 100,
    })
    ..securitySettings = jsonEncode({
      'allowed_accessibility_apps': [MdmAgentService.defaultPackage],
    })
    ..launcher = jsonEncode({
      'mode': true,
      'design': {
        'columns': 3,
        'item_display': {
          'icon_size': 'medium',
          'show_label': true,
          'long_press_settings_open': true,
        },
      },
      'header_widgets': {'left': true, 'center': true, 'right': true},
    })
    ..otherSettings = jsonEncode({'time_12_24': 24});

  static Future<void> _upgradeUntouchedStarter(
    Session session,
    DateTime now,
    Transaction transaction,
  ) async {
    final previous = await Policy.db.findFirstRow(
      session,
      where: (t) =>
          t.slug.equals(_starterSlug) &
          t.name.equals(_starterName) &
          t.defaultPolicy.equals(true) &
          t.isActive.equals(true) &
          t.version.equals(1) &
          t.syncSettings.equals(null) &
          t.deletedAt.equals(null),
      transaction: transaction,
      lockMode: LockMode.forUpdate,
    );

    // Older installers seeded a policy with empty settings and identical timestamps.
    if (previous == null ||
        previous.createdAt == null ||
        previous.createdAt != previous.updatedAt ||
        previous.description != null ||
        previous.activeTimeRanges != null ||
        previous.adminPassword != null ||
        previous.batterySettings != null ||
        previous.storageSettings != null ||
        previous.audioSettings != null ||
        previous.displaySettings != null ||
        previous.securitySettings != null ||
        previous.restrictionSettings != null ||
        previous.launcher != null ||
        previous.otherSettings != null) {
      return;
    }

    final updated = _applyStarterSettings(previous.copyWith(updatedAt: now));
    await PolicyService.applySavingRules(updated, previous: previous);
    final saved = await Policy.db.updateRow(
      session,
      updated,
      transaction: transaction,
    );
    await PolicyService.onUpdated(session, saved, previous: previous);
  }

  static Future<void> _importAgent(
    Session session,
    File manifest,
    DateTime now,
    Transaction transaction,
  ) async {
    final meta =
        jsonDecode(await manifest.readAsString()) as Map<String, dynamic>;
    final versionCode = meta['versionCode'] as int;
    final checksum = meta['sha256'] as String;
    if (meta['packageName'] != MdmAgentService.defaultPackage ||
        versionCode <= 0 ||
        !RegExp(r'^[a-f0-9]{64}$').hasMatch(checksum)) {
      throw const FormatException('Invalid bundled MDM APK manifest.');
    }

    final importKey = 'bundled_mdm_apk_$versionCode';
    if (await SettingService.raw(
          session,
          importKey,
          transaction: transaction,
        ) !=
        null) {
      return;
    }

    final app =
        await Application.db.findFirstRow(
          session,
          where: (t) => t.packageName.equals(MdmAgentService.defaultPackage),
          transaction: transaction,
        ) ??
        await Application.db.insertRow(
          session,
          Application(
            packageName: MdmAgentService.defaultPackage,
            appName: 'Wonkru MDM',
            sourceType: AppSourceType.apk,
            createdAt: now,
            updatedAt: now,
          ),
          transaction: transaction,
        );

    final appId = app.id!;
    final existing = await ApplicationVersion.db.findFirstRow(
      session,
      where: (t) =>
          t.applicationId.equals(appId) & t.versionCode.equals(versionCode),
      transaction: transaction,
    );
    if (existing == null && app.deletedAt == null) {
      final bytes = await File('$_assets/wonkru-mdm.apk').readAsBytes();
      if (sha256.convert(bytes).toString() != checksum) {
        throw const FormatException('Bundled MDM APK checksum does not match.');
      }
      final path = StorageArea.applications.pathFor('wonkru-mdm-$checksum.apk');
      await session.storage.storeFile(
        storageId: StorageArea.applications.defaultDisk,
        path: path,
        byteData: ByteData.sublistView(bytes),
      );
      final hasVersion =
          await ApplicationVersion.db.count(
            session,
            where: (t) => t.applicationId.equals(appId),
            transaction: transaction,
          ) >
          0;
      await ApplicationVersion.db.insertRow(
        session,
        ApplicationVersion(
          applicationId: appId,
          versionName: meta['versionName'] as String,
          versionCode: versionCode,
          filePath: path,
          fileSizeBytes: bytes.length,
          checksumSha256: checksum,
          minSdkVersion: meta['minSdkVersion'] as int?,
          targetSdkVersion: meta['targetSdkVersion'] as int?,
          isDefault: !hasVersion,
          createdAt: now,
          updatedAt: now,
        ),
        transaction: transaction,
      );
    }
    await SettingService.save(
      session,
      importKey,
      checksum,
      transaction: transaction,
    );
  }
}
