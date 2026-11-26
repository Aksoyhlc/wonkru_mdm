import 'package:flutter/services.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';

const _safeExecutorTag = 'SafeExecutor';

mixin SafeExecutor {
  Future<bool> safeExecute(
    Future<void> Function() action, {
    String? logMessage,
    bool showToastOnError = false,
    Function()? onError,
    Function()? onFinalliy,
  }) async {
    try {
      await action();
      return true;
    } on PlatformException catch (e) {
      WLog.e(_safeExecutorTag, 'Native error (safeExecute): ${e.message}', error: e);
      return false;
    } catch (e, s) {
      WLog.e(_safeExecutorTag, 'Operation error (safeExecute): $e', error: e, stackTrace: s);
      if (onError != null) onError();
      return false;
    } finally {
      onFinalliy?.call();
    }
  }

  Future<T> safeCall<T>(
    Future<T> Function() action, {
    required T defaultValue,
    Function()? onError,
    String? logMessage,
  }) async {
    try {
      return await action();
    } on PlatformException catch (e) {
      WLog.e(_safeExecutorTag, 'Native error (safeCall): ${e.message}', error: e);
      return defaultValue;
    } catch (e, s) {
      WLog.e(_safeExecutorTag, 'Data fetch error (safeCall): $e', error: e, stackTrace: s);
      if (onError != null) onError();

      return defaultValue;
    }
  }

  Future<(bool success, T? data)> mdmResultSafeCall<T>(
    Future<dynamic> Function() action, {
    T? defaultValue,
    Function()? onError,
    String? logMessage,
  }) async {
    try {
      final result = await action();

      bool isSuccess = false;
      String? message;
      dynamic rawData;

      if (result is Map) {
        isSuccess = result['success'] == true;
        // Some native handlers put the error under the 'error' key (e.g.
        // launchIntent); reading only 'message' would lose the error text.
        message =
            result['message']?.toString() ?? result['error']?.toString();
        rawData = result['data'];
      } else {
        try {
          isSuccess = (result as dynamic).success == true;
          message = (result as dynamic).message;
          rawData = (result as dynamic).data;
        } catch (e) {
          WLog.e(
            _safeExecutorTag,
            'Type error (mdmResultSafeCall): result is neither Map nor MdmResult-compatible',
            error: e,
          );
        }
      }

      if (isSuccess) {
        return (true, rawData as T?);
      } else {
        WLog.w(_safeExecutorTag, 'MdmResult failed: $message');
        if (onError != null) onError();
        return (false, defaultValue);
      }
    } on PlatformException catch (e) {
      WLog.e(_safeExecutorTag, 'Native error (mdmResultSafeCall): ${e.message}', error: e);
      if (onError != null) onError();
      return (false, defaultValue);
    } catch (e, s) {
      WLog.e(_safeExecutorTag, 'MdmResult error (mdmResultSafeCall): $e', error: e, stackTrace: s);
      if (onError != null) onError();
      return (false, defaultValue);
    }
  }
}