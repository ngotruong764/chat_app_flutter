import 'package:chat_app_flutter/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpOTP extends StatelessWidget {
  SignUpOTP({super.key});

  void getInforUser() {
    Get.toNamed(AppRoutes.INFORUSER);
  }

  var code = 'OTP'.obs;

  void error() {
    print('Incorrect OTP');
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
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(5, 40, 0, 0), // Thêm padding
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new), // Thay thế icon bằng bất kỳ biểu tượng nào
                  color: Colors.black, // Màu của biểu tượng
                  iconSize: 30.0, // Kích thước biểu tượng
                  onPressed: () {
                    // Hành động khi nút được bấm
                    Get.back();
                  },
                )
              ),
          
              Container(
                margin: const EdgeInsets.only(top: 0),
                alignment: Alignment.center,
                child: const Text(
                  'Verification email',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              const SizedBox(
                width: 325,
                height: 50,
                child: TextField(
                  decoration: InputDecoration(
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
                onPressed: () {
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
