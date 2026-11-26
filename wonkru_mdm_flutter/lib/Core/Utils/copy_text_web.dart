import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'copy_text.dart' as platform;

Future<bool> tryCopyText(String text) async {
  if (web.window.isSecureContext && await platform.tryCopyText(text)) {
    return true;
  }

  final body = web.document.body;
  if (body == null) return false;
  final focused = web.document.activeElement;
  final field = web.HTMLTextAreaElement()
    ..value = text
    ..readOnly = true
    ..tabIndex = -1;
  field.style
    ..position = 'fixed'
    ..top = '0'
    ..left = '0'
    ..opacity = '0'
    ..pointerEvents = 'none';

  // On LAN HTTP, copy the selection while the click still grants activation.
  body.appendChild(field);
  try {
    field.focus();
    field.select();
    return web.document.execCommand('copy');
  } catch (_) {
    return false;
  } finally {
    field.remove();
    if (focused != null && focused.isA<web.HTMLElement>()) {
      (focused as web.HTMLElement).focus(web.FocusOptions(preventScroll: true));
    }
  }
}
