import 'package:chat_app_flutter/data/api/apis_user_info.dart';
import 'package:get/get.dart';

class ForgetPassController extends GetxController{


  Future<bool> pushVerificationCode(String userEmail) async{
    return await ApisUserinfo.pushVerificationCode(userEmail: userEmail);
  }
}