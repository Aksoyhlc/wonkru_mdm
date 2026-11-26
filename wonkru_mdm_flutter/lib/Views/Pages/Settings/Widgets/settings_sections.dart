import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../../Core/Time/app_time.dart';
import '../../../../Logic/Controllers/settings_controller.dart';
import '../../../Widgets/Card/section_card.dart';
import '../../../Widgets/Input/custom_text_field.dart';
import '../../../Widgets/Input/named_dropdown.dart';
import '../../../Widgets/Input/string_list_field.dart';
import '../../../Widgets/Switch/named_switch.dart';
import 'alert_channels_field.dart';

class SettingsSections extends StatelessWidget {
  const SettingsSections({super.key, required this.controller});

  final SettingsController controller;

  /// Empty or invalid values are also rejected server-side.
  static final RegExp _timePattern = RegExp(
    r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$',
  );

  static Map<PanelTheme, String> get _themeItems => <PanelTheme, String>{
    PanelTheme.light: L.settings.themeLight,
    PanelTheme.dark: L.settings.themeDark,
    PanelTheme.system: L.settings.themeSystem,
  };

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
      children: [
        _general(),
        _uploadLimits(),
        _policyDefaults(),
        _alerts(),
        _backup(),
        _wlog(),
      ],
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
        NamedDropdown<PanelTheme>(
          name: 'settings.panelDefaultTheme',
          label: L.settings.panelTheme,
          items: _themeItems,
          dense: true,
          fallback: PanelTheme.system,
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
          'settings.deviceAlertsOnlineMinutes',
          L.settings.onlineAlertMinutes,
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

  Widget _policyDefaults() {
    return SectionCard(
      title: L.settings.sectionPolicyDefaults,
      child: _grid([
        _number(
          'settings.policyDefaultServerReportInterval',
          L.settings.reportInterval,
        ),
        _number('settings.policyDefaultMinTimeMs', L.settings.minDuration),
        _number(
          'settings.policyDefaultMinDistanceMeters',
          L.settings.minDistance,
        ),
        _number(
          'settings.policyDevicesUpdatedCheckDelayMinutes',
          L.settings.updateCheckDelay,
        ),
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

  Widget _backup() {
    return SectionCard(
      title: L.settings.sectionBackup,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.s16,
        children: [
          StringListField(
            label: L.settings.cleanTimes,
            helper: L.settings.timeFormatHelper.trParams({'example': '01:00'}),
            hint: '01:00',
            keyboardType: TextInputType.datetime,
            values: controller.backupScheduleCleanTimes,
            onChanged: controller.setCleanTimes,
            validate: _validateTime,
          ),
          StringListField(
            label: L.settings.runTimes,
            helper: L.settings.timeFormatHelper.trParams({'example': '01:30'}),
            hint: '01:30',
            keyboardType: TextInputType.datetime,
            values: controller.backupScheduleRunTimes,
            onChanged: controller.setRunTimes,
            validate: _validateTime,
          ),
          StringListField(
            label: L.settings.monitorTimes,
            helper: L.settings.timeFormatHelper.trParams({'example': '04:00'}),
            hint: '04:00',
            keyboardType: TextInputType.datetime,
            values: controller.backupScheduleMonitorTimes,
            onChanged: controller.setMonitorTimes,
            validate: _validateTime,
          ),
          StringListField(
            label: L.settings.notifyUserIds,
            helper: L.settings.notifyUserIdsHelper,
            hint: L.settings.userIdHint,
            values: controller.backupNotifyUserIds,
            onChanged: controller.setNotifyUserIds,
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

  String? _validateTime(String value) {
    if (!_timePattern.hasMatch(value)) {
      return L.settings.timeFormatInvalid;
    }
    return null;
  }

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
