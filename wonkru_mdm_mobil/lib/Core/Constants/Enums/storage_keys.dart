enum Sk {
  lastConfigFetchTime,
  deviceCode,
  device_code,
  deviceUuid,
  deviceToken,
  lastPolicyUpdate,
  lastPolicyVersion,
  lastSync,
  installTime,
  permissionsCompletedAt,
  installedAppsCache,
  bootStartupApps,
  app_events,
  restriction_lifted,
  launcher_mode_enabled,
  engine_owner,
  watchdog_service_enabled,
  flutter_alive_timestamp,
  locale,
  server_url,
  bootstrap_ca_cert_b64,
  bt_management_admin_password,
  wlogConfig,

  /// Last processed command ids + ack outcomes (dedupe filter, pending acks).
  commandJournal,

  /// Global enrollment key (secure store). A QR extra lands in [BasicStorage]
  /// as `enrollment_key` and is moved here.
  enrollmentKey,

  /// Enrollment key the server rejected; while it matches, no automatic
  /// re-enroll is attempted.
  enrollmentKeyRejected,

  /// Set so the watchdog does not re-enable Wi-Fi the operator turned off with
  /// `disable_wifi`.
  wifiOperatorOverride,
}
