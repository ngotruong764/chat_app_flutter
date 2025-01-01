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
  final TextEditingController confirmPasswordController = TextEditingController();
  String? errorMessage;



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

  void register(String username,  String email, String password, String confirmPassword) async {

    print("Password: '$password'");
    print("Confirm Password: '$confirmPassword'");
    print("Password.trim(): '${password.trim()}'");
    print("Confirm Password.trim(): '${confirmPassword.trim()}'");

    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        errorMessage = "All information must be filled out!";
      });
      return;
    }
    if (password.trim() != confirmPassword.trim()) {
      setState(() {
        errorMessage = "Passwords do not match!";
      });
      return;
    }

    // create UserInfo object
    UserInfo? user = await loginController.registerUser(username, email, password);
    if (user != null) {
      Get.toNamed(AppRoutes.LOGINOTP);
    } else {
      setState(() {
        errorMessage = "Registration failed. Please try again!";
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background_login.png'),
            fit: BoxFit.cover, // Căn chỉnh ảnh (cover, contain, fill...)
          ),
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 80),
                    alignment: Alignment.center,
                    // child: const Text(
                    //   "Your information",
                    //   style: TextStyle(
                    //     fontSize: 30,
                    //     fontWeight: FontWeight.w700,
                    //   ),
                    // ),
                  ),

                  const SizedBox(height: 230),

                  SizedBox(
                    width: 325,
                    height: 50,
                    child: TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person), // Icon cho username
                        hintText: 'Username',
                        // hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  SizedBox(
                    width: 325,
                    height: 50,
                    child: TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress, // Tối ưu bàn phím cho email

                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Email',
                        // hintStyle: TextStyle(color: Colors.white),

                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  SizedBox(
                    width: 325,
                    height: 50,
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Password',
                        // hintStyle: TextStyle(color: Colors.white),

                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  SizedBox(
                    width: 325,
                    height: 50,
                    child: TextField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Confirm password',
                        // hintStyle: TextStyle(color: Colors.white),

                      ),
                    ),
                  ),


                  const SizedBox(height: 10,),

                  if (errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 200,),

                  ElevatedButton(

                    onPressed: () async {
                      register(
                        usernameController.text.trim(), // username
                        emailController.text.trim(),    // email
                        passwordController.text.trim(), // password
                        confirmPasswordController.text.trim(), // confirmPassword
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5, // Tạo bóng đổ
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
                    child: const Text('Do you have an account?',
                      style: TextStyle(
                        fontSize: 16,
                        // decoration: TextDecoration.underline,
                        color: Colors.blue,
                      ),),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
