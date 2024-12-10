import 'package:chat_app_flutter/modules/settings/controller/settings_controller.dart';
import 'package:get/get.dart';

class SettingsBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => SettingsController());
  }

}