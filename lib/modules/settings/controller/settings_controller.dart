import 'package:get/get.dart';

import '../../../data/api/apis_user_info.dart';
import '../../../model/user_info.dart';

class SettingsController extends GetxController{
  List<String> gender = ['Male', 'Female', 'Others'];

  @override
  void onInit() {
    super.onInit();
  }

  // Update user info
  Future<UserInfo?> updateUser(UserInfo user) async{
    UserInfo? userInfo = await ApisUserinfo.updateUserInfo(userInfo: user);
    return userInfo;
  }
}