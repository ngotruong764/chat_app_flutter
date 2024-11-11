import 'package:chat_app_flutter/modules/chat/screen/chat_box.dart';
import 'package:get/get.dart';

import '../controller/chat_controller.dart';

class ChatBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ChatController());
  }
}