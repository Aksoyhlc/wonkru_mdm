import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonkrumdm/Core/Logging/wlog.dart';

const _tag = 'InputController';

class InputController extends GetxController {
  static InputController get to => Get.find<InputController>();
  final RxMap<String, TextEditingController> _dataController = <String, TextEditingController>{}.obs;
  final RxMap<String, String> _validationErrors = <String, String>{}.obs;
  final RxMap<String, bool> _isDirty = <String, bool>{}.obs;
  final RxMap<String, dynamic> _initialValues = <String, dynamic>{}.obs;

  final Map<String, String Function(String)?> _validators = {};
  final Map<String, VoidCallback> _listeners = {};

  final RxMap<String, Function(String)> _onChangeCallbacks = <String, Function(String)>{}.obs;

  TextEditingController? getController(String key, {bool createIfNull = true, String? defaultValue}) {
    final existingController = _dataController[key];

    if (existingController == null && createIfNull) {
      final newController = TextEditingController(text: defaultValue);
      _dataController[key] = newController;
      _initialValues[key] = defaultValue ?? '';
      _setupControllerListener(key, newController);
      return newController;
    } else if (existingController != null && defaultValue != null && existingController.text != defaultValue) {
      existingController.text = defaultValue;
      _checkDirtyState(key);
    }

    return existingController;
  }

  String getValue(String key) => _dataController[key]?.text ?? '';

  void setValue(String key, String value, {bool markAsDirty = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = getController(key, defaultValue: value);
      if (controller != null && controller.text != value) {
        controller.text = value;
        if (markAsDirty) _checkDirtyState(key);
        _validateField(key);
      }
    });
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

  void _checkDirtyState(String key) {
    final currentValue = getValue(key);
    final initialValue = _initialValues[key]?.toString() ?? '';
    _isDirty[key] = currentValue != initialValue;
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

  int get controllerCount => _dataController.length;

  @override
  void onClose() {
    clearController();
    super.onClose();
  }
}
