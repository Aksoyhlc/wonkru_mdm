import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens an external link in the default browser.
///
/// If opening fails (e.g. the platform does not support it) the link is copied
/// to the clipboard and `false` is returned; `true` on success.
Future<bool> openExternalLink(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) return false;

  try {
    if (await launchUrl(uri, mode: LaunchMode.platformDefault)) {
      return true;
    }
  } catch (_) {}

  await Clipboard.setData(ClipboardData(text: url));
  return false;
}
