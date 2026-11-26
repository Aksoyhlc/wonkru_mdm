import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:wonkrumdm/Core/Constants/Enums/storage_keys.dart';
import 'package:wonkrumdm/Core/L10n/L.dart';
import 'package:wonkrumdm/Core/Managers/Stream/device_stream_manager.dart';
import 'package:wonkrumdm/Core/Managers/app_manager.dart';
import 'package:wonkrumdm/Core/Managers/audio_manager.dart';
import 'package:wonkrumdm/Core/Managers/battery_manager.dart';
import 'package:wonkrumdm/Core/Managers/display_manager.dart';
import 'package:wonkrumdm/Core/Managers/network_manager.dart';
import 'package:wonkrumdm/Core/Managers/storage_manager.dart';
import 'package:wonkrumdm/Core/Native/Bridges/watchdog_bridge.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_theme.dart';
import 'package:wonkrumdm/Core/Utils/basic_storage.dart';
import 'package:wonkrumdm/Core/Utils/storage_helper.dart';
import 'package:wonkrumdm/Logic/Common/watchdog_controller.dart';
import 'package:wonkrumdm/Views/BtManagement/Widgets/bt_section_card.dart';
import 'package:wonkrumdm/Views/BtManagement/Widgets/bt_watchdog_tile.dart';
import 'package:wonkrumdm/Views/Widgets/bootstrap_ca_installer_sheet.dart';

class BtDiagnosticsTab extends StatefulWidget {
  const BtDiagnosticsTab({super.key});

  @override
  State<BtDiagnosticsTab> createState() => _BtDiagnosticsTabState();
}

class _BtDiagnosticsTabState extends State<BtDiagnosticsTab> {
  final _st = StorageHelper();
  bool? _nativeWatchdogEnabled;
  bool _nativeWatchdogLoading = false;

  @override
  Widget build(BuildContext context) {
    final batteryManager = BatteryManager();
    final networkManager = NetworkManager();
    final lastSync = DateTime.fromMillisecondsSinceEpoch(_st.getInt(Sk.lastSync.name) ?? 0);
    final lastPolicy = DateTime.fromMillisecondsSinceEpoch(_st.getInt(Sk.lastPolicyUpdate.name) ?? 0);
    final lastPolicyVersion = _st.getInt(Sk.lastPolicyVersion.name);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BtSectionCard(
            icon: Icons.health_and_safety_outlined,
            title: L.bt_diagnostics_status_summary,
            child: Column(
              children: [
                BtInfoRow(
                  icon: Icons.battery_charging_full_rounded,
                  label: L.bt_battery_label,
                  value: '${batteryManager.level ?? '—'}%',
                ),
                BtInfoRow(
                  icon: Icons.wifi_tethering_rounded,
                  label: L.bt_connection_section_title,
                  value: DeviceStreamManager.to.rxConnected.value ? L.bt_connection_connected : L.bt_connection_disconnected,
                ),
                BtInfoRow(
                  icon: Icons.sync_rounded,
                  label: L.last_sync,
                  value: lastSync.millisecondsSinceEpoch == 0 ? '—' : lastSync.toString(),
                ),
                BtInfoRow(
                  icon: Icons.policy_rounded,
                  label: L.last_policy,
                  value: lastPolicy.millisecondsSinceEpoch == 0 ? '—' : lastPolicy.toString(),
                ),
                BtInfoRow(
                  icon: Icons.numbers_rounded,
                  label: L.bt_policy_version,
                  value: lastPolicyVersion != null ? lastPolicyVersion.toString() : '—',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          BtSectionCard(
            icon: Icons.verified_user_outlined,
            title: L.bt_cert_tools_title,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  L.bt_cert_tools_desc,
                  style: TextStyle(fontSize: 12, color: Colors.white60),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => BootstrapCaInstallerSheet.show(context),
                    icon: const Icon(Icons.download_rounded, size: 18),
                    label: Text(L.bt_cert_tools_install_btn),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: WonkruColors.accent,
                      side: BorderSide(color: WonkruColors.accent),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          BtSectionCard(
            icon: Icons.pets_rounded,
            title: L.bt_watchdog_section_title,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile(
                  title: Text(
                    L.bt_watchdog_service_planned,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    L.bt_watchdog_service_subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.white60),
                  ),
                  value: _nativeWatchdogEnabled ??
                      BasicStorage.instance.getBool(Sk.watchdog_service_enabled.name) ??
                      true,
                  onChanged: _nativeWatchdogLoading
                      ? null
                      : (value) async {
                          setState(() => _nativeWatchdogLoading = true);
                          BasicStorage.instance.setBool(Sk.watchdog_service_enabled.name, value);
                          try {
                            if (value) {
                              await WatchdogBridge.startWatchdog();
                            } else {
                              await WatchdogBridge.stopWatchdog();
                            }
                            if (mounted) {
                              setState(() {
                                _nativeWatchdogEnabled = value;
                                _nativeWatchdogLoading = false;
                              });
                            }
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    value
                                        ? L.bt_watchdog_service_on_toast
                                        : L.bt_watchdog_service_off_toast,
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          } on PlatformException catch (e) {
                            if (mounted) setState(() => _nativeWatchdogLoading = false);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(L.errorWithMessage(e.message ?? '')),
                                  backgroundColor: WonkruColors.red,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          }
                        },
                  activeTrackColor: WonkruColors.accent,
                  activeThumbColor: WonkruColors.bg,
                ),
                const Divider(height: 24),
                Text(
                  L.bt_flutter_watchdogs_title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white60,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                BtWatchdogTile(
                  label: L.bt_battery_label,
                  running: batteryManager.isWatchdogRunning,
                  onStart: () {
                    WatchdogController.to.start<BatteryManager>();
                    setState(() {});
                  },
                  onStop: () {
                    WatchdogController.to.stop<BatteryManager>();
                    setState(() {});
                  },
                ),
                BtWatchdogTile(
                  label: L.bt_storage_label,
                  running: StorageManager().isWatchdogRunning,
                  onStart: () {
                    WatchdogController.to.start<StorageManager>();
                    setState(() {});
                  },
                  onStop: () {
                    WatchdogController.to.stop<StorageManager>();
                    setState(() {});
                  },
                ),
                BtWatchdogTile(
                  label: L.bt_audio_label,
                  running: AudioManager().isWatchdogRunning,
                  onStart: () {
                    WatchdogController.to.start<AudioManager>();
                    setState(() {});
                  },
                  onStop: () {
                    WatchdogController.to.stop<AudioManager>();
                    setState(() {});
                  },
                ),
                BtWatchdogTile(
                  label: L.bt_display_label,
                  running: DisplayManager().isWatchdogRunning,
                  onStart: () {
                    WatchdogController.to.start<DisplayManager>();
                    setState(() {});
                  },
                  onStop: () {
                    WatchdogController.to.stop<DisplayManager>();
                    setState(() {});
                  },
                ),
                BtWatchdogTile(
                  label: L.bt_app_label,
                  running: AppManager().isWatchdogRunning,
                  onStart: () {
                    WatchdogController.to.start<AppManager>();
                    setState(() {});
                  },
                  onStop: () {
                    WatchdogController.to.stop<AppManager>();
                    setState(() {});
                  },
                ),
                BtWatchdogTile(
                  label: L.bt_network_label,
                  running: networkManager.isWatchdogRunning,
                  onStart: () {
                    WatchdogController.to.start<NetworkManager>();
                    setState(() {});
                  },
                  onStop: () {
                    WatchdogController.to.stop<NetworkManager>();
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}