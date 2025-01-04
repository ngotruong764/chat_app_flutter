import 'package:chat_app_flutter/modules/application/creategroup/controller/create_group_controller.dart';
import 'package:get/get.dart';

class SearchBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => CreateGroupController());
  }

}