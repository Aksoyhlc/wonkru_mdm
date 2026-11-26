import 'package:get/get.dart';

/// Every key has a getter, enforced by `test/logic/l10n_accessor_test.dart`.
/// Placeholder texts are fetched at the call site with `.trParams(...)`.
final class PoliciesL {
  const PoliciesL();

  String get emptyTitle => 'policies.empty_title'.tr;
  String get emptySubtitle => 'policies.empty_subtitle'.tr;
  String get newPolicy => 'policies.new_policy'.tr;
  String get slug => 'policies.slug'.tr;
  String get slugHint => 'policies.slug_hint'.tr;
  String get isDefault => 'policies.is_default'.tr;
  String get updatedAt => 'policies.updated_at'.tr;
  String get notDefault => 'policies.not_default'.tr;
  String get preview => 'policies.preview'.tr;
  String get sendToDevices => 'policies.send_to_devices'.tr;
  String get makeDefault => 'policies.make_default'.tr;
  String get copiedToast => 'policies.copied_toast'.tr;
  String get copyFailed => 'policies.copy_failed'.tr;
  String get previewFailed => 'policies.preview_failed'.tr;
  String get sendConfirm => 'policies.send_confirm'.tr;
  String get sendQueued => 'policies.send_queued'.tr;
  String get sendFailed => 'policies.send_failed'.tr;
  String get alreadyDefault => 'policies.already_default'.tr;
  String get defaultUpdated => 'policies.default_updated'.tr;
  String get setDefaultFailed => 'policies.set_default_failed'.tr;
  String get deleteTitle => 'policies.delete_title'.tr;
  String get deleted => 'policies.deleted'.tr;
  String get previewTitle => 'policies.preview_title'.tr;
  String get copyNameSuffix => 'policies.copy_name_suffix'.tr;
  String get nameRequired => 'policies.name_required'.tr;
  String get cloneTitle => 'policies.clone_title'.tr;
  String get newNameLabel => 'policies.new_name_label'.tr;
  String get loadFailed => 'policies.load_failed'.tr;
  String get applications => 'policies.applications'.tr;
  String get files => 'policies.files'.tr;
  String get certificates => 'policies.certificates'.tr;
  String get selectorsList => 'policies.selectors_list'.tr;
  String get pivotLists => 'policies.pivot_lists'.tr;
  String get loadWarning => 'policies.load_warning'.tr;
  String get and => 'policies.and'.tr;
  String get retry => 'policies.retry'.tr;
  String get adminPassword => 'policies.admin_password'.tr;
  String get adminPasswordHint => 'policies.admin_password_hint'.tr;
  String get adminPasswordRequiredHint =>
      'policies.admin_password_required_hint'.tr;
  String get adminPasswordRequired => 'policies.admin_password_required'.tr;
  String get defaultPolicy => 'policies.default_policy'.tr;
  String get restrictionSaveWarning => 'policies.restriction_save_warning'.tr;
  String get created => 'policies.created'.tr;
  String get updated => 'policies.updated'.tr;
  String get pivotSaveFirst => 'policies.pivot_save_first'.tr;
  String get tabAudio => 'policies.tab_audio'.tr;
  String get tabOther => 'policies.tab_other'.tr;
  String get tabDisplay => 'policies.tab_display'.tr;
  String get tabRestriction => 'policies.tab_restriction'.tr;
  String get groupActiveTimeRanges => 'policies.group_active_time_ranges'.tr;
  String get addTimeRange => 'policies.add_time_range'.tr;
  String get noTimeRanges => 'policies.no_time_ranges'.tr;
  String get fieldActiveTimeRanges => 'policies.field_active_time_ranges'.tr;
  String get helperActiveTimeRanges => 'policies.helper_active_time_ranges'.tr;
  String get groupSyncSettings => 'policies.group_sync_settings'.tr;
  String get fieldFullSyncCron => 'policies.field_full_sync_cron'.tr;
  String get helperFullSyncCron => 'policies.helper_full_sync_cron'.tr;
  String get fieldMaxInterval => 'policies.field_max_interval'.tr;
  String get helperMaxInterval => 'policies.helper_max_interval'.tr;
  String get groupBatteryThresholds => 'policies.group_battery_thresholds'.tr;
  String get fieldLowBatteryThreshold =>
      'policies.field_low_battery_threshold'.tr;
  String get helperLowBattery => 'policies.helper_low_battery'.tr;
  String get fieldCriticalBatteryThreshold =>
      'policies.field_critical_battery_threshold'.tr;
  String get helperCriticalBattery => 'policies.helper_critical_battery'.tr;
  String get groupStorageThresholds => 'policies.group_storage_thresholds'.tr;
  String get fieldWarningThreshold => 'policies.field_warning_threshold'.tr;
  String get helperWarningThreshold => 'policies.helper_warning_threshold'.tr;
  String get fieldCriticalThreshold => 'policies.field_critical_threshold'.tr;
  String get helperCriticalThreshold => 'policies.helper_critical_threshold'.tr;
  String get groupAudioSettings => 'policies.group_audio_settings'.tr;
  String get fieldFixedVolumePolicy => 'policies.field_fixed_volume_policy'.tr;
  String get fieldFixedVolume => 'policies.field_fixed_volume'.tr;
  String get fieldMinVolume => 'policies.field_min_volume'.tr;
  String get fieldMaxVolume => 'policies.field_max_volume'.tr;
  String get fieldNoConfigBluetooth => 'policies.field_no_config_bluetooth'.tr;
  String get helperNoConfigBluetooth =>
      'policies.helper_no_config_bluetooth'.tr;
  String get fieldNoBluetooth => 'policies.field_no_bluetooth'.tr;
  String get helperNoBluetooth => 'policies.helper_no_bluetooth'.tr;
  String get fieldNoBluetoothSharing =>
      'policies.field_no_bluetooth_sharing'.tr;
  String get helperNoBluetoothSharing =>
      'policies.helper_no_bluetooth_sharing'.tr;
  String get groupDatetimeSettings => 'policies.group_datetime_settings'.tr;
  String get fieldAutoTime => 'policies.field_auto_time'.tr;
  String get fieldAutoTimeZone => 'policies.field_auto_time_zone'.tr;
  String get fieldTimeZone => 'policies.field_time_zone'.tr;
  String get helperTimeZone => 'policies.helper_time_zone'.tr;
  String get fieldTimeFormat => 'policies.field_time_format'.tr;
  String get optionHours12 => 'policies.option_hours_12'.tr;
  String get optionHours24 => 'policies.option_hours_24'.tr;
  String get fieldNoPhysicalMedia => 'policies.field_no_physical_media'.tr;
  String get helperNoPhysicalMedia => 'policies.helper_no_physical_media'.tr;
  String get groupHardware => 'policies.group_hardware'.tr;
  String get fieldNoCamera => 'policies.field_no_camera'.tr;
  String get helperNoCamera => 'policies.helper_no_camera'.tr;
  String get fieldRequiredWifi => 'policies.field_required_wifi'.tr;
  String get groupScreenLock => 'policies.group_screen_lock'.tr;
  String get fieldLockScreenMessage => 'policies.field_lock_screen_message'.tr;
  String get helperLockScreenMessage =>
      'policies.helper_lock_screen_message'.tr;
  String get fieldScreenCapturePolicy =>
      'policies.field_screen_capture_policy'.tr;
  String get helperScreenCapturePolicy =>
      'policies.helper_screen_capture_policy'.tr;
  String get groupTimeout => 'policies.group_timeout'.tr;
  String get fieldScreenTimeout => 'policies.field_screen_timeout'.tr;
  String get helperScreenTimeout => 'policies.helper_screen_timeout'.tr;
  String get fieldTimeoutLock => 'policies.field_timeout_lock'.tr;
  String get helperTimeoutLock => 'policies.helper_timeout_lock'.tr;
  String get groupBrightness => 'policies.group_brightness'.tr;
  String get fieldBrightnessLock => 'policies.field_brightness_lock'.tr;
  String get helperBrightnessLock => 'policies.helper_brightness_lock'.tr;
  String get fieldBrightnessLevel => 'policies.field_brightness_level'.tr;
  String get fieldMinBrightness => 'policies.field_min_brightness'.tr;
  String get fieldMaxBrightness => 'policies.field_max_brightness'.tr;
  String get fieldAutoBrightnessPolicy =>
      'policies.field_auto_brightness_policy'.tr;
  String get groupRotation => 'policies.group_rotation'.tr;
  String get fieldRotationPolicy => 'policies.field_rotation_policy'.tr;
  String get optionFree => 'policies.option_free'.tr;
  String get optionLocked => 'policies.option_locked'.tr;
  String get optionSystemDefault => 'policies.option_system_default'.tr;
  String get fieldLockedOrientation => 'policies.field_locked_orientation'.tr;
  String get optionPortrait => 'policies.option_portrait'.tr;
  String get optionLandscape => 'policies.option_landscape'.tr;
  String get optionPortraitReverse => 'policies.option_portrait_reverse'.tr;
  String get optionLandscapeReverse => 'policies.option_landscape_reverse'.tr;
  String get optionAuto => 'policies.option_auto'.tr;
  String get helperLockedOrientation => 'policies.helper_locked_orientation'.tr;
  String get groupPasswordPolicy => 'policies.group_password_policy'.tr;
  String get fieldComplexityLevel => 'policies.field_complexity_level'.tr;
  String get optionCustom => 'policies.option_custom'.tr;
  String get optionLow => 'policies.option_low'.tr;
  String get optionMedium => 'policies.option_medium'.tr;
  String get optionHigh => 'policies.option_high'.tr;
  String get fieldPasswordQuality => 'policies.field_password_quality'.tr;
  String get optionUnspecified => 'policies.option_unspecified'.tr;
  String get optionNumeric => 'policies.option_numeric'.tr;
  String get optionAlpha => 'policies.option_alpha'.tr;
  String get optionAlphanumeric => 'policies.option_alphanumeric'.tr;
  String get optionComplex => 'policies.option_complex'.tr;
  String get fieldMinLength => 'policies.field_min_length'.tr;
  String get fieldMinUpperCase => 'policies.field_min_upper_case'.tr;
  String get fieldMinLowerCase => 'policies.field_min_lower_case'.tr;
  String get fieldMinLetters => 'policies.field_min_letters'.tr;
  String get fieldMinNumeric => 'policies.field_min_numeric'.tr;
  String get fieldMinSymbols => 'policies.field_min_symbols'.tr;
  String get fieldMinNonLetter => 'policies.field_min_non_letter'.tr;
  String get fieldHistoryLength => 'policies.field_history_length'.tr;
  String get fieldPasswordExpiration => 'policies.field_password_expiration'.tr;
  String get fieldMaxFailedAttempts => 'policies.field_max_failed_attempts'.tr;
  String get groupKeyguard => 'policies.group_keyguard'.tr;
  String get fieldDisableLockScreenCamera =>
      'policies.field_disable_lock_screen_camera'.tr;
  String get fieldHideNotificationContent =>
      'policies.field_hide_notification_content'.tr;
  String get fieldDisableFingerprint => 'policies.field_disable_fingerprint'.tr;
  String get fieldDisableFaceUnlock => 'policies.field_disable_face_unlock'.tr;
  String get fieldDisableIris => 'policies.field_disable_iris'.tr;
  String get fieldDisableAllBiometrics =>
      'policies.field_disable_all_biometrics'.tr;
  String get fieldDisableSmartLock => 'policies.field_disable_smart_lock'.tr;
  String get groupAccessibility => 'policies.group_accessibility'.tr;
  String get fieldAllowedAccessibilityApps =>
      'policies.field_allowed_accessibility_apps'.tr;
  String get helperAllowedAccessibilityApps =>
      'policies.helper_allowed_accessibility_apps'.tr;
  String get groupLauncherMode => 'policies.group_launcher_mode'.tr;
  String get fieldLauncherModeEnabled =>
      'policies.field_launcher_mode_enabled'.tr;
  String get helperLauncherMode => 'policies.helper_launcher_mode'.tr;
  String get groupGrid => 'policies.group_grid'.tr;
  String get fieldGridColumns => 'policies.field_grid_columns'.tr;
  String get helperGridColumns => 'policies.helper_grid_columns'.tr;
  String get groupBackground => 'policies.group_background'.tr;
  String get fieldBackgroundType => 'policies.field_background_type'.tr;
  String get optionColor => 'policies.option_color'.tr;
  String get optionImage => 'policies.option_image'.tr;
  String get fieldBackgroundColor => 'policies.field_background_color'.tr;
  String get helperBackgroundColor => 'policies.helper_background_color'.tr;
  String get fieldBackgroundImage => 'policies.field_background_image'.tr;
  String get helperBackgroundImage => 'policies.helper_background_image'.tr;
  String get groupAppDisplay => 'policies.group_app_display'.tr;
  String get fieldIconSize => 'policies.field_icon_size'.tr;
  String get optionSmall => 'policies.option_small'.tr;
  String get optionLarge => 'policies.option_large'.tr;
  String get fieldShowLabel => 'policies.field_show_label'.tr;
  String get fieldLabelColor => 'policies.field_label_color'.tr;
  String get helperLabelColor => 'policies.helper_label_color'.tr;
  String get fieldItemBackgroundColor =>
      'policies.field_item_background_color'.tr;
  String get helperItemBackgroundColor =>
      'policies.helper_item_background_color'.tr;
  String get fieldBorderRadius => 'policies.field_border_radius'.tr;
  String get fieldLabelFontSize => 'policies.field_label_font_size'.tr;
  String get fieldLongPressSettings => 'policies.field_long_press_settings'.tr;
  String get groupHeaderWidgets => 'policies.group_header_widgets'.tr;
  String get fieldHeaderLeft => 'policies.field_header_left'.tr;
  String get fieldHeaderCenter => 'policies.field_header_center'.tr;
  String get fieldHeaderRight => 'policies.field_header_right'.tr;
  String get noApplications => 'policies.no_applications'.tr;
  String get action => 'policies.action'.tr;
  String get order => 'policies.order'.tr;
  String get flags => 'policies.flags'.tr;
  String get up => 'policies.up'.tr;
  String get down => 'policies.down'.tr;
  String get flagBoot => 'policies.flag_boot'.tr;
  String get flagAfterInstall => 'policies.flag_after_install'.tr;
  String get actionInstall => 'policies.action_install'.tr;
  String get actionConfigure => 'policies.action_configure'.tr;
  String get selectApplication => 'policies.select_application'.tr;
  String get applicationAdded => 'policies.application_added'.tr;
  String get applicationUpdated => 'policies.application_updated'.tr;
  String get removeApplicationTitle => 'policies.remove_application_title'.tr;
  String get removeApplicationConfirm =>
      'policies.remove_application_confirm'.tr;
  String get applicationRemoved => 'policies.application_removed'.tr;
  String get editApplication => 'policies.edit_application'.tr;
  String get addApplication => 'policies.add_application'.tr;
  String get showInLauncher => 'policies.show_in_launcher'.tr;
  String get runOnBoot => 'policies.run_on_boot'.tr;
  String get uninstallBlock => 'policies.uninstall_block'.tr;
  String get startAfterInstall => 'policies.start_after_install'.tr;
  String get loadingVersions => 'policies.loading_versions'.tr;
  String get targetVersion => 'policies.target_version'.tr;
  String get noVersion => 'policies.no_version'.tr;
  String get customAppName => 'policies.custom_app_name'.tr;
  String get grantPermission => 'policies.grant_permission'.tr;
  String get updatePolicy => 'policies.update_policy'.tr;
  String get updateAlways => 'policies.update_always'.tr;
  String get updateWifiOnly => 'policies.update_wifi_only'.tr;
  String get updateNever => 'policies.update_never'.tr;
  String get operationOpen => 'policies.operation_open'.tr;
  String get destinationPath => 'policies.destination_path'.tr;

  String get destinationPathAbsoluteRequired =>
      'policies.destination_path_absolute_required'.tr;

  String get filterSystemTitle => 'policies.filter_system_title'.tr;

  String get filterInstallableTitle => 'policies.filter_installable_title'.tr;

  String get filterSystemApps => 'policies.filter_system_apps'.tr;

  String get filterUserApps => 'policies.filter_user_apps'.tr;

  String get installable => 'policies.installable'.tr;

  String get notInstallable => 'policies.not_installable'.tr;
  String get addPath => 'policies.add_path'.tr;
  String get deletePath => 'policies.delete_path'.tr;
  String get deletePathHint => 'policies.delete_path_hint'.tr;
  String get uploadFile => 'policies.upload_file'.tr;
  String get noFilesForOperation => 'policies.no_files_for_operation'.tr;
  String get file => 'policies.file'.tr;
  String get flagReplaceIfExists => 'policies.flag_replace_if_exists'.tr;
  String get flagOpenAfterDownload => 'policies.flag_open_after_download'.tr;
  String get pickFileForOperation => 'policies.pick_file_for_operation'.tr;
  String get fileAdded => 'policies.file_added'.tr;
  String get fileUploaded => 'policies.file_uploaded'.tr;
  String get fileUpdated => 'policies.file_updated'.tr;
  String get removeFileTitle => 'policies.remove_file_title'.tr;
  String get removeFileConfirm => 'policies.remove_file_confirm'.tr;
  String get fileRemoved => 'policies.file_removed'.tr;
  String get fileNoDownloadUrl => 'policies.file_no_download_url'.tr;
  String get linkCopied => 'policies.link_copied'.tr;
  String get editFile => 'policies.edit_file'.tr;
  String get addFile => 'policies.add_file'.tr;
  String get operation => 'policies.operation'.tr;
  String get openAfterDownload => 'policies.open_after_download'.tr;
  String get selectFileFirst => 'policies.select_file_first'.tr;
  String get uploadFileTitle => 'policies.upload_file_title'.tr;
  String get uploadAndAdd => 'policies.upload_and_add'.tr;
  String get fileDropHelper => 'policies.file_drop_helper'.tr;
  String get newCertificate => 'policies.new_certificate'.tr;
  String get noCertificates => 'policies.no_certificates'.tr;
  String get certificate => 'policies.certificate'.tr;
  String get selectCertificate => 'policies.select_certificate'.tr;
  String get certificateAdded => 'policies.certificate_added'.tr;
  String get certificateCreatedAttached =>
      'policies.certificate_created_attached'.tr;
  String get removeCertificateTitle => 'policies.remove_certificate_title'.tr;
  String get removeCertificateConfirm =>
      'policies.remove_certificate_confirm'.tr;
  String get certificateRemoved => 'policies.certificate_removed'.tr;
  String get addCertificate => 'policies.add_certificate'.tr;
  String get noTags => 'policies.no_tags'.tr;
  String get addValueHint => 'policies.add_value_hint'.tr;
  String get hintKey => 'policies.hint_key'.tr;
  String get hintValue => 'policies.hint_value'.tr;
  String get noRecords => 'policies.no_records'.tr;
  String get restrictionLoadFailed => 'policies.restriction_load_failed'.tr;
  String get restrictionStateDefault => 'policies.restriction_state_default'.tr;
  String get restrictionStateRestrict =>
      'policies.restriction_state_restrict'.tr;
  String get triDefault => 'policies.tri_default'.tr;
  String get rangeInvalid => 'policies.range_invalid'.tr;
  String get valueClampedToMax => 'policies.value_clamped_to_max'.tr;
  String get brightnessRangeInvalid => 'policies.brightness_range_invalid'.tr;
  String get restrictionGroupNetwork => 'policies.restriction_group.network'.tr;
  String get restrictionGroupApplications =>
      'policies.restriction_group.applications'.tr;
  String get restrictionGroupUserAndAccount =>
      'policies.restriction_group.user_and_account'.tr;
  String get restrictionGroupPrivacyAndSharing =>
      'policies.restriction_group.privacy_and_sharing'.tr;
  String get restrictionGroupSystemAndUi =>
      'policies.restriction_group.system_and_ui'.tr;
  String get restrictionAllowParentProfileAppLinking =>
      'policies.restriction.allow_parent_profile_app_linking'.tr;
  String get restrictionNoAddPrivateProfile =>
      'policies.restriction.no_add_private_profile'.tr;
  String get restrictionNoAmbientDisplay =>
      'policies.restriction.no_ambient_display'.tr;
  String get restrictionNoControlApps =>
      'policies.restriction.no_control_apps'.tr;
  String get restrictionNoAssistContent =>
      'policies.restriction.no_assist_content'.tr;
  String get restrictionNoBluetooth => 'policies.restriction.no_bluetooth'.tr;
  String get restrictionNoBluetoothSharing =>
      'policies.restriction.no_bluetooth_sharing'.tr;
  String get restrictionNoCamera => 'policies.restriction.no_camera'.tr;
  String get restrictionDisallowCameraToggle =>
      'policies.restriction.disallow_camera_toggle'.tr;
  String get restrictionNoChangeNearFieldCommunicationRadio =>
      'policies.restriction.no_change_near_field_communication_radio'.tr;
  String get restrictionNoConfigBluetooth =>
      'policies.restriction.no_config_bluetooth'.tr;
  String get restrictionNoConfigCellBroadcasts =>
      'policies.restriction.no_config_cell_broadcasts'.tr;
  String get restrictionNoConfigCredentials =>
      'policies.restriction.no_config_credentials'.tr;
  String get restrictionNoConfigScreenTimeout =>
      'policies.restriction.no_config_screen_timeout'.tr;
  String get restrictionNoContentCapture =>
      'policies.restriction.no_content_capture'.tr;
  String get restrictionNoContentSuggestions =>
      'policies.restriction.no_content_suggestions'.tr;
  String get restrictionNoCreateWindows =>
      'policies.restriction.no_create_windows'.tr;
  String get restrictionNoCrossProfileCopyPaste =>
      'policies.restriction.no_cross_profile_copy_paste'.tr;
  String get restrictionNoFun => 'policies.restriction.no_fun'.tr;
  String get restrictionDisallowMicrophoneToggle =>
      'policies.restriction.disallow_microphone_toggle'.tr;
  String get restrictionNoModifyAccounts =>
      'policies.restriction.no_modify_accounts'.tr;
  String get restrictionNoPhysicalMedia =>
      'policies.restriction.no_physical_media'.tr;
  String get restrictionNoNearFieldCommunicationRadio =>
      'policies.restriction.no_near_field_communication_radio'.tr;
  String get restrictionNoNetworkReset =>
      'policies.restriction.no_network_reset'.tr;
  String get restrictionNoOutgoingBeam =>
      'policies.restriction.no_outgoing_beam'.tr;
  String get restrictionNoOutgoingCalls =>
      'policies.restriction.no_outgoing_calls'.tr;
  String get restrictionNoPrinting => 'policies.restriction.no_printing'.tr;
  String get restrictionNoRemoveUser =>
      'policies.restriction.no_remove_user'.tr;
  String get restrictionNoRunInBackground =>
      'policies.restriction.no_run_in_background'.tr;
  String get restrictionNoSetUserIcon =>
      'policies.restriction.no_set_user_icon'.tr;
  String get restrictionNoSharingIntoProfile =>
      'policies.restriction.no_sharing_into_profile'.tr;
  String get restrictionNoSimGlobally =>
      'policies.restriction.no_sim_globally'.tr;
  String get restrictionNoSystemErrorDialogs =>
      'policies.restriction.no_system_error_dialogs'.tr;
  String get restrictionNoThreadNetwork =>
      'policies.restriction.no_thread_network'.tr;
  String get restrictionNoUltraWidebandRadio =>
      'policies.restriction.no_ultra_wideband_radio'.tr;
  String get restrictionDisallowUnmuteDevice =>
      'policies.restriction.disallow_unmute_device'.tr;
  String get restrictionEnsureVerifyApps =>
      'policies.restriction.ensure_verify_apps'.tr;
  String get restrictionRestrictionsPending =>
      'policies.restriction.restrictions_pending'.tr;
}
