import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../Core/Constants/Enums/alert_enums.dart';
import '../../../Core/Constants/Enums/table_enums.dart';
import '../../../Core/L10n/L.dart';
import '../../../Logic/Controllers/certificates_controller.dart';
import '../../Widgets/Action/open_link.dart';
import '../../Widgets/Action/run_action.dart';
import '../../Widgets/Table/Cells/cell_action.dart';
import '../../Widgets/Table/Cells/cell_badge.dart';
import '../../Widgets/Table/Cells/cell_date.dart';
import '../../Widgets/Table/Cells/cell_primary.dart';
import '../../Widgets/Table/Cells/cell_text.dart';
import '../../Widgets/Table/app_data_table.dart';
import '../../Widgets/Table/table_column.dart';
import 'Widgets/certificate_form_dialog/certificate_form_dialog.dart';

class CertificatesPage extends StatefulWidget {
  const CertificatesPage({super.key});

  @override
  State<CertificatesPage> createState() => _CertificatesPageState();
}

class _CertificatesPageState extends State<CertificatesPage> {
  late final CertificatesController _controller =
      Get.find<CertificatesController>();

  @override
  Widget build(BuildContext context) {
    return AppDataTable<Certificate>(
      controller: _controller,
      columns: _columns(context),
      rowId: (certificate) => certificate.id,
      searchHint: L.certificates.searchHint,
      emptyTitle: L.certificates.emptyTitle,
      emptySubtitle: L.certificates.emptySubtitle,
      createLabel: L.certificates.newCertificate,
      onCreate: () => _create(context),
      onBulkDelete: _controller.deleteSelected,
    );
  }

  List<AppColumn<Certificate>> _columns(BuildContext context) {
    return [
      AppColumn<Certificate>(
        title: L.common.name,
        width: 260,
        sortKey: 'name',
        freeze: AppColumnFreeze.start,
        hideable: false,
        cell: (certificate) => CellPrimary(
          title: certificate.name,
          subtitle: certificate.certificateType.name,
        ),
      ),
      AppColumn<Certificate>(
        title: 'Issuer',
        width: 220,
        cell: (certificate) => CellText(certificate.issuer),
      ),
      AppColumn<Certificate>(
        title: 'Subject',
        width: 220,
        expand: true,
        cell: (certificate) => CellText(certificate.subject),
      ),
      AppColumn<Certificate>(
        title: 'Format',
        width: 110,
        cell: (certificate) => CellText(certificate.format.name),
      ),
      AppColumn<Certificate>(
        title: L.certificates.validity,
        width: 160,
        cell: (certificate) => CellDate(
          certificate.validUntil,
          relative: false,
          withTime: false,
        ),
      ),
      AppColumn<Certificate>(
        title: L.common.status,
        width: 110,
        cell: (certificate) => CellBadge(
          certificate.isActive ? L.common.active : L.common.inactive,
          tone: certificate.isActive ? UiAlertTone.success : UiAlertTone.danger,
        ),
      ),
      AppColumn.actions(
        (certificate) => [
          CellAction.edit(() => _edit(context, certificate)),
          CellAction(
            label: L.common.download,
            icon: LucideIcons.download,
            onTap: () => _download(certificate),
          ),
          CellAction.delete(() => _delete(context, certificate)),
        ],
      ),
    ];
  }

  Future<void> _create(BuildContext context) async {
    final result = await showCertificateFormDialog(context);
    if (result == null) return;

    await runAction(
      () => _controller.createCertificate(result),
      success: L.certificates.created,
      failure: L.common.saveFailed,
    );
  }

  Future<void> _edit(BuildContext context, Certificate certificate) async {
    final result = await showCertificateFormDialog(
      context,
      certificate: certificate,
    );
    if (result == null) return;

    await runAction(
      () => _controller.updateCertificate(result),
      success: L.certificates.updated,
      failure: L.common.saveFailed,
    );
  }

  Future<void> _download(Certificate certificate) async {
    final id = certificate.id;
    if (id == null) return;

    await openDownload(
      () => _controller.downloadUrl(id),
      missingMessage: L.certificates.downloadMissing,
      copiedMessage: L.common.linkCopied,
      failure: L.common.downloadFailed,
    );
  }

  Future<void> _delete(BuildContext context, Certificate certificate) async {
    final id = certificate.id;
    if (id == null) return;

    await confirmAndRun(
      context,
      title: L.certificates.deleteTitle,
      message: L.common.deleteConfirm.trParams({
        'name': certificate.name,
      }),
      action: () => _controller.deleteCertificate(id),
      success: L.certificates.deleted,
      failure: L.common.deleteFailed,
    );
  }
}
