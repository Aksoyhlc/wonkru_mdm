enum CertificateAction {
  install,
  uninstall;

  static CertificateAction fromString(String? value) {
    switch ((value ?? '').toLowerCase()) {
      case 'uninstall':
      case 'remove':
        return CertificateAction.uninstall;
      default:
        return CertificateAction.install;
    }
  }
}
