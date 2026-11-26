const Map<String, String> settingsTr = {
  'settings.title': 'Ayarlar',
  'settings.retry': 'Yeniden dene',
  'settings.options_load_failed': 'Policy listesi yüklenemedi: @message',
  'settings.load_failed': 'Ayarlar yüklenemedi.',
  'settings.check_fields': 'Lütfen alanları kontrol edin.',
  'settings.saved': 'Ayarlar kaydedildi',

  'settings.channel_database': 'Veritabanı',
  'settings.channel_required':
      'Her uyarı türü için en az bir kanal seçili olmalı.',
  'settings.no_alert_types': 'Kayıtlı uyarı türü yok.',

  'settings.section_upload_limits': 'Yükleme Sınırları',
  'settings.section_alerts': 'Uyarılar',

  'settings.default_policy': 'Varsayılan Policy',
  'settings.panel_brand_name': 'E-postalarda Görünen Marka Adı',
  'settings.mdm_apk_package_name': 'MDM APK paket adı',
  'settings.download_mdm_apk': 'MDM APK’yı indir',
  'settings.mdm_apk_unavailable': 'Seçili uygulamanın indirilebilir APK’sı yok.',
  'settings.panel_timezone': 'Saat Dilimi',
  'settings.panel_timezone_unset': 'UTC (ayarlanmadı)',
  'settings.offline_timeout': 'Çevrimdışı Zaman Aşımı (dk)',
  'settings.offline_alert_minutes': 'Çevrimdışı Uyarı (dk)',
  'settings.policy_not_selected': 'Seçilmedi',

  'settings.upload_hint_max': 'En fazla @ceiling MB',
  'settings.upload_apk': 'Uygulama / APK (MB)',
  'settings.upload_file': 'Dosya (MB)',
  'settings.upload_certificate': 'Sertifika (MB)',
  'settings.upload_launcher_bg': 'Launcher Arka Planı (MB)',
  'settings.upload_device_kb': 'Cihazdan Yükleme (KB)',

  'settings.update_check_delay': 'Güncelleme Kontrol Gecikmesi (dk)',

  'settings.duplicate_prevention': 'Tekrar Önleme (saat)',

  'settings.log_level_verbose': 'Ayrıntılı (0)',
  'settings.log_level_debug': 'Hata Ayıklama (1)',
  'settings.log_level_info': 'Bilgi (2)',
  'settings.log_level_warning': 'Uyarı (3)',
  'settings.log_level_error': 'Hata (4)',
  'settings.log_level_fatal': 'Ölümcül (5)',

  'settings.console_level': 'Konsol Seviyesi',
  'settings.db_level': 'Veritabanı Seviyesi',
  'settings.remote_level': 'Uzak Seviye',
  'settings.max_local_entries': 'Maks. Yerel Kayıt',
  'settings.flush_threshold': 'Flush Eşiği',
  'settings.idle_flush_seconds': 'Boşta Flush (sn)',
  'settings.retention_days': 'Saklama (gün)',
  'settings.remote_log_enabled': 'Uzak Log Gönderimi',
  'settings.remote_log_subtitle':
      'Loglar yapılandırılan uç noktaya gönderilir.',
  'settings.remote_endpoint': 'Uzak Uç Nokta',
  'settings.remote_auth_token': 'Uzak Yetki Token\'ı',
  'settings.max_retries': 'Maks. Deneme',

  'settings.smtp_enabled': 'SMTP Etkin',
  'settings.smtp_enabled_subtitle': 'E-postalar SMTP üzerinden gönderilir.',
  'settings.smtp_host': 'Sunucu',
  'settings.smtp_encryption': 'Şifreleme',
  'settings.smtp_username': 'Kullanıcı Adı',
  'settings.smtp_password': 'Parola',
  'settings.smtp_from_address': 'Gönderen Adresi',
  'settings.smtp_from_name': 'Gönderen Adı',
  'settings.smtp_recipient': 'Alıcı (opsiyonel)',
  'settings.smtp_recipient_hint': 'Boşsa sunucu varsayılanı kullanılır',
  'settings.send_test_mail': 'Test Maili Gönder',
  'settings.test_mail_failed': 'Test maili gönderilemedi',
  'settings.send_test_failed': 'Test maili gönderilemedi: @error',
  'settings.notice_invalid_email': 'Geçersiz e-posta adresi',
  'settings.notice_missing_host': 'SMTP sunucusu tanımlı değil',
  'settings.notice_not_smtp': 'Varsayılan mailer SMTP değil',
  'settings.notice_sent': 'Test maili gönderildi',

  'settings.section_enrollment': 'Cihaz Kayıt Anahtarı',
  'settings.enrollment_key_hint':
      'Yeni cihazlar yalnız bu anahtarla kayıt olabilir. Provisioning QR '
      'kodları anahtarı otomatik taşır; QR olmadan kurulumda cihazın kurulum '
      'ekranına elle girilir.',
  'settings.enrollment_key_show': 'Göster',
  'settings.enrollment_key_hide': 'Gizle',
  'settings.enrollment_key_copied': 'Kayıt anahtarı kopyalandı',
  'settings.enrollment_key_copy_failed':
      'Kopyalanamadı. Göster’e basıp anahtarı seçerek kopyalayın.',
  'settings.enrollment_key_rotate': 'Yenile',
  'settings.enrollment_key_rotate_title': 'Kayıt anahtarı yenilensin mi?',
  'settings.enrollment_key_rotate_message':
      'Kayıtlı cihazlar etkilenmez. Eski anahtarı taşıyan QR kodları ve '
      'elle girilen eski anahtar ile yeni cihaz kaydı artık reddedilir; '
      'dağıtılmış QR kodlarını yeniden yazdırmanız gerekir.',
  'settings.enrollment_key_rotated': 'Kayıt anahtarı yenilendi',
  'settings.enrollment_key_rotate_failed': 'Kayıt anahtarı yenilenemedi',
  'settings.enrollment_key_load_failed': 'Kayıt anahtarı yüklenemedi',
  'settings.enrollment_key_qr': 'QR Göster',
  'settings.enrollment_key_qr_title': 'Kurulum QR kodu',
  'settings.enrollment_key_qr_hint':
      'Cihazın kurulum ekranından bu kodu okutun.',
};
