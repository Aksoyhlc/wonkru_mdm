import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';

import '../../../../Core/L10n/L.dart';
import '../../../../Core/Theme/design.dart';
import '../../EmptyState/empty_state.dart';
import '../../Motion/enter_animation.dart';
import 'Widgets/nice_scale.dart';
import 'Widgets/trend_geometry.dart';
import 'Widgets/trend_painter.dart';

/// Time-series area + line chart. With [secondary] a second dashed series is
/// drawn on the same axis with a legend. When [height] is null the chart fills
/// its parent, so the parent must bound the height.
class TrendChart extends StatefulWidget {
  const TrendChart({
    super.key,
    required this.chart,
    this.secondary,
    this.primaryLabel,
    this.secondaryLabel,
    this.height = 200,
    this.labelFormatter,
  });

  final DashboardChart chart;

  final List<int>? secondary;

  final String? primaryLabel;

  final String? secondaryLabel;
  final double? height;

  final String Function(String label)? labelFormatter;

  @override
  State<TrendChart> createState() => _TrendChartState();
}

class _TrendChartState extends State<TrendChart>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: AppMotion.chart,
  );
  late List<int> _values;
  List<int>? _secondaryValues;
  bool _started = false;
  Timer? _entranceTimer;
  @override
  void initState() {
    super.initState();
    _snapshot();
  }

  void _snapshot() {
    _values = List.of(widget.chart.values);
    _secondaryValues = widget.secondary == null
        ? null
        : List.of(widget.secondary!);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotion.reduced(context)) {
      _entranceTimer?.cancel();
      _entranceTimer = null;
      _controller.value = 1;
      _started = true;
    } else if (!_started) {
      _started = true;
      final delay = EnterAnimation.remainingDelayOf(context);
      if (delay == Duration.zero) {
        _controller.forward();
      } else {
        _entranceTimer = Timer(delay, () {
          _entranceTimer = null;
          if (mounted) _controller.forward(from: 0);
        });
      }
    }
  }

  @override
  void didUpdateWidget(TrendChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(_values, widget.chart.values) ||
        !listEquals(_secondaryValues, widget.secondary)) {
      _snapshot();
      _hoverIndex = null;
      if (AppMotion.reduced(context)) {
        _controller.value = 1;
      } else if (_entranceTimer == null) {
        _controller.forward(from: 0);
      }
    }
  }

  @override
  void dispose() {
    _entranceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  int? _hoverIndex;

  String get _localeName => Get.locale?.toString() ?? 'en_US';

  NumberFormat get _axisFormat => NumberFormat.compact(locale: _localeName);

  NumberFormat get _valueFormat => NumberFormat.decimalPattern(_localeName);

  String get _primaryLabel => widget.primaryLabel ?? L.common.total;

  String get _secondaryLabel => widget.secondaryLabel ?? L.common.error;

  List<int>? get _secondary {
    final secondary = widget.secondary;
    if (secondary == null || secondary.length != widget.chart.values.length) {
      return null;
    }
    return secondary;
  }

  String _label(int index) {
    final labels = widget.chart.labels;
    if (index >= labels.length) return '';
    return widget.labelFormatter?.call(labels[index]) ?? labels[index];
  }

  @override
  Widget build(BuildContext context) {
    if (widget.chart.values.isEmpty) {
      return EmptyState(title: L.common.noData);
    }

    final secondary = _secondary;
    final chart = LayoutBuilder(
      builder: (context, constraints) => AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => _plot(context, constraints.biggest),
      ),
    );

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (secondary != null) ...[
          _legend(context),
          AppGap.v8,
        ],
        Expanded(child: chart),
      ],
    );

    return widget.height == null
        ? body
        : SizedBox(height: widget.height, child: body);
  }

  Widget _legend(BuildContext context) {
    final colors = context.appColors;
    return Wrap(
      spacing: AppSpacing.s16,
      children: [
        _legendItem(context, colors.loomBlue, _primaryLabel),
        _legendItem(context, colors.madder, _secondaryLabel),
      ],
    );
  }

  Widget _legendItem(BuildContext context, Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppRadius.r2),
          ),
        ),
        AppGap.h6,
        Text(label, style: AppText.caption(context)),
      ],
    );
  }

  Widget _plot(BuildContext context, Size size) {
    final colors = context.appColors;
    final values = widget.chart.values;
    final secondary = _secondary;
    final axisStyle = AppText.caption(context, size: 10.5);

    final peak = [
      ...values,
      ...?secondary,
    ].fold<int>(0, math.max);
    final scale = NiceScale.of(peak);
    final tickLabels = [
      for (var i = 0; i <= scale.ticks; i++) _axisFormat.format(scale.step * i),
    ];
    final axisWidth =
        tickLabels
            .map((t) => _measure(t, axisStyle).width)
            .fold(0.0, math.max) +
        10;

    final geometry = TrendGeometry(
      size: size,
      leftInset: axisWidth,
      count: values.length,
      max: scale.max,
    );

    final hoverIndex = _hoverIndex;
    return MouseRegion(
      onHover: (event) {
        final index = geometry.indexAt(event.localPosition.dx);
        if (index != _hoverIndex) setState(() => _hoverIndex = index);
      },
      onExit: (_) => setState(() => _hoverIndex = null),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: TrendPainter(
                progress: AppMotion.enter.transform(_controller.value),
                geometry: geometry,
                values: values,
                secondary: secondary,
                ticks: scale.ticks,
                tickLabels: tickLabels,
                xLabels: [for (var i = 0; i < values.length; i++) _label(i)],
                hoverIndex: hoverIndex,
                line: colors.loomBlue,
                secondaryLine: colors.madder,
                grid: colors.border,
                surface: colors.workshop,
                axisStyle: axisStyle,
              ),
            ),
          ),
          if (hoverIndex != null)
            _tooltip(context, geometry, hoverIndex, secondary),
        ],
      ),
    );
  }

  Widget _tooltip(
    BuildContext context,
    TrendGeometry geometry,
    int index,
    List<int>? secondary,
  ) {
    final colors = context.appColors;
    final x = geometry.xAt(index);
    final flip = x > geometry.size.width / 2;

    return Positioned(
      left: x,
      top: 0,
      child: IgnorePointer(
        child: FractionalTranslation(
          translation: Offset(flip ? -1 : 0, 0),
          child: Container(
            margin: AppInsets.h10,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s10,
              vertical: AppSpacing.s8,
            ),
            decoration: BoxDecoration(
              color: colors.surfaceSubtle,
              borderRadius: BorderRadius.circular(AppRadius.r6),
              border: Border.all(color: colors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_label(index), style: AppText.caption(context, size: 11)),
                AppGap.v4,
                _tooltipRow(
                  context,
                  colors.loomBlue,
                  _primaryLabel,
                  widget.chart.values[index],
                ),
                if (secondary != null)
                  _tooltipRow(
                    context,
                    colors.madder,
                    _secondaryLabel,
                    secondary[index],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tooltipRow(
    BuildContext context,
    Color color,
    String label,
    int value,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        AppGap.h6,
        Text(label, style: AppText.caption(context)),
        AppGap.h12,
        Text(_valueFormat.format(value), style: AppText.cellPrimary(context)),
      ],
    );
  }

  static Size _measure(String text, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();
    return painter.size;
  }
}
