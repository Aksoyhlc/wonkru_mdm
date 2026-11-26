import 'dart:async';
import 'dart:typed_data';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/Constants/Enums/alert_enums.dart';
import '../../../../Core/Errors/server_error_message.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../../Core/Utils/file_metadata.dart';
import '../../../../Logic/Controllers/file_upload_controller.dart';
import '../../Alert/app_toast.dart';
import '../uploaded_file.dart';
import 'Widgets/upload_busy_panel.dart';
import 'Widgets/upload_error_panel.dart';
import 'Widgets/upload_idle_panel.dart';
import 'Widgets/uploaded_file_panel.dart';

/// Central file upload area.
///
/// `FileUploader` reports no progress, so a busy upload shows an indeterminate
/// spinner. Drag-and-drop works only on desktop and web.
class AppFileUpload extends StatefulWidget {
  const AppFileUpload({
    super.key,
    required this.purpose,
    this.label,
    this.helper,
    this.accept,
    this.disk,
    this.enabled = true,
    required this.onUploaded,
    this.onRemoved,
  });

  /// Server-side upload purpose: `apk`, `certificate`, `file`,
  /// `launcherBackground`.
  final String purpose;

  final String? label;
  final String? helper;

  /// Dotless accepted extensions (e.g. `['APK']`). `null` means no type limit.
  final List<String>? accept;

  /// Selects the disk for the `file` purpose (`private`/`public`). Ignored for
  /// other purposes and when `null`, where the server default applies.
  final String? disk;

  final bool enabled;

  final Future<void> Function(UploadedFile file) onUploaded;

  /// Called when "Remove" (or "Discard" on error) fires, so the parent form can
  /// clear state such as a stored path or hash.
  final VoidCallback? onRemoved;

  @override
  State<AppFileUpload> createState() => _AppFileUploadState();
}

enum _UploadStage { idle, busy, uploaded, error }

class _AppFileUploadState extends State<AppFileUpload> {
  late final FileUploadController _uploads = Get.find<FileUploadController>();

  _UploadStage _stage = _UploadStage.idle;
  UploadedFile? _file;
  String? _error;
  String? _warning;
  bool _dragging = false;

  String? _pendingName;
  Uint8List? _pendingBytes;

  bool get _enabled => widget.enabled && _stage != _UploadStage.busy;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppText.cellPrimary(
              context,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
          AppGap.v6,
        ],
        DropTarget(
          enable: _enabled,
          onDragEntered: (_) => setState(() => _dragging = true),
          onDragExited: (_) => setState(() => _dragging = false),
          onDragDone: (details) {
            setState(() => _dragging = false);
            unawaited(_handleDrop(details));
          },
          child: _buildBody(context),
        ),
        if (_warning != null) ...[
          AppGap.v6,
          _note(context, _warning!, colors.warning, LucideIcons.triangleAlert),
        ] else if (widget.helper != null && _stage == _UploadStage.idle) ...[
          AppGap.v6,
          _note(context, widget.helper!, colors.graphite, null),
        ],
      ],
    );
  }

  Widget _buildBody(BuildContext context) => switch (_stage) {
    _UploadStage.idle => UploadIdlePanel(
      dragging: _dragging,
      enabled: _enabled,
      onPick: _pick,
    ),
    _UploadStage.busy => const UploadBusyPanel(),
    _UploadStage.uploaded => UploadedFilePanel(
      file: _file!,
      enabled: _enabled,
      onRemove: _clear,
      onReplace: _pick,
    ),
    _UploadStage.error => UploadErrorPanel(
      message: _error ?? L.common.uploadFailed,
      canRetry: _pendingBytes != null,
      onDiscard: _clear,
      onRetry: _retry,
    ),
  };

  Widget _note(
    BuildContext context,
    String message,
    Color color,
    IconData? icon,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 13, color: color),
          AppGap.h6,
        ],
        Expanded(
          child: Text(
            message,
            style: AppText.caption(context, size: 11).copyWith(color: color),
          ),
        ),
      ],
    );
  }

  Future<void> _pick() async {
    final accept = widget.accept;
    final groups = accept == null || accept.isEmpty
        ? const <XTypeGroup>[]
        : <XTypeGroup>[
            XTypeGroup(label: accept.join(', '), extensions: accept),
          ];
    try {
      final picked = await openFile(acceptedTypeGroups: groups);
      if (picked == null) return;
      final bytes = await picked.readAsBytes();
      await _handle(picked.name, bytes);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _stage = _UploadStage.error;
        _error = L.common.fileReadFailed.trParams({
          'error': serverErrorMessage(e),
        });
      });
    }
  }

  Future<void> _handleDrop(DropDoneDetails details) async {
    if (!_enabled || details.files.isEmpty) return;
    final item = details.files.first;
    try {
      final bytes = await item.readAsBytes();
      await _handle(item.name, bytes);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _stage = _UploadStage.error;
        _error = L.common.fileReadFailed.trParams({
          'error': serverErrorMessage(e),
        });
      });
    }
  }

  Future<void> _handle(String fileName, Uint8List bytes) async {
    final accept = widget.accept;
    if (accept != null && accept.isNotEmpty) {
      final extension = fileExtensionOf(fileName);
      final allowed = accept.map((e) => e.toLowerCase()).toSet();
      if (!allowed.contains(extension)) {
        setState(() {
          _warning = L.common.expectedFileTypes.trParams({
            'types': accept.join(', '),
          });
        });
        AppToast.show(
          L.common.unsupportedFileType.trParams({'extension': extension}),
          tone: UiAlertTone.warning,
        );
        return;
      }
    }

    setState(() {
      _stage = _UploadStage.busy;
      _error = null;
      _warning = null;
      _pendingName = fileName;
      _pendingBytes = bytes;
    });

    try {
      final description = await _uploads.describe(
        widget.purpose,
        fileName,
        bytes.length,
        disk: widget.disk,
      );
      final uploader = FileUploader(description.description);
      final uploaded = await uploader.uploadByteData(
        ByteData.sublistView(bytes),
      );
      if (!uploaded) {
        // The server handed out a description but the bytes did not transfer:
        // browser CORS block (preflight rejected), connection failure, or the
        // server rejecting the upload (size limit, expired token).
        if (!mounted) return;
        setState(() {
          _stage = _UploadStage.error;
          _error = L.common.uploadTransferFailed.trParams({
            'size': formatBytes(bytes.length),
          });
        });
        return;
      }

      final verified = await _uploads.verify(
        description.storageId,
        description.path,
      );
      if (!verified) {
        if (!mounted) return;
        setState(() {
          _stage = _UploadStage.error;
          _error = L.common.uploadVerifyFailed;
        });
        return;
      }

      // The server computed the checksum during upload; it is only read here.
      String? checksum;
      try {
        checksum = await _uploads.checksum(
          description.storageId,
          description.path,
        );
      } catch (_) {
        // If the checksum is unavailable the file is still usable; the field
        // stays empty.
      }

      final file = UploadedFile(
        storageId: description.storageId,
        path: description.path,
        fileName: fileName,
        sizeBytes: bytes.length,
        bytes: bytes,
        contentType: mimeTypeForFileName(fileName),
        checksumSha256: checksum,
      );
      if (!mounted) return;
      setState(() {
        _stage = _UploadStage.uploaded;
        _file = file;
        _error = null;
      });
      await widget.onUploaded(file);
    } on AdminUploadException catch (e) {
      // The server's rejection message is user-ready.
      if (!mounted) return;
      setState(() {
        _stage = _UploadStage.error;
        _error = e.message;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _stage = _UploadStage.error;
        _error = L.common.uploadFailedConnection.trParams({
          'error': serverErrorMessage(e),
        });
      });
    }
  }

  Future<void> _retry() async {
    final name = _pendingName;
    final bytes = _pendingBytes;
    if (name == null || bytes == null) return;
    await _handle(name, bytes);
  }

  void _clear() {
    setState(() {
      _stage = _UploadStage.idle;
      _file = null;
      _error = null;
      _warning = null;
      _pendingName = null;
      _pendingBytes = null;
    });
    widget.onRemoved?.call();
  }
}
