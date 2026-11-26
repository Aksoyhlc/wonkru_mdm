import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../Core/L10n/L.dart';
import '../Dialog/device_picker_dialog.dart';
import 'custom_text_field.dart';
import 'text_controllers_owner.dart';

class DevicePickerField extends StatefulWidget {
  const DevicePickerField({
    super.key,
    required this.name,
    required this.onChanged,
    this.label,
    this.hint,
  });

  final String name;

  final ValueChanged<Device?> onChanged;
  final String? label;
  final String? hint;

  @override
  State<DevicePickerField> createState() => _DevicePickerFieldState();
}

class _DevicePickerFieldState extends State<DevicePickerField>
    with TextControllersOwner<DevicePickerField> {
  late final _label = textController();
  Device? _device;

  Future<void> _pick() async {
    final device = await showDeviceSinglePickerDialog(
      context,
      initialDeviceId: _device?.id,
    );
    if (device == null) return;

    setState(() {
      _device = device;
      _label.text = device.name?.isNotEmpty == true
          ? device.name!
          : device.code;
    });
    widget.onChanged(device);
  }

  void _clear() {
    setState(() {
      _device = null;
      _label.text = '';
    });
    widget.onChanged(null);
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      name: widget.name,
      controller: _label,
      label: widget.label ?? L.common.device,
      hint: widget.hint ?? L.common.pickDevice,
      dense: true,
      readOnly: true,
      showValidationError: false,
      suffixIcon: _device == null ? LucideIcons.search : LucideIcons.x,
      onSuffixTap: _device == null ? _pick : _clear,
    );
  }
}
