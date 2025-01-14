import 'package:chat_app_flutter/modules/forgetPass/controller/forget_pass_controller.dart';
import 'package:get/get.dart';

class ForgetPassBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ForgetPassController());
  }

}