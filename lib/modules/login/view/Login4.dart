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

   final CheckboxController checkboxController = Get.put(CheckboxController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(width: 400, height: 50,
              margin: EdgeInsets.only(top: 480),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Username or email'
                ),
              ),
            ),
          ),
          const SizedBox(height: 5,),

          Align(
            alignment: Alignment.center,
            child: Container(width: 400, height: 50,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Password'
                ),
              ),
            ),
          ),
          const SizedBox(height: 10,),

          Row(
            children: [
              Obx(() => Checkbox( // Sử dụng Obx để theo dõi thay đổi
                value: checkboxController.isChecked.value,
                onChanged: (bool? value) {
                  checkboxController.toggleCheckbox(value);
                },
              )),
              Obx(() => Text(checkboxController.isChecked.value ? 'Save password' : 'Non-Saving password')), // Hiển thị trạng thái
        ],
          ),
      ],
    ),
    );
  }
}
