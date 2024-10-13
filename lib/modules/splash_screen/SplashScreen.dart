import 'dart:convert';

import 'package:chat_app_flutter/data/api/apis_user_info.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/user_info.dart';
import '../../routes/app_routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  // init
  void init() async {
    await Future.delayed(const Duration(seconds: 2));
    // get SharedPreferences instance
    final prefs = await SharedPreferences.getInstance();
    // get 'userInfo'
    final String? userPrefs = prefs.getString('userInfo');
    // if user info != null means app is login
    if (userPrefs != null) {
      // read the userInfo
      Map<String, dynamic> userMap = jsonDecode(userPrefs) as Map<
          String,
          dynamic>;
      UserInfo userInfo = UserInfo.fromJson(userMap);
      // login request
      UserInfo? loginUser = await ApisUserinfo.login(userInfo: userInfo);
      // if login user is not null --> direct to application
      if (loginUser != null) {
        Get.offAllNamed(AppRoutes.APPLICATION);
      }
    } else {
      // direct to Login page
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }

  @override
  Widget build(BuildContext context) {
    //
    // Future.delayed(Duration(seconds: 3), () {
    //   Get.off(
    //     Login(),
    //     transition: Transition.fade, // Hiệu ứng mờ dần
    //     duration: Duration(seconds: 1), // Thời gian chuyển tiếp
    //   );
    // });

    init();
    //
    return Scaffold(
        body: Container(
        alignment: Alignment.center,

          child: Image.asset('assets/images/logo.png',
        width: 150,
        height: 150,
        fit: BoxFit.cover,  // Ảnh sẽ vừa khít với khung),
    )
    ));
  }
}
