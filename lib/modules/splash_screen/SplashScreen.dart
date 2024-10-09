import 'package:chat_app_flutter/modules/login/view/Login.dart';
import 'package:chat_app_flutter/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //
    Future.delayed(Duration(seconds: 3), () {
      Get.off(
        Login(),
        transition: Transition.fade, // Hiệu ứng mờ dần
        duration: Duration(seconds: 1), // Thời gian chuyển tiếp
      );
    });

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
