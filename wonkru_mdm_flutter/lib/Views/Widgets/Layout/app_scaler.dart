import 'package:flutter/widgets.dart';

/// Scales the whole UI by one factor, like browser zoom: icons, spacing and
/// boxes scale too, unlike `textScaler`. [child] is laid out at `1 / scale`
/// and drawn scaled, and `MediaQuery` metrics are shrunk by the same factor.
class AppScaler extends StatelessWidget {
  const AppScaler({super.key, required this.scale, required this.child});

  final double scale;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (scale == 1) return child;

    final media = MediaQuery.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest / scale;
        return MediaQuery(
          data: media.copyWith(
            size: media.size / scale,
            padding: media.padding / scale,
            viewPadding: media.viewPadding / scale,
            viewInsets: media.viewInsets / scale,
          ),
          child: Transform.scale(
            scale: scale,
            alignment: Alignment.topLeft,
            child: OverflowBox(
              alignment: Alignment.topLeft,
              minWidth: size.width,
              maxWidth: size.width,
              minHeight: size.height,
              maxHeight: size.height,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
