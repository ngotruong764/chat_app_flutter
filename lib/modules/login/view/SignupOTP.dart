import 'package:chat_app_flutter/data/api/apis_base.dart';
import 'package:chat_app_flutter/modules/login/controller/login_controller.dart';
import 'package:chat_app_flutter/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/user_info.dart';

class SignUpOTP extends StatefulWidget {
  const SignUpOTP({super.key});


  @override
  State<StatefulWidget> createState() => _VerificationEmailState();
}

class _VerificationEmailState extends State<SignUpOTP>{
  // login controller
  final LoginController loginController = Get.put(LoginController());
  // text controller
  final TextEditingController verificationCtl = TextEditingController();

  UserInfo userInfo = Get.arguments ?? UserInfo();

  void getInforUser() {
    Get.toNamed(AppRoutes.INFORUSER, arguments: userInfo);
  }

  var code = 'OTP'.obs;

  void error() {
    print('Incorrect OTP');
  }

  @override
  void dispose() {
    super.dispose();
    verificationCtl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(

          image: DecorationImage(
            image: AssetImage('assets/images/background_login.png'), // Đường dẫn ảnh
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
                    margin: const EdgeInsets.fromLTRB(5, 40, 0, 0), // Thêm padding
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new), // Thay thế icon bằng bất kỳ biểu tượng nào
                      color: Colors.black, // Màu của biểu tượng
                      iconSize: 30.0, // Kích thước biểu tượng
                      onPressed: () {
                        // Hành động khi nút được bấm
                        Get.back();
                      },
                    )
                ),

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
                      border:  OutlineInputBorder(),
                      // hintText: '$code',
                      hintText: 'Verification code',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 230,
                ),
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
                    backgroundColor: Colors.green,
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
