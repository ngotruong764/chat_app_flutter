import 'package:chat_app_flutter/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget{
  const SplashScreen({super.key});

  void getSignUp1(){
    Get.toNamed(AppRoutes.LOGIN);
  }

  void  getSignUp2(){
    Get.toNamed(AppRoutes.LOGIN2);
  }


  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(title: Text('Lựa chọn')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Trả về dữ liệu và đóng màn hình
                getSignUp1();
              },
              child: Text('Tùy chọn 1'),
            ),
            ElevatedButton(
              onPressed: () {
                getSignUp2();

                // Trả về dữ liệu và đóng màn hình
                // Get.back(result: 'Tùy chọn 2');
              },
              child: Text('Tùy chọn 2'),
            ),
          ],
        ),
      ),
    );

  }

}