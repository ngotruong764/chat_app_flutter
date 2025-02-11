import 'package:chat_app_flutter/data/api/apis_base.dart';
import 'package:chat_app_flutter/data/api/apis_user_info.dart';
import 'package:get/get.dart';

import '../../../model/user_info.dart';

class   LoginController extends GetxController{

  DateTime firstDate = DateTime(1900);
  DateTime lastDate = DateTime.now();
  //
  List<String> gender = ['Male', 'Female', 'Others'];

  Rx<bool> isLoading = false.obs;

  Future<UserInfo?> registerUser(String username, String email, String password) async{
    UserInfo? userInfo = await ApisUserinfo.registerAccount(username: username, email: email, password: password, isLoading: isLoading);
    return userInfo;
  }

  Future<UserInfo?> login(UserInfo user) async{
    UserInfo? userInfo = await ApisUserinfo.login(userInfo: user, isLoading: isLoading);
    return userInfo;
  }

  // Verification account after create
  Future<UserInfo?> confirmAccount(UserInfo user) async{
    UserInfo? userInfo = await ApisUserinfo.confirmAccount(userInfo: user, isLoading: isLoading);
    return userInfo;
  }

  // Update user info
  Future<UserInfo?> updateUser(UserInfo user) async{
    UserInfo? userInfo = await ApisUserinfo.updateUserInfo(userInfo: user, isLoading: isLoading);
    return userInfo;
  }

}