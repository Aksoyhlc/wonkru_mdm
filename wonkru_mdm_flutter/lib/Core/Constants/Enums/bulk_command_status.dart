import '../../L10n/L.dart';

/// Wire values must stay in sync with the server's `BulkCommandStatus` enum.
enum BulkCommandStatus {
  pending('pending'),
  running('running'),
  completed('completed'),
  success('success'),
  error('error'),
  noResponse('no_response');

  const BulkCommandStatus(this.value);

  final String value;

  String get label => switch (this) {
    pending => L.common.statusPending,
    running => L.common.statusRunning,
    completed => L.common.statusCompleted,
    success => L.common.statusSuccess,
    error => L.common.statusError,
    noResponse => L.common.statusNoResponse,
  };

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

  static BulkCommandStatus overallFrom({
    required int totalCount,
    required int pendingCount,
    required int sentCount,
    required int ackedCount,
    required int timeoutCount,
    required int errorCount,
  }) {
    if (pendingCount + sentCount > 0) {
      return sentCount > 0 ? running : pending;
    }
    if (totalCount > 0 && ackedCount == totalCount) {
      return success;
    }
    if (errorCount > 0) {
      return error;
    }
    if (timeoutCount > 0 && ackedCount == 0) {
      return noResponse;
    }
    return completed;
  }

  static bool isSuccessValue(String? value) => value != error.value;
}
