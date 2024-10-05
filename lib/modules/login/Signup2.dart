
import 'package:chat_app_flutter/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUp2 extends StatelessWidget {
   SignUp2({super.key});

  // void getSignUp3() {
  //   Get.toNamed(AppRoutes.LOGIN3);
  // }
  //
  // void getSignUp1() {
  //   Get.toNamed(AppRoutes.LOGIN);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 80),
            alignment: Alignment.center,
            child: const Text(
              "Create new account 2",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          const Row(
            children: [
              SizedBox(
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Frist name',
                  ),
                ),
              ),
              const SizedBox(
                width: 22,
              ),
              SizedBox(
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Last name',
                  ),
                ),
              )
            ],
          ),

          const SizedBox(
            width: 325,
            height: 50,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Telephone number',
              ),
            ),
          ),

          const SizedBox(height: 15,),

          Container(
            child: const Text('Date of birth', style: TextStyle(color: Colors.black),), ),

          Row(
            children: [
              SizedBox(
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Day',
                  ),
                ),
              ),

              // const SizedBox(width: 10,),

              SizedBox(
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Month',
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                  child: TextField(
                      decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Year',
              )))
            ],
          ),

          Row(
            children: [
              SizedBox(
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Day',
                  ),
                ),
              ),

              // const SizedBox(width: 10,),

              SizedBox(
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Month',
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),


              SizedBox(
                  child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Year',
                      )))
            ],
          ),
        ],
      ),
    );

  }
}
