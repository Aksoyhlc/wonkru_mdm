import '../enums/system_alert_enums.dart';
import '../generated/protocol.dart';

/// Alert-channel routing stored in the `settings` table under [key].
///
/// [normalizeRouting] fills every alert type, so a stored routing is complete
/// even when it was written by an older panel version.
class AlertRoutingSettings {
  const AlertRoutingSettings._();

  static const key = 'system_alert_routing';

  /// Old type names kept so a stored routing survives a rename.
  static const legacyTypeKeys = {
    'DeviceOffline': 'device_offline',
    'PolicyUpdatePending': 'policy_update_pending',
    'SecurityInfo': 'security_info',
    'AdbRootEnabled': 'security_info',
    'adb_root_enabled': 'security_info',
  };

  static const allowedChannels = ['database', 'mail', 'sms'];

  static List<AlertTypeChannels> normalizeRouting(dynamic raw) {
    final incoming = <SystemAlertType, List<String>>{};
    final typeChannels = raw is Map ? raw['type_channels'] : null;

    if (typeChannels is Map) {
      for (final entry in typeChannels.entries) {
        final type = resolveAlertType('${entry.key}');
        if (type == null) {
          continue;
        }
        final channels = entry.value;
        incoming[type] = channels is List
            ? sanitizeChannels(channels)
            : const [];
      }
    }

    final result = <AlertTypeChannels>[];
    for (final type in SystemAlertType.values) {
      final channels = incoming[type] ?? const <String>[];
      result.add(
        AlertTypeChannels(
          type: type,
          channels: channels.isEmpty ? defaultChannels(type) : channels,
        ),
      );
    }

    return result;
  }

  static Map<String, List<String>> encodeRouting(
    List<AlertTypeChannels> routing,
  ) {
    final stored = <String, List<String>>{
      for (final type in SystemAlertType.values)
        type.name: defaultChannels(type),
    };

    for (final entry in routing) {
      final channels = sanitizeChannels(entry.channels);
      if (channels.isNotEmpty) {
        stored[entry.type.name] = channels;
      }
    }

    return stored;
  }

  static SystemAlertType? resolveAlertType(String key) {
    final remapped = legacyTypeKeys[key] ?? key;
    for (final type in SystemAlertType.values) {
      if (type.name == remapped) {
        return type;
      }
    }
    return null;
  }

  static List<String> defaultChannels(SystemAlertType alertType) {
    return [SystemAlertChannel.database.value];
  }

  static List<String> sanitizeChannels(List<dynamic> channels) {
    final clean = <String>[];

    for (final channel in channels) {
      final value = channel is String ? channel : '';
      if (value.isEmpty || !allowedChannels.contains(value)) {
        continue;
      }
      if (!clean.contains(value)) {
        clean.add(value);
      }
    }

    return clean;
  }
}
