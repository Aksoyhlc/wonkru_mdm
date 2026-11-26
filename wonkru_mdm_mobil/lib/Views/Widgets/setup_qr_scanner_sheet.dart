import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:wonkrumdm/Core/L10n/L.dart';
import 'package:wonkrumdm/Core/Theme/wonkru_theme.dart';
import 'package:wonkrumdm/Core/Utils/setup_payload.dart';

/// Full-screen QR reader for the setup flow. Pops the parsed [SetupPayload].
class SetupQrScannerSheet extends StatefulWidget {
  const SetupQrScannerSheet({super.key});

  static Future<SetupPayload?> show(BuildContext context) =>
      Navigator.of(context).push<SetupPayload>(
        MaterialPageRoute(builder: (_) => const SetupQrScannerSheet()),
      );

  @override
  State<SetupQrScannerSheet> createState() => _SetupQrScannerSheetState();
}

class _SetupQrScannerSheetState extends State<SetupQrScannerSheet> {
  final _controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  bool _handled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;

    for (final barcode in capture.barcodes) {
      final payload = SetupPayload.parse(barcode.rawValue);
      if (payload != null) {
        _handled = true;
        Navigator.of(context).pop(payload);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          L.scan_qr_title,
          style: WonkruText.body(16, color: Colors.white),
        ),
      ),
      body: MobileScanner(
        controller: _controller,
        onDetect: _onDetect,
        errorBuilder: (context, error) => _ScannerError(
          permissionDenied:
              error.errorCode == MobileScannerErrorCode.permissionDenied,
        ),
      ),
    );
  }
}

class _ScannerError extends StatelessWidget {
  const _ScannerError({required this.permissionDenied});

  final bool permissionDenied;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          permissionDenied ? L.scan_qr_permission_hint : L.scan_qr_hint,
          textAlign: TextAlign.center,
          style: WonkruText.body(14, color: Colors.white),
        ),
      ),
    );
  }
}
