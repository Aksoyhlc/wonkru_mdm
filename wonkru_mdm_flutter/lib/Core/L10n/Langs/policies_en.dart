/// Keeps the same key set and order as [policies_tr.dart]; `@name` placeholders
/// must stay identical across languages (enforced by
/// test/logic/l10n_placeholder_parity_test.dart).
const Map<String, String> policiesEn = {
  'policies.empty_title': 'No policy found',
  'policies.empty_subtitle': 'Create your first policy.',
  'policies.new_policy': 'New Policy',
  'policies.slug': 'Slug',
  'policies.slug_hint': 'Generated from the name as you type; edit if you like',
  'policies.is_default': 'Default',
  'policies.updated_at': 'Updated',
  'policies.not_default': 'No',

  'policies.preview': 'Preview',
  'policies.send_to_devices': 'Send to Devices',
  'policies.make_default': 'Make Default',
  'policies.copied_toast': 'Policy copied: @name',
  'policies.copy_failed': 'Could not copy: @error',
  'policies.preview_failed': 'Could not load preview: @error',
  'policies.send_confirm': 'Send the "@name" policy to devices?',
  'policies.send_queued': 'Send queued for @count device(s)',
  'policies.send_failed': 'Could not send: @error',
  'policies.already_default': 'This policy is already the default',
  'policies.default_updated': 'Default policy updated',
  'policies.set_default_failed': 'Could not set as default: @error',
  'policies.delete_title': 'Delete Policy',
  'policies.deleted': 'Policy deleted',
  'policies.preview_title': 'Preview — @title',

  'policies.copy_name_suffix': '@name (copy)',
  'policies.name_required': 'Name cannot be empty',
  'policies.clone_title': 'Copy Policy',
  'policies.new_name_label': 'New policy name',

  'policies.load_failed': 'Policy could not be loaded.',
  'policies.applications': 'Applications',
  'policies.files': 'Files',
  'policies.certificates': 'Certificates',
  'policies.selectors_list': 'Selector lists',
  'policies.pivot_lists': 'Pivot lists',
  'policies.load_warning': 'Could not load @parts: @error',
  'policies.and': ' and ',
  'policies.retry': 'Try again',
  'policies.admin_password': 'Admin Password',
  'policies.admin_password_hint':
      'Type to change (leave empty to keep the current one)',
  'policies.admin_password_required_hint': 'Required',
  'policies.admin_password_required': 'Admin password is required',
  'policies.default_policy': 'Default Policy',
  'policies.restriction_save_warning':
      'Restriction catalog could not be loaded; restriction selections were left unchanged.',
  'policies.created': 'Policy created',
  'policies.updated': 'Policy updated',
  'policies.pivot_save_first': 'Save the policy first to add pivots.',

  'policies.tab_audio': 'Audio',
  'policies.tab_other': 'Other',
  'policies.tab_display': 'Display',
  'policies.tab_restriction': 'Restrictions',

  'policies.group_active_time_ranges': 'Active Time Ranges',
  'policies.add_time_range': 'Add range',
  'policies.no_time_ranges': 'No ranges',
  'policies.field_active_time_ranges': 'Application Range (Active Hours)',
  'policies.helper_active_time_ranges':
      'The policy is applied only during the hour ranges you set.',
  'policies.group_sync_settings': 'Periodic Data Collection Settings',
  'policies.field_full_sync_cron': 'Full Data Sync (Cron)',
  'policies.helper_full_sync_cron':
      'E.g. "0 * * * *" every hour. Uploads all device data to the server.',
  'policies.field_max_interval': 'Maximum Interval (Minutes)',
  'policies.helper_max_interval':
      'The maximum interval devices may wait before sending data to the server. E.g. 60 (minutes).',

  'policies.group_battery_thresholds': 'Battery Thresholds',
  'policies.field_low_battery_threshold': 'Low Battery Threshold (%)',
  'policies.helper_low_battery':
      'A low battery warning is issued when the battery level drops below this value.',
  'policies.field_critical_battery_threshold': 'Critical Battery Threshold (%)',
  'policies.helper_critical_battery':
      'A critical battery warning is issued when the battery level drops below this value.',

  'policies.group_storage_thresholds': 'Storage Thresholds',
  'policies.field_warning_threshold': 'Warning Threshold (%)',
  'policies.helper_warning_threshold':
      'A warning is issued when storage usage exceeds this percentage.',
  'policies.field_critical_threshold': 'Critical Threshold (%)',
  'policies.helper_critical_threshold':
      'A critical warning is issued when storage usage exceeds this percentage.',

  'policies.group_audio_settings': 'Audio Settings',
  'policies.field_fixed_volume_policy': 'Keep Volume Fixed',
  'policies.field_fixed_volume': 'Fixed Volume Level',
  'policies.field_min_volume': 'Minimum Volume Level',
  'policies.field_max_volume': 'Maximum Volume Level',

  'policies.field_no_config_bluetooth': 'Bluetooth Configuration',
  'policies.helper_no_config_bluetooth':
      'The user cannot configure Bluetooth settings. Changes the DISALLOW_CONFIG_BLUETOOTH key on the "Restrictions" tab.',
  'policies.field_no_bluetooth': 'Turn Off Bluetooth',
  'policies.helper_no_bluetooth':
      'Blocks Bluetooth use on the device. Changes the DISALLOW_BLUETOOTH key on the "Restrictions" tab.',
  'policies.field_no_bluetooth_sharing': 'Bluetooth Sharing',
  'policies.helper_no_bluetooth_sharing':
      'Blocks outgoing Bluetooth sharing. Changes the DISALLOW_BLUETOOTH_SHARING key on the "Restrictions" tab.',
  'policies.group_datetime_settings': 'Date and Time Settings',
  'policies.field_auto_time': 'Automatic Date/Time',
  'policies.field_auto_time_zone': 'Automatic Time Zone',
  'policies.field_time_zone': 'Time Zone',
  'policies.helper_time_zone':
      'IANA time zone identifier (e.g. Europe/Istanbul).',
  'policies.field_time_format': 'Time format (12 / 24 hour)',
  'policies.option_hours_12': '12-hour',
  'policies.option_hours_24': '24-hour',
  'policies.field_no_physical_media': 'Physical Media',
  'policies.helper_no_physical_media':
      'Prevents the user from mounting physical external media (USB drive etc.). Changes the DISALLOW_MOUNT_PHYSICAL_MEDIA key on the "Restrictions" tab.',
  'policies.group_hardware': 'Hardware',
  'policies.field_no_camera': 'Camera',
  'policies.helper_no_camera':
      'Blocks camera use on the device. Changes the DISALLOW_CAMERA key on the "Restrictions" tab.',
  'policies.field_required_wifi': 'WiFi required',

  'policies.group_screen_lock': 'Screen / Lock',
  'policies.field_lock_screen_message': 'Lock Screen Message',
  'policies.helper_lock_screen_message': 'Message shown on the lock screen.',
  'policies.field_screen_capture_policy': 'Screen Capture Policy',
  'policies.helper_screen_capture_policy':
      'Permission for screenshots and screen recording.',
  'policies.group_timeout': 'Timeout',
  'policies.field_screen_timeout': 'Screen Timeout (ms)',
  'policies.helper_screen_timeout':
      'If 0 is entered, the device default is used.',
  'policies.field_timeout_lock': 'Timeout Lock',
  'policies.helper_timeout_lock': 'The user cannot change the screen timeout.',
  'policies.group_brightness': 'Brightness',
  'policies.field_brightness_lock': 'Brightness Lock',
  'policies.helper_brightness_lock': 'The user cannot change the brightness.',
  'policies.field_brightness_level': 'Brightness Level (%)',
  'policies.field_min_brightness': 'Minimum Brightness (%)',
  'policies.field_max_brightness': 'Maximum Brightness (%)',
  'policies.field_auto_brightness_policy': 'Auto Brightness Policy',
  'policies.group_rotation': 'Rotation',
  'policies.field_rotation_policy': 'Rotation Policy',
  'policies.option_free': 'Free',
  'policies.option_locked': 'Locked',
  'policies.option_system_default': 'System Default',
  'policies.field_locked_orientation': 'Locked Orientation',
  'policies.option_portrait': 'Portrait',
  'policies.option_landscape': 'Landscape',
  'policies.option_portrait_reverse': 'Reverse Portrait',
  'policies.option_landscape_reverse': 'Reverse Landscape',
  'policies.option_auto': 'Auto',
  'policies.helper_locked_orientation':
      'Applies only while the rotation policy is "Locked".',

  'policies.group_password_policy': 'Password Policy',
  'policies.field_complexity_level': 'Complexity Level',
  'policies.option_custom': 'Custom',
  'policies.option_low': 'Low',
  'policies.option_medium': 'Medium',
  'policies.option_high': 'High',
  'policies.field_password_quality': 'Password Quality',
  'policies.option_unspecified': 'Unspecified',
  'policies.option_numeric': 'Numeric',
  'policies.option_alpha': 'Alphabetic',
  'policies.option_alphanumeric': 'Alphanumeric',
  'policies.option_complex': 'Complex',
  'policies.field_min_length': 'Minimum Length',
  'policies.field_min_upper_case': 'Minimum Uppercase Letters',
  'policies.field_min_lower_case': 'Minimum Lowercase Letters',
  'policies.field_min_letters': 'Minimum Letters',
  'policies.field_min_numeric': 'Minimum Digits',
  'policies.field_min_symbols': 'Minimum Symbols',
  'policies.field_min_non_letter': 'Minimum Non-Letters',
  'policies.field_history_length': 'History Length',
  'policies.field_password_expiration': 'Password Expiration (ms)',
  'policies.field_max_failed_attempts': 'Maximum Failed Attempts',
  'policies.group_keyguard': 'Screen Lock',
  'policies.field_disable_lock_screen_camera': 'Disable Lock Screen Camera',
  'policies.field_hide_notification_content': 'Hide Notification Content',
  'policies.field_disable_fingerprint': 'Disable Fingerprint',
  'policies.field_disable_face_unlock': 'Disable Face Unlock',
  'policies.field_disable_iris': 'Disable Iris Unlock',
  'policies.field_disable_all_biometrics': 'Disable All Biometrics',
  'policies.field_disable_smart_lock': 'Disable Smart Lock',
  'policies.group_accessibility': 'Accessibility',
  'policies.field_allowed_accessibility_apps': 'Allowed Accessibility Apps',
  'policies.helper_allowed_accessibility_apps':
      'Add package names one by one (e.g. com.example.app).',

  'policies.group_launcher_mode': 'Launcher Mode',
  'policies.field_launcher_mode_enabled': 'Launcher Mode Enabled',
  'policies.helper_launcher_mode': 'Starts the device with a custom launcher.',
  'policies.group_grid': 'Grid',
  'policies.field_grid_columns': 'Number of Columns',
  'policies.helper_grid_columns': 'A value between 1 and 6.',
  'policies.group_background': 'Background',
  'policies.field_background_type': 'Background Type',
  'policies.option_color': 'Color',
  'policies.option_image': 'Image',
  'policies.field_background_color': 'Background Color',
  'policies.helper_background_color': 'E.g. #FFFFFF.',
  'policies.field_background_image': 'Background Image',
  'policies.helper_background_image': 'PNG, JPG or WebP · max 2 MB.',
  'policies.group_app_display': 'App Appearance',
  'policies.field_icon_size': 'Icon Size',
  'policies.option_small': 'Small',
  'policies.option_large': 'Large',
  'policies.field_show_label': 'Show App Name',
  'policies.field_label_color': 'App Name Color',
  'policies.helper_label_color': 'E.g. #000000.',
  'policies.field_item_background_color': 'Item Background Color',
  'policies.helper_item_background_color': 'E.g. #F5F5F5.',
  'policies.field_border_radius': 'Corner Radius',
  'policies.field_label_font_size': 'Label Font Size',
  'policies.field_long_press_settings': 'Open Settings on Long Press',
  'policies.group_header_widgets': 'Header',
  'policies.field_header_left': 'Left Widgets',
  'policies.field_header_center': 'Center Widgets',
  'policies.field_header_right': 'Right Widgets',

  'policies.no_applications': 'No applications added to this policy.',
  'policies.action': 'Action',
  'policies.order': 'Order',
  'policies.flags': 'Flags',
  'policies.up': 'Up',
  'policies.down': 'Down',
  'policies.flag_boot': 'On boot',
  'policies.flag_after_install': 'After install',
  'policies.action_install': 'Install',
  'policies.action_configure': 'Configure',
  'policies.select_application': 'Select Application',
  'policies.application_added': 'Application added',
  'policies.application_updated': 'Application updated',
  'policies.remove_application_title': 'Remove Application',
  'policies.remove_application_confirm': 'Remove "@name" from the policy?',
  'policies.application_removed': 'Application removed',
  'policies.edit_application': 'Edit Application',
  'policies.add_application': 'Add Application',
  'policies.show_in_launcher': 'Show in launcher',
  'policies.run_on_boot': 'Run on boot',
  'policies.uninstall_block': 'Block uninstall',
  'policies.start_after_install': 'Start after install',
  'policies.loading_versions': 'Loading versions…',
  'policies.target_version': 'Target Version',
  'policies.no_version': 'No version',
  'policies.custom_app_name': 'Custom App Name',
  'policies.grant_permission': 'Grant Permission',
  'policies.update_policy': 'Update Policy',
  'policies.update_always': 'Always',
  'policies.update_wifi_only': 'Wi-Fi only',
  'policies.update_never': 'Never',

  'policies.operation_open': 'Open',
  'policies.destination_path': 'Destination Path',
  'policies.destination_path_absolute_required':
      'Destination path must be absolute (e.g. /sdcard/Download).',
  'policies.filter_system_title': 'System',
  'policies.filter_installable_title': 'Installability',
  'policies.filter_system_apps': 'System',
  'policies.filter_user_apps': 'User',
  'policies.installable': 'Installable',
  'policies.not_installable': 'Not installable',
  'policies.add_path': 'Add Path',
  'policies.delete_path': 'Path to Delete',
  'policies.delete_path_hint':
      'File or directory path on the device, e.g. /sdcard/Download/file.pdf',
  'policies.upload_file': 'Upload File',
  'policies.no_files_for_operation': 'No files added for this operation.',
  'policies.file': 'File',
  'policies.flag_replace_if_exists': 'Replace if exists',
  'policies.flag_open_after_download': 'Open after download',
  'policies.pick_file_for_operation': 'Choose a File for @operation',
  'policies.file_added': 'File added',
  'policies.file_uploaded': 'File uploaded',
  'policies.file_updated': 'File updated',
  'policies.remove_file_title': 'Remove File',
  'policies.remove_file_confirm': 'Remove "@name" from the policy?',
  'policies.file_removed': 'File removed',
  'policies.file_no_download_url': 'The file has no download link.',
  'policies.link_copied': 'Link copied to clipboard.',
  'policies.edit_file': 'Edit File',
  'policies.add_file': 'Add File',
  'policies.operation': 'Operation',
  'policies.open_after_download': 'Open after downloading',
  'policies.select_file_first': 'Select a file first',
  'policies.upload_file_title': 'Upload File (@operation)',
  'policies.upload_and_add': 'Upload and Add',
  'policies.file_drop_helper': 'Drag a file here or choose one',

  'policies.new_certificate': 'New Certificate',
  'policies.no_certificates': 'No certificates added to this policy.',
  'policies.certificate': 'Certificate',
  'policies.select_certificate': 'Select Certificate',
  'policies.certificate_added': 'Certificate added',
  'policies.certificate_created_attached': 'Certificate created and attached',
  'policies.remove_certificate_title': 'Remove Certificate',
  'policies.remove_certificate_confirm': 'Remove "@name" from the policy?',
  'policies.certificate_removed': 'Certificate removed',
  'policies.add_certificate': 'Add Certificate',

  'policies.no_tags': 'No tags yet.',
  'policies.add_value_hint': 'Add a value',
  'policies.hint_key': 'Key',
  'policies.hint_value': 'Value',
  'policies.no_records': 'No records found.',

  'policies.restriction_load_failed':
      'Restriction catalog could not be loaded.',
  'policies.restriction_state_default': 'Default',
  'policies.restriction_state_restrict': 'Restrict',

  'policies.tri_default': 'Default',
  'policies.range_invalid': 'This value cannot exceed its upper limit.',
  'policies.value_clamped_to_max': 'Upper limit exceeded; value set to @max.',
  'policies.brightness_range_invalid':
      'Minimum brightness cannot be greater than maximum brightness.',
  'policies.restriction_group.network': 'Network',
  'policies.restriction_group.applications': 'Applications',
  'policies.restriction_group.user_and_account': 'User and Account',
  'policies.restriction_group.privacy_and_sharing': 'Privacy and Sharing',
  'policies.restriction_group.system_and_ui': 'System and UI',

  'policies.restriction.allow_parent_profile_app_linking':
      'Allows apps in the parent profile to handle web links from the managed profile.',
  'policies.restriction.no_add_private_profile':
      'Prevents the user from creating a private profile.',
  'policies.restriction.no_ambient_display':
      'Prevents ambient display from being used for the user.',
  'policies.restriction.no_control_apps':
      'Prevents the user from modifying apps (uninstall, disable, etc.) via Settings or launchers.',
  'policies.restriction.no_assist_content':
      'Prevents assist content (screenshots, etc.) from being sent to a privileged app (e.g. Assistant).',
  'policies.restriction.no_bluetooth':
      'Completely disables Bluetooth on the device.',
  'policies.restriction.no_bluetooth_sharing':
      'Prevents outgoing Bluetooth sharing.',
  'policies.restriction.no_camera':
      'Completely disables camera use on the device.',
  'policies.restriction.disallow_camera_toggle':
      'Prevents use of the system toggle that disables camera access.',
  'policies.restriction.no_change_near_field_communication_radio':
      'Prevents changing the Near Field Communication (NFC) radio state.',
  'policies.restriction.no_config_bluetooth':
      'Prevents the user from configuring Bluetooth via Settings.',
  'policies.restriction.no_config_cell_broadcasts':
      'Prevents the user from configuring cell broadcast settings.',
  'policies.restriction.no_config_credentials':
      'Prevents the user from configuring user credentials.',
  'policies.restriction.no_config_screen_timeout':
      'Prevents the user from changing the screen timeout duration.',
  'policies.restriction.no_content_capture':
      'Prevents the user screen from being captured (content capture).',
  'policies.restriction.no_content_suggestions':
      'Prevents the user from receiving content suggestions based on screen content.',
  'policies.restriction.no_create_windows':
      'Prevents creating windows other than app windows (Toast, Overlay, etc.).',
  'policies.restriction.no_cross_profile_copy_paste':
      'Prevents content copied to the clipboard from being pasted to other users or profiles.',
  'policies.restriction.no_fun':
      'Prevents the user from having fun (e.g. Easter Egg games).',
  'policies.restriction.disallow_microphone_toggle':
      'Prevents use of the system toggle that disables microphone access.',
  'policies.restriction.no_modify_accounts':
      'Prevents the user from adding or removing accounts.',
  'policies.restriction.no_physical_media':
      'Prevents the user from mounting physical external media (e.g. USB drive).',
  'policies.restriction.no_near_field_communication_radio':
      'Prevents NFC (Near-field communication) use on the device.',
  'policies.restriction.no_network_reset':
      'Prevents the user from resetting network settings.',
  'policies.restriction.no_outgoing_beam':
      'Prevents the user from beaming data from apps via NFC.',
  'policies.restriction.no_outgoing_calls':
      'Prevents the user from making outgoing calls (except emergency calls).',
  'policies.restriction.no_printing': 'Prevents the user from printing.',
  'policies.restriction.no_remove_user': 'Prevents removal of secondary users.',
  'policies.restriction.no_run_in_background':
      'Prevents the user or profile from running in the background; it may be stopped and locked during user switch.',
  'policies.restriction.no_set_user_icon':
      'Prevents the user from changing their icon.',
  'policies.restriction.no_sharing_into_profile':
      'Prevents sharing data (e.g. files, images) from the primary user to the managed profile.',
  'policies.restriction.no_sim_globally':
      'Prevents the user from adding an embedded SIM (eSIM) to the device.',
  'policies.restriction.no_system_error_dialogs':
      'Prevents system error dialogs from being shown for crashed or unresponsive apps.',
  'policies.restriction.no_thread_network':
      'Prevents use of the Thread network (low-power wireless) on the device.',
  'policies.restriction.no_ultra_wideband_radio':
      'Prevents use of the Ultra-wideband (UWB) radio on the device.',
  'policies.restriction.disallow_unmute_device':
      'Prevents the user from unmuting the device master volume.',
  'policies.restriction.ensure_verify_apps':
      'Prevents app verification from being disabled.',
  'policies.restriction.restrictions_pending':
      'Key indicating that app restrictions have not yet arrived but will arrive soon.',
};
