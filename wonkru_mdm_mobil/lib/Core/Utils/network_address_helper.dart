import 'dart:convert';
import 'dart:io';

import 'package:network_info_plus/network_info_plus.dart';

class NetworkAddressHelper {
  NetworkAddressHelper._();

  static String? _publicIpCache;
  static DateTime? _publicIpCacheAt;

  static bool _isTunnelInterface(String name) {
    final n = name.toLowerCase();
    return n.contains('tun') ||
        n.contains('wg') ||
        n.contains('ppp') ||
        n.contains('ipsec') ||
        n.contains('pptp');
  }

  static Future<String?> getPreferredIPv4() async {
    try {
      final interfaces = await NetworkInterface.list();
      for (final iface in interfaces) {
        if (!_isTunnelInterface(iface.name)) continue;
        for (final addr in iface.addresses) {
          if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
            return addr.address;
          }
        }
      }
      for (final iface in interfaces) {
        for (final addr in iface.addresses) {
          if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
            return addr.address;
          }
        }
      }
    } catch (_) {}
    return null;
  }

  static Future<String?> getPreferredIPv6() async {
    try {
      final interfaces = await NetworkInterface.list();
      for (final iface in interfaces) {
        if (!_isTunnelInterface(iface.name)) continue;
        for (final addr in iface.addresses) {
          if (addr.type == InternetAddressType.IPv6 && !addr.isLoopback) {
            return addr.address;
          }
        }
      }
      for (final iface in interfaces) {
        for (final addr in iface.addresses) {
          if (addr.type == InternetAddressType.IPv6 && !addr.isLoopback) {
            return addr.address;
          }
        }
      }
    } catch (_) {}
    return null;
  }

  static Future<String?> getLocalLanIPv4() async {
    try {
      final wifi = await NetworkInfo().getWifiIP();
      if (wifi != null && wifi.isNotEmpty && wifi != '0.0.0.0') {
        return wifi;
      }
    } catch (_) {}
    try {
      final interfaces = await NetworkInterface.list();
      for (final iface in interfaces) {
        if (_isTunnelInterface(iface.name)) continue;
        for (final addr in iface.addresses) {
          if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
            return addr.address;
          }
        }
      }
    } catch (_) {}
    return null;
  }

  static Future<String?> getPublicIPv4({Duration timeout = const Duration(seconds: 2)}) async {
    final now = DateTime.now();
    if (_publicIpCache != null &&
        _publicIpCacheAt != null &&
        now.difference(_publicIpCacheAt!) < const Duration(seconds: 60)) {
      return _publicIpCache;
    }

    const urls = <String>[
      'https://api.ipify.org',
      'https://icanhazip.com',
    ];
    for (final url in urls) {
      HttpClient? client;
      try {
        client = HttpClient();
        client.connectionTimeout = timeout;
        final request = await client.getUrl(Uri.parse(url)).timeout(timeout);
        final response = await request.close().timeout(timeout);
        if (response.statusCode != 200) continue;
        final body = await response.transform(utf8.decoder).join().timeout(timeout);
        final ip = body.trim();
        if (_isPlausibleIpv4(ip)) {
          _publicIpCache = ip;
          _publicIpCacheAt = DateTime.now();
          return ip;
        }
      } catch (_) {
        continue;
      } finally {
        client?.close(force: true);
      }
    }
    return null;
  }

  static bool _isPlausibleIpv4(String s) {
    try {
      final a = InternetAddress(s);
      return a.type == InternetAddressType.IPv4 && !a.isLoopback;
    } catch (_) {
      return false;
    }
  }
}