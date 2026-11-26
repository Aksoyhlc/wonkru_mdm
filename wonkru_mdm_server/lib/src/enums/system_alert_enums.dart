library;

enum SystemAlertChannel {
  database('database'),
  mail('mail'),
  sms('sms');

  const SystemAlertChannel(this.value);

  final String value;

  static SystemAlertChannel? fromValue(String? value) {
    if (value == null) {
      return null;
    }
    for (final channel in values) {
      if (channel.value == value) {
        return channel;
      }
    }
    return null;
  }
}
