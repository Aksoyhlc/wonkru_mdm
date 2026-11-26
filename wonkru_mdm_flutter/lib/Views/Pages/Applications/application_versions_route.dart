import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../Core/Errors/server_error_message.dart';
import '../../../Core/L10n/L.dart';
import '../../../Logic/Controllers/applications_controller.dart';
import '../../Widgets/EmptyState/error_panel.dart';
import '../../Widgets/Loading/app_loader.dart';
import 'application_versions_page.dart';

class ApplicationVersionsRoute extends StatefulWidget {
  const ApplicationVersionsRoute({
    super.key,
    required this.applicationId,
    this.application,
    this.openUploadOnStart = false,
  });

  final int applicationId;
  final Application? application;
  final bool openUploadOnStart;

  @override
  State<ApplicationVersionsRoute> createState() =>
      _ApplicationVersionsRouteState();
}

class _ApplicationVersionsRouteState extends State<ApplicationVersionsRoute> {
  Application? _application;
  String? _error;

  @override
  void initState() {
    super.initState();
    _application = widget.application;
    if (_application == null) _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final application = await Get.find<ApplicationsController>()
          .getApplication(widget.applicationId);
      if (mounted) setState(() => _application = application);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = L.applications.loadFailed.trParams({
            'error': serverErrorMessage(e),
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final error = _error;
    if (error != null) {
      return ErrorPanel(message: error, onRetry: _load);
    }

    final application = _application;
    if (application == null) {
      return const Center(child: AppLoader(size: 28));
    }

    return ApplicationVersionsPage(
      application: application,
      openUploadOnStart: widget.openUploadOnStart,
    );
  }
}
