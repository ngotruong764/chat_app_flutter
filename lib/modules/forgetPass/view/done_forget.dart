import 'package:chat_app_flutter/modules/login/view/Login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UnForget extends StatelessWidget {
  const UnForget({super.key});


  @override
  Widget build(BuildContext context) {

    Future.delayed(const Duration(seconds: 3), () {
      Get.off(() => const Login(),
        transition: Transition.fade, // Hiệu ứng mờ dần
        duration: const Duration(seconds: 1), // Thời gian chuyển tiếp
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
            alignment: Alignment.center,
            child: const Text(
              "Change PassWord Successfull",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 40,
              ),
              textAlign: TextAlign.center,

            ),
          ),

        ],
      ),
    );
  }
}
