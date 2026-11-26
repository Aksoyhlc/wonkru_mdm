import 'dart:convert';

/// The server's `DeviceEndpoint._isErrorAck` looks for `{"error": true}` or
/// `{"success": false}`, so `success` is always written explicitly; `status` is
/// kept for readability in the panel.
String encodeAckPayload(Map<String, dynamic>? result) {
  if (result == null) {
    return jsonEncode(<String, dynamic>{
      'success': false,
      'status': 'error',
      'message': 'Command result could not be produced',
    });
  }

  final payload = Map<String, dynamic>.from(result);
  final status = (payload['status'] as String?)?.toLowerCase();
  final isError = status == 'error' || payload['success'] == false;
  payload['success'] = !isError;
  payload['status'] = isError ? 'error' : 'success';
  return jsonEncode(payload);
}
