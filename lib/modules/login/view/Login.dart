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

  void getConversation() {
    Get.toNamed(AppRoutes.CONVERSATIONS);
  }

  final CheckboxController checkboxController = Get.put(CheckboxController());

  /*
  * TODO:
  * If not username --> username == null, email != null
  * If not email --> email == null, username != null
  *   viết validate
  */
  void login(String accountName, String password) {
    loginController.login(null, accountName, password);
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
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Ẩn bàn phím
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 400,
                    height: 50,
                    margin: const EdgeInsets.only(top: 420),
                    child: TextField(
                      controller: accountNameCtl,
                      decoration: InputDecoration(
                        label: const Text('Username or email'),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 400,
                  height: 50,
                  child: TextField(
                    controller: passwordCtl,
                    decoration: InputDecoration(
                      label: const Text('Password'),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                child: Row(
                  children: [
                    Obx(() => Checkbox(
                          // Sử dụng Obx để theo dõi thay đổi
                          value: checkboxController.isChecked.value,
                          onChanged: (bool? value) {
                            checkboxController.toggleCheckbox(value);
                          },
                        )),
                    Obx(() => Text(checkboxController.isChecked.value
                        ? 'Save password'
                        : 'Non-Saving password')), // Hiển thị trạng thái
                  ],
                ),
              ),

              const SizedBox(
                height: 35,
              ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,  // Căn giữa hàng
              //
              //   children: [
              //   Container(
              //     alignment: Alignment.center,
              //     child: Image.asset('assets/images/phone.png',
              //     height: 30,
              //     fit: BoxFit.contain ,),
              //   ),
              //   const SizedBox(width: 25,),
              //
              //   Container(
              //     alignment: Alignment.center,
              //     child: Image.asset('assets/images/google.png',
              //       width: 30,
              //       height: 30,
              //       fit: BoxFit.contain ,),
              //   ),
              //   const SizedBox(width: 25,),
              //
              //   Container(
              //     alignment: Alignment.center,
              //     child: Image.asset('assets/images/facebook.png',
              //       width: 30,
              //       height: 30,
              //       fit: BoxFit.contain ,),
              //   ),
              //
              // ],
              // ),

              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  // onPressed: getConversation,
                  onPressed: () {
                    login(accountNameCtl.text, passwordCtl.text);
                  },
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  onPressed: getCreateAccount,
                  child: const Text("Create new accout"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
