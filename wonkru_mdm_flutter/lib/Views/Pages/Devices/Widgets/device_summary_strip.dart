import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../Core/Extensions/datetime.dart';
import '../../../../Core/Extensions/num.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../Widgets/Badge/status_badge.dart';
import '../../../Widgets/Layout/app_tile_grid.dart';
import '../../../Widgets/Table/Cells/cell_meter.dart';

class DeviceSummaryStrip extends StatelessWidget {
  const DeviceSummaryStrip({
    super.key,
    required this.device,
    required this.onlineMinutes,
    this.state,
    this.applicationCount,
  });

  final Device device;
  final DeviceStateCache? state;

  final int? applicationCount;

  final int onlineMinutes;

  @override
  Widget build(BuildContext context) {
    final battery = state?.batteryLevel ?? device.batteryLevel;
    final total = state?.totalStorageBytes ?? device.totalStorageBytes;
    final free = state?.freeStorageBytes ?? device.freeStorageBytes;
    final usedPct = _usedPercent(total, free);
    final lastSeen = device.lastSeenAt;
    final online =
        lastSeen != null &&
        DateTime.now().difference(lastSeen).inMinutes <= onlineMinutes;
    final apps = applicationCount ?? state?.totalInstalledApps;

    return AppTileGrid(
      minTileWidth: 170,
      children: [
        _Tile(
          icon: LucideIcons.batteryMedium,
          label: L.common.battery,
          child: CellMeter(
            percent: battery?.toDouble(),
            tone: CellMeter.batteryTone(battery),
            width: double.infinity,
          ),
        ),
        _Tile(
          icon: LucideIcons.hardDrive,
          label: L.common.storage,
          child: CellMeter(
            percent: usedPct,
            label: usedPct == null
                ? null
                : L.devices.storageUsedLabel.trParams({
                    'percent': '${usedPct.round()}',
                    'free': free!.readableBytes,
                  }),
            tone: CellMeter.usageTone(usedPct),
            width: double.infinity,
          ),
        ),
        _Tile(
          icon: LucideIcons.wifi,
          label: L.common.status,
          child: Wrap(
            spacing: 8,
            runSpacing: 2,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              StatusBadge(
                label: online ? L.common.online : L.common.offline,
                tone: online ? UiAlertTone.success : UiAlertTone.danger,
              ),
              Text(
                lastSeen?.relativeTr() ?? L.devices.neverSeen,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.cellSecondary(context),
              ),
            ],
          ),
        ),
        _Tile(
          icon: LucideIcons.package,
          label: L.devices.installedApp,
          child: Text(
            apps?.toString() ?? '—',
            style: AppText.sectionTitle(context),
          ),
        ),
      ],
    );
  }

  static double? _usedPercent(int? total, int? free) {
    if (total == null || total <= 0 || free == null) return null;
    return ((total - free) / total * 100).clamp(0, 100).toDouble();
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.icon, required this.label, required this.child});

  final IconData icon;
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: AppInsets.all16,
      decoration: colors.outlined(fill: colors.workshop),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: colors.graphite),
              AppGap.h6,
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.fieldLabel(context),
                ),
              ),
            ],
          ),
          AppGap.v10,
          child,
        ],
      ),
    );
  }
}
