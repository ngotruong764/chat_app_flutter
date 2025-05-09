import 'package:chat_app_flutter/data/api/apis_base.dart';
import 'package:chat_app_flutter/helper/my_dialog.dart';
import 'package:chat_app_flutter/model/user_info.dart';
import 'package:chat_app_flutter/modules/login/controller/login_controller.dart';
import 'package:chat_app_flutter/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckboxController extends GetxController {
  // Observable boolean variable
  RxBool isChecked = false.obs;

  // Function to toggle checkbox value
  void toggleCheckbox(bool? value) {
    isChecked.value = value!;
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final LoginController loginController = Get.put(LoginController());
  final TextEditingController accountNameCtl = TextEditingController();
  final TextEditingController passwordCtl = TextEditingController();

  //
  void getCreateAccount() {
    Get.toNamed(AppRoutes.CREATACCOUNT);
  }

  void directToApplication() {
    Get.toNamed(AppRoutes.APPLICATION);
  }

  void forgotPassWord() {
    Get.toNamed(AppRoutes.FOGGOTPASSWORD);
  }

  final CheckboxController checkboxController = Get.put(CheckboxController());

  /*
  * TODO:
  * If not username --> username == null, email != null
  * If not email --> email == null, username != null
  *   viết validate
  */
  String? errorMessage;

  void login(String accountName, String password) async {
    if (accountName.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = "Username or password cannot be empty!";
      });
      return;
    }

    // create UserInfo object
    UserInfo userInfo =
        UserInfo(username: null, email: accountName, password: password);
    UserInfo? user = await loginController.login(userInfo);
    if (user != null) {
      // redirect to application
      Get.offAllNamed(AppRoutes.APPLICATION);
    } else {
      setState(() {
        errorMessage = "Incorrect email or password";
      });
    }
  }

  // dispose
  @override
  void dispose() {
    super.dispose();
    accountNameCtl.dispose();
    passwordCtl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Talkie.png'), // Đường dẫn ảnh
                fit: BoxFit.cover, // Căn chỉnh ảnh (cover, contain, fill...)
              ),
            ),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus(); // Ẩn bàn phím
              },
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: 400,
                              height: 50,
                              margin: const EdgeInsets.only(top: 500),
                              child: TextField(
                                controller: accountNameCtl,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.email_rounded),
                                  label: const Text('Username or email'),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: 400,
                              height: 50,
                              child: TextField(
                                controller: passwordCtl,
                                obscureText: true,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.lock),
                                  label: const Text('Password'),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              // Container(
                              //   margin: const EdgeInsets.only(left: 15.0),
                              //   alignment: Alignment.centerLeft, // Căn sang lề phải
                              //   child: Row(
                              //     children: [
                              //       Obx(() => Checkbox(
                              //         // Sử dụng Obx để theo dõi thay đổi
                              //         value: checkboxController.isChecked.value,
                              //         onChanged: (bool? value) {
                              //           checkboxController
                              //               .toggleCheckbox(value);
                              //         },
                              //       )),
                              //       Obx(() => Text(
                              //           checkboxController.isChecked.value
                              //               ? 'Save password'
                              //               : 'Non-Saving password')),
                              //       // Hiển thị trạng thái
                              //     ],
                              //   ),
                              // ),
                              const Spacer(),
                              Container(
                                margin: const EdgeInsets.only(right: 25.0),
                                alignment: Alignment.centerRight,
                                // Căn sang lề phải
                                child: TextButton(
                                  onPressed: forgotPassWord,
                                  child: const Text(
                                    'Forget password?',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          if (errorMessage != null)
                            Container(
                              padding: const EdgeInsets.only(left: 30.0),
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'Error message',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          const SizedBox(
                            height: 35,
                          ),
                          SizedBox(
                            width: 300,
                            height: 50,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    )),
                                onPressed: () {
                                  login(accountNameCtl.text, passwordCtl.text);
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.login,
                                        size: 20, color: Colors.white),
                                    SizedBox(width: 10),
                                    Text(
                                      'Login',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                                  ],
                                )),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 300,
                            height: 50,
                            child: ElevatedButton(
                                onPressed: getCreateAccount,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.person_add,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "Create new accout",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        Obx(() => loginController.isLoading.value ? MyDiaLog.loading() : const SizedBox.shrink()),
      ],
    );
  }
}
