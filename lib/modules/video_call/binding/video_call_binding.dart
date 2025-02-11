import 'package:chat_app_flutter/modules/video_call/controller/video_call_controller.dart';
import 'package:get/get.dart';

class VideoCallBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => VideoCallController());
  }
}