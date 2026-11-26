import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../Core/L10n/L.dart';
import '../../../Core/Theme/design.dart';

class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    required this.controller,
    this.onChanged,
    this.onSubmitted,
    this.hintText,
    this.autofocus = false,
    this.showClear = false,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  final ValueChanged<String>? onSubmitted;

  final String? hintText;
  final bool autofocus;
  final bool showClear;

  void _clear() {
    controller.clear();
    onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      constraints: const BoxConstraints(minHeight: 36),
      decoration: colors.outlined(fill: colors.workshop),
      padding: AppInsets.h10,
      child: Row(
        children: [
          Icon(LucideIcons.search, size: 16, color: colors.graphite),
          AppGap.h8,
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: autofocus,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              textInputAction: onSubmitted == null
                  ? null
                  : TextInputAction.search,
              style: AppText.body(context).copyWith(fontSize: 14, height: 1.3),
              cursorColor: colors.carbon,
              cursorWidth: 1.2,
              decoration: InputDecoration(
                isDense: true,
                isCollapsed: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 9),
                hintText: hintText ?? L.common.search,
                hintStyle: AppText.bodyMuted(context).copyWith(
                  fontSize: 14,
                  color: colors.graphite.withValues(alpha: 0.6),
                ),
              ),
            ),
          ),
          if (showClear)
            ListenableBuilder(
              listenable: controller,
              builder: (context, _) {
                if (controller.text.isEmpty) return const SizedBox.shrink();
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _clear,
                    child: Padding(
                      padding: const EdgeInsets.only(left: AppSpacing.s6),
                      child: Icon(
                        LucideIcons.x,
                        size: 15,
                        color: colors.graphite,
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
