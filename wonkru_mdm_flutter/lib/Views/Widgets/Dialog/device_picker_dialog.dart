import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../Core/Constants/Enums/button_enums.dart';
import '../../../Core/L10n/L.dart';
import '../../../Core/Theme/design.dart';
import '../../../Logic/Controllers/devices_controller.dart';
import '../Button/app_button.dart';
import '../Input/checkbox_row.dart';
import '../Input/remote_search_list.dart';
import 'app_dialog_shell.dart';

Future<Set<int>?> showDevicePickerDialog(
  BuildContext context, {
  Set<int> initial = const {},
  void Function(List<Device> devices)? onLoaded,
}) {
  return showDialog<Set<int>>(
    context: context,
    builder: (_) => _DevicePickerDialog(initial: initial, onLoaded: onLoaded),
  );
}

Future<Device?> showDeviceSinglePickerDialog(
  BuildContext context, {
  int? initialDeviceId,
}) {
  return showDialog<Device>(
    context: context,
    builder: (_) => AppDialogShell(
      title: L.common.selectDevice,
      maxWidth: 560,
      actions: [AppButton.cancel(context)],
      child: RemoteSearchList<Device>(
        load: _searchDevices,
        searchName: 'device_single_picker_search',
        searchHint: L.common.deviceSearchHint,
        errorText: L.common.devicesLoadFailed,
        emptyText: L.common.noMatchingDevices,
        itemBuilder: (context, device) => CheckboxRow(
          title: _deviceName(device),
          subtitle: device.code,
          selected: device.id == initialDeviceId,
          onChanged: (_) => Navigator.pop(context, device),
        ),
      ),
    ),
  );
}

Future<List<Device>> _searchDevices(String? search) =>
    Get.find<DevicesController>().searchDevices(search);

String _deviceName(Device device) =>
    device.name?.isNotEmpty == true ? device.name! : device.code;

class _DevicePickerDialog extends StatefulWidget {
  const _DevicePickerDialog({required this.initial, this.onLoaded});

  final Set<int> initial;
  final void Function(List<Device> devices)? onLoaded;

  @override
  State<_DevicePickerDialog> createState() => _DevicePickerDialogState();
}

class _DevicePickerDialogState extends State<_DevicePickerDialog> {
  late final Set<int> _selected = widget.initial.toSet();
  Map<int, String> _groupNames = const {};

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    try {
      final names = await Get.find<DevicesController>().groupNames();
      if (!mounted) return;
      setState(() => _groupNames = names);
    } catch (_) {
      // Group names are optional; a failed fetch falls back to "—".
    }
  }

  void _selectAll(List<Device> devices) {
    setState(() {
      for (final device in devices) {
        final id = device.id;
        if (id != null) _selected.add(id);
      }
    });
  }

  void _toggle(Device device, bool checked) {
    final id = device.id;
    if (id == null) return;

    setState(() {
      checked ? _selected.add(id) : _selected.remove(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppDialogShell(
      title: L.common.selectDevice,
      maxWidth: 560,
      actions: [
        AppButton.cancel(context),
        AppButton(
          label: L.common.selectCount.trParams({
            'count': '${_selected.length}',
          }),
          onPressed: () => Navigator.pop(context, _selected),
        ),
      ],
      child: RemoteSearchList<Device>(
        load: _searchDevices,
        onLoaded: widget.onLoaded,
        searchName: 'notification_device_picker_search',
        searchHint: L.common.deviceSearchHint,
        errorText: L.common.devicesLoadFailed,
        emptyText: L.common.noMatchingDevices,
        toolbar: (loading, devices) => Row(
          children: [
            AppButton(
              label: L.common.selectAll,
              compact: true,
              variant: AppButtonVariant.secondary,
              icon: LucideIcons.check,
              onPressed: loading || devices.isEmpty
                  ? null
                  : () => _selectAll(devices),
            ),
            AppGap.h8,
            AppButton(
              label: L.common.clear,
              compact: true,
              variant: AppButtonVariant.secondary,
              icon: LucideIcons.x,
              onPressed: _selected.isEmpty
                  ? null
                  : () => setState(_selected.clear),
            ),
          ],
        ),
        listHeader: _listHeader(context),
        itemBuilder: (context, device) => CheckboxRow(
          title: _deviceName(device),
          subtitle: device.code,
          selected: _selected.contains(device.id),
          onChanged: (checked) => _toggle(device, checked),
          trailing: SizedBox(
            width: 120,
            child: Text(
              _groupNames[device.groupId] ?? '—',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: AppText.cellSecondary(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _listHeader(BuildContext context) {
    final style = AppText.columnHeader(context).copyWith(fontSize: 11);
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.s4,
        right: AppSpacing.s4,
        bottom: AppSpacing.s4,
      ),
      child: Row(
        children: [
          const SizedBox(width: 40),
          Expanded(child: Text(L.common.device, style: style)),
          SizedBox(
            width: 120,
            child: Text(
              L.common.group,
              style: style,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
