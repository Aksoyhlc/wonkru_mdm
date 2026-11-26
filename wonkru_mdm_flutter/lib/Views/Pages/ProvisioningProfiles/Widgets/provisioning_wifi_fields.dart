import 'package:flutter/material.dart';

import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../Widgets/Input/app_dropdown.dart';
import '../../../Widgets/Input/custom_text_field.dart';
import '../../../Widgets/Input/text_controllers_owner.dart';
import '../../../Widgets/Switch/ui_switch.dart';
import 'provisioning_wifi_config.dart';

class ProvisioningWifiFields extends StatefulWidget {
  const ProvisioningWifiFields({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final ProvisioningWifiConfig value;
  final ValueChanged<ProvisioningWifiConfig> onChanged;

  @override
  State<ProvisioningWifiFields> createState() => _ProvisioningWifiFieldsState();
}

class _ProvisioningWifiFieldsState extends State<ProvisioningWifiFields>
    with TextControllersOwner<ProvisioningWifiFields> {
  late final _ssid = textController(widget.value.ssid);
  late final _password = textController(widget.value.password);

  @override
  void didUpdateWidget(covariant ProvisioningWifiFields oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_ssid.text != widget.value.ssid) _ssid.text = widget.value.ssid;
    if (_password.text != widget.value.password) {
      _password.text = widget.value.password;
    }
  }

  void _update({String? security, String? eapMethod, bool? hidden}) {
    final current = widget.value;
    widget.onChanged(
      ProvisioningWifiConfig(
        ssid: _ssid.text,
        security: security ?? current.security,
        password: _password.text,
        hidden: hidden ?? current.hidden,
        eapMethod: eapMethod ?? current.eapMethod,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wifi = widget.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s8,
      children: [
        Text(L.provisioning.wifiTitle, style: AppText.columnHeader(context)),
        CustomTextField(
          name: 'provisioning_wifi_ssid',
          controller: _ssid,
          label: L.provisioning.wifiSsid,
          helper: wifi.hasNetwork ? null : L.provisioning.wifiSsidRequired,
          dense: true,
          onChanged: (_) => _update(),
        ),
        if (wifi.hasNetwork) ...[
          AppDropdown<String>(
            label: L.provisioning.wifiSecurity,
            value: wifi.security,
            items: {
              ProvisioningWifiConfig.wpa: L.provisioning.wifiWpa,
              ProvisioningWifiConfig.open: L.provisioning.wifiOpen,
              ProvisioningWifiConfig.wep: 'WEP',
              ProvisioningWifiConfig.eap: L.provisioning.wifiEap,
            },
            dense: true,
            onChanged: (security) => _update(security: security),
          ),
          if (wifi.security != ProvisioningWifiConfig.open)
            CustomTextField(
              name: 'provisioning_wifi_password',
              controller: _password,
              label: L.provisioning.wifiPassword,
              dense: true,
              obscureText: true,
              onChanged: (_) => _update(),
            ),
          if (wifi.security == ProvisioningWifiConfig.eap) ...[
            AppDropdown<String>(
              label: L.provisioning.wifiEapMethod,
              value: wifi.eapMethod,
              items: {
                '': L.provisioning.wifiEapMethodRequired,
                for (final method in ProvisioningWifiConfig.eapMethods)
                  method: method,
              },
              dense: true,
              onChanged: (method) => _update(eapMethod: method),
            ),
            Text(L.provisioning.wifiEapHint, style: AppText.caption(context)),
          ],
          UiSwitch(
            title: L.provisioning.wifiHidden,
            value: wifi.hidden,
            onChanged: (hidden) => _update(hidden: hidden),
          ),
        ],
      ],
    );
  }
}
