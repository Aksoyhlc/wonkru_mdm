import 'dart:js_interop';

import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

@JS('globalThis.isSecureContext')
external JSBoolean? get _isSecureContext;

FlutterAuthSessionManager createPanelAuthSessionManager() =>
    FlutterAuthSessionManager(
      storage: (_isSecureContext?.toDart ?? false)
          ? null
          : _CookieSessionMetadataStorage(),
    );

// On HTTP LAN URLs Web Crypto is unavailable. Persist only the metadata the
// session manager needs to refresh from the HttpOnly cookie after a reload.
class _CookieSessionMetadataStorage extends KeyValueClientAuthSuccessStorage {
  _CookieSessionMetadataStorage()
    : super(
        keyValueStorage: _BrowserPreferences(),
        authSuccessStorageKey: 'wonkru.cookieSessionMetadata',
      );

  @override
  Future<void> set(AuthSuccess? data) =>
      super.set(data?.copyWith(token: '', refreshToken: null));
}

class _BrowserPreferences implements KeyValueStorage {
  final _preferences = SharedPreferencesAsync();

  @override
  Future<String?> get(String key) => _preferences.getString(key);

  @override
  Future<void> set(String key, String? value) => value == null
      ? _preferences.remove(key)
      : _preferences.setString(key, value);
}
