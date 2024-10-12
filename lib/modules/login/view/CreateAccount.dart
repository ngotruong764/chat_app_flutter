import 'package:chat_app_flutter/model/user_info.dart';
import 'package:chat_app_flutter/modules/login/controller/login_controller.dart';
import 'package:chat_app_flutter/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _Signup1State();
}

class _Signup1State extends State<CreateAccount> {

  final LoginController loginController = Get.put(LoginController());
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
    // dispose TextEditingController
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  void getSignUpOTP() {
    Get.toNamed(AppRoutes.LOGINOTP);
  }

  void getLogin() {
    Get.toNamed(AppRoutes.LOGIN);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Ẩn bàn phím
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 80),
                  alignment: Alignment.center,
                  child: const Text(
                    "Your information",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 80),
                //   child: const Text(
                //     "Your information",
                //     style: TextStyle(
                //       fontSize: 30,
                //       fontWeight: FontWeight.w700,
                //     ),
                //   ),
                // ),
            
                const SizedBox(height: 130),
            
                SizedBox(
                  width: 325,
                  height: 50,
                  child: TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Username',
                    ),
                  ),
                ),
            
                const SizedBox(height: 30),
                SizedBox(
                  width: 325,
                  height: 50,
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Email',
                    ),
                  ),
                ),
            
                const SizedBox(height: 30),
                SizedBox(
                  width: 325,
                  height: 50,
                  child: TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Password',
                    ),
                  ),
                ),
            
                const SizedBox(height: 30),
                SizedBox(
                  width: 325,
                  height: 50,
                  child: TextField(
                    controller: confirmPasswordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Confirm password',
                    ),
                  ),
                ),
            
                const SizedBox(height: 200,),

                ElevatedButton(
                  onPressed: () async {
                    String username = usernameController.text;
                    String email = emailController.text;
                    String password = passwordController.text;
                    // sent request
                    // UserInfo? userInfo =  await loginController.registerUser(username, email, password);
                    getSignUpOTP();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
            
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {getLogin();},
                  child: const Text('Do you have an account?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
