import 'package:flutter/material.dart';
import 'package:wonkrumdm/Core/Constants/Enums/storage_keys.dart';
import 'package:wonkrumdm/Core/Constants/const.dart';
import 'package:wonkrumdm/Core/Extensions/num.dart';
import 'package:wonkrumdm/Core/L10n/L.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_theme.dart';
import 'package:wonkrumdm/Core/Utils/storage_helper.dart';
import 'package:wonkrumdm/Views/Widgets/confirm_dialog.dart';

import 'bt_section_card.dart';

class BtAdminPasswordTab extends StatefulWidget {
  const BtAdminPasswordTab({super.key});

  @override
  State<BtAdminPasswordTab> createState() => _BtAdminPasswordTabState();
}

class _BtAdminPasswordTabState extends State<BtAdminPasswordTab> {
  final _controller = TextEditingController();

  String? _localPassword() {
    return StorageHelper.instance
        .getString(Sk.bt_management_admin_password.name)
        ?.trim();
  }

  bool get _hasCustomPassword {
    final local = _localPassword();
    return local != null && local.isNotEmpty;
  }

  Future<void> _savePassword() async {
    final next = _controller.text.trim();
    if (next.isEmpty) {
      _showMessage(L.bt_admin_password_empty);
      return;
    }
    StorageHelper.instance.setString(
      Sk.bt_management_admin_password.name,
      next,
    );
    _controller.clear();
    if (!mounted) return;
    setState(() {});
    _showMessage(L.bt_admin_password_saved);
  }

  Future<void> _resetToDefault() async {
    if (!_hasCustomPassword) return;
    await confirmDialog(
      context: context,
      message: L.bt_admin_password_reset_confirm,
      onConfirm: () {
        StorageHelper.instance.remove(Sk.bt_management_admin_password.name);
        if (!mounted) return;
        setState(() {});
        _showMessage(L.bt_admin_password_reset_done);
      },
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activePassword = btManagementAdminPassword;
    final statusText = _hasCustomPassword
        ? L.bt_admin_password_using_custom
        : activePassword.isEmpty
        ? L.off
        : L.bt_admin_password_using_default;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: BtSectionCard(
        icon: Icons.password_rounded,
        title: L.bt_admin_password_title,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              L.bt_admin_password_subtitle,
              style: WonkruText.body(
                13,
                color: Colors.white60,
              ).copyWith(height: 1.35),
            ),
            12.hh,
            BtInfoRow(
              icon: Icons.info_outline_rounded,
              label: L.bt_admin_password_current_mode,
              value: statusText,
            ),
            if (activePassword.isNotEmpty)
              BtInfoRow(
                icon: Icons.key_rounded,
                label: L.bt_admin_password_active_value,
                value: activePassword,
              ),
            8.hh,
            Text(
              L.bt_admin_password_new_password_label,
              style: WonkruText.body(13, color: Colors.white60),
            ),
            8.hh,
            TextField(
              controller: _controller,
              obscureText: true,
              decoration: InputDecoration(
                hintText: L.bt_admin_password_new_password_hint,
                border: const OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _savePassword(),
            ),
            12.hh,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _savePassword,
                icon: const Icon(Icons.save_rounded, size: 18),
                label: Text(L.bt_admin_password_save),
              ),
            ),
            8.hh,
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _hasCustomPassword ? _resetToDefault : null,
                icon: const Icon(Icons.restore_rounded, size: 18),
                label: Text(L.bt_admin_password_reset_default),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
