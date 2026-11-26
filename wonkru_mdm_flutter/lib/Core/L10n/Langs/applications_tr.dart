const Map<String, String> applicationsTr = {
  'applications.search_hint': 'Ad veya paket adı',
  'applications.empty_title': 'Uygulama bulunamadı',
  'applications.empty_subtitle': 'İlk uygulamayı ekleyin.',
  'applications.new_application': 'Yeni Uygulama',
  'applications.developer': 'Geliştirici',
  'applications.category': 'Kategori',
  'applications.category_hint': 'Örn. Araçlar',
  'applications.system_app': 'Sistem',
  'applications.user_app': 'Kullanıcı',
  'applications.source': 'Kaynak',
  'applications.all_sources': 'Tüm kaynaklar',
  'applications.source_other': 'Diğer',
  'applications.system_app_filter': 'Sistem Uygulaması',
  'applications.versions_apk': 'Sürümler / APK',
  'applications.create': 'Oluştur',

  'applications.created': 'Uygulama eklendi',
  'applications.created_with_apk': 'Uygulama ve APK yüklendi',
  'applications.updated': 'Uygulama güncellendi',
  'applications.delete_title': 'Uygulama Sil',
  'applications.delete_confirm':
      '"@name" ve sürümleri kalıcı olarak silinsin mi?',
  'applications.deleted': 'Uygulama silindi',
  'applications.load_failed': 'Uygulama açılamadı: @error',
  'applications.bulk_delete_title': 'Uygulamaları Sil',
  'applications.bulk_delete_confirm':
      '@count uygulama ve sürümleri kalıcı olarak silinsin mi?',
  'applications.bulk_deleted': '@count uygulama silindi',

  'applications.versions_title': 'Sürümler — @name',
  'applications.upload_apk': 'APK Yükle',
  'applications.upload': 'Yükle',
  'applications.version_search_hint': 'Sürüm adı ara',
  'applications.versions_empty_title': 'Sürüm bulunamadı',
  'applications.versions_empty_subtitle': 'İlk APK’yi yükleyin.',
  'applications.version_code_cell': 'kod @code',
  'applications.default': 'Varsayılan',
  'applications.min_target_sdk': 'Min / Target SDK',
  'applications.version_updated': 'Sürüm güncellendi',
  'applications.version_delete_title': 'Sürüm Sil',
  'applications.version_delete_confirm':
      '"@name" sürümü kalıcı olarak silinsin mi?',
  'applications.version_deleted': 'Sürüm silindi',
  'applications.edit_version_title': 'Sürümü Düzenle',

  'applications.app_name': 'Uygulama Adı',
  'applications.app_name_hint': 'Örn. Wonkru MDM',
  'applications.package_name': 'Paket Adı',
  'applications.package_name_fixed': 'Paket adı düzenlenemez.',
  'applications.apk_package_mismatch':
      'Seçilen APK "@apk" paketi için; bu uygulama "@expected" paketini '
      'kullanıyor. Yalnızca bu uygulamaya ait bir APK yükleyebilirsiniz.',
  'applications.system_app_switch': 'Sistem uygulaması',
  'applications.system_app_switch_subtitle':
      'Cihazla birlikte gelen bir uygulamaysa işaretleyin.',
  'applications.edit_title': 'Uygulamayı Düzenle',
  'applications.first_version_section': 'İlk Sürüm',
  'applications.info_section': 'Uygulama Bilgileri',
  'applications.version_name': 'Sürüm Adı',
  'applications.version_name_hint': 'Örn. 1.2.0',
  'applications.version_code': 'Sürüm Kodu',
  'applications.min_sdk': 'Min SDK',
  'applications.target_sdk': 'Target SDK',
  'applications.default_version': 'Varsayılan sürüm',
  'applications.default_version_subtitle':
      'Uygulamanın varsayılan sürümü yapılır.',

  'applications.app_name_required': 'Uygulama adı boş olamaz',
  'applications.package_name_required': 'Paket adı boş olamaz',
  'applications.version_name_required': 'Sürüm adı boş olamaz',
  'applications.version_code_number': 'Sürüm kodu sayı olmalı',
  'applications.application_id_missing': 'Uygulama kimliği bulunamadı',
  'applications.duplicate_package_title': 'Paket Zaten Kayıtlı',
  'applications.duplicate_package_confirm':
      '"@package" paketi "@name" olarak zaten kayıtlı. Yüklediğiniz APK\'yı '
      'bu uygulamaya yeni bir sürüm olarak eklemek ister misiniz?',
  'applications.duplicate_package_saved':
      'APK, "@name" uygulamasına sürüm olarak eklendi.',
  'applications.duplicate_package_exists':
      '"@package" paketi zaten kayıtlı: "@name".',
  'applications.version_code_exists': 'Bu sürüm kodu zaten kayıtlı: @code.',

  'applications.apk_file': 'APK Dosyası',
  'applications.apk_file_helper': 'APK dosyasını buraya sürükleyin veya seçin',
  'applications.apk_file_helper_create':
      'APK’yı buraya sürükleyin veya seçin. Yüklemezseniz sürümü sonradan '
      '"Sürümler / APK"dan ekleyebilirsiniz.',
  'applications.select_apk_first': 'Önce bir APK seçin',
  'applications.apk_uploaded': 'APK yüklendi: @version',
  'applications.upload_failed': 'Yüklenemedi: @error',
  'applications.manifest_unreadable':
      'APK manifesti okunamadı; alanları elle girebilirsiniz.',
  'applications.manifest_unreadable_versions':
      'APK manifesti okunamadı; sürüm bilgilerini elle girebilirsiniz.',
  'applications.manifest_read_no_fields':
      'APK manifesti okundu; eklenecek yeni alan yok.',
  'applications.fields_filled': '@fields dolduruldu',
  'applications.permissions_read_count': '@count izin okundu',
  'applications.from_manifest': 'Manifestten @details.',
  'applications.filled_from_apk': 'APK’dan dolduruldu: @fields.',
  'applications.permissions_count': '@count izin',
  'applications.field_app_name': 'uygulama adı',
  'applications.field_package_name': 'paket adı',
  'applications.field_version_name': 'sürüm adı',
  'applications.field_version_code': 'sürüm kodu',
  'applications.field_min_sdk': 'min SDK',
  'applications.field_target_sdk': 'target SDK',
};
