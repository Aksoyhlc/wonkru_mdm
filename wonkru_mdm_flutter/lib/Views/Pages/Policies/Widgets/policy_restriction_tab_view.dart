import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/L10n/L.dart';
import '../../../../Core/Logging/wlog.dart';
import '../../../../Core/Theme/design.dart';
import '../../../../Logic/Controllers/policy_editor_controller.dart';
import '../../../Widgets/Card/section_card.dart';
import '../../../Widgets/EmptyState/error_panel.dart';
import '../../../Widgets/Loading/app_loader.dart';
import 'policy_restriction_catalog.dart';
import 'policy_restriction_shortcut.dart';

const _tag = 'PolicyRestrictionTab';

String restrictionLabelKey(String catalogKey) =>
    'policies.restriction.$catalogKey';

/// The catalog comes from the server's single source
/// (`wonkru_core.core.catalogs()`); the panel only owns ordering and group
/// labels. Each selection writes `policy.restriction_settings.<key>` as `'2'`
/// (default — untouched on device), `'1'` (restrict) or `'0'` (allow); on save
/// `flatToRestrictionSettings` turns these into
/// `{"restrictions":[{"restriction":<key>,"value":0|1|2}, ...]}`.
class PolicyRestrictionTabView extends StatefulWidget {
  const PolicyRestrictionTabView({super.key, required this.controller});

  final PolicyEditorController controller;

  @override
  State<PolicyRestrictionTabView> createState() =>
      _PolicyRestrictionTabViewState();
}

class _PolicyRestrictionTabViewState extends State<PolicyRestrictionTabView> {
  late Future<List<RestrictionGroupView>> _future = _load();

  Future<List<RestrictionGroupView>> _load() async {
    try {
      final entries = await widget.controller.restrictionCatalog();
      return restrictionGroupsInPanelOrder(entries);
    } catch (e, st) {
      WLog.e(_tag, 'restriction catalog load failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  void _retry() => setState(() => _future = _load());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RestrictionGroupView>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: AppInsets.v32,
            child: Center(child: AppLoader(size: 22)),
          );
        }
        if (snapshot.hasError) {
          return ErrorPanel(
            message: L.policies.restrictionLoadFailed,
            onRetry: _retry,
          );
        }

        final groups = snapshot.data ?? const <RestrictionGroupView>[];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < groups.length; i++) ...[
              if (i > 0) AppGap.v16,
              _groupCard(context, groups[i]),
            ],
          ],
        );
      },
    );
  }

  Widget _groupCard(BuildContext context, RestrictionGroupView group) {
    return SectionCard(
      title: group.label.tr,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 900
              ? 2
              : constraints.maxWidth >= 560
              ? 2
              : 1;
          const spacing = 16.0;
          final width =
              (constraints.maxWidth - spacing * (columns - 1)) / columns;

          return Wrap(
            spacing: spacing,
            runSpacing: 4,
            children: [
              for (final entry in group.entries)
                SizedBox(
                  width: width,
                  child: _RestrictionToggle(entry: entry),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _RestrictionToggle extends StatelessWidget {
  const _RestrictionToggle({required this.entry});

  final RestrictionCatalogEntry entry;

  @override
  Widget build(BuildContext context) {
    return PolicyRestrictionShortcut(
      name: 'policy.restriction_settings.${entry.key}',
      title: entry.name,
      subtitle: '${restrictionLabelKey(entry.key).tr} (API ${entry.apiLevel}+)',
    );
  }
}
