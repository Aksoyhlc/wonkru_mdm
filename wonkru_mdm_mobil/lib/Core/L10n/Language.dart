import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wonkrumdm/Core/Constants/Enums/storage_keys.dart';
import 'package:wonkrumdm/Core/Utils/basic_storage.dart';

import 'Langs/en_us.dart';
import 'Langs/tr_tr.dart';

class AppTranslations extends Translations {
  AppTranslations._();
  factory AppTranslations() => AppTranslations._();

  static const Locale tr = Locale('tr', 'TR');
  static const Locale en = Locale('en', 'US');

  static const String _keyTr = 'tr_TR';
  static const String _keyEn = 'en_US';

  @override
  Map<String, Map<String, String>> get keys => {
        _keyTr: trTR,
        _keyEn: enUs,
      };

  static Iterable<Locale> get supportedLocales => [AppTranslations.tr, AppTranslations.en];

  static Locale? localeFromStorageKey(String? stored) {
    if (stored == _keyTr) return tr;
    if (stored == _keyEn) return en;
    return null;
  }

  static String storageKeyFor(Locale locale) {
    if (locale.languageCode == 'tr') return _keyTr;
    if (locale.languageCode == 'en') return _keyEn;
    return _keyEn;
  }

  static Locale get initialLocale {
    final stored = BasicStorage.instance.getString(Sk.locale.name);
    return localeFromStorageKey(stored) ?? Get.deviceLocale ?? en;
  }
}