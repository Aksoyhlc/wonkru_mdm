import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wonkrumdm/Core/Extensions/num.dart';
import 'package:wonkrumdm/Core/Extensions/string.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_theme.dart';

class FieldRow extends StatelessWidget {
  const FieldRow({
    super.key,
    required this.title,
    required this.value,
    this.info,
    this.txtColor,
    this.bgColor,
    this.firstColumnWidth,
    this.column = false,
    this.subTitle = false,
    this.crossAlign = CrossAxisAlignment.center,
    this.minWidth,
    this.maxWidth,
  });

  final String title;
  final dynamic value;
  final String? info;
  final Color? txtColor;
  final Color? bgColor;
  final double? firstColumnWidth;
  final bool column;
  final bool subTitle;
  final CrossAxisAlignment crossAlign;
  final double? minWidth;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    return column
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: children(),
          )
        : Row(crossAxisAlignment: crossAlign, mainAxisAlignment: MainAxisAlignment.start, children: children());
  }

  List<Widget> children() {
    final color = txtColor ?? WonkruColors.creamDim;
    return [
      Container(
        width: firstColumnWidth,
        constraints: BoxConstraints(maxWidth: 150, minWidth: minWidth ?? 100),
        child: SelectableText(
          !title.isNullOrEmpty ? "$title:" : "",
          style: WonkruText.body(
            14,
            color: color,
            weight: subTitle ? FontWeight.w600 : FontWeight.w600,
          ).copyWith(letterSpacing: .25),
        ),
      ),
      10.ww,
      Flexible(
        child: value is String || value is int || value is double
            ? Container(
                padding: bgColor == null ? null : EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                margin: EdgeInsets.only(bottom: bgColor == null ? 0 : 5),
                constraints: bgColor == null ? null : BoxConstraints(maxWidth: 75, minWidth: 30),
                decoration: BoxDecoration(color: bgColor ?? Colors.transparent, borderRadius: BorderRadius.circular(5)),
                child: Row(
                  mainAxisAlignment: bgColor == null ? MainAxisAlignment.start : MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: SelectableText(
                        (int.tryParse(value.toString()) != null
                                ? NumberFormat.compact().format(int.tryParse(value.toString()) ?? 0)
                                : value)
                            .toString(),
                        style: WonkruText.body(14, color: color, weight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              )
            : value ?? Container(),
      ),
      if (info != null) 10.ww,
    ];
  }
}