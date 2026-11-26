package com.wonkrumdm.core

object Constants {
    private const val PACKAGE_PREFIX = "com.wonkrumdm"

    const val ACTION_INSTALL_COMPLETE = "$PACKAGE_PREFIX.ACTION_INSTALL_COMPLETE"
    const val ACTION_UNINSTALL_COMPLETE = "$PACKAGE_PREFIX.ACTION_UNINSTALL_COMPLETE"

    const val EXTRA_TARGET_PACKAGE_NAME = "target_package_name"
    const val EXTRA_RESTORE_INSTALL_RESTRICTION = "restore_install_restriction"

    const val KEY_DEVICE_UUID = "deviceUuid"
    const val KEY_DEVICE_CODE = "deviceCode"
    const val KEY_WLOG_CONFIG = "wlogConfig"
    const val KEY_BOOT_STARTUP_APPS = "bootStartupApps"
    const val KEY_APP_EVENTS = "app_events"
    const val KEY_RESTRICTION_LIFTED = "restriction_lifted"
    const val KEY_LAUNCHER_MODE_ENABLED = "launcher_mode_enabled"
    const val KEY_ENGINE_OWNER = "engine_owner"
    const val KEY_WATCHDOG_SERVICE_ENABLED = "watchdog_service_enabled"
    const val KEY_PERMISSIONS_COMPLETED_AT = "permissionsCompletedAt"
    const val KEY_INSTALL_TIME = "installTime"
    const val KEY_FLUTTER_ALIVE_TIMESTAMP = "flutter_alive_timestamp"
}