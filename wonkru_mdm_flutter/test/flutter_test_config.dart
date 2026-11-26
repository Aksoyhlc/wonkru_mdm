import 'dart:async';

import 'support/l10n_test_support.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  installTestTranslations();
  await testMain();
}
