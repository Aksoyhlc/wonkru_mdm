import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wonkrumdm/Core/Constants/Enums/global.dart';
import 'package:wonkrumdm/Core/Constants/Enums/storage_keys.dart';
import 'package:wonkrumdm/Core/Constants/ext.dart';
import 'package:wonkrumdm/Core/Extensions/context.dart';
import 'package:wonkrumdm/Core/L10n/L.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_theme.dart';
import 'package:wonkrumdm/Core/Utils/network_address_helper.dart';
import 'package:wonkrumdm/Core/Utils/storage_helper.dart';
import 'package:wonkrumdm/Data/DataSources/Local/config.dart';
import 'package:wonkrumdm/Data/DataSources/Remote/device.dart';
import 'package:wonkrumdm/Logic/Common/device_controller.dart';
import 'package:wonkrumdm/Views/BtManagement/bt_management_password_page.dart';
import 'package:wonkrumdm/Views/Widgets/center_loading.dart';

class LauncherInfoButton extends StatelessWidget {
  const LauncherInfoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: L.bt_device_info_section,
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _openInfoSheet(context),
        onDoubleTap: () => context.to(const BtManagementPasswordPage()),
        onLongPress: () => context.to(const BtManagementPasswordPage()),
        child: const SizedBox.square(
          dimension: 36,
          child: Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.info_outline_rounded,
              size: 18,
              color: Color(0x73FFFFFF),
            ),
          ),
        ),
      ),
    );
  }

  void _openInfoSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: WonkruColors.bg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white12),
          ),
          child: FutureBuilder<Map<String, dynamic>>(
            future: _deviceInfo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const SizedBox(height: 220, child: CenterLoadingCard());
              }
              final data = snapshot.data!;
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 14, 22, 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 36,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            L.bt_device_info_section,
                            style: WonkruText.body(16, color: Colors.white, weight: FontWeight.w600).copyWith(height: 1.2),
                          ),
                        ),
                        Text(
                          '#${data['deviceName']}',
                          style: WonkruText.body(14, color: WonkruColors.accent, weight: FontWeight.w600).copyWith(height: 1.2),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _InfoRow(label: L.ip_local, value: data['ipLocal']),
                    _InfoRow(label: L.last_policy, value: data['lastPolicyUpdate']),
                    _InfoRow(label: L.bt_policy_version, value: data['policyVersion']),
                    _InfoRow(label: L.last_sync, value: data['lastSync']),
                    _InfoRow(label: L.agent_version, value: '${data['version']} - ${data['buildNumber']}'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _SheetAction(
                          tooltip: L.sync_tooltip,
                          icon: Icons.cloud_upload_outlined,
                          onPressed: () async {
                            Navigator.of(context).pop();
                            final deviceAPI = DeviceAPI();
                            final (ok, config) = await deviceAPI.sync();
                            if (ok) {
                              bottomMessage(L.sync_success, type: MessageType.success);
                            } else {
                              bottomMessage(L.sync_failed);
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                        _SheetAction(
                          tooltip: L.download_tooltip,
                          icon: Icons.cloud_download_outlined,
                          onPressed: () async {
                            Navigator.of(context).pop();
                            DeviceController.to.applyLatestConfig(applyConfiguration: true, forceUpdate: true);
                            bottomMessage(L.config_update_started, type: MessageType.success);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> _deviceInfo() async {
    final st = StorageHelper();
    final packageInfo = await PackageInfo.fromPlatform();
    final local = await NetworkAddressHelper.getLocalLanIPv4();
    final cached = LocalConfig().getConfig();
    final policyNum = st.getInt(Sk.lastPolicyVersion.name) ?? cached?.version ?? cached?.id;
    return {
      'buildNumber': packageInfo.buildNumber,
      'version': packageInfo.version,
      'ipLocal': local ?? (await NetworkInfo().getWifiIP()) ?? '—',
      'deviceName': st.getString(Sk.deviceCode.name) ?? '',
      'lastSync': DateTime.fromMillisecondsSinceEpoch(st.getInt(Sk.lastSync.name) ?? 0).toString().split('.').first,
      'lastPolicyUpdate': DateTime.fromMillisecondsSinceEpoch(
        st.getInt(Sk.lastPolicyUpdate.name) ?? 0,
      ).toString().split('.').first,
      'policyVersion': policyNum != null ? policyNum.toString() : '—',
    };
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white12)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              label,
              style: WonkruText.body(12, color: Colors.white60, weight: FontWeight.w500).copyWith(height: 1.3),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 6,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: WonkruText.body(14, color: Colors.white, weight: FontWeight.w600).copyWith(height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetAction extends StatelessWidget {
  const _SheetAction({required this.tooltip, required this.icon, required this.onPressed});

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: onPressed,
        style: IconButton.styleFrom(
          foregroundColor: WonkruColors.accent,
          backgroundColor: Colors.white10,
          fixedSize: const Size(44, 44),
        ),
        icon: Icon(icon, size: 20),
      ),
    );
  }
}
