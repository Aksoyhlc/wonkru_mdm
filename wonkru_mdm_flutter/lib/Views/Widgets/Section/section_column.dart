import 'package:flutter/material.dart';

import '../../../Core/Theme/design.dart';

class SectionColumn<T> {
  const SectionColumn(this.title, {required this.cell, this.flex = 1});

  SectionColumn.text(
    this.title,
    String Function(T row) text, {
    this.flex = 1,
    bool ellipsis = true,
  }) : cell = ((context, row) => Text(
         text(row),
         maxLines: ellipsis ? 1 : null,
         overflow: ellipsis ? TextOverflow.ellipsis : null,
         style: AppText.body(context),
       ));

  final String title;
  final int flex;
  final Widget Function(BuildContext context, T row) cell;
}
