import 'dart:math';

import 'package:chat_app_flutter/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';





class SignUpOTP extends StatelessWidget {
   SignUpOTP({super.key});

  void getSignUp3(){
    Get.toNamed(AppRoutes.LOGIN3);
  }

  var code = 'OTP'.obs;

  void error(){
    print('Incorrect OTP');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 80),
            alignment: Alignment.center,

            child: Text('Confirm OTP code',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 150,),

          SizedBox(
            width: 325,
            height: 50,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '$code',
              ),
            ),
          ),

          const SizedBox(height: 230,),


         ElevatedButton(
              onPressed: () {
               return getSignUp3();},



              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text('Next',
                style: TextStyle(fontSize: 20),
              ),
            ),

        ],
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