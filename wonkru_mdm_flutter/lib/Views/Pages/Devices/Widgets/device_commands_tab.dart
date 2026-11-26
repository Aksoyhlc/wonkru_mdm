import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/Constants/Enums/device_action.dart';
import '../../../../Core/Constants/Enums/dialog_enums.dart';
import '../../../../Core/Extensions/datetime.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../../Logic/Controllers/device_detail_commands_controller.dart';
import '../../../Widgets/Button/app_button.dart';
import '../../../Widgets/Dialog/app_dialog_shell.dart';
import '../../../Widgets/Table/app_data_table.dart';
import '../../../Widgets/Table/table_column.dart';
import 'device_command_response_view.dart';
import 'device_command_status_badge.dart';

class DeviceCommandsTab extends StatefulWidget {
  const DeviceCommandsTab({super.key, required this.deviceId});

  final int deviceId;

  @override
  State<DeviceCommandsTab> createState() => _DeviceCommandsTabState();
}

class _DeviceCommandsTabState extends State<DeviceCommandsTab> {
  late final DeviceDetailCommandsController _controller =
      DeviceDetailCommandsController(widget.deviceId);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppDataTable<DeviceCommand>(
      controller: _controller,
      columns: _columns(context),
      showSearch: false,
      onRowTap: _showResponse,
      emptyTitle: L.devices.noCommands,
      emptySubtitle: L.devices.noCommandsSubtitle,
    );
  }

  List<AppColumn<DeviceCommand>> _columns(BuildContext context) {
    return [
      AppColumn<DeviceCommand>(
        title: L.devices.commandsAction,
        width: 170,
        cell: (command) => _text(context, command.action.label),
      ),
      AppColumn<DeviceCommand>(
        title: L.common.status,
        width: 120,
        cell: (command) => _badge(context, command.status),
      ),
      AppColumn<DeviceCommand>(
        title: L.devices.response,
        width: 240,
        cell: (command) => _text(context, _responseLabel(command), tone: true),
      ),
      AppColumn<DeviceCommand>(
        title: L.devices.createdAt,
        width: 150,
        cell: (command) => _text(context, _moment(command.createdAt)),
      ),
      AppColumn<DeviceCommand>(
        title: L.devices.sentAt,
        width: 150,
        cell: (command) => _text(context, _moment(command.sentAt)),
      ),
      AppColumn<DeviceCommand>(
        title: L.devices.ackedAt,
        width: 150,
        cell: (command) => _text(context, _moment(command.ackedAt)),
      ),
    ];
  }

  void _showResponse(DeviceCommand command) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AppDialogShell(
        title: L.devices.response,
        description: _moment(command.createdAt),
        size: AppDialogSize.lg,
        scrollable: true,
        actions: [
          AppButton(
            label: L.common.close,
            onPressed: () => Navigator.pop(dialogContext),
          ),
        ],
        child: DeviceCommandResponseView(
          command: command,
          title: command.action.label,
        ),
      ),
    );
  }

  Widget _badge(BuildContext context, DeviceCommandStatus status) {
    return Padding(
      padding: AppInsets.h10,
      child: Align(
        alignment: Alignment.centerLeft,
        child: DeviceCommandStatusBadge(status: status),
      ),
    );
  }

  Widget _text(BuildContext context, String value, {bool tone = false}) {
    return Padding(
      padding: AppInsets.h10,
      child: Text(
        value,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: tone ? AppText.bodyMuted(context) : AppText.body(context),
      ),
    );
  }

  static String _responseLabel(DeviceCommand command) {
    final raw = command.response?.trim();
    if (raw == null || raw.isEmpty) {
      return '—';
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map) {
        final message = command.action.localizeResultMessage(
          decoded['message']?.toString(),
        );
        if (message != null) return message;
        return decoded.entries
            .map((entry) => '${entry.key}: ${entry.value}')
            .join(', ');
      }
      if (decoded is List) {
        return decoded.join(', ');
      }
    } on FormatException {
      // Not JSON; show the raw text.
    }

    return command.action.localizeResultMessage(raw) ?? raw;
  }

  static String _moment(DateTime? moment) =>
      moment?.formatDateTime('dd.MM.yyyy HH:mm:ss') ?? '—';
}
