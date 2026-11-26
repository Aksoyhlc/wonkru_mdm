import 'package:flutter/material.dart';

import '../../../Core/Theme/design.dart';
import '../Button/app_button.dart';
import '../Input/checkbox_row.dart';
import 'app_dialog_shell.dart';

/// An empty result clears every assignment.
Future<List<int>?> showAssignGroupsDialog<T>(
  BuildContext context, {
  required String title,
  required String applyLabel,
  required String emptyText,
  required List<T> groups,
  required int? Function(T group) idOf,
  required String Function(T group) nameOf,
  required String Function(T group) subtitleOf,
  List<int> initial = const [],
}) {
  final selected = initial.toSet();

  return showDialog<List<int>>(
    context: context,
    builder: (_) => StatefulBuilder(
      builder: (context, setState) => AppDialogShell(
        title: title,
        actions: [
          AppButton.cancel(context),
          AppButton(
            label: applyLabel,
            onPressed: () => Navigator.pop(context, selected.toList()),
          ),
        ],
        child: groups.isEmpty
            ? Text(emptyText, style: AppText.bodyMuted(context))
            : ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 320),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final group in groups)
                        CheckboxRow(
                          title: nameOf(group),
                          subtitle: subtitleOf(group),
                          singleLine: false,
                          selected: selected.contains(idOf(group)),
                          onChanged: (checked) {
                            final id = idOf(group);
                            if (id == null) return;
                            setState(() {
                              checked ? selected.add(id) : selected.remove(id);
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ),
      ),
    ),
  );
}
