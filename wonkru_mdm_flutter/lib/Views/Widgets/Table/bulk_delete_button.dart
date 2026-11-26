import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Core/Constants/Enums/alert_enums.dart';
import '../../../Core/Constants/Enums/button_enums.dart';
import '../../../Core/Errors/server_error_message.dart';
import '../../../Core/L10n/L.dart';
import '../Alert/app_toast.dart';
import '../Button/app_button.dart';
import '../Dialog/confirm_dialog.dart';

/// After confirmation, [onDelete] runs and its returned count is shown; clearing
/// the selection and refreshing the list is [onDelete]'s responsibility.
class BulkDeleteButton extends StatefulWidget {
  const BulkDeleteButton({
    super.key,
    required this.label,
    required this.onDelete,
    this.title,
    this.message,
    this.successMessage,
    this.failure,
  });

  final String label;
  final Future<int> Function() onDelete;
  final String? title;
  final String? message;

  /// Success text for the deleted count; defaults to [CommonL.recordsDeleted].
  final String Function(int count)? successMessage;

  /// Failure template with an `@error` placeholder.
  final String? failure;

  @override
  State<BulkDeleteButton> createState() => _BulkDeleteButtonState();
}

class _BulkDeleteButtonState extends State<BulkDeleteButton> {
  bool _running = false;

  Future<void> _run() async {
    final confirmed = await confirmDialog(
      context: context,
      title: widget.title ?? L.common.delete,
      message: widget.message ?? L.common.bulkDeleteConfirm,
    );
    if (confirmed != true) return;

    setState(() => _running = true);
    try {
      final count = await widget.onDelete();
      AppToast.show(
        widget.successMessage?.call(count) ??
            L.common.recordsDeleted.trParams({'count': '$count'}),
        tone: UiAlertTone.success,
      );
    } catch (e) {
      AppToast.show(
        (widget.failure ?? L.common.operationFailed).trParams({
          'error': serverErrorMessage(e),
        }),
        tone: UiAlertTone.danger,
      );
    } finally {
      if (mounted) setState(() => _running = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: widget.label,
      compact: true,
      variant: AppButtonVariant.danger,
      loading: _running,
      onPressed: _running ? null : _run,
    );
  }
}
