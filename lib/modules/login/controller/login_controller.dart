import 'package:chat_app_flutter/data/api/apis_user_info.dart';
import 'package:get/get.dart';

import '../../../model/user_info.dart';

class LoginController extends GetxController{


  Future<UserInfo?>? registerUser(String username, String email, String password) async{
    UserInfo? userInfo = await ApisUserinfo.registerAccount(username: username, email: email, password: password);
    return null;
  }

  Future<UserInfo?>? login(String? username, String? email, String password) async{
    UserInfo? userInfo = await ApisUserinfo.login(username: username, email: email, password: password);
    return null;
  }

}