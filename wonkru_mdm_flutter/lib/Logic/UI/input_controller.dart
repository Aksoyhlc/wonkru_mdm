import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Core/Logging/wlog.dart';

const _tag = 'InputController';

class InputController extends GetxController {
  static InputController get to => Get.find<InputController>();

  /// Deliberately NOT Rx. This is only a registry of which key owns which
  /// controller; making it Rx would notify listeners from [getController] during
  /// build and trigger a "setState() or markNeedsBuild() called during build"
  /// assertion. Reactivity comes from the [TextEditingController] itself and the
  /// [_validationErrors] / [_isDirty] maps below.
  final Map<String, TextEditingController> _dataController =
      <String, TextEditingController>{};
  final Map<String, dynamic> _initialValues = <String, dynamic>{};

  final RxMap<String, String> _validationErrors = <String, String>{}.obs;
  final RxMap<String, bool> _isDirty = <String, bool>{}.obs;

  final Map<String, String Function(String)?> _validators = {};
  final Map<String, VoidCallback> _listeners = {};

  final RxMap<String, Function(String)> _onChangeCallbacks =
      <String, Function(String)>{}.obs;

  void dataControllerChange(String key, TextEditingController value) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _dataController[key]?.dispose();
      _dataController[key] = value;
      _setupControllerListener(key, value);
    });
  }

  /// Returns the controller for `key`, creating it if needed (never null).
  /// [defaultValue] applies only on first creation and never overwrites existing
  /// text; use [setValue] to change a value later.
  TextEditingController getController(String key, {String? defaultValue}) {
    final existing = _dataController[key];
    if (existing != null) return existing;

    final created = TextEditingController(text: defaultValue);
    _dataController[key] = created;
    _initialValues[key] = defaultValue ?? '';
    _setupControllerListener(key, created);
    return created;
  }

  TextEditingController? tryGetController(String key) => _dataController[key];

  Map<String, TextEditingController?> getControllers(
    List<String> keys, {
    bool createIfNull = true,
    Map<String, String>? defaultValues,
  }) {
    return {
      for (final key in keys)
        key: createIfNull
            ? getController(key, defaultValue: defaultValues?[key])
            : tryGetController(key),
    };
  }

  String getValue(String key) => _dataController[key]?.text ?? '';

  Map<String, String> getValues(List<String> keys) {
    return {for (final key in keys) key: getValue(key)};
  }

  Map<String, String> getAllValues() {
    return {
      for (final entry in _dataController.entries) entry.key: entry.value.text,
    };
  }

  void setValue(String key, String value, {bool markAsDirty = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = getController(key, defaultValue: value);
      if (controller.text != value) {
        controller.text = value;
        if (markAsDirty) _checkDirtyState(key);
        _validateField(key);
      }
    });
    // Post-frame callbacks do not schedule a frame after an idle tap.
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  void setValues(Map<String, String> values, {bool markAsDirty = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final entry in values.entries) {
        setValue(entry.key, entry.value, markAsDirty: markAsDirty);
      }
    });
  }

  void addValidator(String key, String Function(String) validator) {
    _validators[key] = validator;
  }

  void addValidators(Map<String, String Function(String)> validators) {
    _validators.addAll(validators);
  }

  bool _validateField(String key) {
    final validator = _validators[key];
    if (validator == null) return true;

    final value = getValue(key);
    final error = validator(value);

    if (error.isNotEmpty) {
      _validationErrors[key] = error;
      return false;
    } else {
      _validationErrors.remove(key);
      return true;
    }
  }

  bool validateAll() {
    bool allValid = true;
    for (final key in _validators.keys) {
      if (!_validateField(key)) {
        allValid = false;
      }
    }
    return allValid;
  }

  String? getValidationError(String key) => _validationErrors[key];

  bool isFieldValid(String key) => !_validationErrors.containsKey(key);

  Map<String, String> getAllValidationErrors() => Map.from(_validationErrors);

  void _checkDirtyState(String key) {
    final currentValue = getValue(key);
    final initialValue = _initialValues[key]?.toString() ?? '';
    _isDirty[key] = currentValue != initialValue;
  }

  bool isFieldDirty(String key) => _isDirty[key] ?? false;

  bool get hasAnyDirtyField => _isDirty.values.any((dirty) => dirty);

  List<String> getDirtyFields() {
    return _isDirty.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
  }

  void addOnChangeCallback(String key, Function(String) callback) {
    _onChangeCallbacks[key] = callback;
  }

  void _setupControllerListener(String key, TextEditingController controller) {
    _listeners[key]?.call();

    void listener() {
      _checkDirtyState(key);
      _validateField(key);
      _onChangeCallbacks[key]?.call(controller.text);
    }

    controller.addListener(listener);
    _listeners[key] = () => controller.removeListener(listener);
  }

  void resetField(String key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final initialValue = _initialValues[key]?.toString() ?? '';
      setValue(key, initialValue, markAsDirty: false);
      _isDirty[key] = false;
      _validationErrors.remove(key);
    });
  }

  void resetAllFields() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final key in _initialValues.keys) {
        resetField(key);
      }
    });
  }

  void clearController() {
    try {
      for (final removeListener in _listeners.values) {
        removeListener();
      }
      _listeners.clear();

      for (final controller in _dataController.values) {
        controller.dispose();
      }
      _dataController.clear();
      _validationErrors.clear();
      _isDirty.clear();
      _initialValues.clear();
      _onChangeCallbacks.clear();
    } catch (e, st) {
      WLog.e(_tag, 'clearController error', error: e, stackTrace: st);
    }
  }

  void clearAll() => clearController();

  void clearValue(String key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _dataController[key]?.clear();
      _checkDirtyState(key);
      _validateField(key);
    });
  }

  void clearAllValue() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final entry in _dataController.entries) {
        entry.value.clear();
        _checkDirtyState(entry.key);
        _validateField(entry.key);
      }
    });
  }

  void removeDataController(String key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _listeners[key]?.call();
      _listeners.remove(key);

      final controller = _dataController.remove(key);
      controller?.dispose();

      _validationErrors.remove(key);
      _isDirty.remove(key);
      _initialValues.remove(key);
      _onChangeCallbacks.remove(key);
      _validators.remove(key);
    });
  }

  void removeDataControllers(List<String> keys) {
    for (final key in keys) {
      removeDataController(key);
    }
  }

  Map<String, dynamic> exportToJson() {
    return {
      'values': getAllValues(),
      'isDirty': Map.from(_isDirty),
      'validationErrors': Map.from(_validationErrors),
      'hasErrors': _validationErrors.isNotEmpty,
      'isDirtyForm': hasAnyDirtyField,
    };
  }

  void importFromJson(Map<String, dynamic> json) {
    final values = json['values'] as Map<String, dynamic>?;
    if (values != null) {
      setValues(values.map((k, v) => MapEntry(k, v.toString())));
    }
  }

  int get controllerCount => _dataController.length;

  List<String> getEmptyFields() {
    return _dataController.entries
        .where((entry) => entry.value.text.isEmpty)
        .map((entry) => entry.key)
        .toList();
  }

  bool areFieldsFilled(List<String> keys) {
    return keys.every((key) => getValue(key).isNotEmpty);
  }

  void debugPrintStatus() {
    WLog.d(
      _tag,
      'Status: controllers=$controllerCount, dirty=${getDirtyFields()}, errors=${getAllValidationErrors()}, empty=${getEmptyFields()}',
    );
  }

  @override
  void onClose() {
    clearController();
    super.onClose();
  }
}
