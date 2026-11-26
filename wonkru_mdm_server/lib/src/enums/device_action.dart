library;

enum BulkCommandStatus {
  pending('pending'),
  running('running'),
  completed('completed'),
  success('success'),
  error('error'),
  noResponse('no_response');

  const BulkCommandStatus(this.value);

  final String value;

  static BulkCommandStatus? fromValue(String? value) {
    if (value == null) {
      return null;
    }
    for (final status in values) {
      if (status.value == value) {
        return status;
      }
    }
    return null;
  }

  static bool isSuccessValue(String? value) => value != error.value;
}
