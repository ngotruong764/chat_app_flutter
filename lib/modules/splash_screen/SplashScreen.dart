import 'package:chat_app_flutter/modules/login/view/Login4.dart';
import 'package:chat_app_flutter/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget{
  const SplashScreen({super.key});




  @override
  Widget build(BuildContext context) {

    Future.delayed(Duration(seconds: 3), () {
      Get.off(Login4(),
        transition: Transition.fade, // Hiệu ứng mờ dần
        duration: Duration(seconds: 1), // Thời gian chuyển tiếp
      );
    });

    return Scaffold(
      appBar: AppBar(title: Text('Lựa chọn')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

          ],
        ),
      ),
    );

  }

}