import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../Core/Constants/Enums/pivot_enums.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../Widgets/Badge/status_badge.dart';
import '../../../Widgets/Button/app_button.dart';
import '../../../Widgets/Dialog/app_dialog_shell.dart';
import '../../../Widgets/Input/text_controllers_owner.dart';
import '../../../Widgets/Search/app_search_field.dart';
import '../../../Widgets/Switch/ui_segmented_switch.dart';
import 'policy_pivot_option.dart';

export 'policy_pivot_option.dart';

/// Filters [options] by system/installable; when a specific filter is active,
/// options whose metadata is `null` are excluded.
List<PolicyPivotOption> filterPivotOptions(
  List<PolicyPivotOption> options, {
  PivotSystemFilter system = PivotSystemFilter.all,
  PivotInstallableFilter installable = PivotInstallableFilter.all,
}) {
  return [
    for (final option in options)
      if (_matchesSystem(option, system) &&
          _matchesInstallable(option, installable))
        option,
  ];
}

bool _matchesSystem(PolicyPivotOption option, PivotSystemFilter filter) {
  return switch (filter) {
    PivotSystemFilter.all => true,
    PivotSystemFilter.system => option.isSystemApp == true,
    PivotSystemFilter.user => option.isSystemApp == false,
  };
}

bool _matchesInstallable(
  PolicyPivotOption option,
  PivotInstallableFilter filter,
) {
  return switch (filter) {
    PivotInstallableFilter.all => true,
    PivotInstallableFilter.installable => option.hasVersions == true,
    PivotInstallableFilter.notInstallable => option.hasVersions == false,
  };
}

/// Drops ids already attached to the policy: the `(policyId, id)` unique index
/// would otherwise fail with a unique violation on the server.
List<PolicyPivotOption> availablePivotOptions(
  List<PolicyPivotOption> options,
  Set<int> attachedIds,
) {
  if (attachedIds.isEmpty) return options;
  return [
    for (final option in options)
      if (!attachedIds.contains(option.id)) option,
  ];
}

Future<int?> showPolicyPivotPicker({
  required BuildContext context,
  required String title,
  required List<PolicyPivotOption> options,
  bool showApplicationFilters = false,
}) {
  return showDialog<int>(
    context: context,
    builder: (_) => _PolicyPivotPickerDialog(
      title: title,
      options: options,
      showApplicationFilters: showApplicationFilters,
    ),
  );
}

class _PolicyPivotPickerDialog extends StatefulWidget {
  const _PolicyPivotPickerDialog({
    required this.title,
    required this.options,
    this.showApplicationFilters = false,
  });

  final String title;
  final List<PolicyPivotOption> options;
  final bool showApplicationFilters;

  @override
  State<_PolicyPivotPickerDialog> createState() =>
      _PolicyPivotPickerDialogState();
}

class _PolicyPivotPickerDialogState extends State<_PolicyPivotPickerDialog>
    with TextControllersOwner<_PolicyPivotPickerDialog> {
  late final _search = textController();
  String _query = '';
  PivotSystemFilter _system = PivotSystemFilter.all;
  PivotInstallableFilter _installable = PivotInstallableFilter.all;

  List<PolicyPivotOption> get _filtered {
    final base = widget.showApplicationFilters
        ? filterPivotOptions(
            widget.options,
            system: _system,
            installable: _installable,
          )
        : widget.options;

    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return base;
    return [
      for (final option in base)
        if (option.label.toLowerCase().contains(query) ||
            (option.subtitle?.toLowerCase().contains(query) ?? false))
          option,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final options = _filtered;

    return AppDialogShell(
      title: widget.title,
      maxWidth: 560,
      actions: [
        AppButton.cancel(context),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSearchField(
            controller: _search,
            autofocus: true,
            showClear: true,
            hintText: L.common.search,
            onChanged: (value) => setState(() => _query = value),
          ),
          AppGap.v10,
          if (widget.showApplicationFilters) ...[
            UiSegmentedSwitch<PivotSystemFilter>(
              title: L.policies.filterSystemTitle,
              value: _system,
              items: {
                PivotSystemFilter.all: L.common.all,
                PivotSystemFilter.system: L.policies.filterSystemApps,
                PivotSystemFilter.user: L.policies.filterUserApps,
              },
              onChanged: (value) => setState(() => _system = value),
            ),
            UiSegmentedSwitch<PivotInstallableFilter>(
              title: L.policies.filterInstallableTitle,
              value: _installable,
              items: {
                PivotInstallableFilter.all: L.common.all,
                PivotInstallableFilter.installable: L.policies.installable,
                PivotInstallableFilter.notInstallable:
                    L.policies.notInstallable,
              },
              onChanged: (value) => setState(() => _installable = value),
            ),
            AppGap.v4,
          ],
          if (options.isEmpty)
            Padding(
              padding: AppInsets.v24,
              child: Text(
                L.policies.noRecords,
                textAlign: TextAlign.center,
                style: AppText.bodyMuted(context),
              ),
            )
          else
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 360),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final option in options)
                      _PickerItem(
                        option: option,
                        onTap: () => Navigator.pop(context, option.id),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PickerItem extends StatefulWidget {
  const _PickerItem({required this.option, required this.onTap});

  final PolicyPivotOption option;
  final VoidCallback onTap;

  @override
  State<_PickerItem> createState() => _PickerItemState();
}

class _PickerItemState extends State<_PickerItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final option = widget.option;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s10,
            vertical: AppSpacing.s8,
          ),
          decoration: BoxDecoration(
            color: _hovered ? colors.muted : null,
            borderRadius: BorderRadius.circular(AppRadius.r6),
          ),
          child: Row(
            children: [
              Icon(LucideIcons.circle, size: 8, color: colors.graphite),
              AppGap.h10,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      option.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.body(context),
                    ),
                    if (option.subtitle != null &&
                        option.subtitle!.isNotEmpty) ...[
                      AppGap.v2,
                      Text(
                        option.subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.cellSecondary(context),
                      ),
                    ],
                    if (option.isSystemApp != null ||
                        option.hasVersions != null) ...[
                      AppGap.v4,
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          if (option.isSystemApp == true)
                            StatusBadge(
                              label: L.policies.filterSystemApps,
                              tone: UiAlertTone.info,
                            ),
                          if (option.hasVersions != null)
                            StatusBadge(
                              label: option.hasVersions!
                                  ? L.policies.installable
                                  : L.policies.notInstallable,
                              tone: option.hasVersions!
                                  ? UiAlertTone.success
                                  : UiAlertTone.warning,
                            ),
                        ],
                      ),
                    ],
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
