import 'package:chat_app_flutter/modules/forgetPass/controller/forget_pass_controller.dart';
import 'package:chat_app_flutter/modules/forgetPass/view/new_pass.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../login/view/Login.dart';

class ForgetPassword extends GetView<ForgetPassController> {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();

    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background_login.png'),
              // Đường dẫn ảnh
              fit: BoxFit.cover, // Căn chỉnh ảnh (cover, contain, fill...)
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 300),

                const Text(
                  "Forget Password",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 40,
                  ),
                ),

                const SizedBox(height: 20),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Please enter your email to receive a reset password link.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // TextField nhập email
                SizedBox(
                  width: 380,
                  height: 50,

                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      prefixIcon: const Icon(Icons.email),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Nút gửi yêu cầu reset password
                SizedBox(
                  width: 380,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async{
                      pushVerificationCode(textController.text, context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => EnterNewPass()));
                      // Hành động gửi yêu cầu reset password
                      Get.snackbar(
                        "Email Sent",
                        "A reset password link has been sent to your email.",
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 2),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      backgroundColor: Colors.blue, // Màu nền của nút
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),

                SizedBox(
                  height: 30,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Login(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back_ios),
                        Text(
                          'Back to Login',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          )),
    );
  }

  void pushVerificationCode(String userEmail, BuildContext context) async{
    if(userEmail.isNotEmpty){
      bool isSent = await controller.pushVerificationCode(userEmail);

      if(isSent){
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => EnterNewPass()));
        // Hành động gửi yêu cầu reset password
        Get.snackbar(
          "Email Sent",
          "A reset password link has been sent to your email.",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    }
  }
}
