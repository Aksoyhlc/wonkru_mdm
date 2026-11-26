import 'package:wonkrumdm/Core/Utils/storage_helper.dart';
import 'package:wonkrumdm/Logic/Common/device_controller.dart';
import 'package:wonkrumdm/Logic/UI/input_controller.dart';

mixin StateTools {
  String errorMessage = "";
  final ic = InputController.to;
  final dc = DeviceController.to;
  final st = StorageHelper();
}