import 'package:chat_app_flutter/modules/application/controller/application_controller.dart';
import 'package:get/get.dart';

import '../../chat/controller/chat_controller.dart';

class ApplicationBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ApplicationController());
    Get.lazyPut(() => ChatController());
  }

}