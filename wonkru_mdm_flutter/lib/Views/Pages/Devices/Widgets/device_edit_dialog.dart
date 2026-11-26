import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../Widgets/Button/app_button.dart';
import '../../../Widgets/Dialog/app_dialog_shell.dart';
import '../../../Widgets/Input/app_dropdown.dart';
import '../../../Widgets/Input/string_list_field.dart';
import '../../../Widgets/Input/text_controllers_owner.dart';

Future<AdminDeviceUpdateRequest?> showDeviceEditDialog(
  BuildContext context, {
  required Device device,
  required List<Policy> policies,
  required List<DeviceGroupRow> groups,
  required List<int> groupIds,
  List<AdminUserRow> users = const [],
}) {
  return showDialog<AdminDeviceUpdateRequest>(
    context: context,
    builder: (_) => _DeviceEditDialog(
      device: device,
      policies: policies,
      groups: groups,
      groupIds: groupIds,
      users: users,
    ),
  );
}

List<String> _parseStringList(String? raw) {
  if (raw == null || raw.trim().isEmpty) return const [];
  try {
    final decoded = jsonDecode(raw);
    if (decoded is List) {
      return [
        for (final item in decoded)
          if (item != null && '$item'.trim().isNotEmpty) '$item'.trim(),
      ];
    }
  } on FormatException {
    // Corrupt record; start editing with an empty list.
  }
  return const [];
}

class _DeviceEditDialog extends StatefulWidget {
  const _DeviceEditDialog({
    required this.device,
    required this.policies,
    required this.groups,
    required this.groupIds,
    required this.users,
  });

  final Device device;
  final List<Policy> policies;
  final List<DeviceGroupRow> groups;
  final List<int> groupIds;
  final List<AdminUserRow> users;

  @override
  State<_DeviceEditDialog> createState() => _DeviceEditDialogState();
}

class _DeviceEditDialogState extends State<_DeviceEditDialog>
    with TextControllersOwner<_DeviceEditDialog> {
  static const _noPolicy = 'none';
  static const _noUser = 'none';

  late final _name = textController(widget.device.name ?? '');
  late final _code = textController(widget.device.code);
  late String _policy = widget.device.policyId?.toString() ?? _noPolicy;
  late String _user = widget.device.userId?.toString() ?? _noUser;
  late List<String> _mustUse = _parseStringList(
    widget.device.mustUseApplications,
  );
  late final Set<int> _groups = widget.groupIds.toSet();

  String _userLabel(AdminUserRow user) {
    final name = user.name?.trim();
    if (name != null && name.isNotEmpty) return name;
    final email = user.email?.trim();
    if (email != null && email.isNotEmpty) return email;
    return user.authUserId.toString();
  }

  void _save() {
    final name = _name.text.trim();
    final code = _code.text.trim();
    Navigator.pop(
      context,
      AdminDeviceUpdateRequest(
        deviceId: widget.device.id!,
        name: name.isEmpty ? null : name,
        code: code.isEmpty ? null : code,
        policyId: _policy == _noPolicy ? null : int.tryParse(_policy),
        userId: _user == _noUser ? null : UuidValue.fromString(_user),
        mustUseApplications: jsonEncode(_mustUse),
        deviceGroupIds: _groups.toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppDialogShell(
      title: L.devices.editTitle,
      maxWidth: 560,
      actions: [
        AppButton.cancel(context),
        AppButton(label: L.common.save, onPressed: _save),
      ],
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 460),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _name,
                decoration: InputDecoration(labelText: L.common.name),
              ),
              AppGap.v12,
              TextField(
                controller: _code,
                decoration: InputDecoration(labelText: L.common.code),
              ),
              AppGap.v12,
              AppDropdown<String>(
                label: L.common.policy,
                value: _policy,
                items: {
                  _noPolicy: L.devices.defaultPolicy,
                  for (final policy in widget.policies)
                    '${policy.id}': policy.name,
                },
                onChanged: (value) =>
                    setState(() => _policy = value ?? _noPolicy),
              ),
              AppGap.v12,
              AppDropdown<String>(
                label: L.devices.assignedUser,
                value: _user,
                items: {
                  _noUser: L.common.none,
                  for (final user in widget.users)
                    user.authUserId.toString(): _userLabel(user),
                },
                onChanged: (value) => setState(() => _user = value ?? _noUser),
              ),
              AppGap.v16,
              StringListField(
                name: 'device_must_use_applications',
                label: L.devices.mandatoryApps,
                values: _mustUse,
                hint: L.devices.mandatoryAppsHint,
                emptyText: L.devices.noMandatoryApps,
                addLabel: L.devices.addApplication,
                onChanged: (values) => _mustUse = values,
              ),
              AppGap.v16,
              Text(
                L.common.groups,
                style: AppText.caption(
                  context,
                  size: 12,
                ).copyWith(fontWeight: FontWeight.w500),
              ),
              AppGap.v6,
              if (widget.groups.isEmpty)
                Text(
                  L.devices.noGroupsDefined,
                  style: AppText.bodyMuted(context),
                )
              else
                for (final row in widget.groups)
                  Row(
                    children: [
                      Checkbox(
                        value: _groups.contains(row.group.id),
                        visualDensity: VisualDensity.compact,
                        onChanged: (checked) {
                          final id = row.group.id;
                          if (id == null) return;
                          setState(
                            () => checked == true
                                ? _groups.add(id)
                                : _groups.remove(id),
                          );
                        },
                      ),
                      Expanded(
                        child: Text(
                          row.group.name,
                          style: AppText.body(context),
                        ),
                      ),
                    ],
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
