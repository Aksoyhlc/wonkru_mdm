import 'dart:convert';
import 'dart:io';

import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';
import 'package:wonkrumdm/Core/Constants/Enums/storage_keys.dart';
import 'package:wonkrumdm/Core/Constants/const.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Utils/basic_storage.dart';

const _tag = 'ServerpodGateway';

class ServerpodGateway {
  ServerpodGateway._();

  static final ServerpodGateway instance = ServerpodGateway._();

  Client? _client;
  Client? _uploadClient;
  String? _host;

  /// Serverpod's client has no per-call timeout, so the timeout is fixed here.
  static const connectionTimeout = Duration(seconds: 20);

  static const uploadTimeout = Duration(minutes: 5);

  bool get isInitialized => _client != null;

  Client get client {
    final current = _client;
    if (current == null) {
      throw StateError(
        'Client cannot be used before ServerpodGateway.init() is called.',
      );
    }
    return current;
  }

  /// Separate, long-timeout client used only for file uploads.
  ///
  /// Serverpod's `connectionTimeout` covers the whole request and cannot be
  /// changed per call; the 20s limit cut off large uploads, while raising the
  /// general client's timeout would let every RPC hang. Built lazily with the
  /// same base address and trust context.
  Client get uploadClient {
    final main = client;
    final existing = _uploadClient;
    if (existing != null) return existing;
    final created = Client(
      _host ?? main.host,
      securityContext: _securityContext(),
      connectionTimeout: uploadTimeout,
      streamingConnectionTimeout: const Duration(seconds: 15),
    );
    _uploadClient = created;
    return created;
  }

  Client init({String? baseUrl}) {
    final host = _normalize(baseUrl ?? serverUrl);
    final existing = _client;
    if (existing != null && _host == host) {
      return existing;
    }

    // Clear state before closing the old client: if building the new client
    // throws, `_client` stays null and `isInitialized` won't wrongly report a
    // closed client.
    _client = null;
    _host = null;
    existing?.close();
    _uploadClient?.close();
    _uploadClient = null;

    final context = _securityContext();
    final created = Client(
      host,
      securityContext: context,
      connectionTimeout: connectionTimeout,
      streamingConnectionTimeout: const Duration(seconds: 15),
    );
    _client = created;
    _host = host;
    WLog.i(_tag, 'Serverpod client ready: $host');
    return created;
  }

  void reset() {
    _client?.close();
    _client = null;
    _uploadClient?.close();
    _uploadClient = null;
    _host = null;
  }

  String _normalize(String raw) =>
      raw.trim().endsWith('/') ? raw.trim() : '${raw.trim()}/';

  SecurityContext? _securityContext() {
    final b64 = BasicStorage.instance.getString(Sk.bootstrap_ca_cert_b64.name);
    if (b64 == null || b64.isEmpty) return null;
    try {
      final context = SecurityContext(withTrustedRoots: true);
      context.setTrustedCertificatesBytes(base64Decode(b64));
      return context;
    } catch (e) {
      WLog.w(_tag, 'Could not load bootstrap CA; using default trust: $e');
      return null;
    }
  }
}
