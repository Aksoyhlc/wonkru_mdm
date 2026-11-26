import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonkrumdm/Core/Constants/const.dart';
import 'package:wonkrumdm/Core/Extensions/num.dart';
import 'package:wonkrumdm/Core/L10n/L.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_theme.dart';
import 'package:wonkrumdm/Views/Widgets/wonkru_backdrop.dart';
import 'package:wonkrumdm/Views/Widgets/setup_qr_scanner_sheet.dart';
import 'package:wonkrumdm/generated/assets.dart';

const _tag = 'ServerConfigFormScreen';

class ServerConfigFormScreen extends StatefulWidget {
  final VoidCallback onCancel;

  /// Starts setup; if [enrollmentKey] is empty the stored key is used.
  final Future<void> Function(String serverUrl, String enrollmentKey)
  onStartSetup;

  final String? initialEnrollmentKey;

  const ServerConfigFormScreen({
    super.key,
    required this.onCancel,
    required this.onStartSetup,
    this.initialEnrollmentKey,
  });

  @override
  State<ServerConfigFormScreen> createState() => _ServerConfigFormScreenState();
}

class _ServerConfigFormScreenState extends State<ServerConfigFormScreen> {
  final _serverUrlController = TextEditingController(text: serverUrl);
  late final _enrollmentKeyController = TextEditingController(
    text: widget.initialEnrollmentKey ?? '',
  );
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  @override
  void dispose() {
    _serverUrlController.dispose();
    _enrollmentKeyController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _serverUrlController.text = serverUrl;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final serverUrl = _serverUrlController.text.trim();
    WLog.d(_tag, 'Starting setup with custom server: server=$serverUrl');
    setState(() => _loading = true);
    try {
      await widget.onStartSetup(
        serverUrl,
        _enrollmentKeyController.text.trim(),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _scanQr() async {
    final payload = await SetupQrScannerSheet.show(context);
    if (payload == null || !mounted) return;
    if (payload.serverUrl != null) {
      _serverUrlController.text = payload.serverUrl!;
    }
    if (payload.enrollmentKey != null) {
      _enrollmentKeyController.text = payload.enrollmentKey!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) widget.onCancel();
      },
      child: Scaffold(
        backgroundColor: WonkruColors.bg,
        body: SizedBox(
          height: context.height,
          child: Stack(
            children: [
              const Positioned.fill(child: WonkruBackdrop()),

              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        SafeArea(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                28.hh,
                                Row(
                                  children: [
                                    IconBtn(
                                      icon: Icons.arrow_back_rounded,
                                      onTap: widget.onCancel,
                                    ),
                                    14.ww,
                                    Image.asset(
                                      Assets.assets.images.logoHorizontal.path,
                                      height: 40,
                                    ),
                                  ],
                                ),
                                24.hh,
                                10.hh,
                                Center(
                                  child: Text(
                                    L.server_config_form_heading,
                                    textAlign: TextAlign.center,
                                    style: WonkruText.body(24, color: Colors.white, weight: FontWeight.w600).copyWith(height: 1.15),
                                  ),
                                ),
                                16.hh,
                                const CustomDivider(),
                                32.hh,
                                FieldLabel(L.server_config_server_url),
                                8.hh,
                                CustomTextField(
                                  controller: _serverUrlController,
                                  hint: L.server_config_server_url_hint,
                                  prefixIcon: Icons.link_rounded,
                                  keyboardType: TextInputType.url,
                                ),
                                20.hh,
                                FieldLabel(L.enrollment_key_label),
                                8.hh,
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextField(
                                        controller: _enrollmentKeyController,
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
                                20.hh,
                                CustomButton(
                                  label: _loading
                                      ? L.server_config_connecting
                                      : L.server_config_start_setup,
                                  variant: ButtonVariant.primary,
                                  icon: _loading
                                      ? null
                                      : Icons.play_arrow_rounded,
                                  loading: _loading,
                                  onTap: _loading ? null : _submit,
                                ),
                                12.hh,
                                CustomButton(
                                  label: L.cancel,
                                  variant: ButtonVariant.ghost,
                                  onTap: widget.onCancel,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
