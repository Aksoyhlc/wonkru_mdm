import 'package:flutter/material.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/Constants/Enums/button_enums.dart';
import '../../../../Core/Extensions/datetime.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../../Logic/Controllers/notifications_controller.dart';
import '../../../Widgets/Badge/status_badge.dart';
import '../../../Widgets/Button/app_button.dart';
import '../../../Widgets/Dialog/app_dialog_shell.dart';
import '../../../Widgets/Loading/app_loader.dart';

Future<void> showNotificationDeliveriesDialog(
  BuildContext context, {
  required int notificationId,
  required NotificationsController controller,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => _NotificationDeliveriesDialog(
      notificationId: notificationId,
      controller: controller,
    ),
  );
}

class _NotificationDeliveriesDialog extends StatefulWidget {
  const _NotificationDeliveriesDialog({
    required this.notificationId,
    required this.controller,
  });

  final int notificationId;
  final NotificationsController controller;

  @override
  State<_NotificationDeliveriesDialog> createState() =>
      _NotificationDeliveriesDialogState();
}

class _NotificationDeliveriesDialogState
    extends State<_NotificationDeliveriesDialog> {
  late Future<List<DeviceNotificationDeliveryRow>> _future = _load();

  Future<List<DeviceNotificationDeliveryRow>> _load() =>
      widget.controller.deliveries(widget.notificationId);

  void _retry() => setState(() => _future = _load());

  @override
  Widget build(BuildContext context) {
    return AppDialogShell(
      title: L.notifications.deliveries,
      maxWidth: 820,
      actions: [
        AppButton.cancel(context, label: L.common.close),
      ],
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 460),
        child: FutureBuilder<List<DeviceNotificationDeliveryRow>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: AppInsets.v32,
                child: Center(child: AppLoader(size: 22)),
              );
            }

            if (snapshot.hasError) {
              return Padding(
                padding: AppInsets.v24,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      L.notifications.deliveriesLoadFailed,
                      textAlign: TextAlign.center,
                      style: AppText.body(
                        context,
                      ).copyWith(color: context.appColors.madder),
                    ),
                    AppGap.v12,
                    AppButton(
                      label: L.notifications.retry,
                      compact: true,
                      variant: AppButtonVariant.secondary,
                      onPressed: _retry,
                    ),
                  ],
                ),
              );
            }

            final deliveries = snapshot.data ?? const [];
            if (deliveries.isEmpty) {
              return Padding(
                padding: AppInsets.v24,
                child: Text(
                  L.notifications.noDeliveries,
                  textAlign: TextAlign.center,
                  style: AppText.bodyMuted(context),
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _header(context),
                  for (final row in deliveries) _deliveryRow(context, row),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    final colors = context.appColors;
    final style = AppText.columnHeader(context).copyWith(fontSize: 11.5);

    return Container(
      padding: AppInsets.v8,
      decoration: colors.hairlineBottom(),
      child: Row(
        children: [
          _cell(3, L.common.device, style),
          _cell(3, L.common.groups, style),
          _cell(2, L.common.status, style),
          _cell(2, L.notifications.columnSent, style),
          _cell(2, L.notifications.columnReceived, style),
        ],
      ),
    );
  }

  Widget _deliveryRow(
    BuildContext context,
    DeviceNotificationDeliveryRow row,
  ) {
    final device = row.device;
    final name = device == null
        ? '—'
        : device.name?.isNotEmpty == true
        ? device.name!
        : device.code;

    return Container(
      padding: AppInsets.v10,
      decoration: context.appColors.hairlineBottom(),
      child: Row(
        children: [
          _cell(3, name, _textStyle(context)),
          _cell(
            3,
            row.groupNames.isEmpty ? '—' : row.groupNames.join(', '),
            _textStyle(context),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: StatusBadge(
                label: NotificationsController.deliveryStatusLabel(
                  row.delivery.status,
                ),
                tone: NotificationsController.deliveryStatusTone(
                  row.delivery.status,
                ),
              ),
            ),
          ),
          _cell(2, _moment(row.delivery.sentAt), _textStyle(context)),
          _cell(2, _moment(row.delivery.receivedAt), _textStyle(context)),
        ],
      ),
    );
  }

  Widget _cell(int flex, String value, TextStyle style) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.only(right: AppSpacing.s10),
        child: Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: style,
        ),
      ),
    );
  }

  TextStyle _textStyle(BuildContext context) =>
      AppText.body(context).copyWith(fontSize: 12.5);

  /// Server times are UTC; displayed as dd.MM.yyyy HH:mm.
  static String _moment(DateTime? moment) =>
      moment?.formatDateTime('dd.MM.yyyy HH:mm') ?? '—';
}
