const Map<String, String> settingsEn = {
  'settings.title': 'Settings',
  'settings.retry': 'Try again',
  'settings.options_load_failed': 'Could not load the policy list: @message',
  'settings.load_failed': 'Could not load the settings.',
  'settings.check_fields': 'Please check the fields.',
  'settings.saved': 'Settings saved',

  'settings.channel_database': 'Database',
  'settings.channel_required':
      'At least one channel must stay enabled for each alert type.',
  'settings.no_alert_types': 'No registered alert types.',

  'settings.section_upload_limits': 'Upload Limits',
  'settings.section_policy_defaults': 'Policy Defaults',
  'settings.section_alerts': 'Alerts',
  'settings.section_backup': 'Backup',

  'settings.default_policy': 'Default Policy',
  'settings.panel_theme': 'Panel Theme',
  'settings.panel_brand_name': 'Panel Brand Name',
  'settings.mdm_apk_package_name': 'MDM APK package name',
  'settings.download_mdm_apk': 'Download MDM APK',
  'settings.mdm_apk_unavailable': 'The selected app has no downloadable APK.',
  'settings.panel_timezone': 'Timezone',
  'settings.panel_timezone_unset': 'UTC (not set)',
  'settings.offline_timeout': 'Offline Timeout (min)',
  'settings.online_alert_minutes': 'Online Alert (min)',
  'settings.offline_alert_minutes': 'Offline Alert (min)',
  'settings.policy_not_selected': 'None selected',
  'settings.theme_light': 'Light',
  'settings.theme_dark': 'Dark',
  'settings.theme_system': 'System',

  'settings.upload_hint_max': 'Up to @ceiling MB',
  'settings.upload_apk': 'App / APK (MB)',
  'settings.upload_file': 'File (MB)',
  'settings.upload_certificate': 'Certificate (MB)',
  'settings.upload_launcher_bg': 'Launcher Background (MB)',
  'settings.upload_device_kb': 'Device Upload (KB)',

  'settings.report_interval': 'Server Report Interval (sec)',
  'settings.min_duration': 'Min. Duration (ms)',
  'settings.min_distance': 'Min. Distance (m)',
  'settings.update_check_delay': 'Update Check Delay (min)',

  'settings.duplicate_prevention': 'Duplicate Prevention (hours)',

  'settings.log_level_verbose': 'Verbose (0)',
  'settings.log_level_debug': 'Debug (1)',
  'settings.log_level_info': 'Info (2)',
  'settings.log_level_warning': 'Warning (3)',
  'settings.log_level_error': 'Error (4)',
  'settings.log_level_fatal': 'Fatal (5)',

  'settings.clean_times': 'Cleanup Times',
  'settings.run_times': 'Run Times',
  'settings.monitor_times': 'Monitor Times',
  'settings.time_format_helper': 'HH:mm format, e.g. @example',
  'settings.time_format_invalid': 'Must be in HH:mm format (e.g. 01:30)',
  'settings.notify_user_ids': 'Notification User IDs',
  'settings.notify_user_ids_helper': 'Users who receive backup notifications.',
  'settings.user_id_hint': 'User ID',

  'settings.console_level': 'Console Level',
  'settings.db_level': 'Database Level',
  'settings.remote_level': 'Remote Level',
  'settings.max_local_entries': 'Max Local Entries',
  'settings.flush_threshold': 'Flush Threshold',
  'settings.idle_flush_seconds': 'Idle Flush (sec)',
  'settings.retention_days': 'Retention (days)',
  'settings.remote_log_enabled': 'Remote Log Shipping',
  'settings.remote_log_subtitle': 'Logs are sent to the configured endpoint.',
  'settings.remote_endpoint': 'Remote Endpoint',
  'settings.remote_auth_token': 'Remote Auth Token',
  'settings.max_retries': 'Max Retries',

  'settings.smtp_enabled': 'SMTP Enabled',
  'settings.smtp_enabled_subtitle': 'Emails are sent over SMTP.',
  'settings.smtp_host': 'Host',
  'settings.smtp_encryption': 'Encryption',
  'settings.smtp_username': 'Username',
  'settings.smtp_password': 'Password',
  'settings.smtp_from_address': 'From Address',
  'settings.smtp_from_name': 'From Name',
  'settings.smtp_recipient': 'Recipient (optional)',
  'settings.smtp_recipient_hint': 'Uses the server default when empty',
  'settings.send_test_mail': 'Send Test Email',
  'settings.test_mail_failed': 'Test email could not be sent',
  'settings.send_test_failed': 'Test email could not be sent: @error',
  'settings.notice_invalid_email': 'Invalid email address',
  'settings.notice_missing_host': 'SMTP host is not configured',
  'settings.notice_not_smtp': 'The default mailer is not SMTP',
  'settings.notice_sent': 'Test email sent',

  'settings.section_enrollment': 'Device Enrollment Key',
  'settings.enrollment_key_hint':
      'New devices can only enroll with this key. Provisioning QR codes carry '
      'it automatically; for setups without a QR, enter it on the device '
      'install screen.',
  'settings.enrollment_key_show': 'Show',
  'settings.enrollment_key_hide': 'Hide',
  'settings.enrollment_key_copied': 'Enrollment key copied',
  'settings.enrollment_key_copy_failed':
      'Could not copy. Select Show, then select and copy the key.',
  'settings.enrollment_key_rotate': 'Regenerate',
  'settings.enrollment_key_rotate_title': 'Regenerate the enrollment key?',
  'settings.enrollment_key_rotate_message':
      'Enrolled devices are not affected. New enrollments with QR codes or '
      'manually entered keys that carry the old key will be rejected; '
      'reprint any QR codes you have handed out.',
  'settings.enrollment_key_rotated': 'Enrollment key regenerated',
  'settings.enrollment_key_rotate_failed':
      'Could not regenerate the '
      'enrollment key',
  'settings.enrollment_key_load_failed': 'Could not load the enrollment key',
  'settings.enrollment_key_qr': 'Show QR',
  'settings.enrollment_key_qr_title': 'Setup QR code',
  'settings.enrollment_key_qr_hint':
      'Scan this code from the device setup screen.',
};
