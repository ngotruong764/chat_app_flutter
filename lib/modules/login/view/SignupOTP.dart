import 'package:chat_app_flutter/data/api/apis_base.dart';
import 'package:chat_app_flutter/modules/login/controller/login_controller.dart';
import 'package:chat_app_flutter/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helper/my_dialog.dart';
import '../../../model/user_info.dart';

class SignUpOTP extends StatefulWidget {
  const SignUpOTP({super.key});

  @override
  State<StatefulWidget> createState() => _VerificationEmailState();
}

class _VerificationEmailState extends State<SignUpOTP> {
  // login controller
  final LoginController loginController = Get.put(LoginController());

  // text controller
  final TextEditingController verificationCtl = TextEditingController();
  String? errorMessage;

  UserInfo userInfo = Get.arguments ?? UserInfo();

  void getInforUser() {
    Get.toNamed(AppRoutes.INFORUSER, arguments: userInfo);
  }

  var code = 'OTP'.obs;

  void error() {
    print('Incorrect OTP');
  }

  void confirmedOtp(String OTP) async {
    if (OTP.isEmpty) {
      setState(() {
        errorMessage = "OTP must be filled out";
      });
      return;
    }
  }

  @override
  void dispose() {
    super.dispose();
    verificationCtl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus(); // Ẩn bàn phím
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.fromLTRB(5, 40, 0, 0),
                        // Thêm padding
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new),
                          color: Colors.black,
                          iconSize: 30.0,
                          onPressed: () {
                            Get.back();
                          },
                        )),

                    const SizedBox(
                      height: 200,
                    ),

                    Container(
                      margin: const EdgeInsets.only(top: 0),
                      alignment: Alignment.center,
                      // child: const Text(
                      //   'Verification email',
                      //   style: TextStyle(
                      //     fontSize: 30,
                      //     fontWeight: FontWeight.w700,
                      //   ),
                      // ),
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                    SizedBox(
                      width: 325,
                      height: 50,
                      child: TextField(
                        controller: verificationCtl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.lock_clock),
                          border: OutlineInputBorder(),
                          label: Text('Verification code'),
                          // hintText: '$code',
                          // hintText: 'Verification code',
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

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
                    // const SizedBox(
                    //   height: 230,
                    // ),
                    ElevatedButton(
                      onPressed: () async {
                        // get user
                        UserInfo userInfo = ApisBase.currentUser;
                        userInfo.verificationCode = verificationCtl.text;
                        await loginController.confirmAccount(userInfo);
                        //
                        getInforUser();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Obx(() => loginController.isLoading.value
            ? MyDiaLog.loading()
            : const SizedBox.shrink()),
      ],
    );
  }
}

// class SnackBarPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('SnackBar Example'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             // Tạo và hiển thị SnackBar
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text('Hello! This is a SnackBar.'),
//                 duration: Duration(seconds: 3),  // Thời gian hiển thị SnackBar
//                 action: SnackBarAction(
//                   label: 'Undo',
//                   onPressed: () {
//                     // Hành động khi nhấn nút "Undo"
//                     print('Undo pressed');
//                   },
//                 ),
//               ),
//             );
//           },
//           child: Text('Show SnackBar'),
//         ),
//       ),
//     );
//   }
// }
