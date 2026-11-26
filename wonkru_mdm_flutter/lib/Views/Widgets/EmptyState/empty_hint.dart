import 'package:flutter/material.dart';

import '../../../Core/Theme/design.dart';

/// Inline muted "nothing here yet" line for list sections.
///
/// Unlike [EmptyState] it is not centered and only adds a little vertical
/// padding, so it can sit inside a card or under a titled header.
class EmptyHint extends StatelessWidget {
  const EmptyHint(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppInsets.v8,
      child: Text(message, style: AppText.bodyMuted(context)),
    );
  }
}
