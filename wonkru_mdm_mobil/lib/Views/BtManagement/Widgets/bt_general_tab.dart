import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wonkrumdm/Core/Constants/Enums/global.dart';
import 'package:wonkrumdm/Core/Constants/Enums/storage_keys.dart';
import 'package:wonkrumdm/Core/Constants/const.dart';
import 'package:wonkrumdm/Core/Constants/ext.dart';
import 'package:wonkrumdm/Core/Extensions/context.dart';
import 'package:wonkrumdm/Core/Extensions/num.dart';
import 'package:wonkrumdm/Core/L10n/L.dart';
import 'package:wonkrumdm/Core/Managers/launcher_mode_manager.dart';
import 'package:wonkrumdm/Core/Managers/Stream/device_stream_manager.dart';
import 'package:wonkrumdm/Core/Native/Bridges/app_bridge.dart';
import 'package:wonkrumdm/Core/Native/Bridges/launcher_mode_bridge.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_theme.dart';
import 'package:wonkrumdm/Core/Utils/basic_storage.dart';
import 'package:wonkrumdm/Core/Utils/enrollment_key_store.dart';
import 'package:wonkrumdm/Core/Utils/device_identity_helper.dart';
import 'package:wonkrumdm/Data/DataSources/Remote/device.dart';
import 'package:wonkrumdm/Logic/Common/device_controller.dart';
import 'package:wonkrumdm/Views/BtManagement/Widgets/bt_action_row.dart';
import 'package:wonkrumdm/Views/BtManagement/Widgets/bt_section_card.dart';
import 'package:wonkrumdm/Views/Install/Widgets/server_config_form_screen.dart';
import 'package:wonkrumdm/Views/PermissionsSetup/permission_setup.dart';

class _BtListDivider extends StatelessWidget {
  const _BtListDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 0,
      thickness: 1,
      color: Colors.white12,
      indent: 12,
      endIndent: 12,
    );
  }
}

class BtGeneralTab extends StatelessWidget {
  const BtGeneralTab({super.key, this.onRefresh});

  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final launcherModeManager = LauncherModeManager();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          16.hh,
          BtSectionCard(
            icon: Icons.settings_ethernet_rounded,
            title: L.server_config_title,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BtInfoRow(
                  icon: Icons.link_rounded,
                  label: L.server_config_server_url,
                  value: serverUrl,
                ),
                BtInfoRow(
                  icon: Icons.tag_rounded,
                  label: L.bt_device_code,
                  value: DeviceIdentityHelper.getCode() ?? '—',
                ),
                BtInfoRow(
                  icon: Icons.fingerprint_rounded,
                  label: L.bt_device_uuid,
                  value: DeviceIdentityHelper.getUuid() ?? '—',
                ),
                16.hh,
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await context.to(
                        ServerConfigFormScreen(
                          onCancel: () => Navigator.of(context).pop(),
                          initialEnrollmentKey: EnrollmentKeyStore.instance.key,
                          onStartSetup: (serverUrl, enrollmentKey) async {
                            if (serverUrl.isEmpty) return;
                            BasicStorage.instance.setString(
                              Sk.server_url.name,
                              serverUrl,
                            );
                            // A new key also re-enables automatic retry of a
                            // rejected registration.
                            if (enrollmentKey.isNotEmpty) {
                              EnrollmentKeyStore.instance.save(enrollmentKey);
                            }
                            DeviceStreamManager.to.restart();

                            DeviceController.to.applyLatestConfig(
                              forceUpdate: true,
                              applyConfiguration: true,
                            );
                            if (context.mounted) Navigator.of(context).pop();
                          },
                        ),
                      );
                      onRefresh?.call();
                    },
                    icon: const Icon(Icons.edit_rounded, size: 18),
                    label: Text(L.bt_server_config_change_btn),
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
          16.hh,
          FadeInDown(
            duration: const Duration(milliseconds: 400),
            delay: const Duration(milliseconds: 120),
            child: BtSectionCard(
              icon: Icons.flash_on_rounded,
              title: L.quick_actions,
              child: Column(
                children: [
                  FutureBuilder<Map<String, dynamic>>(
                    future: launcherModeManager.getData(),
                    builder: (context, snapshot) {
                      final active =
                          snapshot.data?['isLauncherModeActive'] == true;
                      return Column(
                        children: [
                          BtActionRow(
                            label: active
                                ? L.launcher_mode_disable
                                : L.launcher_mode_enable,
                            subtitle: active
                                ? L.launcher_mode_active_subtitle
                                : L.launcher_mode_inactive_subtitle,
                            onTap: () async {
                              if (active) {
                                await launcherModeManager.disableLauncherMode();
                              } else {
                                await launcherModeManager.enableLauncherMode();
                              }
                              onRefresh?.call();
                            },
                          ),
                          const _BtListDivider(),
                        ],
                      );
                    },
                  ),
                  BtActionRow(
                    label: L.permissions_page,
                    onTap: () => context.to(const PermissionsSetupPage()),
                  ),
                  const _BtListDivider(),
                  BtActionRow(
                    label: L.sync_do,
                    subtitle: L.sync_subtitle,
                    onTap: () async {
                      final deviceAPI = DeviceAPI();
                      final (ok, _) = await deviceAPI.sync();
                      if (!context.mounted) return;
                      if (ok) {
                        bottomMessage(
                          L.sync_success,
                          type: MessageType.success,
                        );
                      } else {
                        bottomMessage(
                          deviceAPI.lastMessage.isNotEmpty
                              ? deviceAPI.lastMessage
                              : L.sync_failed,
                        );
                      }
                      onRefresh?.call();
                    },
                  ),
                  const _BtListDivider(),
                  BtActionRow(
                    label: L.policy_download,
                    subtitle: L.policy_download_subtitle,
                    onTap: () async {
                      await DeviceController.to.applyLatestConfig(
                        forceUpdate: true,
                        applyConfiguration: true,
                      );
                      if (!context.mounted) return;
                      bottomMessage(
                        L.policy_update_started,
                        type: MessageType.success,
                      );
                      onRefresh?.call();
                    },
                  ),
                  const _BtListDivider(),
                  BtActionRow(
                    label: L.default_launcher_reset,
                    subtitle: L.default_launcher_reset_subtitle,
                    onTap: () async {
                      final packageInfo = await PackageInfo.fromPlatform();
                      final result = await LauncherModeBridge()
                          .clearHomeIntentHandler(packageInfo.packageName);
                      if (!context.mounted) return;
                      final ok = result['success'] == true;
                      if (ok) {
                        bottomMessage(
                          result['message']?.toString() ??
                              L.launcher_reset_done,
                          type: MessageType.success,
                        );
                      } else {
                        bottomMessage(
                          result['message']?.toString() ??
                              L.launcher_reset_failed,
                        );
                      }
                      onRefresh?.call();
                    },
                  ),
                  const _BtListDivider(),
                  BtActionRow(
                    label: L.open_settings,
                    subtitle: L.open_settings_subtitle,
                    onTap: () async {
                      final ok = await AppBridge().launchApp(
                        'com.android.settings',
                      );
                      if (!context.mounted) return;
                      if (!ok) bottomMessage(L.settings_open_failed);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
