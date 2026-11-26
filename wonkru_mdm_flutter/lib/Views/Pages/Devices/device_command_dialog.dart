import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../Core/Constants/Enums/alert_enums.dart';
import '../../../Core/Constants/Enums/button_enums.dart';
import '../../../Core/Constants/Enums/device_action.dart';
import '../../../Core/L10n/L.dart';
import '../../../Core/Logging/wlog.dart';
import '../../../Core/Theme/design.dart';
import '../../../Logic/Controllers/devices_controller.dart';
import '../../Widgets/Alert/app_toast.dart';
import '../../Widgets/Button/app_button.dart';
import '../../Widgets/Dialog/app_dialog_shell.dart';
import '../../Widgets/Dialog/confirm_dialog.dart';
import '../../Widgets/Dialog/device_picker_dialog.dart';
import '../../Widgets/Input/app_dropdown.dart';
import '../../Widgets/Input/custom_text_field.dart';
import '../../Widgets/Switch/ui_switch.dart';
import 'Widgets/application_picker_dialog.dart';
import 'Widgets/device_command_status_view.dart';

Future<void> showDeviceCommandDialog(
  BuildContext context, {
  int? deviceId,
  String? deviceLabel,
  Set<int> initialDeviceIds = const {},
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => _DeviceCommandDialog(
      deviceId: deviceId,
      deviceLabel: deviceLabel,
      initialDeviceIds: initialDeviceIds,
    ),
  );
}

class _DeviceCommandDialog extends StatefulWidget {
  const _DeviceCommandDialog({
    this.deviceId,
    this.deviceLabel,
    this.initialDeviceIds = const {},
  });

  final int? deviceId;
  final String? deviceLabel;
  final Set<int> initialDeviceIds;

  @override
  State<_DeviceCommandDialog> createState() => _DeviceCommandDialogState();
}

class _DeviceCommandDialogState extends State<_DeviceCommandDialog> {
  late final DevicesController _devices = Get.find<DevicesController>();

  static Map<String, String> get _paramLabels => <String, String>{
    'title': L.common.title,
    'body': L.devices.paramBody,
    'package_name': L.devices.paramPackageName,
    'intent_action': L.devices.paramIntentAction,
    'intent_package': L.devices.paramIntentPackage,
    'intent_component': L.devices.paramIntentComponent,
    'intent_data': L.devices.paramIntentData,
    'intent_type': L.devices.paramIntentType,
    'intent_categories': L.devices.paramIntentCategories,
    'intent_flags': L.devices.paramIntentFlags,
    'level': L.devices.paramLevel,
    'policy_id': L.devices.paramPolicyId,
    'include_system_apps': L.devices.paramIncludeSystemApps,
  };

  static const _numericParams = {'policy_id', 'level'};

  DeviceAction _action = DeviceAction.update_policy;
  late bool _bulk = widget.deviceId == null;
  bool _includeSystemApps = false;
  bool _sending = false;

  bool _sent = false;

  String? _bulkId;

  DeviceCommandBulkStatus? _bulkStatus;

  List<DeviceCommand> _commands = const [];

  bool _loadingStatus = false;
  String? _statusError;
  Timer? _poll;

  late final Set<int> _deviceIds = {
    if (widget.deviceId != null) widget.deviceId!,
    ...widget.initialDeviceIds,
  };
  final _labels = <int, String>{};

  final _controllers = <String, TextEditingController>{};

  @override
  void initState() {
    super.initState();
    final label = widget.deviceLabel;
    if (widget.deviceId != null && label != null) {
      _labels[widget.deviceId!] = label;
    }
    _ensureControllers();
  }

  @override
  void dispose() {
    _poll?.cancel();
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  /// Existing controllers are kept: field widgets are reused across action
  /// changes, and touching a disposed controller threw "used after being
  /// disposed". All are disposed in [dispose] when the dialog closes.
  void _ensureControllers() {
    for (final entry in _action.defaultParams.entries) {
      if (entry.key == 'include_system_apps') {
        _includeSystemApps = entry.value == '1';
        continue;
      }
      final existing = _controllers[entry.key];
      if (existing == null) {
        _controllers[entry.key] = TextEditingController(text: entry.value);
      } else if (existing.text.trim().isEmpty) {
        existing.text = entry.value;
      }
    }
  }

  void _onActionChanged(String? value) {
    if (value == null) return;
    final action = DeviceAction.values.firstWhere(
      (candidate) => candidate.name == value,
      orElse: () => _action,
    );

    setState(() {
      _action = action;
      if (!action.isBulk && _bulk) {
        _bulk = false;
        if (_deviceIds.length > 1) {
          final first = _deviceIds.first;
          _deviceIds
            ..clear()
            ..add(first);
        }
      }
      _ensureControllers();
    });
  }

  Future<void> _pickDevices() async {
    final picked = await showDevicePickerDialog(
      context,
      initial: _deviceIds,
      onLoaded: (devices) {
        for (final device in devices) {
          final id = device.id;
          if (id == null) continue;
          _labels[id] = device.name?.isNotEmpty == true
              ? device.name!
              : device.code;
        }
      },
    );
    if (picked == null || !mounted) return;

    setState(() {
      _deviceIds.clear();
      if (_bulk) {
        _deviceIds.addAll(picked);
      } else if (picked.isNotEmpty) {
        _deviceIds.add(picked.first);
      }
    });
  }

  Future<void> _pickApplication(String key) async {
    final package = await showApplicationPickerDialog(context);
    if (package == null || !mounted) return;
    setState(() => _controllers[key]?.text = package);
  }

  Map<String, String> _buildParams() {
    final params = <String, String>{};
    for (final key in _action.defaultParams.keys) {
      if (key == 'include_system_apps') {
        params[key] = _includeSystemApps ? '1' : '0';
      } else {
        params[key] = _controllers[key]?.text.trim() ?? '';
      }
    }
    return params;
  }

  Future<void> _send() async {
    final ids = _deviceIds.toList();
    if (ids.isEmpty) {
      AppToast.show(L.devices.commandsSelectOne, tone: UiAlertTone.warning);
      return;
    }

    final params = _buildParams();
    final packageParamKey = _action.packageParamKey;
    if (packageParamKey != null && (params[packageParamKey] ?? '').isEmpty) {
      AppToast.show(
        L.devices.commandsParamRequired.trParams({
          'name': _paramLabels[packageParamKey] ?? packageParamKey,
        }),
        tone: UiAlertTone.warning,
      );
      return;
    }

    final targetIds = _bulk ? ids : [ids.first];
    if (_action.requiresConfirmation) {
      final confirmed = await confirmDialog(
        context: context,
        title: _action.label,
        message: targetIds.length > 1
            ? L.devices.commandsConfirmBulk.trParams({
                'count': '${targetIds.length}',
                'action': _action.label,
              })
            : L.devices.commandsConfirmSingle.trParams({
                'action': _action.label,
              }),
      );
      if (confirmed != true || !mounted) return;
    }

    setState(() => _sending = true);
    try {
      final status = await _devices.sendCommand(
        targetIds,
        _action.name,
        jsonEncode(params),
      );
      if (!mounted) return;
      setState(() {
        _sending = false;
        _sent = true;
        _bulkId = status.bulkId;
        _bulkStatus = status;
      });
      AppToast.show(
        status.total > 0
            ? L.devices.commandsQueued.trParams({'count': '${status.total}'})
            : L.devices.commandsQueueFailed,
        tone: status.total > 0 ? UiAlertTone.success : UiAlertTone.warning,
      );
      _startPolling();
    } catch (e) {
      if (!mounted) return;
      setState(() => _sending = false);
      WLog.e('DeviceCommand', 'command send failed', error: e);
      AppToast.show(
        L.devices.commandsSendFailedRetry,
        tone: UiAlertTone.danger,
      );
    }
  }

  void _startPolling() {
    _poll?.cancel();
    unawaited(_loadBulkStatus());
    _poll = Timer.periodic(const Duration(seconds: 2), (_) {
      unawaited(_loadBulkStatus());
    });
  }

  Future<void> _loadBulkStatus() async {
    final bulkId = _bulkId;
    if (!mounted || bulkId == null) return;

    setState(() {
      _loadingStatus = true;
      _statusError = null;
    });

    try {
      final (status, commands) = await _devices.bulkProgress(bulkId);
      if (!mounted) return;

      setState(() {
        _bulkStatus = status;
        _commands = commands;
        _loadingStatus = false;
      });

      if (status.pending + status.sent == 0) {
        _poll?.cancel();
        _poll = null;
      }
    } catch (e) {
      if (!mounted) return;
      WLog.e('DeviceCommand', 'bulk status load failed', error: e);
      setState(() {
        _loadingStatus = false;
        _statusError = L.devices.commandsStatusLoadFailed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppDialogShell(
      title: _sent ? L.devices.commandsStatusTitle : L.devices.commandCenter,
      maxWidth: 600,
      actions: _sent ? _statusActions(context) : _sendActions(context),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 480),
        child: _sent
            ? DeviceCommandStatusView(
                bulkStatus: _bulkStatus,
                loading: _loadingStatus,
                error: _statusError,
                commands: _commands,
                deviceLabels: _labels,
                onRefresh: () => unawaited(_loadBulkStatus()),
              )
            : _formView(context),
      ),
    );
  }

  List<Widget> _sendActions(BuildContext context) {
    return [
      AppButton.cancel(context, enabled: !_sending),
      AppButton(
        label: L.common.send,
        loading: _sending,
        onPressed: _sending ? null : _send,
      ),
    ];
  }

  List<Widget> _statusActions(BuildContext context) {
    return [
      AppButton(
        label: L.common.refresh,
        variant: AppButtonVariant.secondary,
        icon: LucideIcons.refreshCw,
        onPressed: _loadingStatus ? null : () => unawaited(_loadBulkStatus()),
      ),
      AppButton(
        label: L.common.close,
        onPressed: () => Navigator.pop(context),
      ),
    ];
  }

  Widget _formView(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppDropdown<String>(
            label: L.devices.commandsAction,
            value: _action.name,
            items: {
              for (final action in DeviceAction.values)
                action.name: action.label,
            },
            onChanged: _onActionChanged,
          ),
          if (_action.defaultParams.isNotEmpty) ...[
            AppGap.v16,
            _sectionTitle(L.devices.commandsParameters),
            AppGap.v8,
            for (final key in _action.defaultParams.keys)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s12),
                child: _paramField(key),
              ),
          ],
          AppGap.v16,
          _sectionTitle(L.devices.commandsTarget),
          AppGap.v8,
          if (_action.isBulk)
            UiSwitch(
              value: _bulk,
              title: L.devices.commandsBulkSend,
              subtitle: L.devices.commandsBulkSendSubtitle,
              onChanged: (value) => setState(() => _bulk = value),
            ),
          AppGap.v6,
          Row(
            children: [
              Expanded(child: _targetLabel(context)),
              AppGap.h12,
              AppButton(
                label: L.common.selectDevice,
                compact: true,
                variant: AppButtonVariant.secondary,
                icon: LucideIcons.users,
                onPressed: _sending ? null : _pickDevices,
              ),
            ],
          ),
          AppGap.v16,
          _responseNote(context),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: AppText.columnHeader(context),
    );
  }

  Widget _paramField(String key) {
    if (key == 'include_system_apps') {
      return UiSwitch(
        value: _includeSystemApps,
        title: _paramLabels[key] ?? key,
        dense: true,
        onChanged: (value) => setState(() => _includeSystemApps = value),
      );
    }

    final numeric = _numericParams.contains(key);
    final field = CustomTextField(
      name: 'device_command_$key',
      controller: _controllers[key],
      label: _paramLabels[key] ?? key,
      showValidationError: false,
      keyboardType: numeric ? TextInputType.number : null,
    );

    if (key != 'package_name') return field;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: field),
        AppGap.h8,
        AppButton(
          label: L.devices.commandsPickApplication,
          compact: true,
          variant: AppButtonVariant.secondary,
          icon: LucideIcons.package,
          onPressed: _sending ? null : () => unawaited(_pickApplication(key)),
        ),
      ],
    );
  }

  Widget _targetLabel(BuildContext context) {
    final text = switch ((_bulk, _deviceIds.isEmpty)) {
      (true, true) => L.devices.commandsNoDeviceSelected,
      (true, false) => L.devices.commandsDevicesSelected.trParams({
        'count': '${_deviceIds.length}',
      }),
      (false, true) => L.devices.commandsNoDeviceSelected,
      (false, false) => _labels[_deviceIds.first] ?? '#${_deviceIds.first}',
    };

    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppText.body(context),
    );
  }

  Widget _responseNote(BuildContext context) {
    return Text(
      L.devices.commandsResponseNote,
      style: AppText.caption(context),
    );
  }
}
