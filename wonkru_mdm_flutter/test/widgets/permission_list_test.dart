import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/L.dart';
import 'package:wonkru_mdm_flutter/Core/Theme/app_theme.dart';
import 'package:wonkru_mdm_flutter/Views/Widgets/Input/permission_list.dart';

void main() {
  Future<void> pumpList(WidgetTester tester, {String? value}) {
    return tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: PermissionList(value: value)),
      ),
    );
  }

  test('namesOf returns only the populated keys in order', () {
    expect(
      PermissionList.namesOf(
        jsonEncode({
          'android.permission.CAMERA': 'allow',
          'android.permission.INTERNET': 'deny',
        }),
      ),
      ['android.permission.CAMERA', 'android.permission.INTERNET'],
    );
    expect(PermissionList.namesOf(null), isEmpty);
    expect(PermissionList.namesOf(''), isEmpty);
    expect(PermissionList.namesOf('this is not json'), isEmpty);
  });

  testWidgets('shows stored permission names read-only', (tester) async {
    await pumpList(
      tester,
      value: jsonEncode({'android.permission.CAMERA': 'allow'}),
    );

    expect(find.text('android.permission.CAMERA'), findsOneWidget);
    expect(find.text(L.common.allow), findsNothing);
    expect(find.text(L.common.ask), findsNothing);
    expect(find.text(L.common.deny), findsNothing);
    expect(find.text(L.common.addPermission), findsNothing);
    expect(find.byTooltip(L.common.remove), findsNothing);
  });

  testWidgets('shows empty state when no permissions exist', (tester) async {
    await pumpList(tester, value: null);

    expect(find.text(L.common.noPermissions), findsOneWidget);
  });
}
