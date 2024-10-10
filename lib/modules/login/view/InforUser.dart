import 'package:chat_app_flutter/modules/login/controller/login_controller.dart';
import 'package:chat_app_flutter/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InforUser extends StatefulWidget {
   const InforUser({super.key});


  @override
  State<StatefulWidget> createState() =>_InfoUserState();
}

class _InfoUserState extends State<InforUser>{
  // Login controller
  final LoginController loginController = LoginController();
  // Text editing controller
  final TextEditingController firstNameCtl = TextEditingController();
  final TextEditingController lastNameCtl = TextEditingController();
  final TextEditingController phoneNumberCtl = TextEditingController();
  //
  void getSignUp3() {
    Get.toNamed(AppRoutes.LOGIN3);
  }

  void getCreateAccount() {
    Get.toNamed(AppRoutes.CREATACCOUNT);
  }

  @override
  void dispose() {
    super.dispose();
    firstNameCtl.dispose();
    lastNameCtl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Ẩn bàn phím
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                        getCreateAccount();
                      },
                    )
                ),
                Container(
                  margin: const EdgeInsets.only(top: 0),
                  alignment: Alignment.center,
                  child: const Text(
                    "Create new account ",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: firstNameCtl,
                        decoration: const InputDecoration(
                          label: Text("First name"),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 22,
                    ),
                    Expanded(
                      child: TextField(
                        controller: lastNameCtl,
                        decoration: const InputDecoration(
                          label: Text('Last name'),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15,),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextField(
                    autofocus: true, // Tự động mở bàn phím khi vào trường này
                    controller: phoneNumberCtl,
                    decoration: const InputDecoration(
                      label: Text('Phone number'),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 15,),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(16, 13, 0, 0),
                  child: const Text('Date of birth',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),),
                ),

                const SizedBox(height: 10,),
                const Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Day',
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Month',
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Year',
                        ),
                      ),
                    ),
                  ],
                ),

                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.fromLTRB(16, 13, 0, 0),
                  child: const Text('Sex',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),),
                ),
                const Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Male',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Female',
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: TextField(

                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Other',
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 80,),

                ElevatedButton(
                  onPressed: () {
                    getSignUp3();
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