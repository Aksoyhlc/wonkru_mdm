import '../L10n/L.dart';

class AppPermissions {
  const AppPermissions._();

  /// Actions used in the `ApplicationVersion.permissions` JSON.
  static const allow = 'allow';
  static const ask = 'ask';
  static const deny = 'deny';

  static const dangerous = <String>{
    'android.permission.READ_CALENDAR',
    'android.permission.WRITE_CALENDAR',
    'android.permission.CAMERA',
    'android.permission.POST_NOTIFICATIONS',
    'android.permission.READ_CONTACTS',
    'android.permission.WRITE_CONTACTS',
    'android.permission.GET_ACCOUNTS',
    'android.permission.ACCESS_FINE_LOCATION',
    'android.permission.ACCESS_COARSE_LOCATION',
    'android.permission.RECORD_AUDIO',
    'android.permission.READ_PHONE_STATE',
    'android.permission.READ_PHONE_NUMBERS',
    'android.permission.CALL_PHONE',
    'android.permission.ANSWER_PHONE_CALLS',
    'android.permission.READ_CALL_LOG',
    'android.permission.WRITE_CALL_LOG',
    'android.permission.ADD_VOICEMAIL',
    'android.permission.USE_SIP',
    'android.permission.PROCESS_OUTGOING_CALLS',
    'android.permission.BODY_SENSORS',
    'android.permission.SEND_SMS',
    'android.permission.RECEIVE_SMS',
    'android.permission.READ_SMS',
    'android.permission.RECEIVE_WAP_PUSH',
    'android.permission.RECEIVE_MMS',
    'android.permission.READ_EXTERNAL_STORAGE',
    'android.permission.WRITE_EXTERNAL_STORAGE',
    'android.permission.READ_MEDIA_IMAGES',
    'android.permission.READ_MEDIA_VIDEO',
    'android.permission.READ_MEDIA_AUDIO',
  };

  static bool isDangerous(String permission) => dangerous.contains(permission);

  static String defaultAction(String permission) =>
      isDangerous(permission) ? ask : allow;

  static String normalize(Object? value) {
    final text = '$value'.trim().toLowerCase();
    return switch (text) {
      deny => deny,
      ask => ask,
      _ => allow,
    };
  }

  static String label(String action) => switch (action) {
    deny => L.common.deny,
    ask => L.common.ask,
    _ => L.common.allow,
  };
}
