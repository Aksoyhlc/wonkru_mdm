import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/Constants/Enums/button_enums.dart';
import '../../../../Core/Constants/Enums/device_action.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Router/app_routes.dart';
import '../../../../Core/Theme/design.dart';
import '../../../Widgets/Action/open_link.dart';
import '../../../Widgets/Button/app_button.dart';
import 'device_command_status_badge.dart';

/// The response's `apps` list is not rendered here: the server writes it to the
/// device's application table, so only a count and a link are shown.
class DeviceCommandResponseView extends StatelessWidget {
  const DeviceCommandResponseView({
    super.key,
    required this.command,
    required this.title,
  });

  final DeviceCommand command;

  final String title;

  static const _keyWidth = 140.0;

  static const _envelopeKeys = {'success', 'status', 'message', 'action'};

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final response = _decode(command.response);
    final message = command.action.localizeResultMessage(
      response?['message']?.toString(),
    );
    final fields = <String, Object?>{
      for (final entry in (response ?? const <String, Object?>{}).entries)
        if (!_envelopeKeys.contains(entry.key)) entry.key: entry.value,
    };
    final pending = DeviceCommandStatusBadge.isPending(command.status);
    final mapUrl = _mapUrl(fields);
    final apps = fields.remove('apps');
    if (apps is List) fields.remove('count');

    return Container(
      padding: AppInsets.all12,
      decoration: colors.outlined(fill: colors.surfaceSubtle),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.cellPrimary(context),
                ),
              ),
              AppGap.h8,
              DeviceCommandStatusBadge(status: command.status),
            ],
          ),
          AppGap.v8,
          if (pending)
            Text(
              L.devices.commandsResponseWaiting,
              style: AppText.caption(context),
            )
          else ...[
            if (message != null) ...[
              Text(message, style: AppText.body(context)),
              AppGap.v8,
            ],
            if (apps is List)
              _appsSummary(context, apps.length)
            else if (fields.isEmpty && message == null)
              Text(
                L.devices.commandsResponseEmpty,
                style: AppText.caption(context),
              )
            else
              for (final entry in fields.entries)
                _field(context, entry.key, entry.value),
            if (mapUrl != null) ...[
              AppGap.v8,
              Align(
                alignment: Alignment.centerLeft,
                child: AppButton(
                  label: L.devices.commandsOpenMap,
                  compact: true,
                  variant: AppButtonVariant.secondary,
                  icon: LucideIcons.mapPin,
                  onPressed: () => unawaited(
                    openLinkOrCopy(mapUrl, L.common.linkCopied),
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _appsSummary(BuildContext context, int count) {
    return Row(
      children: [
        Expanded(
          child: Text(
            L.devices.commandsAppsReceived.trParams({'count': '$count'}),
            style: AppText.body(context),
          ),
        ),
        AppGap.h8,
        AppButton(
          label: L.devices.commandsOpenAppsTab,
          compact: true,
          variant: AppButtonVariant.secondary,
          icon: LucideIcons.arrowRight,
          onPressed: () {
            final router = GoRouter.of(context);
            Navigator.of(context).pop();
            router.go(AppRoutes.deviceApps(command.deviceId));
          },
        ),
      ],
    );
  }

  Widget _field(BuildContext context, String key, Object? value) {
    final nested = value is Map || value is List;
    final text = nested
        ? const JsonEncoder.withIndent('  ').convert(value)
        : '${value ?? '—'}';

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s4),
      child: nested
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(key, style: AppText.caption(context)),
                AppGap.v4,
                SelectableText(
                  text,
                  style: AppText.mono(context.appColors.carbon),
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: _keyWidth,
                  child: Text(key, style: AppText.caption(context)),
                ),
                Expanded(
                  child: SelectableText(
                    text,
                    style: AppText.mono(context.appColors.carbon),
                  ),
                ),
              ],
            ),
    );
  }

  static Map<String, Object?>? _decode(String? raw) {
    final trimmed = raw?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is Map) return decoded.cast<String, Object?>();
      return {'data': decoded};
    } on FormatException {
      return {'message': trimmed};
    }
  }

  static String? _mapUrl(Map<String, Object?> fields) {
    final lat = fields['latitude'];
    final lng = fields['longitude'];
    if (lat is! num || lng is! num) return null;
    return 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
  }
}
