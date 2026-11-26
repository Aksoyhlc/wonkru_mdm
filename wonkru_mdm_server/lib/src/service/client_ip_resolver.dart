import 'dart:io';

import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';
import '../enums/client_ip_source.dart';

/// Resolves the client IP for rate limiting and audit records.
///
/// Forwarding headers are only trusted when [source] selects them, so a spoofed
/// header cannot bypass a limit unless the deployment really sits behind that
/// proxy. The client IP defaults to the raw socket address.
class ClientIpResolver {
  const ClientIpResolver._();

  static const unknownClient = 'unknown';

  /// Set once by the bootstrap from the environment; defaults to
  /// [ClientIpSource.socket].
  static ClientIpSource source = ClientIpSource.socket;

  /// Null writes to `stderr`.
  @visibleForTesting
  static void Function(String message)? warningSink;

  static bool _proxyHeaderWarningLogged = false;

  static bool _invalidSourceWarned = false;

  static int _anonymousFallback = 0;

  /// The only parse point for `CLIENT_IP_SOURCE`. Unset, empty, or unknown
  /// values fall back to [ClientIpSource.socket]; unknown values also warn once.
  static ClientIpSource parseSource(String? raw) {
    switch (raw?.trim().toLowerCase()) {
      case 'proxy':
        return ClientIpSource.proxy;
      case 'cloudflare':
        return ClientIpSource.cloudflare;
      case 'socket':
      case null:
      case '':
        return ClientIpSource.socket;
      default:
        if (!_invalidSourceWarned) {
          _invalidSourceWarned = true;
          _warn(
            'CLIENT_IP_SOURCE="$raw" is not recognized; using "socket". '
            'Valid values: socket, proxy, cloudflare.',
          );
        }
        return ClientIpSource.socket;
    }
  }

  @visibleForTesting
  static void resetWarnings() {
    _proxyHeaderWarningLogged = false;
    _invalidSourceWarned = false;
  }

  static void _warn(String message) {
    final sink = warningSink;
    if (sink != null) {
      sink(message);
      return;
    }
    stderr.writeln('[client-ip] $message');
  }

  /// A malformed header falls through to the next source and finally to the
  /// socket address; if that is unreadable too, a per-request unique key is
  /// returned rather than collapsing every client into one bucket.
  static String resolve(Request? request) {
    if (request == null) {
      return unknownClient;
    }

    final fromHeaders = _headerIp(request);
    if (fromHeaders != null) {
      return fromHeaders;
    }

    final socket = _socketAddress(request);
    if (socket != null) {
      return socket;
    }

    _anonymousFallback++;
    return 'anonymous:$_anonymousFallback';
  }

  static String? _headerIp(Request request) {
    switch (source) {
      case ClientIpSource.cloudflare:
        return _headerFirst(request, 'cf-connecting-ip') ??
            _forwardedIp(request);
      case ClientIpSource.proxy:
        return _forwardedIp(request);
      case ClientIpSource.socket:
        _maybeWarnAboutProxyHeaders(request);
        return null;
    }
  }

  static String? _headerFirst(Request request, String name) {
    try {
      final values = request.headers[name];
      if (values == null) {
        return null;
      }
      for (final value in values) {
        final trimmed = value.trim();
        if (trimmed.isNotEmpty) {
          return trimmed;
        }
      }
    } catch (_) {}
    return null;
  }

  static String? _forwardedIp(Request request) {
    try {
      final info = request.remoteInfo.trim();
      return info.isEmpty ? null : info;
    } catch (_) {
      return null;
    }
  }

  static String? _socketAddress(Request request) {
    try {
      final address = request.connectionInfo.remote.address.toString();
      return address.isEmpty ? null : address;
    } catch (_) {
      return null;
    }
  }

  static void _maybeWarnAboutProxyHeaders(Request request) {
    if (_proxyHeaderWarningLogged) {
      return;
    }
    if (!_hasForwardingHeaders(request)) {
      return;
    }

    _proxyHeaderWarningLogged = true;
    _warn(
      'The request carries a forwarding header (CF-Connecting-IP / X-Forwarded-For / '
      'Forwarded) but CLIENT_IP_SOURCE=socket. Per-IP rate limiting uses the raw '
      'socket address; behind a proxy or Cloudflare Tunnel every client may share '
      'one bucket and be limited more than needed. '
      'For Cloudflare Tunnel set CLIENT_IP_SOURCE=cloudflare, for another reverse '
      'proxy set CLIENT_IP_SOURCE=proxy.',
    );
  }

  static bool _hasForwardingHeaders(Request request) {
    try {
      return request.headers['cf-connecting-ip'] != null ||
          request.headers['x-forwarded-for'] != null ||
          request.headers['forwarded'] != null;
    } catch (_) {
      return false;
    }
  }

  static String forSession(Session session) => resolve(session.request);

  /// Keyed by device identity when available so devices behind one NAT do not
  /// consume each other's quota.
  static String deviceKey(Session session, String? deviceUuid) {
    final uuid = deviceUuid?.trim();
    if (uuid != null && uuid.isNotEmpty) {
      return 'device:$uuid';
    }
    return ipKey(session);
  }

  static String ipKey(Session session) => 'ip:${forSession(session)}';

  static String ipKeyFor(Request request) => 'ip:${resolve(request)}';
}
