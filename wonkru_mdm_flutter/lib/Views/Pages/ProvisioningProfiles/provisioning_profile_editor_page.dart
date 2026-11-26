import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../Core/Constants/Enums/alert_enums.dart';
import '../../../Core/Errors/server_error_message.dart';
import '../../../Core/L10n/L.dart';
import '../../../Core/Theme/design.dart';
import '../../../Logic/Controllers/provisioning_profiles_controller.dart';
import '../../Widgets/Alert/app_toast.dart';
import '../../Widgets/Button/app_button.dart';
import '../../Widgets/Button/app_icon_button.dart';
import '../../Widgets/Card/section_card.dart';
import '../../Widgets/EmptyState/error_panel.dart';
import '../../Widgets/Input/custom_text_field.dart';
import '../../Widgets/Input/text_controllers_owner.dart';
import '../../Widgets/Loading/app_loader.dart';
import '../../Widgets/Page/page_header.dart';
import '../../Widgets/Switch/ui_switch.dart';
import 'Widgets/provisioning_config.dart';
import 'Widgets/provisioning_config_fields.dart';
import 'Widgets/provisioning_qr_preview.dart';
import 'Widgets/provisioning_wifi_config.dart';
import 'Widgets/provisioning_wifi_fields.dart';

class ProvisioningProfileEditorPage extends StatefulWidget {
  const ProvisioningProfileEditorPage({super.key, this.profileId});

  final int? profileId;

  @override
  State<ProvisioningProfileEditorPage> createState() =>
      _ProvisioningProfileEditorPageState();
}

class _ProvisioningProfileEditorPageState
    extends State<ProvisioningProfileEditorPage>
    with TextControllersOwner<ProvisioningProfileEditorPage> {
  late final ProvisioningProfilesController _profiles =
      Get.find<ProvisioningProfilesController>();

  late final _name = textController();
  late final _description = textController();
  late final _raw = textController();

  ProvisioningConfig _config = ProvisioningConfig.defaults;

  ProvisioningProfile? _profile;
  bool _isActive = true;

  bool _loading = false;
  bool _saving = false;
  bool _fillingDefault = false;

  String? _loadError;
  String? _jsonError;
  String? _qrPayload;

  bool _syncingRaw = false;

  bool get _isEditing => widget.profileId != null;
  bool get _canLoadDefaultTemplate =>
      _raw.text.trim().isEmpty ||
      (!_isEditing &&
          _config.apkUrl.isEmpty &&
          ProvisioningConfig.wifiFrom(_raw.text).hasNetwork);

  @override
  void initState() {
    super.initState();
    _raw.addListener(_onRawChanged);
    if (_isEditing) _load();
  }

  @override
  void dispose() {
    _raw.removeListener(_onRawChanged);
    super.dispose();
  }

  void _onRawChanged() {
    if (_syncingRaw) return;
    _applyRaw();
  }

  void _applyRaw() {
    final raw = _raw.text;
    final parsed = ProvisioningConfig.tryParse(raw);
    final error = ProvisioningConfig.validate(raw);
    if (parsed == null) {
      setState(() {
        _jsonError = error;
        _qrPayload = null;
      });
      return;
    }
    setState(() {
      _config = parsed;
      _jsonError = error;
      _qrPayload = error == null
          ? ProvisioningConfig.canonicalPayload(raw)
          : null;
    });
  }

  void _onFieldsChanged(ProvisioningConfig updated) =>
      _replaceRaw(updated.toJson(baseJson: _raw.text));

  void _onWifiChanged(ProvisioningWifiConfig wifi) {
    _replaceRaw(
      ProvisioningConfig.withWifi(_raw.text, wifi) ??
          ProvisioningConfig.withWifi(_config.toJson(), wifi)!,
    );
  }

  void _replaceRaw(String json) {
    _syncingRaw = true;
    _raw.text = json;
    _syncingRaw = false;
    _applyRaw();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final profile = await _profiles.getProfile(widget.profileId!);
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _name.text = profile.name;
        _description.text = profile.description ?? '';
        _isActive = profile.isActive;
        _loading = false;
      });
      _loadRawConfig(profile.config);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadError = serverErrorMessage(e);
        _loading = false;
      });
    }
  }

  void _loadRawConfig(String raw) {
    _replaceRaw(ProvisioningConfig.formattedJson(raw) ?? raw);
  }

  Future<void> _fillDefaultConfig() async {
    setState(() => _fillingDefault = true);
    try {
      final fetched = await _profiles.defaultConfig();
      if (!mounted) return;
      _loadRawConfig(ProvisioningConfig.templateWithWifi(fetched, _raw.text));
    } catch (e) {
      AppToast.show(
        L.provisioning.templateLoadFailed.trParams({
          'error': serverErrorMessage(e),
        }),
        tone: UiAlertTone.danger,
      );
    } finally {
      if (mounted) setState(() => _fillingDefault = false);
    }
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      AppToast.show(L.provisioning.nameRequired, tone: UiAlertTone.warning);
      return;
    }

    final configError = ProvisioningConfig.validate(_raw.text);
    if (configError != null) {
      setState(() => _jsonError = configError);
      AppToast.show(configError, tone: UiAlertTone.warning);
      return;
    }

    final description = _description.text.trim();
    final config = ProvisioningConfig.formattedJson(_raw.text)!;
    final base = _profile;

    setState(() => _saving = true);
    try {
      final value = base == null
          ? ProvisioningProfile(
              name: name,
              description: description.isEmpty ? null : description,
              config: config,
              isActive: _isActive,
            )
          : base.copyWith(
              name: name,
              description: description.isEmpty ? null : description,
              config: config,
              isActive: _isActive,
            );

      await _profiles.saveProfile(value);

      if (!mounted) return;
      AppToast.show(
        _isEditing
            ? L.provisioning.profileUpdated
            : L.provisioning.profileCreated,
        tone: UiAlertTone.success,
      );
      context.back();
    } catch (e) {
      AppToast.show(
        L.common.saveFailed.trParams({'error': serverErrorMessage(e)}),
        tone: UiAlertTone.danger,
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: AppLoader(size: 26));
    }
    if (_loadError != null) {
      return ErrorPanel(message: _loadError!, onRetry: _load);
    }

    return Column(
      children: [
        PageHeader(
          leading: AppIconButton.back(context),
          title: _name.text.trim().isEmpty
              ? L.provisioning.newProfile
              : _name.text.trim(),
          subtitle: _isEditing ? L.provisioning.editorSubtitle : null,
          actions: [
            AppButton(
              label: L.common.save,
              compact: true,
              icon: LucideIcons.save,
              loading: _saving,
              onPressed: _save,
            ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: AppInsets.all20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SectionCard(
                  title: L.common.general,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: AppSpacing.s12,
                    children: [
                      CustomTextField(
                        name: 'provisioning_profile_name',
                        controller: _name,
                        label: L.common.name,
                        hint: L.provisioning.nameHint,
                        showValidationError: false,
                      ),
                      CustomTextField(
                        name: 'provisioning_profile_description',
                        controller: _description,
                        label: L.common.description,
                        hint: L.common.optional,
                        maxLines: 3,
                        showValidationError: false,
                      ),
                      UiSwitch(
                        title: L.common.active,
                        value: _isActive,
                        onChanged: (value) => setState(() => _isActive = value),
                      ),
                    ],
                  ),
                ),
                AppGap.v16,
                SectionCard(
                  title: L.provisioning.configSection,
                  trailing: AppButton(
                    label: L.provisioning.loadDefaultTemplate,
                    compact: true,
                    icon: LucideIcons.sparkles,
                    loading: _fillingDefault,
                    onPressed: _canLoadDefaultTemplate
                        ? _fillDefaultConfig
                        : null,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final wide = constraints.maxWidth >= 880;
                      final fields = Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: AppSpacing.s16,
                        children: [
                          ProvisioningWifiFields(
                            value: ProvisioningConfig.wifiFrom(_raw.text),
                            onChanged: _onWifiChanged,
                          ),
                          ProvisioningConfigFields(
                            value: _config,
                            onChanged: _onFieldsChanged,
                          ),
                        ],
                      );
                      final qr = ProvisioningQrPreview(payload: _qrPayload);
                      final raw = _rawJsonField(context);

                      if (!wide) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: AppSpacing.s20,
                          children: [fields, qr, raw],
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 3, child: fields),
                              AppGap.h20,
                              Expanded(flex: 2, child: qr),
                            ],
                          ),
                          AppGap.v20,
                          raw,
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _rawJsonField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(L.provisioning.rawJson, style: AppText.columnHeader(context)),
        AppGap.v6,
        CustomTextField(
          name: 'provisioning_profile_config',
          controller: _raw,
          hint: '{ ... }',
          maxLines: 14,
          keyboardType: TextInputType.multiline,
          showValidationError: false,
        ),
        if (_jsonError != null) ...[
          AppGap.v6,
          Text(
            _jsonError!,
            style: AppText.caption(
              context,
              size: 12,
            ).copyWith(color: context.appColors.madder),
          ),
        ] else ...[
          AppGap.v6,
          Text(
            L.provisioning.rawHelp,
            style: AppText.caption(context, size: 11),
          ),
        ],
      ],
    );
  }
}
