import '../generated/protocol.dart';

class RestrictionCatalog {
  const RestrictionCatalog._();

  static final List<RestrictionCatalogEntry>
  all = List<RestrictionCatalogEntry>.unmodifiable(<RestrictionCatalogEntry>[
    RestrictionCatalogEntry(
      name: 'ALLOW_PARENT_PROFILE_APP_LINKING',
      key: 'allow_parent_profile_app_linking',
      apiLevel: 23,
      group: 'applications',
    ),
    RestrictionCatalogEntry(
      name: 'DISALLOW_ADD_PRIVATE_PROFILE',
      key: 'no_add_private_profile',
      apiLevel: 35,
      group: 'user_and_account',
    ),
    RestrictionCatalogEntry(
      name: 'DISALLOW_AMBIENT_DISPLAY',
      key: 'no_ambient_display',
      apiLevel: 28,
      group: 'device',
    ),
    RestrictionCatalogEntry(
      name: 'DISALLOW_APPS_CONTROL',
      key: 'no_control_apps',
      apiLevel: 21,
      group: 'applications',
    ),
    RestrictionCatalogEntry(
      name: 'DISALLOW_ASSIST_CONTENT',
      key: 'no_assist_content',
      apiLevel: 35,
      group: 'privacy_and_sharing',
    ),
    RestrictionCatalogEntry(
      name: 'DISALLOW_BLUETOOTH',
      key: 'no_bluetooth',
      apiLevel: 26,
      group: 'device',
    ),
    RestrictionCatalogEntry(
      name: 'DISALLOW_BLUETOOTH_SHARING',
      key: 'no_bluetooth_sharing',
      apiLevel: 26,
      group: 'device',
    ),
    RestrictionCatalogEntry(
      name: 'DISALLOW_CAMERA',
      key: 'no_camera',
      apiLevel: 18,
      group: 'security',
    ),
    RestrictionCatalogEntry(
      name: 'DISALLOW_CAMERA_TOGGLE',
      key: 'disallow_camera_toggle',
      apiLevel: 31,
      group: 'security',
    ),
    RestrictionCatalogEntry(
      name: 'DISALLOW_CHANGE_NEAR_FIELD_COMMUNICATION_RADIO',
      key: 'no_change_near_field_communication_radio',
      apiLevel: 36,
      group: 'network',
    ),
    RestrictionCatalogEntry(
      name: 'DISALLOW_CONFIG_BLUETOOTH',
      key: 'no_config_bluetooth',
      apiLevel: 18,
      group: 'device',
    ),
    RestrictionCatalogEntry(
      name: 'DISALLOW_CONFIG_CELL_BROADCASTS',
      key: 'no_config_cell_broadcasts',
      apiLevel: 21,
      group: 'network',
    ),
    RestrictionCatalogEntry(
      name: 'DISALLOW_CONFIG_CREDENTIALS',
      key: 'no_config_credentials',
      apiLevel: 18,
      group: 'user_and_account',
    ),
    RestrictionCatalogEntry(
      name: 'DISALLOW_CONFIG_SCREEN_TIMEOUT',
      key: 'no_config_screen_timeout',
      apiLevel: 28,
      group: 'device',
    ),
    RestrictionCatalogEntry(
      name: 'DISALLOW_CONTENT_CAPTURE',
      key: 'no_content_capture',
      apiLevel: 29,
      group: 'privacy_and_sharing',
    ),
    RestrictionCatalogEntry(
      name: 'DISALLOW_CONTENT_SUGGESTIONS',
      key: 'no_content_suggestions',
      apiLevel: 29,
      group: 'privacy_and_sharing',
    ),
    RestrictionCatalogEntry(
      name: 'DISALLOW_CREATE_WINDOWS',
      key: 'no_create_windows',
      apiLevel: 21,
      group: 'applications',
    ),
    RestrictionCatalogEntry(
      name: 'DISALLOW_CROSS_PROFILE_COPY_PASTE',
      key: 'no_cross_profile_copy_paste',
      apiLevel: 21,
      group: 'privacy_and_sharing',
    ),
    RestrictionCatalogEntry(
      name: 'DISALLOW_FUN',
      key: 'no_fun',
      apiLevel: 23,
      group: 'system_and_ui',
    ),
    RestrictionCatalogEntry(
      name: 'DISALLOW_MICROPHONE_TOGGLE',
      key: 'disallow_microphone_toggle',
      apiLevel: 31,
      group: 'security',
    ),
    RestrictionCatalogEntry(
      name: 'DISALLOW_MODIFY_ACCOUNTS',
      key: 'no_modify_accounts',
      apiLevel: 18,
      group: 'user_and_account',
    ),
    RestrictionCatalogEntry(
      name: 'DISALLOW_MOUNT_PHYSICAL_MEDIA',
      key: 'no_physical_media',
      apiLevel: 21,
      group: 'device',
    ),
    RestrictionCatalogEntry(
      name: 'DISALLOW_NEAR_FIELD_COMMUNICATION_RADIO',
      key: 'no_near_field_communication_radio',
      apiLevel: 35,
      group: 'network',
    ),
    RestrictionCatalogEntry(
      name: 'DISALLOW_NETWORK_RESET',
      key: 'no_network_reset',
      apiLevel: 23,
      group: 'network',
    ),
    RestrictionCatalogEntry(
      name: 'DISALLOW_OUTGOING_BEAM',
      key: 'no_outgoing_beam',
      apiLevel: 22,
      group: 'network',
    ),
    RestrictionCatalogEntry(
      name: 'DISALLOW_OUTGOING_CALLS',
      key: 'no_outgoing_calls',
      apiLevel: 21,
      group: 'system_and_ui',
    ),
    RestrictionCatalogEntry(
      name: 'DISALLOW_PRINTING',
      key: 'no_printing',
      apiLevel: 28,
      group: 'device',
    ),
    RestrictionCatalogEntry(
      name: 'DISALLOW_REMOVE_USER',
      key: 'no_remove_user',
      apiLevel: 18,
      group: 'user_and_account',
    ),
    RestrictionCatalogEntry(
      name: 'DISALLOW_RUN_IN_BACKGROUND',
      key: 'no_run_in_background',
      apiLevel: 18,
      group: 'applications',
    ),
    RestrictionCatalogEntry(
      name: 'DISALLOW_SET_USER_ICON',
      key: 'no_set_user_icon',
      apiLevel: 24,
      group: 'user_and_account',
    ),
    RestrictionCatalogEntry(
      name: 'DISALLOW_SHARE_INTO_MANAGED_PROFILE',
      key: 'no_sharing_into_profile',
      apiLevel: 28,
      group: 'privacy_and_sharing',
    ),
    RestrictionCatalogEntry(
      name: 'DISALLOW_SIM_GLOBALLY',
      key: 'no_sim_globally',
      apiLevel: 35,
      group: 'network',
    ),
    RestrictionCatalogEntry(
      name: 'DISALLOW_SYSTEM_ERROR_DIALOGS',
      key: 'no_system_error_dialogs',
      apiLevel: 28,
      group: 'applications',
    ),
    RestrictionCatalogEntry(
      name: 'DISALLOW_THREAD_NETWORK',
      key: 'no_thread_network',
      apiLevel: 36,
      group: 'network',
    ),
    RestrictionCatalogEntry(
      name: 'DISALLOW_ULTRA_WIDEBAND_RADIO',
      key: 'no_ultra_wideband_radio',
      apiLevel: 34,
      group: 'network',
    ),
    RestrictionCatalogEntry(
      name: 'DISALLOW_UNMUTE_DEVICE',
      key: 'disallow_unmute_device',
      apiLevel: 28,
      group: 'device',
    ),
    RestrictionCatalogEntry(
      name: 'ENSURE_VERIFY_APPS',
      key: 'ensure_verify_apps',
      apiLevel: 21,
      group: 'security',
    ),
    RestrictionCatalogEntry(
      name: 'KEY_RESTRICTIONS_PENDING',
      key: 'restrictions_pending',
      apiLevel: 22,
      group: 'device',
    ),
  ]);

  static final Map<String, RestrictionCatalogEntry> byKey =
      Map<String, RestrictionCatalogEntry>.unmodifiable({
        for (final entry in all) entry.key: entry,
      });
}
