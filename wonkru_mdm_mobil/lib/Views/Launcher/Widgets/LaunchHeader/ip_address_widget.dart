import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:wonkrumdm/Core/Managers/network_manager.dart';
import 'package:wonkrumdm/Core/Utils/network_address_helper.dart';
import 'package:wonkrumdm/Views/Launcher/Widgets/LaunchHeader/status_badge.dart';

class IpAddressWidget extends StatelessWidget {
  const IpAddressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ConnectivityResult>>(
      stream: NetworkManager.instance.onConnectivityChanged,
      builder: (context, _) {
        return FutureBuilder<String>(
          future: _getIPAddress(),
          builder: (context, snapshot) =>
              StatusBadge(icon: const Icon(Icons.wifi_rounded), label: snapshot.data ?? '...'),
        );
      },
    );
  }

  static Future<String> _getIPAddress() async {
    final local = await NetworkAddressHelper.getLocalLanIPv4();
    final l = local != null && local.isNotEmpty ? local : '—';
    return l;
  }
}
