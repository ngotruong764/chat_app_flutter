import 'dart:math';

import 'package:chat_app_flutter/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class SignUpOTP extends StatelessWidget {
   SignUpOTP({super.key});

  void getSignUp1(){
    Get.toNamed(AppRoutes.LOGIN);
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
          Obx(
            ()=> ElevatedButton(
              onPressed: () {
                if (code == '123456'){return getSignUp1();}
                else{
                  return error();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text('$code',
                style: TextStyle(fontSize: 20),
              ),
            ),
          )
        ],
      ),

    );
  }
}