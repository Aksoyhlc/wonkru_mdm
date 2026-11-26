import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../../Core/Time/app_time.dart';
import '../../../../Logic/Controllers/settings_controller.dart';
import '../../../Widgets/Card/section_card.dart';
import '../../../Widgets/Input/custom_text_field.dart';
import '../../../Widgets/Input/named_dropdown.dart';
import '../../../Widgets/Switch/named_switch.dart';
import 'alert_channels_field.dart';

class SettingsSections extends StatelessWidget {
  const SettingsSections({super.key, required this.controller});

  final SettingsController controller;

  static Map<String, String> get _logLevelItems => <String, String>{
    '0': L.settings.logLevelVerbose,
    '1': L.settings.logLevelDebug,
    '2': L.settings.logLevelInfo,
    '3': L.settings.logLevelWarning,
    '4': L.settings.logLevelError,
    '5': L.settings.logLevelFatal,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s16,
      children: [_general(), _uploadLimits(), _alerts(), _wlog()],
    );
  }

  Widget _general() {
    final policyItems = <String, String>{
      '': L.settings.policyNotSelected,
      for (final policy in controller.policyOptions)
        '${policy.id}': policy.name,
    };
    final selectedPackage =
        controller.state.value?.mdmApkPackageName ??
        SettingsController.defaultMdmApkPackageName;
    final applicationItems = {
      selectedPackage: selectedPackage,
      for (final app in controller.applicationOptions)
        app.packageName: '${app.appName} (${app.packageName})',
    };

    return SectionCard(
      title: L.common.general,
      child: _grid([
        NamedDropdown<String>(
          name: 'settings.defaultPolicyId',
          label: L.settings.defaultPolicy,
          items: policyItems,
          dense: true,
          fallback: '',
        ),
        NamedDropdown<String>(
          name: 'settings.mdmApkPackageName',
          label: L.settings.mdmApkPackageName,
          items: applicationItems,
          dense: true,
          fallback: selectedPackage,
          searchable: true,
        ),
        _text('settings.panelBrandName', L.settings.panelBrandName),
        NamedDropdown<String>(
          name: 'settings.panelTimezone',
          label: L.settings.panelTimezone,
          items: {
            '': L.settings.panelTimezoneUnset,
            for (final zone in AppTime.zoneNames) zone: zone,
          },
          dense: true,
          fallback: '',
        ),
        _number('settings.offlineTimeout', L.settings.offlineTimeout),
        _number(
          'settings.policyDevicesUpdatedCheckDelayMinutes',
          L.settings.updateCheckDelay,
        ),
        _number(
          'settings.deviceAlertsOfflineMinutes',
          L.settings.offlineAlertMinutes,
        ),
      ]),
    );
  }

  /// No limit may exceed the server's `maxRequestSize`; the ceiling is shown
  /// in the section header.
  Widget _uploadLimits() {
    final ceiling = controller.state.value?.uploadCeilingMb ?? 0;
    final hint = ceiling > 0
        ? L.settings.uploadHintMax.trParams({'ceiling': '$ceiling'})
        : null;

    return SectionCard(
      title: L.settings.sectionUploadLimits,
      trailing: ceiling > 0
          ? Builder(
              builder: (context) => Padding(
                padding: const EdgeInsets.only(right: AppSpacing.s8),
                child: Text(
                  L.common.serverCeiling.trParams({'ceiling': '$ceiling'}),
                  style: AppText.caption(context, size: 12),
                ),
              ),
            )
          : null,
      child: _grid([
        _number(
          'settings.uploadApkMaxSizeMb',
          L.settings.uploadApk,
          hint: hint,
        ),
        _number(
          'settings.uploadFileMaxSizeMb',
          L.settings.uploadFile,
          hint: hint,
        ),
        _number(
          'settings.uploadCertificateMaxSizeMb',
          L.settings.uploadCertificate,
          hint: hint,
        ),
        _number(
          'settings.uploadLauncherBackgroundMaxSizeMb',
          L.settings.uploadLauncherBg,
          hint: hint,
        ),
        _number('settings.deviceUploadMaxSizeKb', L.settings.uploadDeviceKb),
      ]),
    );
  }

  Widget _alerts() {
    return SectionCard(
      title: L.settings.sectionAlerts,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _grid([
            _number(
              'settings.deviceAlertsDuplicatePreventionHours',
              L.settings.duplicatePrevention,
            ),
          ]),
          AppGap.v16,
          AlertChannelsField(
            values: controller.systemAlertTypeChannels,
            onChanged: controller.setAlertChannels,
          ),
        ],
      ),
    );
  }

  Widget _wlog() {
    return SectionCard(
      title: 'WLog',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _grid([
            NamedDropdown<String>(
              name: 'settings.wlogConsoleMinLevel',
              label: L.settings.consoleLevel,
              items: _logLevelItems,
              dense: true,
              fallback: '2',
            ),
            NamedDropdown<String>(
              name: 'settings.wlogDbMinLevel',
              label: L.settings.dbLevel,
              items: _logLevelItems,
              dense: true,
              fallback: '2',
            ),
            NamedDropdown<String>(
              name: 'settings.wlogRemoteMinLevel',
              label: L.settings.remoteLevel,
              items: _logLevelItems,
              dense: true,
              fallback: '2',
            ),
            _number('settings.wlogMaxLocalEntries', L.settings.maxLocalEntries),
            _number('settings.wlogFlushThreshold', L.settings.flushThreshold),
            _number(
              'settings.wlogIdleFlushSeconds',
              L.settings.idleFlushSeconds,
            ),
            _number('settings.wlogRetentionDays', L.settings.retentionDays),
          ]),
          AppGap.v8,
          NamedSwitch(
            name: 'settings.wlogRemoteEnabled',
            title: L.settings.remoteLogEnabled,
            subtitle: L.settings.remoteLogSubtitle,
            dense: true,
          ),
          AppGap.v16,
          _grid([
            _text('settings.wlogRemoteEndpoint', L.settings.remoteEndpoint),
            _text('settings.wlogRemoteAuthToken', L.settings.remoteAuthToken),
            _number('settings.wlogRemoteMaxRetries', L.settings.maxRetries),
          ]),
        ],
      ),
    );
  }

  Widget _text(String name, String label, {String? hint}) =>
      CustomTextField(name: name, label: label, hint: hint, dense: true);

  Widget _number(String name, String label, {String? hint}) => CustomTextField(
    name: name,
    label: label,
    hint: hint,
    keyboardType: TextInputType.number,
    dense: true,
  );

  Widget _grid(List<Widget> children) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 900
            ? 3
            : constraints.maxWidth >= 560
            ? 2
            : 1;
        const spacing = 16.0;
        final width =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: 16,
          children: [
            for (final child in children) SizedBox(width: width, child: child),
          ],
        );
      },
    );
  }
}
