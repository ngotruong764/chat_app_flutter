import 'package:chat_app_flutter/modules/login/view/Login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUp3 extends StatelessWidget {
  const SignUp3({super.key});


  @override
  Widget build(BuildContext context) {

    Future.delayed(Duration(seconds: 3), () {
      Get.off(Login(),
        transition: Transition.fade, // Hiệu ứng mờ dần
        duration: Duration(seconds: 1), // Thời gian chuyển tiếp
      );
    });

    return Scaffold(
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 300),
            child: Image.asset('assets/images/task.png'),
          ),

          const SizedBox(height: 40,),

          Container(
            child: const Text(
              "Signup Successfull",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 40,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
