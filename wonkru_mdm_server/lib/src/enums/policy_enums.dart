library;

enum AppPermissionAction {
  allow('allow'),
  deny('deny'),
  ask('ask');

  const AppPermissionAction(this.value);

  final String value;

  static AppPermissionAction? fromValue(String? value) {
    if (value == null) {
      return null;
    }
    for (final action in values) {
      if (action.value == value) {
        return action;
      }
    }
    return null;
  }
}
