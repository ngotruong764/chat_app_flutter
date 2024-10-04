import 'dart:math';

import 'package:chat_app_flutter/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';




class SignUp1 extends StatelessWidget {
  const SignUp1({super.key});


  void getSignUpOTP(){
    Get.toNamed(AppRoutes.LOGINOTP);
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
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

            const SizedBox(height: 130),

            const SizedBox(
              width: 325,
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Name login',
                ),
              ),
            ),

            const SizedBox(height: 30),
            const SizedBox(
              width: 325,
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Email address',
                ),
              ),
            ),

            const SizedBox(height: 30),
            const SizedBox(
              width: 325,
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Input password',
                ),
              ),
            ),

            const SizedBox(height: 30),
            const SizedBox(
              width: 325,
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Confirm password',
                ),
              ),
            ),

            const SizedBox(height: 230,),
            ElevatedButton(
              onPressed: () {
                getSignUpOTP();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text("Next",
                style: TextStyle(fontSize: 20),
              ),
            ),

            const SizedBox(height: 10,),
            TextButton(
              onPressed: () {
                // Handle button press
              },
              child: const Text('Do you have a account?'),
            ),
          ],
        ),
    );
  }
}