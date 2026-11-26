const Map<String, String> policiesTr = {
  'policies.empty_title': 'Policy bulunamadı',
  'policies.empty_subtitle': "İlk policy'yi oluşturun.",
  'policies.new_policy': 'Yeni Policy',
  'policies.slug': 'Kısa Ad',
  'policies.slug_hint':
      'Ad yazılırken otomatik oluşturulur; isterseniz düzenleyin',
  'policies.is_default': 'Varsayılan',
  'policies.updated_at': 'Güncellendi',
  'policies.not_default': 'Değil',

  'policies.preview': 'Önizleme',
  'policies.send_to_devices': 'Cihazlara Gönder',
  'policies.make_default': 'Varsayılan Yap',
  'policies.copied_toast': 'Policy kopyalandı: @name',
  'policies.copy_failed': 'Kopyalanamadı: @error',
  'policies.preview_failed': 'Önizleme alınamadı: @error',
  'policies.send_confirm': '"@name" politikası cihazlara gönderilsin mi?',
  'policies.send_queued': '@count cihaza gönderim kuyruğa alındı',
  'policies.send_failed': 'Gönderilemedi: @error',
  'policies.already_default': 'Bu policy zaten varsayılan',
  'policies.default_updated': 'Varsayılan policy güncellendi',
  'policies.set_default_failed': 'Ayarlanamadı: @error',
  'policies.delete_title': 'Policy Sil',
  'policies.deleted': 'Policy silindi',
  'policies.preview_title': 'Önizleme — @title',

  'policies.copy_name_suffix': '@name (kopya)',
  'policies.name_required': 'Ad boş olamaz',
  'policies.clone_title': 'Policy Kopyala',
  'policies.new_name_label': 'Yeni policy adı',

  'policies.load_failed': 'Policy yüklenemedi.',
  'policies.applications': 'Uygulamalar',
  'policies.files': 'Dosyalar',
  'policies.certificates': 'Sertifikalar',
  'policies.selectors_list': 'Seçici listeleri',
  'policies.pivot_lists': 'Pivot listeleri',
  'policies.load_warning': '@parts yüklenemedi: @error',
  'policies.and': ' ve ',
  'policies.retry': 'Yeniden dene',
  'policies.admin_password': 'Yönetici Şifresi',
  'policies.admin_password_hint':
      'Değiştirmek için yazın (boş bırakılırsa korunur)',
  'policies.admin_password_required_hint': 'Zorunlu',
  'policies.admin_password_required': 'Yönetici şifresi zorunludur',
  'policies.default_policy': 'Varsayılan Policy',
  'policies.restriction_save_warning':
      'Kısıtlama kataloğu yüklenemedi; kısıtlama seçimleri değiştirilmedi.',
  'policies.created': 'Policy oluşturuldu',
  'policies.updated': 'Policy güncellendi',
  'policies.pivot_save_first': 'Pivot eklemek için önce policy kaydedin.',

  'policies.tab_audio': 'Ses',
  'policies.tab_other': 'Diğer',
  'policies.tab_display': 'Ekran',
  'policies.tab_restriction': 'Kısıtlama',

  'policies.group_active_time_ranges': 'Aktif Zaman Aralıkları',
  'policies.add_time_range': 'Aralık Ekle',
  'policies.no_time_ranges': 'Aralık yok',
  'policies.field_active_time_ranges': 'Uygulama Aralığı (Aktif Saatler)',
  'policies.helper_active_time_ranges':
      'Politika sadece belirlediğiniz saat aralıklarında uygulanır.',
  'policies.group_sync_settings': 'Periyodik Veri Toplama Ayarları',
  'policies.field_full_sync_cron': 'Tüm Veri Senkronizasyonu (Cron)',
  'policies.helper_full_sync_cron':
      'Örn: "0 * * * *" her saat başı. Tüm cihaz verilerini sunucuya aktarır.',
  'policies.field_max_interval': 'Maksimum Aralık (Dakika)',
  'policies.helper_max_interval':
      'Cihazların sunucuya veri göndermek zorunda olduğu maksimum aralık. Örn: 60 (dakika).',

  'policies.group_battery_thresholds': 'Batarya Eşikleri',
  'policies.field_low_battery_threshold': 'Düşük Batarya Eşiği (%)',
  'policies.helper_low_battery':
      'Batarya seviyesi bu değerin altına düştüğünde düşük batarya uyarısı verilir.',
  'policies.field_critical_battery_threshold': 'Kritik Batarya Eşiği (%)',
  'policies.helper_critical_battery':
      'Batarya seviyesi bu değerin altına düştüğünde kritik batarya uyarısı verilir.',

  'policies.group_storage_thresholds': 'Depolama Eşikleri',
  'policies.field_warning_threshold': 'Uyarı Eşiği (%)',
  'policies.helper_warning_threshold':
      'Depolama kullanımı bu yüzdeyi aştığında uyarı verilir.',
  'policies.field_critical_threshold': 'Kritik Eşik (%)',
  'policies.helper_critical_threshold':
      'Depolama kullanımı bu yüzdeyi aştığında kritik uyarı verilir.',

  'policies.group_audio_settings': 'Ses Ayarları',
  'policies.field_fixed_volume_policy': 'Ses Sabit Kalsın',
  'policies.field_fixed_volume': 'Sabit Ses Seviyesi',
  'policies.field_min_volume': 'Min Ses Seviyesi',
  'policies.field_max_volume': 'Max Ses Seviyesi',

  'policies.field_no_config_bluetooth': 'Bluetooth Yapılandırma',
  'policies.helper_no_config_bluetooth':
      'Kullanıcı Bluetooth ayarlarını yapılandıramaz. "Kısıtlama" sekmesindeki DISALLOW_CONFIG_BLUETOOTH anahtarını değiştirir.',
  'policies.field_no_bluetooth': "Bluetooth'u Kapat",
  'policies.helper_no_bluetooth':
      'Cihazda Bluetooth kullanımını engeller. "Kısıtlama" sekmesindeki DISALLOW_BLUETOOTH anahtarını değiştirir.',
  'policies.field_no_bluetooth_sharing': 'Bluetooth Paylaşımı',
  'policies.helper_no_bluetooth_sharing':
      'Giden Bluetooth paylaşımını engeller. "Kısıtlama" sekmesindeki DISALLOW_BLUETOOTH_SHARING anahtarını değiştirir.',
  'policies.group_datetime_settings': 'Tarih ve Saat Ayarları',
  'policies.field_auto_time': 'Otomatik Tarih/Saat',
  'policies.field_auto_time_zone': 'Otomatik Saat Dilimi',
  'policies.field_time_zone': 'Saat Dilimi',
  'policies.helper_time_zone':
      'IANA saat dilimi kimliği (ör. Europe/Istanbul).',
  'policies.field_time_format': 'Saat formatı (12 / 24 saat)',
  'policies.option_hours_12': '12 saat',
  'policies.option_hours_24': '24 saat',
  'policies.field_no_physical_media': 'Fiziksel Medya',
  'policies.helper_no_physical_media':
      'Kullanıcının fiziksel harici medya (USB bellek vb.) bağlamasını engeller. "Kısıtlama" sekmesindeki DISALLOW_MOUNT_PHYSICAL_MEDIA anahtarını değiştirir.',
  'policies.group_hardware': 'Donanım',
  'policies.field_no_camera': 'Kamera',
  'policies.helper_no_camera':
      'Cihazda kamera kullanımını engeller. "Kısıtlama" sekmesindeki DISALLOW_CAMERA anahtarını değiştirir.',
  'policies.field_required_wifi': 'WiFi zorunlu',

  'policies.group_screen_lock': 'Ekran / Kilit',
  'policies.field_lock_screen_message': 'Kilit Ekranı Mesajı',
  'policies.helper_lock_screen_message': 'Kilit ekranında gösterilecek mesaj.',
  'policies.field_screen_capture_policy': 'Ekran Görüntüsü Politikası',
  'policies.helper_screen_capture_policy': 'Ekran görüntüsü/ekran kaydı izni.',
  'policies.group_timeout': 'Zaman Aşımı',
  'policies.field_screen_timeout': 'Ekran Zaman Aşımı (ms)',
  'policies.helper_screen_timeout': '0 girilirse cihaz varsayılanı kullanılır.',
  'policies.field_timeout_lock': 'Zaman Aşımı Kilidi',
  'policies.helper_timeout_lock': 'Kullanıcı ekran zaman aşımını değiştiremez.',
  'policies.group_brightness': 'Parlaklık',
  'policies.field_brightness_lock': 'Parlaklık Kilidi',
  'policies.helper_brightness_lock': 'Kullanıcı parlaklığı değiştiremez.',
  'policies.field_brightness_level': 'Parlaklık Seviyesi (%)',
  'policies.field_min_brightness': 'Min Parlaklık (%)',
  'policies.field_max_brightness': 'Max Parlaklık (%)',
  'policies.field_auto_brightness_policy': 'Otomatik Parlaklık Politikası',
  'policies.group_rotation': 'Döndürme',
  'policies.field_rotation_policy': 'Döndürme Politikası',
  'policies.option_free': 'Serbest',
  'policies.option_locked': 'Kilitli',
  'policies.option_system_default': 'Sistem Varsayılanı',
  'policies.field_locked_orientation': 'Kilitli Yönlendirme',
  'policies.option_portrait': 'Dikey',
  'policies.option_landscape': 'Yatay',
  'policies.option_portrait_reverse': 'Ters Dikey',
  'policies.option_landscape_reverse': 'Ters Yatay',
  'policies.option_auto': 'Otomatik',
  'policies.helper_locked_orientation':
      'Yalnızca döndürme politikası "Kilitli" iken geçerlidir.',

  'policies.group_password_policy': 'Şifre Politikası',
  'policies.field_complexity_level': 'Karmaşıklık Seviyesi',
  'policies.option_custom': 'Özel',
  'policies.option_low': 'Düşük',
  'policies.option_medium': 'Orta',
  'policies.option_high': 'Yüksek',
  'policies.field_password_quality': 'Şifre Kalitesi',
  'policies.option_unspecified': 'Belirtilmemiş',
  'policies.option_numeric': 'Sayısal',
  'policies.option_alpha': 'Alfabetik',
  'policies.option_alphanumeric': 'Alfanümerik',
  'policies.option_complex': 'Karmaşık',
  'policies.field_min_length': 'Min Uzunluk',
  'policies.field_min_upper_case': 'Min Büyük Harf',
  'policies.field_min_lower_case': 'Min Küçük Harf',
  'policies.field_min_letters': 'Min Harf',
  'policies.field_min_numeric': 'Min Rakam',
  'policies.field_min_symbols': 'Min Sembol',
  'policies.field_min_non_letter': 'Min Harf Dışı',
  'policies.field_history_length': 'Geçmiş Uzunluğu',
  'policies.field_password_expiration': 'Şifre Geçerlilik Süresi (ms)',
  'policies.field_max_failed_attempts': 'Maksimum Hatalı Deneme',
  'policies.group_keyguard': 'Ekran Kilidi',
  'policies.field_disable_lock_screen_camera': 'Kilit Ekranı Kamerasını Kapat',
  'policies.field_hide_notification_content': 'Bildirim İçeriğini Gizle',
  'policies.field_disable_fingerprint': 'Parmak İzini Kapat',
  'policies.field_disable_face_unlock': 'Yüz Kilidini Kapat',
  'policies.field_disable_iris': 'İris Kilidini Kapat',
  'policies.field_disable_all_biometrics': 'Tüm Biyometriği Kapat',
  'policies.field_disable_smart_lock': "Smart Lock'ı Kapat",
  'policies.group_accessibility': 'Erişilebilirlik',
  'policies.field_allowed_accessibility_apps':
      'İzin Verilen Erişilebilirlik Uygulamaları',
  'policies.helper_allowed_accessibility_apps':
      'Paket adlarını (ör. com.ornek.app) tek tek ekleyin.',

  'policies.group_launcher_mode': 'Launcher Modu',
  'policies.field_launcher_mode_enabled': 'Launcher Modu Etkin',
  'policies.helper_launcher_mode': 'Cihazı özel launcher ile başlatır.',
  'policies.group_grid': 'Izgara',
  'policies.field_grid_columns': 'Kolon Sayısı',
  'policies.helper_grid_columns': '1 ile 6 arasında bir değer.',
  'policies.group_background': 'Arka Plan',
  'policies.field_background_type': 'Arka Plan Türü',
  'policies.option_color': 'Renk',
  'policies.option_image': 'Resim',
  'policies.field_background_color': 'Arka Plan Rengi',
  'policies.helper_background_color': 'Örn. #FFFFFF.',
  'policies.field_background_image': 'Arka Plan Resmi',
  'policies.helper_background_image': 'PNG, JPG veya WebP · en fazla 2 MB.',
  'policies.group_app_display': 'Uygulama Görünümü',
  'policies.field_icon_size': 'Simge Boyutu',
  'policies.option_small': 'Küçük',
  'policies.option_large': 'Büyük',
  'policies.field_show_label': 'Uygulama İsmini Göster',
  'policies.field_label_color': 'Uygulama İsmi Rengi',
  'policies.helper_label_color': 'Örn. #000000.',
  'policies.field_item_background_color': 'Öğe Arka Plan Rengi',
  'policies.helper_item_background_color': 'Örn. #F5F5F5.',
  'policies.field_border_radius': 'Köşe Yuvarlaklığı',
  'policies.field_label_font_size': 'Etiket Yazı Boyutu',
  'policies.field_long_press_settings': 'Uzun Basınca Ayarları Aç',
  'policies.group_header_widgets': 'Üst Başlık',
  'policies.field_header_left': 'Sol Bileşenler',
  'policies.field_header_center': 'Orta Bileşenler',
  'policies.field_header_right': 'Sağ Bileşenler',

  'policies.no_applications': 'Bu politikaya uygulama eklenmemiş.',
  'policies.action': 'Aksiyon',
  'policies.order': 'Sıra',
  'policies.flags': 'Bayraklar',
  'policies.up': 'Yukarı',
  'policies.down': 'Aşağı',
  'policies.flag_boot': 'Açılışta',
  'policies.flag_after_install': 'Kurulum Sonrası',
  'policies.action_install': 'Yükle',
  'policies.action_configure': 'Yapılandır',
  'policies.select_application': 'Uygulama Seç',
  'policies.application_added': 'Uygulama eklendi',
  'policies.application_updated': 'Uygulama güncellendi',
  'policies.remove_application_title': 'Uygulamayı Kaldır',
  'policies.remove_application_confirm': '"@name" politikadan kaldırılsın mı?',
  'policies.application_removed': 'Uygulama kaldırıldı',
  'policies.edit_application': 'Uygulamayı Düzenle',
  'policies.add_application': 'Uygulama Ekle',
  'policies.show_in_launcher': "Launcher'da göster",
  'policies.run_on_boot': 'Açılışta çalıştır',
  'policies.uninstall_block': 'Kaldırmayı engelle',
  'policies.start_after_install': 'Kurulum sonrası başlat',
  'policies.loading_versions': 'Sürümler yükleniyor…',
  'policies.target_version': 'Hedef Sürüm',
  'policies.no_version': 'Sürüm yok',
  'policies.custom_app_name': 'Özel Uygulama Adı',
  'policies.grant_permission': 'İzin Ver',
  'policies.update_policy': 'Güncelleme Politikası',
  'policies.update_always': 'Her Zaman',
  'policies.update_wifi_only': 'Sadece Wi-Fi',
  'policies.update_never': 'Asla',

  'policies.operation_open': 'Aç',
  'policies.destination_path': 'Hedef Yol',
  'policies.destination_path_absolute_required':
      'Hedef yol mutlak olmalı (ör. /sdcard/Download).',
  'policies.filter_system_title': 'Sistem',
  'policies.filter_installable_title': 'Yüklenebilirlik',
  'policies.filter_system_apps': 'Sistem',
  'policies.filter_user_apps': 'Kullanıcı',
  'policies.installable': 'Yüklenebilir',
  'policies.not_installable': 'Yüklenemez',
  'policies.add_path': 'Yol Ekle',
  'policies.delete_path': 'Silinecek Yol',
  'policies.delete_path_hint':
      'Cihazdaki dosya ya da dizin yolu; ör. /sdcard/Download/dosya.pdf',
  'policies.upload_file': 'Dosya Yükle',
  'policies.no_files_for_operation': 'Bu işlem için dosya eklenmemiş.',
  'policies.file': 'Dosya',
  'policies.flag_replace_if_exists': 'Varsa değiştir',
  'policies.flag_open_after_download': 'İndirince aç',
  'policies.pick_file_for_operation': '@operation için Dosya Seç',
  'policies.file_added': 'Dosya eklendi',
  'policies.file_uploaded': 'Dosya yüklendi',
  'policies.file_updated': 'Dosya güncellendi',
  'policies.remove_file_title': 'Dosyayı Kaldır',
  'policies.remove_file_confirm': '"@name" politikadan kaldırılsın mı?',
  'policies.file_removed': 'Dosya kaldırıldı',
  'policies.file_no_download_url': 'Dosyanın indirme bağlantısı yok.',
  'policies.link_copied': 'Bağlantı panoya kopyalandı.',
  'policies.edit_file': 'Dosyayı Düzenle',
  'policies.add_file': 'Dosya Ekle',
  'policies.operation': 'İşlem',
  'policies.open_after_download': 'İndirdikten sonra aç',
  'policies.select_file_first': 'Önce bir dosya seçin',
  'policies.upload_file_title': 'Dosya Yükle (@operation)',
  'policies.upload_and_add': 'Yükle ve Ekle',
  'policies.file_drop_helper': 'Dosyayı buraya sürükleyin veya seçin',
  'policies.new_certificate': 'Yeni Sertifika',
  'policies.no_certificates': 'Bu politikaya sertifika eklenmemiş.',
  'policies.certificate': 'Sertifika',
  'policies.select_certificate': 'Sertifika Seç',
  'policies.certificate_added': 'Sertifika eklendi',
  'policies.certificate_created_attached': 'Sertifika oluşturuldu ve eklendi',
  'policies.remove_certificate_title': 'Sertifikayı Kaldır',
  'policies.remove_certificate_confirm': '"@name" politikadan kaldırılsın mı?',
  'policies.certificate_removed': 'Sertifika kaldırıldı',
  'policies.add_certificate': 'Sertifika Ekle',

  'policies.no_tags': 'Henüz etiket yok.',
  'policies.add_value_hint': 'Değer ekle',
  'policies.hint_key': 'Anahtar',
  'policies.hint_value': 'Değer',
  'policies.no_records': 'Kayıt bulunamadı.',

  'policies.restriction_load_failed': 'Kısıtlama kataloğu yüklenemedi.',
  'policies.restriction_state_default': 'Varsayılan',
  'policies.restriction_state_restrict': 'Kısıtla',

  'policies.tri_default': 'Varsayılan',
  'policies.range_invalid': 'Bu değer üst sınırdan büyük olamaz.',
  'policies.value_clamped_to_max':
      'Üst sınır aşıldı; değer @max olarak ayarlandı.',
  'policies.brightness_range_invalid':
      'En düşük parlaklık en yüksek parlaklıktan büyük olamaz.',
  'policies.restriction_group.network': 'Ağ',
  'policies.restriction_group.applications': 'Uygulamalar',
  'policies.restriction_group.user_and_account': 'Kullanıcı ve Hesap',
  'policies.restriction_group.privacy_and_sharing': 'Gizlilik ve Paylaşım',
  'policies.restriction_group.system_and_ui': 'Sistem ve Arayüz',

  'policies.restriction.allow_parent_profile_app_linking':
      'Ebeveyn profilindeki uygulamaların, yönetilen profilden gelen web bağlantılarını işlemesine izin verir.',
  'policies.restriction.no_add_private_profile':
      'Kullanıcının özel (private) bir profil oluşturmasını engeller.',
  'policies.restriction.no_ambient_display':
      'Kullanıcı için ortam ekranının (ambient display) kullanılmasını engeller.',
  'policies.restriction.no_control_apps':
      'Kullanıcının Ayarlar veya başlatıcılar üzerinden uygulamaları değiştirmesini (kaldırma, devre dışı bırakma vb.) engeller.',
  'policies.restriction.no_assist_content':
      'Yardımcı içeriklerin (ekran görüntüsü vb.) ayrıcalıklı bir uygulamaya (Asistan gibi) gönderilmesini engeller.',
  'policies.restriction.no_bluetooth':
      'Cihazda Bluetooth kullanımını tamamen engeller.',
  'policies.restriction.no_bluetooth_sharing':
      'Giden Bluetooth paylaşımını engeller.',
  'policies.restriction.no_camera':
      'Cihazda kamera kullanımını tamamen engeller.',
  'policies.restriction.disallow_camera_toggle':
      'Kamera erişimini engelleyen sistem geçiş düğmesinin (toggle) kullanılmasını engeller.',
  'policies.restriction.no_change_near_field_communication_radio':
      'Yakın Alan İletişimi (NFC) radyo durumunun değiştirilmesini engeller.',
  'policies.restriction.no_config_bluetooth':
      'Kullanıcının Ayarlar üzerinden Bluetooth yapılandırması yapmasını engeller.',
  'policies.restriction.no_config_cell_broadcasts':
      'Kullanıcının hücre yayını (cell broadcasts) ayarlarını yapılandırmasını engeller.',
  'policies.restriction.no_config_credentials':
      'Kullanıcının kullanıcı kimlik bilgilerini yapılandırmasını engeller.',
  'policies.restriction.no_config_screen_timeout':
      'Kullanıcının ekran zaman aşımı süresini değiştirmesini engeller.',
  'policies.restriction.no_content_capture':
      'Kullanıcı ekranının yakalanmasını (content capture) engeller.',
  'policies.restriction.no_content_suggestions':
      'Kullanıcının ekran içeriğine dayalı içerik önerileri almasını engeller.',
  'policies.restriction.no_create_windows':
      'Uygulama pencereleri dışında başka tür pencerelerin (Toast, Overlay vb.) oluşturulmasını engeller.',
  'policies.restriction.no_cross_profile_copy_paste':
      'Panoya kopyalanan içeriğin diğer kullanıcılara veya profillere yapıştırılmasını engeller.',
  'policies.restriction.no_fun':
      'Kullanıcının eğlenmesini (örneğin Easter Egg oyunları) engeller.',
  'policies.restriction.disallow_microphone_toggle':
      'Mikrofon erişimini engelleyen sistem geçiş düğmesinin (toggle) kullanılmasını engeller.',
  'policies.restriction.no_modify_accounts':
      'Kullanıcının hesap eklemesini veya kaldırmasını engeller.',
  'policies.restriction.no_physical_media':
      'Kullanıcının fiziksel harici medya (USB bellek vb.) bağlamasını engeller.',
  'policies.restriction.no_near_field_communication_radio':
      'Cihazda NFC (Near-field communication) kullanımını engeller.',
  'policies.restriction.no_network_reset':
      'Kullanıcının ağ ayarlarını sıfırlamasını engeller.',
  'policies.restriction.no_outgoing_beam':
      'Kullanıcının NFC kullanarak uygulamalardan veri göndermesini (beam) engeller.',
  'policies.restriction.no_outgoing_calls':
      'Kullanıcının giden arama yapmasını engeller (Acil aramalar hariç).',
  'policies.restriction.no_printing':
      'Kullanıcının yazdırma işlemi yapmasını engeller.',
  'policies.restriction.no_remove_user':
      'İkincil kullanıcıların (secondary users) kaldırılmasını engeller.',
  'policies.restriction.no_run_in_background':
      'Kullanıcının/profilin arka planda çalışmasını engeller; kullanıcı değişiminde durdurulup kilitlenmesine neden olabilir.',
  'policies.restriction.no_set_user_icon':
      'Kullanıcının simgesini değiştirmesini engeller.',
  'policies.restriction.no_sharing_into_profile':
      'Dosya/resim gibi verilerin birincil kullanıcıdan yönetilen profile paylaşılmasını engeller.',
  'policies.restriction.no_sim_globally':
      'Kullanıcının cihaza gömülü SIM (eSIM) eklemesini engeller.',
  'policies.restriction.no_system_error_dialogs':
      'Çöken veya yanıt vermeyen uygulamalar için sistem hata diyaloglarının gösterilmesini engeller.',
  'policies.restriction.no_thread_network':
      'Cihazda Thread ağının (düşük güçlü kablosuz ağ) kullanımını engeller.',
  'policies.restriction.no_ultra_wideband_radio':
      'Cihazda Ultra-wideband (UWB) radyosunun kullanımını engeller.',
  'policies.restriction.disallow_unmute_device':
      'Kullanıcının cihazın genel sesini açmasını (unmute) engeller.',
  'policies.restriction.ensure_verify_apps':
      'Uygulama doğrulamasının devre dışı bırakılmasını engeller.',
  'policies.restriction.restrictions_pending':
      'Uygulama kısıtlamalarının henüz gelmediğini ancak yakında geleceğini belirten anahtar.',
};
