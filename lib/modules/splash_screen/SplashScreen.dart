import 'package:chat_app_flutter/modules/login/view/Login.dart';
import 'package:chat_app_flutter/data/storage/secure_storage.dart';
import 'package:chat_app_flutter/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../chat/ListConversations.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  // init
  void init() async{

    await Future.delayed(const Duration(seconds: 2));

    SecureStorage secureStorage = SecureStorage();
    String? data = await secureStorage.readSecureData('jwt_token');
    // if data == null --> not login --> go to login page
    if(data == null){
      Get.offAll(
            () => Login(),
        transition: Transition.fade, // Hiệu ứng mờ dần
        duration: const Duration(seconds: 1), // Thời gian chuyển tiếp
      );
    } else{
      // Get.offAllNamed(
      //   AppRoutes.CHATBOX
      // );
      Get.offAllNamed(AppRoutes.APPLICATION);
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
