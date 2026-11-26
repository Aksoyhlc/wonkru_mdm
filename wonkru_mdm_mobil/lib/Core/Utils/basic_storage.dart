import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class BasicStorage {
  BasicStorage._();

  static final BasicStorage instance = BasicStorage._();

  factory BasicStorage() => instance;

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get _sp {
    if (_prefs == null) {
      throw Exception('Storage.init() not called');
    }
    return _prefs!;
  }

  String? getString(String key) => _sp.getString(key);

  void setString(String key, String value) => _sp.setString(key, value);

  int? getInt(String key) => _sp.getInt(key);

  void setInt(String key, int value) => _sp.setInt(key, value);

  bool? getBool(String key) => _sp.getBool(key);

  void setBool(String key, bool value) => _sp.setBool(key, value);

  double? getDouble(String key) => _sp.getDouble(key);

  void setDouble(String key, double value) => _sp.setDouble(key, value);

  Map<String, dynamic>? getJson(String key) {
    final str = _sp.getString(key);
    if (str == null) return null;
    try {
      return jsonDecode(str) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  void setJson(String key, Map<String, dynamic> value) {
    _sp.setString(key, jsonEncode(value));
  }

  List<String>? getStringList(String key) => _sp.getStringList(key);

  void setStringList(String key, List<String> value) {
    _sp.setStringList(key, value);
  }

  bool containsKey(String key) => _sp.containsKey(key);

  void remove(String key) => _sp.remove(key);

  void clear() => _sp.clear();

  Future<void> reload() async => await _sp.reload();

  Set<String> getKeys() => _sp.getKeys();

  Map<String, dynamic> getAllData() {
    final keys = _sp.getKeys();
    Map<String, dynamic> allData = {};

    for (String key in keys) {
      allData[key] = _sp.get(key);
    }

    return allData;
  }
}