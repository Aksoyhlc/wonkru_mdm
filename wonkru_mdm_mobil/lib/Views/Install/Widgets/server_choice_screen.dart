import 'package:flutter/material.dart';
import 'package:wonkrumdm/Core/Constants/Enums/storage_keys.dart';
import 'package:wonkrumdm/Core/Constants/const.dart';
import 'package:wonkrumdm/Core/Extensions/num.dart';
import 'package:wonkrumdm/Core/L10n/L.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_theme.dart';
import 'package:wonkrumdm/Core/Utils/basic_storage.dart';
import 'package:wonkrumdm/Views/Widgets/wonkru_backdrop.dart';
import 'package:wonkrumdm/Views/Widgets/bootstrap_ca_installer_sheet.dart';
import 'package:wonkrumdm/Views/Widgets/setup_qr_scanner_sheet.dart';
import 'package:wonkrumdm/generated/assets.dart';

class ServerChoiceScreen extends StatefulWidget {
  final Future<void> Function() onUseDefault;
  final VoidCallback onEnterManual;
  final bool requireBootstrapCaServerInfo;

  /// When provided, the enrollment key field is shown (QR-less setup or a
  /// rejected key). The caller reads its value.
  final TextEditingController? enrollmentKeyController;

  const ServerChoiceScreen({
    super.key,
    required this.onUseDefault,
    required this.onEnterManual,
    this.requireBootstrapCaServerInfo = false,
    this.enrollmentKeyController,
  });

  @override
  State<ServerChoiceScreen> createState() => _ServerChoiceScreenState();
}

class _ServerChoiceScreenState extends State<ServerChoiceScreen> {
  Future<void> _scanQr() async {
    final payload = await SetupQrScannerSheet.show(context);
    if (payload == null || !mounted) return;

    final serverUrl = payload.serverUrl;
    if (serverUrl != null && serverUrl.isNotEmpty) {
      BasicStorage.instance.setString(Sk.server_url.name, serverUrl);
    }
    final deviceCode = payload.deviceCode;
    if (deviceCode != null && deviceCode.isNotEmpty) {
      BasicStorage.instance.setString(Sk.device_code.name, deviceCode);
    }
    final key = payload.enrollmentKey;
    final controller = widget.enrollmentKeyController;
    if (controller != null && key != null) {
      controller.text = key;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final hasServer =
        BasicStorage.instance.getString(Sk.server_url.name)?.isNotEmpty ?? false;
    return SafeArea(
      child: Scaffold(
        backgroundColor: WonkruColors.bg,
        body: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Positioned.fill(child: WonkruBackdrop()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            constraints: BoxConstraints(maxHeight: 150),
                            child: Image.asset(
                              Assets.assets.images.logoHorizontal.path,
                            ),
                          ),
                          24.hh,
                          Text(
                            L.server_config_title,
                            textAlign: TextAlign.center,
                            style: WonkruText.body(26, color: Colors.white, weight: FontWeight.w600).copyWith(height: 1.15),
                          ),
                          if (widget.requireBootstrapCaServerInfo) ...[
                            16.hh,
                            Alert(
                              title: L.server_choice_self_signed_title,
                              message: L.server_choice_self_signed_message,
                              icon: Icons.shield_outlined,
                              color: WonkruColors.accent,
                            ),
                            36.hh,
                            CustomButton(
                              label: L.server_choice_ca_server_info_btn,
                              variant: ButtonVariant.ghost,
                              icon: Icons.edit_rounded,
                              onTap: () =>
                                  BootstrapCaInstallerSheet.show(context),
                            ),
                            12.hh,
                          ],
                          if (widget.enrollmentKeyController != null) ...[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: FieldLabel(L.enrollment_key_label),
                            ),
                            8.hh,
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    controller: widget.enrollmentKeyController!,
                                    hint: L.enrollment_key_hint,
                                    prefixIcon: Icons.key_rounded,
                                  ),
                                ),
                                8.ww,
                                IconBtn(
                                  icon: Icons.qr_code_scanner_rounded,
                                  onTap: _scanQr,
                                ),
                              ],
                            ),
                            16.hh,
                          ],
                          if (!publicAgentBuild || hasServer) ...[
                            CustomButton(
                              label: publicAgentBuild
                                  ? L.server_config_continue
                                  : L.server_config_use_default,
                              variant: ButtonVariant.primary,
                              icon: Icons.check_rounded,
                              onTap: widget.onUseDefault,
                            ),
                            12.hh,
                          ],
                          CustomButton(
                            label: L.server_config_enter_custom,
                            variant: ButtonVariant.secondary,
                            icon: Icons.tune_rounded,
                            onTap: widget.onEnterManual,
                          ),
                          28.hh,
                          MonoBadge(
                            label: L.powered_by_badge,
                            icon: Icons.android_rounded,
                          ),
                          28.hh,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
