import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonkrumdm/Core/Constants/Enums/global.dart';
import 'package:wonkrumdm/Core/Constants/Enums/storage_keys.dart';
import 'package:wonkrumdm/Core/Constants/const.dart';
import 'package:wonkrumdm/Core/Constants/ext.dart';
import 'package:wonkrumdm/Core/Extensions/num.dart';
import 'package:wonkrumdm/Core/L10n/L.dart';
import 'package:wonkrumdm/Core/Managers/Stream/device_stream_manager.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_theme.dart';
import 'package:wonkrumdm/Core/Utils/basic_storage.dart';
import 'package:wonkrumdm/Core/Utils/device_identity_helper.dart';
import 'package:wonkrumdm/Data/DataSources/Remote/serverpod_gateway.dart';
import 'package:wonkrumdm/Views/BtManagement/Widgets/bt_section_card.dart';

class BtConnectionTab extends StatefulWidget {
  const BtConnectionTab({super.key, required this.logScrollController});

  final ScrollController logScrollController;

  @override
  State<BtConnectionTab> createState() => _BtConnectionTabState();
}

class _BtConnectionTabState extends State<BtConnectionTab> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _serverUrlController;
  late final TextEditingController _tokenController;

  @override
  void initState() {
    super.initState();
    _serverUrlController = TextEditingController(
      text: BasicStorage.instance.getString(Sk.server_url.name) ?? serverUrl,
    );
    _tokenController = TextEditingController(text: _maskedToken());
  }

  @override
  void dispose() {
    _serverUrlController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  String _maskedToken() {
    final token = DeviceIdentityHelper.getToken();
    if (token == null || token.isEmpty) return '—';
    final head = token.length <= 8 ? token : token.substring(0, 8);
    return '$head…';
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    final url = _serverUrlController.text.trim();
    if (url.isEmpty) {
      BasicStorage.instance.remove(Sk.server_url.name);
    } else {
      BasicStorage.instance.setString(Sk.server_url.name, url);
    }
    ServerpodGateway.instance.reset();
    await DeviceStreamManager.to.restart();
    bottomMessage(L.bt_connection_settings_saved, type: MessageType.success);
  }

  static String _formatHeartbeatAgo(DateTime at) {
    final sec = DateTime.now().difference(at).inSeconds;
    if (sec < 60) return L.btHeartbeatSecondsAgo(sec.toString());
    final min = sec ~/ 60;
    if (min < 60) return L.btHeartbeatMinutesAgo(min.toString());
    return L.btHeartbeatHoursAgo((min ~/ 60).toString());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Obx(() {
            final mgr = DeviceStreamManager.to;
            final connected = mgr.rxConnected.value;
            final connecting = mgr.rxConnecting.value;
            return BtSectionCard(
              icon: Icons.wifi_tethering_rounded,
              title: L.bt_connection_section_title,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: connected
                              ? WonkruColors.green.withValues(alpha: 0.15)
                              : connecting
                              ? WonkruColors.accent.withValues(alpha: 0.15)
                              : WonkruColors.gray,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          connected
                              ? L.bt_connection_connected
                              : connecting
                              ? L.bt_connection_connecting
                              : L.bt_connection_disconnected,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: connected
                                ? WonkruColors.green
                                : connecting
                                ? WonkruColors.accent
                                : Colors.white60,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (connected && mgr.lastHeartbeatAt != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      L.btConnectionLastHeartbeat(_formatHeartbeatAgo(mgr.lastHeartbeatAt!)),
                      style: TextStyle(fontSize: 13, color: Colors.white60),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [

                      Expanded(
                        child: CustomButton(
                          label: L.bt_connection_start_connection,
                          variant: ButtonVariant.primary,
                          icon: Icons.play_arrow_rounded,
                          onTap: () async {
                            await mgr.connect();
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomButton(
                          label: L.bt_connection_stop_connection,
                          variant: ButtonVariant.secondary,
                          icon: Icons.stop_rounded,
                          onTap: connected ? () => mgr.disconnect() : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
          16.hh,
          BtSectionCard(
            icon: Icons.tune_rounded,
            title: L.bt_connection_connection_settings,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FieldLabel(L.bt_connection_username),
                  8.hh,
                  CustomTextField(
                    controller: _serverUrlController,
                    hint: L.bt_connection_username,
                    prefixIcon: Icons.dns_rounded,
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: _save,
                  ),
                  16.hh,
                  FieldLabel(L.bt_connection_password),
                  8.hh,
                  CustomTextField(
                    controller: _tokenController,
                    hint: L.bt_connection_password,
                    prefixIcon: Icons.key_rounded,
                    readOnly: true,
                    textInputAction: TextInputAction.done,
                  ),
                  20.hh,
                  CustomButton(
                    label: L.bt_connection_save,
                    variant: ButtonVariant.primary,
                    icon: Icons.save_rounded,
                    onTap: _save,
                  ),
                ],
              ),
            ),
          ),
          16.hh,
          BtSectionCard(
            icon: Icons.list_alt_rounded,
            title: L.bt_connection_logs_title,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      DeviceStreamManager.to.clearLogs();
                    },
                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                    label: Text(L.bt_connection_logs_clear),
                    style: TextButton.styleFrom(foregroundColor: Colors.white60),
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 320),
                  child: Obx(() {
                    final logs = DeviceStreamManager.to.logs;
                    if (logs.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(L.bt_connection_logs_empty, style: TextStyle(color: Colors.white60, fontSize: 13)),
                      );
                    }
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (widget.logScrollController.hasClients) {
                        widget.logScrollController.jumpTo(widget.logScrollController.position.maxScrollExtent);
                      }
                    });
                    return ListView.builder(
                      controller: widget.logScrollController,
                      shrinkWrap: true,
                      itemCount: logs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: SelectableText(
                            logs[index],
                            style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}