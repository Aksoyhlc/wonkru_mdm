import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wonkrumdm/Core/Constants/const.dart';
import 'package:wonkrumdm/Core/Extensions/context.dart';
import 'package:wonkrumdm/Core/Extensions/num.dart';
import 'package:wonkrumdm/Core/L10n/L.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_theme.dart';
import 'package:wonkrumdm/Data/DataSources/Remote/device.dart';
import 'package:wonkrumdm/Views/BtManagement/bt_management_page.dart';
import 'package:wonkrumdm/Views/Widgets/wonkru_backdrop.dart';
import 'package:wonkrumdm/generated/assets.dart';

class BtManagementPasswordPage extends StatefulWidget {
  const BtManagementPasswordPage({super.key});

  @override
  State<BtManagementPasswordPage> createState() => _BtManagementPasswordPageState();
}

class _BtManagementPasswordPageState extends State<BtManagementPasswordPage> {
  final _controller = TextEditingController();
  bool _loading = false;
  String? _error;
  bool _manualLoginModeActive = false;
  DateTime? _lastDoubleTapAt;
  Timer? _doubleTapResetTimer;

  @override
  void dispose() {
    _doubleTapResetTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final password = _controller.text.trim();
    if (password.isEmpty) {
      setState(() {
        _error = L.please_enter_password;
        _loading = false;
      });
      return;
    }

    setState(() {
      _error = null;
      _loading = true;
    });

    if (_manualLoginModeActive) {
      final localOrFallback = btManagementAdminPassword;
      if (password == localOrFallback) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const BtManagementPage()));
        return;
      }
    }

    final (requestStatus, passStatus) = await DeviceAPI().checkPassword(password);

    if (!mounted) return;

    if (requestStatus) {
      if (passStatus) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const BtManagementPage()));
        return;
      }
      setState(() {
        _error = L.invalid_password;
        _loading = false;
      });
      return;
    }

    setState(() {
      _error = L.invalid_password_or_server;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) context.back();
      },
      child: Scaffold(
        backgroundColor: WonkruColors.bg,
        body: Stack(
          children: [
            const Positioned.fill(child: WonkruBackdrop()),
            SafeArea(
              child: Column(
                children: [
                  10.hh,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        IconBtn(icon: Icons.arrow_back_rounded, onTap: () => context.back()),
                        14.ww,
                        Image.asset(Assets.assets.images.logoHorizontal.path, height: 40),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          24.hh,
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                            decoration: BoxDecoration(
                              color: WonkruColors.surface.withValues(alpha: 0.62),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Center(
                                  child: GestureDetector(
                                    onDoubleTap: () {
                                      setState(() {
                                        _lastDoubleTapAt = DateTime.now();
                                        _doubleTapResetTimer?.cancel();
                                        _doubleTapResetTimer = Timer(const Duration(seconds: 1), () {
                                          if (mounted) setState(() => _lastDoubleTapAt = null);
                                        });
                                      });
                                    },
                                    onLongPress: () {
                                      if (_lastDoubleTapAt != null &&
                                          DateTime.now().difference(_lastDoubleTapAt!) < const Duration(seconds: 1)) {
                                        _doubleTapResetTimer?.cancel();
                                        _lastDoubleTapAt = null;
                                        setState(() => _manualLoginModeActive = true);
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: _manualLoginModeActive
                                            ? WonkruColors.red.withValues(alpha: 0.25)
                                            : WonkruColors.accentDim,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.admin_panel_settings_rounded,
                                        size: 48,
                                        color: _manualLoginModeActive ? WonkruColors.red : WonkruColors.accent,
                                      ),
                                    ),
                                  ),
                                ),
                                if (_manualLoginModeActive) ...[
                                  12.hh,
                                  Alert(
                                    title: L.manual_login_warning_title,
                                    message: L.manual_login_warning_message,
                                    icon: Icons.info_outline_rounded,
                                    color: WonkruColors.red,
                                    onDismiss: () => setState(() => _manualLoginModeActive = false),
                                  ),
                                ],
                                24.hh,
                                Center(
                                  child: Text(
                                    L.device_management_title,
                                    style: WonkruText.body(22, color: Colors.white, weight: FontWeight.w600).copyWith(height: 1.2),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                8.hh,
                                Center(
                                  child: Text(
                                    L.device_management_subtitle,
                                    style: WonkruText.body(14, color: Colors.white70).copyWith(height: 1.4),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                24.hh,
                                const CustomDivider(),
                                24.hh,
                                FieldLabel(L.password_label),
                                8.hh,
                                CustomTextField(
                                  controller: _controller,
                                  hint: L.password_hint,
                                  prefixIcon: Icons.lock_outline_rounded,
                                  obscureText: true,
                                  enabled: !_loading,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: _submit,
                                  fontSize: 16,
                                  autofillHints: const [AutofillHints.password],
                                ),
                                16.hh,
                                _buildError(),
                                28.hh,
                                CustomButton(
                                  label: _loading ? L.please_wait : L.login_button,
                                  variant: _manualLoginModeActive ? ButtonVariant.danger : ButtonVariant.primary,
                                  icon: _loading ? null : Icons.login_rounded,
                                  loading: _loading,
                                  onTap: _loading ? null : _submit,
                                ),
                                24.hh,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.info_outline_rounded, size: 14, color: WonkruColors.grayLight),
                                    6.ww,
                                    Text(
                                      L.footer_authorized_only,
                                      style: WonkruText.body(12, color: WonkruColors.grayLight),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          32.hh,
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

  Widget _buildError() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: _error != null
          ? Row(
              key: ValueKey(_error),
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline_rounded, size: 18, color: WonkruColors.red),
                6.ww,
                Flexible(
                  child: Text(
                    _error!,
                    style: WonkruText.body(13, color: WonkruColors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
          : const SizedBox.shrink(),
    );
  }
}