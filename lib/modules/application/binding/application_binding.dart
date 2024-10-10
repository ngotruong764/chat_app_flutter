import 'package:chat_app_flutter/modules/application/controller/application_controller.dart';
import 'package:get/get.dart';

class ApplicationBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ApplicationController());
  }

}