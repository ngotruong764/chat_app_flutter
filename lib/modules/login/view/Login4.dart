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

class Login4 extends StatelessWidget {
  Login4({super.key});


  void getSignUp1() {
    Get.toNamed(AppRoutes.LOGIN);
  }

  void getChatBox() {
    Get.toNamed(AppRoutes.CHATBOX);
  }

  final CheckboxController checkboxController = Get.put(CheckboxController());

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
                    margin: EdgeInsets.only(top: 420),
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)

                          ),
                          hintText: 'Username or email'),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 400,
                  height: 50,
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)
                        ), hintText: 'Password'),
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
                        : 'Non-Saving password')
                    ), // Hiển thị trạng thái
                  ],
                ),
              ),
              
              const SizedBox(height: 35,),
              
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

              const SizedBox(height: 30,),

              Container(
                width: 300,
                height: 50,
                child: ElevatedButton(onPressed: getChatBox,
                    child:Text('Login')
                ),
              ),
              const SizedBox(height: 10,),

              Container(
                width: 300,
                height: 50,
                child: ElevatedButton(onPressed: getSignUp1,
                    child:Text("Create new accout")),
              )

            ],
            
          ),
        ),
      ),
    );
  }
}
