import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'policy_version_service.dart';

class SettingService {
  const SettingService._();

  static const defaultPolicyKey = 'default_policy';

  static Future<Setting> save(
    Session session,
    String name,
    String? value, {
    Transaction? transaction,
  }) async {
    final existing = await Setting.db.findFirstRow(
      session,
      where: (t) => t.name.equals(name),
      transaction: transaction,
    );

    final previousValue = existing?.value;

    final persisted = existing == null
        ? await Setting.db.insertRow(
            session,
            Setting(name: name, value: value),
            transaction: transaction,
          )
        : await Setting.db.updateRow(
            session,
            existing..value = value,
            transaction: transaction,
          );

    await _handleDefaultPolicyChange(
      session,
      name,
      previousValue,
      value,
      transaction: transaction,
    );

    return persisted;
  }

  static Future<void> _handleDefaultPolicyChange(
    Session session,
    String name,
    String? oldValue,
    String? newValue, {
    Transaction? transaction,
  }) async {
    if (name != defaultPolicyKey) {
      return;
    }

    await PolicyVersionService.bumpForIds(
      session,
      [int.tryParse(oldValue ?? ''), int.tryParse(newValue ?? '')],
      transaction: transaction,
    );
  }

  static Future<String?> raw(
    Session session,
    String key, {
    Transaction? transaction,
  }) async {
    final setting = await Setting.db.findFirstRow(
      session,
      where: (t) => t.name.equals(key),
      transaction: transaction,
    );
    return setting?.value;
  }

  static Future<int?> getInt(
    Session session,
    String key, {
    int? fallback,
    Transaction? transaction,
  }) async {
    final value = await raw(session, key, transaction: transaction);
    if (value == null || value.isEmpty) {
      return fallback;
    }
    return int.tryParse(value) ?? fallback;
  }

  /// A stored empty string is `false`; only a missing row falls back.
  static Future<bool> getBool(
    Session session,
    String key, {
    bool fallback = false,
    Transaction? transaction,
  }) async {
    final value = await raw(session, key, transaction: transaction);
    if (value == null) {
      return fallback;
    }
    final normalized = value.trim().toLowerCase();
    return normalized == '1' ||
        normalized == 'true' ||
        normalized == 'yes' ||
        normalized == 'on';
  }
}
