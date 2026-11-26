import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../Core/Constants/Enums/alert_enums.dart';
import '../../../Core/Constants/Enums/button_enums.dart';
import '../../../Core/Constants/Enums/policy_enums.dart';
import '../../../Core/Errors/server_error_message.dart';
import '../../../Core/L10n/L.dart';
import '../../../Core/Logging/wlog.dart';
import '../../../Core/Router/app_routes.dart';
import '../../../Core/Theme/design.dart';
import '../../../Core/Utils/slugify.dart';
import '../../../Logic/Controllers/policy_editor_controller.dart';
import '../../../Logic/UI/input_controller.dart';
import '../../Widgets/Alert/app_toast.dart';
import '../../Widgets/Button/app_button.dart';
import '../../Widgets/Button/app_icon_button.dart';
import '../../Widgets/Card/section_card.dart';
import '../../Widgets/EmptyState/error_panel.dart';
import '../../Widgets/Loading/app_loader.dart';
import '../../Widgets/Page/page_header.dart';
import 'Widgets/policy_applications_section/policy_applications_section.dart';
import 'Widgets/policy_certificates_section.dart';
import 'Widgets/policy_clone_dialog.dart';
import 'Widgets/policy_editor_tab_bar.dart';
import 'Widgets/policy_field_spec.dart';
import 'Widgets/policy_files_section/policy_files_section.dart';
import 'Widgets/policy_general_form.dart';
import 'Widgets/policy_load_warning_banner.dart';
import 'Widgets/policy_restriction_catalog.dart';
import 'Widgets/policy_restriction_tab_view.dart';
import 'Widgets/policy_settings_codec.dart';
import 'Widgets/policy_settings_tab_view.dart';
import 'Widgets/policy_settings_tabs/policy_settings_tabs.dart';

const _tag = 'PolicyEditorPage';

class PolicyEditorPage extends StatefulWidget {
  const PolicyEditorPage({super.key, this.policyId});

  final int? policyId;

  @override
  State<PolicyEditorPage> createState() => _PolicyEditorPageState();
}

class _PolicyEditorPageState extends State<PolicyEditorPage>
    with SingleTickerProviderStateMixin {
  late final PolicyEditorController _controller = PolicyEditorController(
    policyId: widget.policyId,
  );

  late final List<PolicySettingsTabSpec> _settingsTabs = widget.policyId == null
      ? <PolicySettingsTabSpec>[policyGeneralTab]
      : <PolicySettingsTabSpec>[policyGeneralTab, ...policySettingsTabs];

  late final List<String> _pivotTitles = widget.policyId == null
      ? const <String>[]
      : const <String>[
          'policies.applications',
          'policies.files',
          'policies.certificates',
        ];

  static const _generalFieldNames = <String>[
    'policy.name',
    'policy.slug',
    'policy.description',
    'policy.adminPassword',
    'policy.isActive',
    'policy.defaultPolicy',
  ];

  late final TabController _tabController = TabController(
    length: _settingsTabs.length + _pivotTitles.length,
    vsync: this,
  );

  Worker? _policyWorker;

  bool _slugAuto = true;

  List<String> _restrictionKeys = const <String>[];

  late final Set<String> _settingKeys = <String>{
    for (final tab in _settingsTabs)
      for (final group in tab.groups)
        for (final field in group.fields) 'policy.${field.path}',
  };

  @override
  void initState() {
    super.initState();
    _policyWorker = ever<Policy?>(_controller.policy, _fillForm);
    unawaited(_initialize());
  }

  /// The restriction catalog must load before the policy: `_fillForm` runs as
  /// soon as the policy arrives and expects the restriction keys to be ready.
  Future<void> _initialize() async {
    await _loadRestrictionKeys();
    if (!mounted) return;
    await _controller.load();
  }

  Future<void> _loadRestrictionKeys() async {
    try {
      final entries = await _controller.restrictionCatalog();
      if (!mounted) return;
      setState(() => _restrictionKeys = restrictionKeysInPanelOrder(entries));
    } catch (e, st) {
      WLog.e(_tag, 'restriction catalog load failed', error: e, stackTrace: st);
    }
  }

  Future<void> _retry() async {
    await _loadRestrictionKeys();
    if (!mounted) return;
    await _controller.load();
  }

  @override
  void dispose() {
    _policyWorker?.dispose();
    _tabController.dispose();
    InputController.to.removeDataControllers([
      ..._generalFieldNames,
      ..._settingKeys,
    ]);
    super.dispose();
  }

  Future<void> _fillForm(Policy? policy) async {
    if (policy == null) return;
    final input = InputController.to;
    input.setValue('policy.name', policy.name, markAsDirty: false);
    input.setValue('policy.slug', policy.slug ?? '', markAsDirty: false);
    _slugAuto = policy.slug == null || policy.slug!.trim().isEmpty;
    input.setValue(
      'policy.description',
      policy.description ?? '',
      markAsDirty: false,
    );
    input.setValue(
      'policy.isActive',
      policy.isActive.toString(),
      markAsDirty: false,
    );
    input.setValue(
      'policy.defaultPolicy',
      policy.defaultPolicy.toString(),
      markAsDirty: false,
    );

    final flat = flattenSettings(policy);
    for (final entry in flat.entries) {
      final key = 'policy.${entry.key}';
      _settingKeys.add(key);
      input.setValue(key, entry.value, markAsDirty: false);
    }

    // Resolved in the same state → cache → network order as saving, so a
    // catalog that arrives later still fills the stored selections instead of
    // silently resetting them to their defaults.
    final restrictionKeys = await resolveRestrictionKeys(
      _restrictionKeys,
      cached: () => _controller.cachedRestrictionCatalog,
      load: _controller.restrictionCatalog,
    );
    if (_restrictionKeys.isEmpty && restrictionKeys.isNotEmpty) {
      _restrictionKeys = restrictionKeys;
    }
    if (restrictionKeys.isEmpty) {
      WLog.d(_tag, 'restriction catalog unavailable while filling the form');
      return;
    }

    final restrictionFlat = restrictionSettingsToFlat(
      policy.restrictionSettings,
      restrictionKeys,
    );
    for (final entry in restrictionFlat.entries) {
      final key = 'policy.${entry.key}';
      _settingKeys.add(key);
      input.setValue(key, entry.value, markAsDirty: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final loading = _controller.loading.value;
      final error = _controller.error.value;
      final policy = _controller.policy.value;

      if (loading && policy == null) {
        return const Center(child: AppLoader(size: 26));
      }
      if (policy == null) {
        return ErrorPanel(
          message: error ?? L.policies.loadFailed,
          onRetry: _retry,
        );
      }

      return Column(
        children: [
          PageHeader(
            leading: AppIconButton.back(context),
            title: policy.name.isNotEmpty ? policy.name : L.policies.newPolicy,
            subtitle: policy.slug?.isNotEmpty == true ? policy.slug : null,
            actions: [
              if (widget.policyId != null)
                AppButton(
                  label: L.common.copy,
                  compact: true,
                  variant: AppButtonVariant.secondary,
                  icon: LucideIcons.copy,
                  onPressed: _controller.saving.value ? null : _duplicate,
                ),
              AppButton(
                label: L.common.save,
                compact: true,
                icon: LucideIcons.save,
                loading: _controller.saving.value,
                onPressed: _save,
              ),
            ],
          ),
          Expanded(
            child: Column(
              children: [
                PolicyEditorTabBar(
                  controller: _tabController,
                  settingsTabs: _settingsTabs,
                  pivotTitles: _pivotTitles,
                ),
                Expanded(
                  // Tabs deliberately do not change on horizontal drag: the
                  // gesture would switch tabs while panning a wide table.
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: [
                      for (var i = 0; i < _settingsTabs.length; i++)
                        _settingsTab(context, policy, i),
                      for (final section in _pivotSections())
                        _pivotTab(context, section),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _settingsTab(BuildContext context, Policy policy, int index) {
    final warning = _loadWarning;
    return SingleChildScrollView(
      padding: AppInsets.all20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (index == 0) ...[
            if (warning != null) ...[
              PolicyLoadWarningBanner(
                message: warning,
                onRetry: _controller.load,
              ),
              AppGap.v16,
            ],
            SectionCard(
              title: L.common.general,
              child: PolicyGeneralForm(
                policy: policy,
                creating: widget.policyId == null,
                onNameChanged: _onNameChanged,
                onSlugChanged: _onSlugChanged,
              ),
            ),
            AppGap.v16,
          ],
          if (_settingsTabs[index].id == 'restriction')
            PolicyRestrictionTabView(controller: _controller)
          else
            PolicySettingsTabView(spec: _settingsTabs[index]),
        ],
      ),
    );
  }

  Widget _pivotTab(BuildContext context, Widget section) {
    return SingleChildScrollView(
      padding: AppInsets.all20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [section],
      ),
    );
  }

  List<Widget> _pivotSections() {
    if (widget.policyId == null) {
      return const [];
    }

    return [
      PolicyApplicationsSection(controller: _controller),
      PolicyFilesSection(controller: _controller),
      PolicyCertificatesSection(controller: _controller),
    ];
  }

  String? get _loadWarning {
    final options = _controller.optionsError.value;
    final pivots = _controller.pivotsError.value;
    if (options == null && pivots == null) return null;

    final parts = <String>[
      if (options != null) L.policies.selectorsList,
      if (pivots != null) L.policies.pivotLists,
    ];
    return L.policies.loadWarning.trParams({
      'parts': parts.join(L.policies.and),
      'error': options ?? pivots ?? '',
    });
  }

  void _onNameChanged(String value) {
    if (!_slugAuto) return;
    InputController.to.setValue(
      'policy.slug',
      slugify(value),
      markAsDirty: false,
    );
  }

  void _onSlugChanged(String value) {
    if (value.isEmpty) {
      _slugAuto = true;
      return;
    }
    _slugAuto = value == slugify(InputController.to.getValue('policy.name'));
  }

  Future<void> _save() async {
    final input = InputController.to;
    final name = input.getValue('policy.name').trim();
    if (name.isEmpty) {
      AppToast.show(L.policies.nameRequired, tone: UiAlertTone.warning);
      return;
    }

    final slug = input.getValue('policy.slug').trim();
    final description = input.getValue('policy.description').trim();
    final adminPassword = input.getValue('policy.adminPassword').trim();
    if (widget.policyId == null && adminPassword.isEmpty) {
      AppToast.show(
        L.policies.adminPasswordRequired,
        tone: UiAlertTone.warning,
      );
      return;
    }
    final isActive = input.getValue('policy.isActive') == 'true';
    final defaultPolicy = input.getValue('policy.defaultPolicy') == 'true';

    final flat = <String, dynamic>{};
    num? clampedMax;
    for (final tab in _settingsTabs) {
      for (final group in tab.groups) {
        for (final field in group.fields) {
          // Shortcuts share keys with the restriction tab and are serialized
          // in the `restriction_settings` block below; adding them here too
          // would produce duplicate, corrupt JSON.
          if (field.type == PolicyFieldType.restrictionShortcut) continue;
          final key = 'policy.${field.path}';
          var value = input.getValue(key);
          final max = field.max;
          if (field.type == PolicyFieldType.number && max != null) {
            final parsed = num.tryParse(value);
            if (parsed != null && parsed > max) {
              value = max.toString();
              input.setValue(key, value);
              clampedMax ??= max;
            }
          }
          flat[field.path] = value;
        }
      }
    }
    if (clampedMax != null) {
      AppToast.show(
        L.policies.valueClampedToMax.trParams({'max': clampedMax.toString()}),
        tone: UiAlertTone.warning,
      );
    }

    final fields = policyFieldsByPath(_settingsTabs);
    if (policyRangeViolations(flat, fields.values).isNotEmpty) {
      AppToast.show(
        L.policies.brightnessRangeInvalid,
        tone: UiAlertTone.warning,
      );
      return;
    }

    // Restriction selections are serialized to a canonical-order
    // `{"restrictions":[...]}` JSON. If the catalog is truly unreachable the
    // restriction settings are left untouched rather than overwritten.
    final restrictionKeys = await resolveRestrictionKeys(
      _restrictionKeys,
      cached: () => _controller.cachedRestrictionCatalog,
      load: _controller.restrictionCatalog,
    );

    if (restrictionKeys.isEmpty) {
      AppToast.show(
        L.policies.restrictionSaveWarning,
        tone: UiAlertTone.warning,
      );
    } else {
      final restrictionFlat = <String, String>{
        for (final key in restrictionKeys)
          'restriction_settings.$key': input.getValue(
            'policy.restriction_settings.$key',
          ),
      };
      flat['restriction_settings'] = flatToRestrictionSettings(
        restrictionFlat,
        restrictionKeys,
      );
    }

    final base = _controller.policy.value ?? Policy(name: '');
    var value = applySettings(base, flat, fields: fields).copyWith(
      name: name,
      slug: slug.isEmpty ? null : slug,
      description: description.isEmpty ? null : description,
      isActive: isActive,
      defaultPolicy: defaultPolicy,
    );

    if (adminPassword.isNotEmpty) {
      value = value.copyWith(adminPassword: adminPassword);
    }

    try {
      await _controller.save(value);
      if (!mounted) return;

      final createdId = _controller.policy.value?.id;
      if (widget.policyId == null && createdId != null) {
        if (defaultPolicy) await _controller.setDefault();
        if (!mounted) return;
        AppToast.show(L.policies.created, tone: UiAlertTone.success);
        context.pushReplacement(AppRoutes.policy(createdId));
        return;
      }

      if (defaultPolicy) await _controller.setDefault();
      if (!mounted) return;
      AppToast.show(L.policies.updated, tone: UiAlertTone.success);
      await _controller.load();
    } on AdminPolicyValidationException catch (e) {
      AppToast.show(
        e.field == 'display_settings.min_brightness'
            ? L.policies.brightnessRangeInvalid
            : e.message,
        tone: UiAlertTone.danger,
      );
    } catch (e) {
      AppToast.show(
        L.common.saveFailed.trParams({'error': serverErrorMessage(e)}),
        tone: UiAlertTone.danger,
      );
    }
  }

  Future<void> _duplicate() async {
    final policy = _controller.policy.value;
    if (policy == null || policy.id == null) return;

    final name = await showPolicyCloneDialog(
      context,
      defaultName: policy.name,
    );
    if (name == null || !mounted) return;

    try {
      final copy = await _controller.duplicate(name);
      if (!mounted) return;
      AppToast.show(
        L.policies.copiedToast.trParams({'name': copy.name}),
        tone: UiAlertTone.success,
      );
      if (copy.id == null) return;
      context.pushReplacement(AppRoutes.policy(copy.id!));
    } catch (e) {
      if (!mounted) return;
      AppToast.show(
        L.policies.copyFailed.trParams({'error': serverErrorMessage(e)}),
        tone: UiAlertTone.danger,
      );
    }
  }
}
