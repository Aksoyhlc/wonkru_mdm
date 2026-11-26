import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../../../Core/L10n/L.dart';
import '../../../../../../Core/Theme/design.dart';
import '../../../../../../Logic/Controllers/policy_editor_controller.dart';
import '../../../../../Widgets/Button/app_button.dart';
import '../../../../../Widgets/Dialog/app_dialog_shell.dart';
import '../../../../../Widgets/Input/app_dropdown.dart';
import '../../../../../Widgets/Input/custom_text_field.dart';
import '../../../../../Widgets/Input/text_controllers_owner.dart';
import '../../../../../Widgets/Switch/ui_switch.dart';
import '../application_version_selection.dart';

class PolicyApplicationDialog extends StatefulWidget {
  const PolicyApplicationDialog({
    super.key,
    required this.controller,
    required this.policyId,
    required this.applicationId,
    required this.applicationLabel,
    this.entry,
  });

  final PolicyEditorController controller;
  final int policyId;
  final int applicationId;
  final String applicationLabel;
  final PolicyApplication? entry;

  @override
  State<PolicyApplicationDialog> createState() =>
      _PolicyApplicationDialogState();
}

class _PolicyApplicationDialogState extends State<PolicyApplicationDialog>
    with TextControllersOwner<PolicyApplicationDialog> {
  static const _actions = <PolicyApplicationAction, String>{
    PolicyApplicationAction.install: 'policies.action_install',
    PolicyApplicationAction.remove: 'common.remove',
    PolicyApplicationAction.configure: 'policies.action_configure',
  };

  static const _updatePolicies = <AppAutoUpdatePolicy, String>{
    AppAutoUpdatePolicy.always: 'policies.update_always',
    AppAutoUpdatePolicy.wifi_only: 'policies.update_wifi_only',
    AppAutoUpdatePolicy.never: 'policies.update_never',
  };

  Map<K, String> _translated<K>(Map<K, String> keys) => {
    for (final entry in keys.entries) entry.key: entry.value.tr,
  };

  late PolicyApplicationAction _action =
      widget.entry?.action ?? PolicyApplicationAction.install;
  late bool _showLauncher = widget.entry?.showLauncher ?? true;
  late bool _runOnBoot = widget.entry?.runOnBoot ?? false;
  late bool _startAfterInstall = widget.entry?.startAfterInstall ?? false;
  late bool _uninstallBlock = widget.entry?.uninstallBlock ?? false;

  late AppAutoUpdatePolicy _updatePolicy =
      widget.entry?.updatePolicy ?? AppAutoUpdatePolicy.always;

  late final _customAppName = textController(widget.entry?.customAppName ?? '');

  List<ApplicationVersion> _versions = const <ApplicationVersion>[];
  bool _loadingVersions = true;
  int? _targetVersionId;

  bool get _isEdit => widget.entry != null;

  @override
  void initState() {
    super.initState();
    _targetVersionId = widget.entry?.targetVersionId;
    _loadVersions();
  }

  Future<void> _loadVersions() async {
    try {
      final versions = await widget.controller.applicationVersions(
        widget.applicationId,
      );
      if (!mounted) return;
      final active = [
        for (final version in versions)
          if (version.isActive) version,
      ];
      final pool = active.isEmpty ? versions : active;
      setState(() {
        _versions = pool;
        _loadingVersions = false;
        _targetVersionId ??= selectDefaultApplicationVersion(pool)?.id;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingVersions = false);
    }
  }

  Map<int, String> get _versionItems {
    final items = <int, String>{
      for (final version in _versions)
        if (version.id != null)
          version.id!:
              '${version.versionName} (${version.versionCode})'
              '${version.isDefault ? ' - ${L.policies.isDefault}' : ''}',
    };
    final selected = _targetVersionId;
    if (selected != null && !items.containsKey(selected)) {
      items[selected] = '#$selected';
    }
    if (items.isEmpty) {
      items[-1] = L.policies.noVersion;
    }
    return items;
  }

  int get _versionDropdownValue {
    final selected = _targetVersionId;
    if (selected != null && _versionItems.containsKey(selected)) {
      return selected;
    }
    return _versionItems.keys.first;
  }

  String? _nullIfEmpty(String value) {
    final text = value.trim();
    return text.isEmpty ? null : text;
  }

  void _submit() {
    final base = widget.entry;
    final customAppName = _nullIfEmpty(_customAppName.text);

    final value = base == null
        ? PolicyApplication(
            policyId: widget.policyId,
            applicationId: widget.applicationId,
            action: _action,
            showLauncher: _showLauncher,
            runOnBoot: _runOnBoot,
            startAfterInstall: _startAfterInstall,
            uninstallBlock: _uninstallBlock,
            targetVersionId: _targetVersionId,
            customAppName: customAppName,
            updatePolicy: _updatePolicy,
          )
        : base.copyWith(
            action: _action,
            showLauncher: _showLauncher,
            runOnBoot: _runOnBoot,
            startAfterInstall: _startAfterInstall,
            uninstallBlock: _uninstallBlock,
            targetVersionId: _targetVersionId,
            customAppName: customAppName,
            updatePolicy: _updatePolicy,
          );

    Navigator.pop(context, value);
  }

  @override
  Widget build(BuildContext context) {
    return AppDialogShell(
      title: _isEdit ? L.policies.editApplication : L.policies.addApplication,
      maxWidth: 620,
      actions: [
        AppButton.cancel(context),
        AppButton(
          label: _isEdit ? L.common.save : L.common.add,
          onPressed: _submit,
        ),
      ],
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 520),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.applicationLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.sectionTitle(context).copyWith(fontSize: 14),
              ),
              AppGap.v12,
              AppDropdown<PolicyApplicationAction>(
                label: L.policies.action,
                value: _action,
                items: _translated(_actions),
                onChanged: (value) =>
                    setState(() => _action = value ?? _action),
              ),
              AppGap.v12,
              Wrap(
                spacing: 20,
                runSpacing: 4,
                children: [
                  UiSwitch(
                    title: L.policies.showInLauncher,
                    value: _showLauncher,
                    onChanged: (value) => setState(() => _showLauncher = value),
                  ),
                  UiSwitch(
                    title: L.policies.runOnBoot,
                    value: _runOnBoot,
                    onChanged: (value) => setState(() => _runOnBoot = value),
                  ),
                  UiSwitch(
                    title: L.policies.uninstallBlock,
                    value: _uninstallBlock,
                    onChanged: (value) =>
                        setState(() => _uninstallBlock = value),
                  ),
                  if (_action == PolicyApplicationAction.install)
                    UiSwitch(
                      title: L.policies.startAfterInstall,
                      value: _startAfterInstall,
                      onChanged: (value) =>
                          setState(() => _startAfterInstall = value),
                    ),
                ],
              ),
              AppGap.v12,
              if (_loadingVersions)
                Text(
                  L.policies.loadingVersions,
                  style: AppText.caption(context, size: 12),
                )
              else
                AppDropdown<int>(
                  label: L.policies.targetVersion,
                  value: _versionDropdownValue,
                  items: _versionItems,
                  onChanged: (value) => setState(() {
                    _targetVersionId = (value == null || value < 0)
                        ? null
                        : value;
                  }),
                ),
              AppGap.v12,
              CustomTextField(
                name: 'policy.application.customAppName',
                controller: _customAppName,
                label: L.policies.customAppName,
                showValidationError: false,
              ),
              AppGap.v12,
              AppDropdown<AppAutoUpdatePolicy>(
                label: L.policies.updatePolicy,
                value: _updatePolicy,
                items: _translated(_updatePolicies),
                onChanged: (value) => setState(
                  () => _updatePolicy = value ?? AppAutoUpdatePolicy.always,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
