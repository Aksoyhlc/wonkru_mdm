import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../util/json_utils.dart';
import 'device_request_limits.dart';

/// Only inserts or updates; rows missing from the reported list are never
/// deleted, so a filtered list (system apps excluded) does not drop existing
/// rows.
class DeviceApplicationSyncService {
  const DeviceApplicationSyncService._();

  static Future<void> upsert(
    Session session, {
    Transaction? transaction,
    required int deviceId,
    required List<dynamic> apps,
  }) async {
    if (apps.length > DeviceRequestLimits.syncApps) {
      session.log(
        'Device $deviceId sent ${apps.length} apps; only the first '
        '${DeviceRequestLimits.syncApps} are stored.',
        level: LogLevel.warning,
      );
    }
    for (final raw in apps.take(DeviceRequestLimits.syncApps)) {
      final app = asMap(raw);
      final packageName = asString(app['packageName']);
      // Android package names cannot exceed 255 characters; longer ones are
      // corrupt or hostile.
      if (packageName == null ||
          packageName.isEmpty ||
          packageName.length > DeviceRequestLimits.shortText) {
        continue;
      }

      final appName = _truncate(
        asString(app['appName']) ?? packageName,
        DeviceRequestLimits.shortText,
      )!;
      final versionName = asString(app['versionName']);
      final now = DateTime.now().toUtc();

      final existing = await DeviceApplication.db.findFirstRow(
        session,
        where: (t) =>
            t.deviceId.equals(deviceId) & t.packageName.equals(packageName),
        transaction: transaction,
      );

      if (existing == null) {
        await DeviceApplication.db.insertRow(
          session,
          DeviceApplication(
            deviceId: deviceId,
            packageName: packageName,
            appName: appName,
            versionName: _truncate(versionName, 255),
            versionCode: asInt(app['versionCode']),
            isSystemApp: asBool(app['isSystemApp']),
            isUninstallBlocked: asBool(app['isUninstallBlocked']),
            isPowerSaveWhitelisted: asBoolOrNull(app['isPowerSaveWhitelisted']),
            lastSeenAt: now,
          ),
          transaction: transaction,
        );
      } else {
        existing
          ..appName = appName
          ..versionName = _truncate(versionName, 255)
          ..versionCode = asInt(app['versionCode'])
          ..isSystemApp = asBool(app['isSystemApp'])
          ..isUninstallBlocked = asBool(app['isUninstallBlocked'])
          ..isPowerSaveWhitelisted = asBoolOrNull(
            app['isPowerSaveWhitelisted'],
          )
          ..lastSeenAt = now;

        await DeviceApplication.db.updateRow(
          session,
          existing,
          transaction: transaction,
        );
      }

      final knownApplication = await Application.db.findFirstRow(
        session,
        where: (t) => t.packageName.equals(packageName),
        transaction: transaction,
      );

      if (knownApplication == null) {
        await Application.db.insertRow(
          session,
          Application(
            packageName: packageName,
            appName: appName,
            isSystemApp: asBool(app['isSystemApp']),
          ),
          transaction: transaction,
        );
      }
    }
  }

  static String? _truncate(String? value, int maxLength) {
    if (value == null) {
      return null;
    }
    return value.length <= maxLength ? value : value.substring(0, maxLength);
  }
}
