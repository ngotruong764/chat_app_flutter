import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'new_pass.dart';

class ForgetOTP extends StatefulWidget{
  const ForgetOTP({super.key});
  
  State<StatefulWidget> createState() => _ForgetOTPState();
}

class _ForgetOTPState extends State<ForgetOTP>{
  String? errorMessage;




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background_login.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.fromLTRB(5, 40, 0, 0),
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
                  margin: const EdgeInsets.only(left: 20.0),
                  alignment: Alignment.centerLeft,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Confirm OTP ',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 5,),
                      Text(
                        'Please enter the latest OTP code. ',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                      ),

                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),

                SizedBox(
                  width: 380,
                  height: 50,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration:  InputDecoration(
                      prefixIcon: Icon(Icons.lock_clock),
                      border:  OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      labelText: 'Verification code',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
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
                const SizedBox(height: 30),

                SizedBox(
                  width: 380,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => EnterNewPass()));

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(fontSize: 20,),

                    ),
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