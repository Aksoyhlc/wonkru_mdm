import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:wonkru_mdm_client/wonkru_mdm_client.dart';
import 'package:wonkru_mdm_flutter/Core/Init/dependency_injection.dart';
import 'package:wonkru_mdm_flutter/Core/L10n/L.dart';
import 'package:wonkru_mdm_flutter/Core/Theme/app_theme.dart';
import 'package:wonkru_mdm_flutter/Views/Pages/Certificates/Widgets/certificate_form_dialog/certificate_form_dialog.dart';

void main() {
  setUp(() async {
    Get.testMode = true;
    await DependencyInjection.initCore();
  });

  Certificate certificate({required CertificateFormat format}) {
    return Certificate(
      name: 'Test',
      certificateType: CertificateType.CA,
      certificateData:
          '-----BEGIN CERTIFICATE-----\nMIIB\n-----END CERTIFICATE-----',
      format: format,
    );
  }

  Future<void> openDialog(WidgetTester tester, Certificate? record) async {
    // The form is taller than the default 800x600 test window.
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () =>
                    showCertificateFormDialog(context, certificate: record),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
  }

  testWidgets('the password field stays hidden for PEM format', (tester) async {
    await openDialog(tester, certificate(format: CertificateFormat.PEM));

    expect(find.text(L.certificates.password), findsNothing);
    expect(find.text(L.certificates.fetchInfo), findsOneWidget);
    expect(find.text(L.certificates.validFrom), findsOneWidget);
    expect(find.text(L.certificates.validUntil), findsOneWidget);
  });

  testWidgets('password field visible for PKCS12 format', (tester) async {
    await openDialog(tester, certificate(format: CertificateFormat.PKCS12));

    expect(find.text(L.certificates.password), findsOneWidget);
  });
}
