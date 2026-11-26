/// Strips identity secrets out of the device storage dumps in a sync.
///
/// Agents put the contents of `st` (secure storage) and `bs` (SharedPreferences)
/// into the sync. Newer agents already omit secrets; this filter is a second gate
/// against older agents and mistakes: the keys below are removed before
/// `DeviceSync.stInfo` / `bsInfo` are written to disk.
///
/// Migration `20260924121924654-device-token-hash` clears the same keys from
/// existing rows, so the list must be kept in sync with it.
class DeviceSyncSanitizer {
  const DeviceSyncSanitizer._();

  static const secretKeys = <String>{
    'deviceToken',
    'enrollment_key',
    'enrollmentKey',
    'enrollmentKeyRejected',
    'commandJournal',
    'bt_management_admin_password',
    'device_config',
  };

  static Map<String, dynamic> strip(Map<String, dynamic> data) => {
    for (final entry in data.entries)
      if (!secretKeys.contains(entry.key)) entry.key: entry.value,
  };
}
