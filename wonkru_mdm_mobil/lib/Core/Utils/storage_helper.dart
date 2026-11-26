import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';

const String _tag = 'StorageHelper';

class StorageEvent {
  final String key;
  final dynamic oldValue;
  final dynamic newValue;
  final StorageEventType type;

  StorageEvent({required this.key, this.oldValue, this.newValue, required this.type});
}

enum StorageEventType { write, remove, clear }

class StorageHelper {
  StorageHelper._();

  factory StorageHelper() => instance;
  static final StorageHelper instance = StorageHelper._();

  final Map<String, dynamic> _cache = {};

  final StreamController<StorageEvent> _eventController = StreamController<StorageEvent>.broadcast();
  final Map<String, List<void Function(dynamic)>> _listeners = {};

  late final FlutterSecureStorage _storage;

  final Map<String, int> _expiryMap = {};

  Stream<StorageEvent> get events => _eventController.stream;

  AndroidOptions _getAndroidOptions() => const AndroidOptions();

  Future<void> init() async {
    _storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
    await _loadAllToCache();
  }

  Future<void> _writeToStorage(String key, dynamic value) async {
    try {
      await _storage.write(key: key, value: _serializeValue(value));
    } catch (e, st) {
      WLog.e(_tag, 'Storage write error (key=$key)', error: e, stackTrace: st);
    }
  }

  Future<void> _loadAllToCache() async {
    try {
      final all = await _storage.readAll();
      for (final entry in all.entries) {
        if (entry.key.endsWith('.expiry')) {
          final expiry = int.tryParse(entry.value);
          if (expiry != null) {
            final originalKey = entry.key.replaceAll('.expiry', '');
            _expiryMap[originalKey] = expiry;
          }
          continue;
        }

        _cache[entry.key] = _parseValue(entry.value);
      }

      _cleanExpiredKeys();
    } catch (e, st) {
      WLog.e(_tag, 'Cache load error (storage -> RAM)', error: e, stackTrace: st);
    }
  }

  String _serializeValue(dynamic value) {
    if (value is String) return value;
    if (value is int || value is double || value is bool) return value.toString();
    if (value is List || value is Map) return jsonEncode(value);
    return value.toString();
  }

  dynamic _parseValue(String value) {
    if (value.startsWith('{') || value.startsWith('[')) {
      try {
        return jsonDecode(value);
      } catch (_) {
        return value;
      }
    }

    return value;
  }

  void _cleanExpiredKeys() {
    final now = DateTime.now().millisecondsSinceEpoch;
    final expiredKeys = <String>[];

    for (final entry in _expiryMap.entries) {
      if (entry.value < now) {
        expiredKeys.add(entry.key);
      }
    }

    for (final key in expiredKeys) {
      _cache.remove(key);
      _expiryMap.remove(key);
      _storage.delete(key: key);
      _storage.delete(key: '$key.expiry');
    }
  }

  bool _isExpired(String key) {
    if (!_expiryMap.containsKey(key)) return false;

    final expiry = _expiryMap[key]!;
    final now = DateTime.now().millisecondsSinceEpoch;

    if (now > expiry) {
      _cache.remove(key);
      _expiryMap.remove(key);
      remove(key);
      return true;
    }

    return false;
  }

  void _notifyChange(String key, dynamic oldValue, dynamic newValue) {
    _eventController.add(StorageEvent(key: key, oldValue: oldValue, newValue: newValue, type: StorageEventType.write));

    _listeners[key]?.forEach((callback) => callback(newValue));
  }

  String? getString(String key) {
    if (_isExpired(key)) return null;
    final value = _cache[key];

    if (value == null) return null;
    return value.toString();
  }

  void setString(String key, String value) {
    final oldValue = _cache[key];
    _cache[key] = value;
    _writeToStorage(key, value);
    _notifyChange(key, oldValue, value);
  }

  int? getInt(String key) {
    if (_isExpired(key)) return null;
    final value = _cache[key];

    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);

    return null;
  }

  void setInt(String key, int value) {
    final oldValue = _cache[key];
    _cache[key] = value;
    _writeToStorage(key, value);
    _notifyChange(key, oldValue, value);
  }

  double? getDouble(String key) {
    if (_isExpired(key)) return null;
    final value = _cache[key];
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  void setDouble(String key, double value) {
    final oldValue = _cache[key];
    _cache[key] = value;
    _writeToStorage(key, value);
    _notifyChange(key, oldValue, value);
  }

  bool? getBool(String key) {
    if (_isExpired(key)) return null;
    final value = _cache[key];

    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }

    return null;
  }

  void setBool(String key, bool value) {
    final oldValue = _cache[key];
    _cache[key] = value;
    _writeToStorage(key, value);
    _notifyChange(key, oldValue, value);
  }

  List<String>? getStringList(String key) {
    if (_isExpired(key)) return null;
    final value = _cache[key];
    if (value is List) return List<String>.from(value);
    return null;
  }

  void setStringList(String key, List<String> value) {
    final oldValue = _cache[key];
    _cache[key] = value;
    _writeToStorage(key, value);
    _notifyChange(key, oldValue, value);
  }

  Map<String, dynamic>? getJson(String key) {
    if (_isExpired(key)) return null;
    final value = _cache[key];
    if (value is Map<String, dynamic>) return value;
    return null;
  }

  void setJson(String key, Map<String, dynamic> value) {
    final oldValue = _cache[key];
    _cache[key] = value;
    _writeToStorage(key, value);
    _notifyChange(key, oldValue, value);
  }

  List<Map<String, dynamic>>? getJsonList(String key) {
    if (_isExpired(key)) return null;
    final value = _cache[key];
    if (value is List) {
      return List<Map<String, dynamic>>.from(value);
    }
    return null;
  }

  void setJsonList(String key, List<Map<String, dynamic>> value) {
    final oldValue = _cache[key];
    _cache[key] = value;
    _writeToStorage(key, value);
    _notifyChange(key, oldValue, value);
  }

  void setStringWithTTL(String key, String value, Duration ttl) {
    setString(key, value);
    final expiry = DateTime.now().add(ttl).millisecondsSinceEpoch;
    _expiryMap[key] = expiry;
    _writeToStorage('$key.expiry', expiry.toString());
  }

  void setIntWithTTL(String key, int value, Duration ttl) {
    setInt(key, value);
    final expiry = DateTime.now().add(ttl).millisecondsSinceEpoch;
    _expiryMap[key] = expiry;
    _writeToStorage('$key.expiry', expiry.toString());
  }

  void setBoolWithTTL(String key, bool value, Duration ttl) {
    setBool(key, value);
    final expiry = DateTime.now().add(ttl).millisecondsSinceEpoch;
    _expiryMap[key] = expiry;
    _writeToStorage('$key.expiry', expiry.toString());
  }

  void setJsonWithTTL(String key, Map<String, dynamic> value, Duration ttl) {
    setJson(key, value);
    final expiry = DateTime.now().add(ttl).millisecondsSinceEpoch;
    _expiryMap[key] = expiry;
    _writeToStorage('$key.expiry', expiry.toString());
  }

  Duration? getRemainingTTL(String key) {
    if (!_expiryMap.containsKey(key)) return null;

    final expiry = _expiryMap[key]!;
    final now = DateTime.now().millisecondsSinceEpoch;
    final remaining = expiry - now;

    if (remaining <= 0) {
      _isExpired(key);
      return null;
    }

    return Duration(milliseconds: remaining);
  }

  void listen(String key, void Function(dynamic value) callback) {
    _listeners[key] ??= [];
    _listeners[key]!.add(callback);
  }

  void removeListener(String key, void Function(dynamic value) callback) {
    _listeners[key]?.remove(callback);
    if (_listeners[key]?.isEmpty ?? false) {
      _listeners.remove(key);
    }
  }

  void clearListeners([String? key]) {
    if (key != null) {
      _listeners.remove(key);
    } else {
      _listeners.clear();
    }
  }

  Stream<StorageEvent> listenToKey(String key) {
    return events.where((event) => event.key == key);
  }

  bool addToList(String key, String item) {
    final list = getStringList(key) ?? [];
    if (list.contains(item)) return false;
    list.add(item);
    setStringList(key, list);
    return true;
  }

  bool removeFromList(String key, String item) {
    final list = getStringList(key) ?? [];
    final removed = list.remove(item);
    if (removed) setStringList(key, list);
    return removed;
  }

  bool listContains(String key, String item) {
    final list = getStringList(key) ?? [];
    return list.contains(item);
  }

  bool toggleInList(String key, String item) {
    final list = getStringList(key) ?? [];
    if (list.contains(item)) {
      list.remove(item);
      setStringList(key, list);
      return false;
    } else {
      list.add(item);
      setStringList(key, list);
      return true;
    }
  }

  int getListLength(String key) {
    return getStringList(key)?.length ?? 0;
  }

  void clearList(String key) {
    setStringList(key, []);
  }

  bool containsKey(String key) {
    if (_isExpired(key)) return false;
    return _cache.containsKey(key);
  }

  void remove(String key) {
    final oldValue = _cache[key];
    _cache.remove(key);
    _expiryMap.remove(key);

    _storage.delete(key: key);
    _storage.delete(key: '$key.expiry');

    _eventController.add(StorageEvent(key: key, oldValue: oldValue, newValue: null, type: StorageEventType.remove));
  }

  Set<String> getKeys() {
    _cleanExpiredKeys();
    return _cache.keys.toSet();
  }

  Map<String, dynamic> getAllData() {
    _cleanExpiredKeys();
    return Map<String, dynamic>.from(_cache);
  }

  Set<String> getKeysWithPrefix(String prefix) {
    _cleanExpiredKeys();
    return _cache.keys.where((key) => key.startsWith(prefix)).toSet();
  }

  void removeKeysWithPrefix(String prefix) {
    final keys = getKeysWithPrefix(prefix);
    for (final key in keys) {
      remove(key);
    }
  }

  Future<void> clear() async {
    _cache.clear();
    _expiryMap.clear();
    await _storage.deleteAll();

    _eventController.add(StorageEvent(key: '', oldValue: null, newValue: null, type: StorageEventType.clear));
  }

  T getWithDefault<T>(String key, T defaultValue) {
    if (_isExpired(key)) return defaultValue;
    final value = _cache[key];
    return (value as T?) ?? defaultValue;
  }

  void writeBatch(Map<String, dynamic> keyValuePairs) {
    for (final entry in keyValuePairs.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value is String) {
        setString(key, value);
      } else if (value is int) {
        setInt(key, value);
      } else if (value is double) {
        setDouble(key, value);
      } else if (value is bool) {
        setBool(key, value);
      } else if (value is List<String>) {
        setStringList(key, value);
      } else if (value is Map<String, dynamic>) {
        setJson(key, value);
      } else {
        setString(key, value.toString());
      }
    }
  }

  Set<String> findKeys(String pattern) {
    _cleanExpiredKeys();
    final regex = RegExp(pattern);
    return _cache.keys.where((key) => regex.hasMatch(key)).toSet();
  }

  Map<String, List<String>> categorizeKeys() {
    _cleanExpiredKeys();
    final categories = <String, List<String>>{'secure': [], 'cache': [], 'system': [], 'user': []};

    for (final key in _cache.keys) {
      if (key.startsWith('_secure_')) {
        categories['secure']!.add(key);
      } else if (key.startsWith('_cache_')) {
        categories['cache']!.add(key);
      } else if (key.startsWith('_')) {
        categories['system']!.add(key);
      } else {
        categories['user']!.add(key);
      }
    }

    return categories;
  }

  int getApproximateSize() {
    int totalSize = 0;
    for (final entry in _cache.entries) {
      totalSize += entry.key.length;
      totalSize += _serializeValue(entry.value).length;
    }
    return totalSize;
  }

  void printAll() {
    final buffer = StringBuffer('StorageHelper contents:\n');
    for (final entry in _cache.entries) {
      final ttl = getRemainingTTL(entry.key);
      final ttlInfo = ttl != null ? ' (TTL: ${ttl.inSeconds}s)' : '';
      buffer.writeln('${entry.key}: ${entry.value}$ttlInfo');
    }
    buffer.writeln('Total Keys: ${_cache.length}, Listeners: ${_listeners.length}');
    WLog.d(_tag, buffer.toString());
  }

  @Deprecated('Use getString instead')
  Future<String?> readString(String key) async => getString(key);

  @Deprecated('Use setString instead')
  Future<bool> writeString(String key, String value) async {
    setString(key, value);
    return true;
  }

  @Deprecated('Use getInt instead')
  Future<int?> readInt(String key) async => getInt(key);

  @Deprecated('Use setInt instead')
  Future<bool> writeInt(String key, int value) async {
    setInt(key, value);
    return true;
  }

  @Deprecated('Use getBool instead')
  Future<bool?> readBool(String key) async => getBool(key);

  @Deprecated('Use setBool instead')
  Future<bool> writeBool(String key, bool value) async {
    setBool(key, value);
    return true;
  }

  Future<void> dispose() async {
    await _eventController.close();
    _cache.clear();
    _listeners.clear();
    _expiryMap.clear();
  }
}