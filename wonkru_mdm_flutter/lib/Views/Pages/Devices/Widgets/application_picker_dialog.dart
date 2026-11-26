import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../../Logic/Controllers/applications_controller.dart';
import '../../../Widgets/Button/app_button.dart';
import '../../../Widgets/Dialog/app_dialog_shell.dart';
import '../../../Widgets/Input/remote_search_list.dart';

Future<String?> showApplicationPickerDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (_) => AppDialogShell(
      title: L.devices.commandsPickApplication,
      maxWidth: 560,
      actions: [AppButton.cancel(context)],
      child: RemoteSearchList<Application>(
        load: Get.find<ApplicationsController>().searchApplications,
        searchName: 'application_picker_search',
        searchHint: L.devices.appSearchHint,
        errorText: L.devices.appsLoadFailed,
        emptyText: L.devices.noMatchingApps,
        itemBuilder: (context, application) => _ApplicationRow(
          application: application,
          onTap: () => Navigator.pop(context, application.packageName),
        ),
      ),
    ),
  );
}

class _ApplicationRow extends StatelessWidget {
  const _ApplicationRow({required this.application, required this.onTap});

  final Application application;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.s6,
          horizontal: AppSpacing.s4,
        ),
        child: Row(
          children: [
            Icon(LucideIcons.package, size: 16, color: colors.graphite),
            AppGap.h10,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    application.appName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.body(context),
                  ),
                  Text(
                    application.packageName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.caption(context, size: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
