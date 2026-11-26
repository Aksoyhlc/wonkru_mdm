library;

String fileExtensionOf(String fileName) {
  final dot = fileName.lastIndexOf('.');
  if (dot < 0 || dot == fileName.length - 1) return '';
  return fileName.substring(dot + 1).toLowerCase();
}

String? mimeTypeForFileName(String fileName) =>
    _mimeTypes[fileExtensionOf(fileName)];

String formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  final kb = bytes / 1024;
  if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
  final mb = kb / 1024;
  return '${mb.toStringAsFixed(1)} MB';
}

const _mimeTypes = <String, String>{
  'apk': 'application/vnd.android.package-archive',
  'png': 'image/png',
  'jpg': 'image/jpeg',
  'jpeg': 'image/jpeg',
  'webp': 'image/webp',
  'gif': 'image/gif',
  'bmp': 'image/bmp',
  'svg': 'image/svg+xml',
  'pdf': 'application/pdf',
  'json': 'application/json',
  'xml': 'application/xml',
  'txt': 'text/plain',
  'csv': 'text/csv',
  'zip': 'application/zip',
  'pem': 'application/x-pem-file',
  'crt': 'application/x-x509-ca-cert',
  'cer': 'application/x-x509-ca-cert',
  'der': 'application/x-x509-ca-cert',
  'p12': 'application/x-pkcs12',
  'pfx': 'application/x-pkcs12',
};
