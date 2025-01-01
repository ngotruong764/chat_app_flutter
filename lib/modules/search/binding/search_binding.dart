import 'package:chat_app_flutter/modules/search/controller/search_user_controller.dart';
import 'package:get/get.dart';

class SearchBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => SearchUserController());
  }

}