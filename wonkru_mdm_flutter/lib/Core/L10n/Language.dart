// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'Langs/activity_en.dart';
import 'Langs/activity_tr.dart';
import 'Langs/applications_en.dart';
import 'Langs/applications_tr.dart';
import 'Langs/certificates_en.dart';
import 'Langs/certificates_tr.dart';
import 'Langs/common_en.dart';
import 'Langs/common_tr.dart';
import 'Langs/dashboard_en.dart';
import 'Langs/dashboard_tr.dart';
import 'Langs/device_groups_en.dart';
import 'Langs/device_groups_tr.dart';
import 'Langs/device_logs_en.dart';
import 'Langs/device_logs_tr.dart';
import 'Langs/device_syncs_en.dart';
import 'Langs/device_syncs_tr.dart';
import 'Langs/devices_en.dart';
import 'Langs/devices_tr.dart';
import 'Langs/files_en.dart';
import 'Langs/files_tr.dart';
import 'Langs/notifications_en.dart';
import 'Langs/notifications_tr.dart';
import 'Langs/policies_en.dart';
import 'Langs/policies_tr.dart';
import 'Langs/profile_en.dart';
import 'Langs/profile_tr.dart';
import 'Langs/provisioning_en.dart';
import 'Langs/provisioning_tr.dart';
import 'Langs/settings_en.dart';
import 'Langs/settings_tr.dart';
import 'Langs/users_en.dart';
import 'Langs/users_tr.dart';

class AppTranslations extends Translations {
  AppTranslations();

  static const Locale tr = Locale('tr', 'TR');
  static const Locale en = Locale('en', 'US');

  /// GetX's fallback for missing keys, and the app's last-resort default when
  /// neither a stored choice nor a supported device language exists.
  static const Locale fallbackLocale = en;

  static const String trKey = 'tr_TR';
  static const String enKey = 'en_US';

  static const Iterable<Locale> supportedLocales = [tr, en];

  /// `ShadApp.custom` does not install its own `Localizations` layer, so the
  /// shadcn delegate must be added here; the Material/Cupertino/Widgets
  /// delegates supply the TR/EN localization.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    GlobalShadLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  @override
  Map<String, Map<String, String>> get keys => {
    trKey: _merge(const [
      commonTr,
      policiesTr,
      devicesTr,
      deviceGroupsTr,
      deviceLogsTr,
      deviceSyncsTr,
      settingsTr,
      profileTr,
      usersTr,
      notificationsTr,
      applicationsTr,
      certificatesTr,
      filesTr,
      provisioningTr,
      dashboardTr,
      activityTr,
    ]),
    enKey: _merge(const [
      commonEn,
      policiesEn,
      devicesEn,
      deviceGroupsEn,
      deviceLogsEn,
      deviceSyncsEn,
      settingsEn,
      profileEn,
      usersEn,
      notificationsEn,
      applicationsEn,
      certificatesEn,
      filesEn,
      provisioningEn,
      dashboardEn,
      activityEn,
    ]),
  };

  static Map<String, String> _merge(List<Map<String, String>> fragments) {
    final merged = <String, String>{};
    for (final fragment in fragments) {
      merged.addAll(fragment);
    }
    return merged;
  }

  static String languageTagFor(Locale locale) => locale.toLanguageTag();

  /// The stored choice wins; otherwise the first supported language in
  /// [deviceLocales] (the browser's languages on web, the system locale
  /// elsewhere); otherwise [fallbackLocale].
  static Locale resolveLocale({
    String? storedTag,
    Iterable<Locale> deviceLocales = const <Locale>[],
  }) {
    final stored = localeFromTag(storedTag);
    if (stored != null) return stored;
    for (final device in deviceLocales) {
      final match = localeFromTag(device.toLanguageTag());
      if (match != null) return match;
    }
    return fallbackLocale;
  }

  static Locale? localeFromTag(String? tag) {
    if (tag == null || tag.trim().isEmpty) return null;
    final code = tag.replaceAll('_', '-').split('-').first.toLowerCase();
    return switch (code) {
      'tr' => tr,
      'en' => en,
      _ => null,
    };
  }
}
