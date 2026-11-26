import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:wonkrumdm/Core/L10n/L.dart';
import 'package:wonkrumdm/Core/Managers/network_manager.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_theme.dart';
import 'package:wonkrumdm/Views/BtManagement/Widgets/bt_section_card.dart';

String _deviceInfoStr(dynamic value) {
  if (value == null) return '—';
  if (value is String) return value.isEmpty ? '—' : value;
  return value.toString();
}

class BtDeviceInfoTab extends StatelessWidget {
  const BtDeviceInfoTab({super.key, required this.deviceInfoFuture, this.onRefresh});

  final Future<Map<String, dynamic>> deviceInfoFuture;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: deviceInfoFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done || snapshot.data == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: WonkruColors.accent),
                const SizedBox(height: 16),
                Text(L.bt_loading, style: TextStyle(color: Colors.white60)),
              ],
            ),
          );
        }
        final data = snapshot.data!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: FadeIn(
            duration: const Duration(milliseconds: 400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BtSectionCard(
                  icon: Icons.info_outline_rounded,
                  title: L.bt_device_info_section,
                  child: Column(
                    children: [
                      BtInfoRow(
                        icon: Icons.tag_rounded,
                        label: L.bt_device_code,
                        value: _deviceInfoStr(data['deviceName']),
                      ),
                      BtInfoRow(
                        icon: Icons.key_outlined,
                        label: L.bt_device_uuid,
                        value: _deviceInfoStr(data['deviceUuid']),
                      ),
                      BtInfoRow(
                        icon: Icons.lan_rounded,
                        label: L.ip_local,
                        value: _deviceInfoStr(data['ipLocal']),
                      ),
                      BtInfoRow(
                        icon: Icons.public_rounded,
                        label: L.ip_public,
                        value: _deviceInfoStr(data['ipPublic']),
                      ),
                      BtInfoRow(
                        icon: Icons.policy_rounded,
                        label: L.last_policy,
                        value: _deviceInfoStr(data['lastPolicyUpdate']),
                      ),
                      BtInfoRow(
                        icon: Icons.numbers_rounded,
                        label: L.bt_policy_version,
                        value: _deviceInfoStr(data['lastPolicyVersion']),
                      ),
                      BtInfoRow(
                        icon: Icons.sync_rounded,
                        label: L.last_sync,
                        value: _deviceInfoStr(data['lastSync']),
                      ),
                      BtInfoRow(
                        icon: Icons.app_settings_alt_rounded,
                        label: L.bt_version_label,
                        value: _deviceInfoStr(data['version']) + ' (' + _deviceInfoStr(data['buildNumber']) + ')',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                BtSectionCard(
                  icon: Icons.smartphone_rounded,
                  title: L.bt_device_info_phone_section,
                  child: Column(
                    children: [
                      BtInfoRow(
                        icon: Icons.business_rounded,
                        label: L.bt_manufacturer,
                        value: _deviceInfoStr(data['manufacturer']),
                      ),
                      BtInfoRow(
                        icon: Icons.phone_android_rounded,
                        label: L.bt_model,
                        value: _deviceInfoStr(data['model']),
                      ),
                      BtInfoRow(
                        icon: Icons.memory_rounded,
                        label: L.bt_brand,
                        value: _deviceInfoStr(data['brand']),
                      ),
                      BtInfoRow(
                        icon: Icons.smartphone_rounded,
                        label: L.bt_device,
                        value: _deviceInfoStr(data['device']),
                      ),
                      BtInfoRow(
                        icon: Icons.android_rounded,
                        label: L.bt_android,
                        value: _deviceInfoStr(data['androidRelease']),
                      ),
                      BtInfoRow(
                        icon: Icons.build_rounded,
                        label: L.bt_sdk,
                        value: _deviceInfoStr(data['sdkInt']),
                      ),
                      BtInfoRow(
                        icon: Icons.security_rounded,
                        label: L.bt_security_patch,
                        value: _deviceInfoStr(data['securityPatch']),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                FutureBuilder<Map<String, dynamic>>(
                  future: NetworkManager().getData(),
                  builder: (context, netSnap) {
                    if (netSnap.connectionState != ConnectionState.done || netSnap.data == null) {
                      return BtSectionCard(
                        icon: Icons.wifi_rounded,
                        title: L.bt_connection_info_title,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(L.bt_loading, style: TextStyle(color: Colors.white60, fontSize: 13)),
                          ),
                        ),
                      );
                    }
                    final net = netSnap.data!;
                    final ipInfo = net['ipInfo'] is Map ? net['ipInfo'] as Map<String, dynamic> : null;
                    final wifi = net['wifi'];
                    final connTypes = net['connectionTypes'];
                    final connStr = connTypes is List ? connTypes.join(', ') : '—';
                    return BtSectionCard(
                      icon: Icons.wifi_rounded,
                      title: L.bt_connection_info_title,
                      child: Column(
                        children: [
                          BtInfoRow(
                            icon: Icons.link_rounded,
                            label: L.bt_online,
                            value: (net['isOnline'] == true) ? L.yes : L.no,
                          ),
                          BtInfoRow(
                            icon: Icons.settings_ethernet_rounded,
                            label: L.bt_connection_types,
                            value: connStr.toString(),
                          ),
                          BtInfoRow(
                            icon: Icons.lan_rounded,
                            label: L.ip_local,
                            value: ipInfo?['ipv4Local']?.toString() ?? '—',
                          ),
                          BtInfoRow(
                            icon: Icons.public_rounded,
                            label: L.ip_public,
                            value: ipInfo?['ipv4Public']?.toString() ?? '—',
                          ),
                          BtInfoRow(
                            icon: Icons.wifi_rounded,
                            label: L.bt_ipv6,
                            value: ipInfo?['ipv6']?.toString() ?? '—',
                          ),
                          BtInfoRow(
                            icon: Icons.router_rounded,
                            label: L.bt_gateway,
                            value: ipInfo?['gateway']?.toString() ?? '—',
                          ),
                          BtInfoRow(
                            icon: Icons.subtitles_rounded,
                            label: L.bt_subnet_mask,
                            value: ipInfo?['subnetMask']?.toString() ?? '—',
                          ),
                          BtInfoRow(
                            icon: Icons.wifi_rounded,
                            label: L.bt_wifi_name,
                            value: ipInfo?['wifiName']?.toString() ?? '—',
                          ),
                          BtInfoRow(
                            icon: Icons.fingerprint_rounded,
                            label: L.bt_bssid,
                            value: ipInfo?['wifiBSSID']?.toString() ?? '—',
                          ),
                          if (wifi is Map) ...[
                            BtInfoRow(
                              icon: Icons.signal_cellular_alt_rounded,
                              label: L.bt_rssi,
                              value: wifi['rssi']?.toString() ?? '—',
                            ),
                            BtInfoRow(
                              icon: Icons.speed_rounded,
                              label: L.bt_link_speed,
                              value: wifi['linkSpeed']?.toString() ?? '—',
                            ),
                            BtInfoRow(
                              icon: Icons.waves_rounded,
                              label: L.bt_frequency_mhz,
                              value: wifi['frequency']?.toString() ?? '—',
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}