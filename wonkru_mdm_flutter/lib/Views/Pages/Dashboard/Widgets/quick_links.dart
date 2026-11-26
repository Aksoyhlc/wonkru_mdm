import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../Core/Constants/app_sections.dart';
import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../../Widgets/Card/section_card.dart';

/// Ordering matches `appSections`, with the Dashboard itself omitted; the
/// command center lives in the dashboard toolbar.
class QuickLinks extends StatelessWidget {
  const QuickLinks({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: L.dashboard.quickLinks,
      child: Wrap(
        spacing: AppSpacing.s8,
        runSpacing: AppSpacing.s8,
        children: [
          for (final section in appSections.skip(1))
            _QuickLinkChip(
              label: section.label,
              icon: section.icon,
              onTap: () => context.go(section.path),
            ),
        ],
      ),
    );
  }
}

class _QuickLinkChip extends StatelessWidget {
  const _QuickLinkChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final radius = BorderRadius.circular(AppRadius.r6);

    return Material(
      color: colors.surfaceSubtle,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        hoverColor: colors.hover,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s12,
            vertical: AppSpacing.s8,
          ),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: colors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15, color: colors.loomBlue),
              AppGap.h8,
              Text(label, style: AppText.cellPrimary(context)),
            ],
          ),
        ),
      ),
    );
  }
}
