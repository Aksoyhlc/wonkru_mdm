/// Labels for the device PDF report.
///
/// The report is produced **server-side**, so the panel's translation
/// dictionaries cannot be used directly; the panel passes its active locale
/// through `reportPdf(deviceId, locale)` and the texts come from here. There is
/// one dictionary per language, and the keys are identical in both (a guard test
/// enforces that, and that the EN texts contain no Turkish characters).
///
/// The `@name` placeholders in a value are filled by [fill], the same contract
/// as the `@count` format in the panel catalogs.
class DevicePdfLabels {
  const DevicePdfLabels._(this._values);

  final Map<String, String> _values;

  /// Turkish (the default).
  static const tr = <String, String>{
    'reportTitle': 'Cihaz Raporu',
    'produced': 'Üretim',
    'pageOf': 'Sayfa @page / @total',
    'deviceIdentity': 'Cihaz Kimliği',
    'lastStatus': 'Son Durum',
    'lastStatusSummary': 'Son Durum Özeti',
    'security': 'Güvenlik',
    'installedApps': 'Kurulu Uygulamalar',
    'logSummary': 'Günlük Özeti',
    'code': 'Kod',
    'name': 'Ad',
    'serialNo': 'Seri No',
    'manufacturer': 'Üretici',
    'brand': 'Marka',
    'model': 'Model',
    'androidVersion': 'Android Sürümü',
    'agentVersion': 'Ajan Sürümü',
    'firstSeen': 'İlk Görülme',
    'lastSeen': 'Son Görülme',
    'lastSync': 'Son Senkron',
    'online': 'Çevrimiçi',
    'battery': 'Batarya',
    'networkSsid': 'Ağ (SSID)',
    'ipAddress': 'IP Adresi',
    'storage': 'Depolama',
    'appCount': 'Uygulama Sayısı',
    'agentKiosk': 'Ajan / Kiosk',
    'noSyncData': 'Bu cihaz için henüz senkron verisi yok.',
    'rooted': 'Root',
    'adb': 'ADB',
    'developerOptions': 'Geliştirici Seçenekleri',
    'unknownSources': 'Bilinmeyen Kaynaklar',
    'encryption': 'Şifreleme',
    'secureLock': 'Ekran Kilidi',
    'deviceOwner': 'Device Owner',
    'passwordSufficient': 'Parola Yeterli',
    'playProtect': 'Play Protect',
    'appCountSummary': 'Toplam @total · kullanıcı @user · sistem @system',
    'noApps': 'Kayıtlı uygulama yok.',
    'app': 'Uygulama',
    'package': 'Paket',
    'version': 'Sürüm',
    'type': 'Tür',
    'system': 'Sistem',
    'user': 'Kullanıcı',
    'capNote': 'Not: @count kayıttan sonrası listelenmedi.',
    'noLogs': 'Kayıtlı günlük yok.',
    'recentLogs': 'Son @count kayıt',
    'time': 'Zaman',
    'level': 'Seviye',
    'tag': 'Etiket',
    'message': 'Mesaj',
    'yes': 'Evet',
    'no': 'Hayır',
    'countTotal': 'toplam @count',
    'countUser': 'kullanıcı @count',
    'countSystem': 'sistem @count',
    'countManaged': 'yönetilen @count',
  };

  static const en = <String, String>{
    'reportTitle': 'Device Report',
    'produced': 'Generated',
    'pageOf': 'Page @page / @total',
    'deviceIdentity': 'Device Identity',
    'lastStatus': 'Last Status',
    'lastStatusSummary': 'Status Summary',
    'security': 'Security',
    'installedApps': 'Installed Applications',
    'logSummary': 'Log Summary',
    'code': 'Code',
    'name': 'Name',
    'serialNo': 'Serial No',
    'manufacturer': 'Manufacturer',
    'brand': 'Brand',
    'model': 'Model',
    'androidVersion': 'Android Version',
    'agentVersion': 'Agent Version',
    'firstSeen': 'First Seen',
    'lastSeen': 'Last Seen',
    'lastSync': 'Last Sync',
    'online': 'Online',
    'battery': 'Battery',
    'networkSsid': 'Network (SSID)',
    'ipAddress': 'IP Address',
    'storage': 'Storage',
    'appCount': 'Application Count',
    'agentKiosk': 'Agent / Kiosk',
    'noSyncData': 'No sync data for this device yet.',
    'rooted': 'Root',
    'adb': 'ADB',
    'developerOptions': 'Developer Options',
    'unknownSources': 'Unknown Sources',
    'encryption': 'Encryption',
    'secureLock': 'Screen Lock',
    'deviceOwner': 'Device Owner',
    'passwordSufficient': 'Password Sufficient',
    'playProtect': 'Play Protect',
    'appCountSummary': 'Total @total · user @user · system @system',
    'noApps': 'No applications recorded.',
    'app': 'Application',
    'package': 'Package',
    'version': 'Version',
    'type': 'Type',
    'system': 'System',
    'user': 'User',
    'capNote': 'Note: entries after @count were not listed.',
    'noLogs': 'No logs recorded.',
    'recentLogs': 'Last @count records',
    'time': 'Time',
    'level': 'Level',
    'tag': 'Tag',
    'message': 'Message',
    'yes': 'Yes',
    'no': 'No',
    'countTotal': 'total @count',
    'countUser': 'user @count',
    'countSystem': 'system @count',
    'countManaged': 'managed @count',
  };

  /// Unknown or empty locales fall back to Turkish.
  static DevicePdfLabels forLocale(String? locale) =>
      locale?.toLowerCase() == 'en'
      ? const DevicePdfLabels._(en)
      : const DevicePdfLabels._(tr);

  /// Returns the key itself for an unknown key, so it is noticed during
  /// development.
  String operator [](String key) => _values[key] ?? key;

  static String fill(String template, Map<String, String> values) {
    var result = template;
    for (final entry in values.entries) {
      result = result.replaceAll('@${entry.key}', entry.value);
    }
    return result;
  }
}
