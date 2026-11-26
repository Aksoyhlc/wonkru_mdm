import 'package:flutter/material.dart';

import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../Widgets/Input/custom_text_field.dart';
import 'provisioning_config.dart';

class ProvisioningConfigFields extends StatefulWidget {
  const ProvisioningConfigFields({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final ProvisioningConfig value;
  final ValueChanged<ProvisioningConfig> onChanged;

  @override
  State<ProvisioningConfigFields> createState() =>
      _ProvisioningConfigFieldsState();
}

class _ProvisioningConfigFieldsState extends State<ProvisioningConfigFields> {
  late final TextEditingController _componentName;
  late final TextEditingController _apkUrl;
  late final TextEditingController _signatureChecksum;
  late final TextEditingController _packageChecksum;
  late final TextEditingController _timeZone;
  late final TextEditingController _locale;
  late final TextEditingController _organization;
  late final TextEditingController _serverUrl;
  late final TextEditingController _deviceCode;

  bool _syncing = false;

  List<TextEditingController> get _controllers => [
    _componentName,
    _apkUrl,
    _signatureChecksum,
    _packageChecksum,
    _timeZone,
    _locale,
    _organization,
    _serverUrl,
    _deviceCode,
  ];

  @override
  void initState() {
    super.initState();
    final v = widget.value;
    _componentName = _controller(v.componentName);
    _apkUrl = _controller(v.apkUrl);
    _signatureChecksum = _controller(v.signatureChecksum);
    _packageChecksum = _controller(v.packageChecksum);
    _timeZone = _controller(v.timeZone);
    _locale = _controller(v.locale);
    _organization = _controller(v.organization);
    _serverUrl = _controller(v.serverUrl);
    _deviceCode = _controller(v.deviceCode);
  }

  TextEditingController _controller(String text) {
    final controller = TextEditingController(text: text);
    controller.addListener(_emit);
    return controller;
  }

  @override
  void didUpdateWidget(covariant ProvisioningConfigFields oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync(widget.value);
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.removeListener(_emit);
      controller.dispose();
    }
    super.dispose();
  }

  void _emit() {
    if (_syncing) return;
    widget.onChanged(
      ProvisioningConfig(
        componentName: _componentName.text,
        apkUrl: _apkUrl.text,
        signatureChecksum: _signatureChecksum.text,
        packageChecksum: _packageChecksum.text,
        timeZone: _timeZone.text,
        locale: _locale.text,
        organization: _organization.text,
        serverUrl: _serverUrl.text,
        deviceCode: _deviceCode.text,
        enrollmentKey: widget.value.enrollmentKey,
      ),
    );
  }

  void _sync(ProvisioningConfig value) {
    _syncing = true;
    _set(_componentName, value.componentName);
    _set(_apkUrl, value.apkUrl);
    _set(_signatureChecksum, value.signatureChecksum);
    _set(_packageChecksum, value.packageChecksum);
    _set(_timeZone, value.timeZone);
    _set(_locale, value.locale);
    _set(_organization, value.organization);
    _set(_serverUrl, value.serverUrl);
    _set(_deviceCode, value.deviceCode);
    _syncing = false;
  }

  void _set(TextEditingController controller, String text) {
    if (controller.text != text) {
      controller.text = text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 520;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _sectionTitle(context, L.provisioning.configuredFields),
            AppGap.v10,
            _pair(
              wide,
              _field(
                name: 'provisioning_component_name',
                controller: _componentName,
                label: L.provisioning.fieldAdminComponent,
              ),
              _field(
                name: 'provisioning_apk_url',
                controller: _apkUrl,
                label: L.provisioning.fieldApkUrl,
                hint: 'https://cdn.wonkru.com/agent.apk',
                keyboardType: TextInputType.url,
              ),
            ),
            AppGap.v10,
            _field(
              name: 'provisioning_signature_checksum',
              controller: _signatureChecksum,
              label: L.provisioning.fieldSignatureChecksum,
              hint: L.provisioning.fieldSignatureChecksumHint,
            ),
            AppGap.v10,
            _field(
              name: 'provisioning_package_checksum',
              controller: _packageChecksum,
              label: L.provisioning.fieldPackageChecksum,
            ),
            AppGap.v10,
            _pair(
              wide,
              _field(
                name: 'provisioning_time_zone',
                controller: _timeZone,
                label: L.provisioning.fieldTimeZone,
              ),
              _field(
                name: 'provisioning_locale',
                controller: _locale,
                label: L.provisioning.fieldLocale,
              ),
            ),
            AppGap.v10,
            _field(
              name: 'provisioning_organization',
              controller: _organization,
              label: L.provisioning.fieldOrganization,
            ),
            AppGap.v16,
            Divider(color: context.appColors.border, height: 1),
            AppGap.v14,
            _sectionTitle(context, L.provisioning.bundleFields),
            AppGap.v10,
            _field(
              name: 'provisioning_server_url',
              controller: _serverUrl,
              label: L.provisioning.fieldServerUrl,
              hint: 'https://mdm.wonkru.com',
              keyboardType: TextInputType.url,
            ),
            AppGap.v10,
            _field(
              name: 'provisioning_device_code',
              controller: _deviceCode,
              label: L.provisioning.fieldDeviceCode,
            ),
          ],
        );
      },
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    return Text(text, style: AppText.columnHeader(context));
  }

  Widget _field({
    required String name,
    required TextEditingController controller,
    required String label,
    String? hint,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return CustomTextField(
      name: name,
      controller: controller,
      label: label,
      hint: hint,
      dense: true,
      obscureText: obscureText,
      keyboardType: keyboardType,
      showValidationError: false,
    );
  }

  Widget _pair(bool wide, Widget left, Widget right) {
    if (!wide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [left, AppGap.v10, right],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        AppGap.h12,
        Expanded(child: right),
      ],
    );
  }
}
