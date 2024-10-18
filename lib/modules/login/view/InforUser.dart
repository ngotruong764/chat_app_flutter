import 'package:chat_app_flutter/data/api/apis_base.dart';
import 'package:chat_app_flutter/model/user_info.dart';
import 'package:chat_app_flutter/modules/login/controller/login_controller.dart';
import 'package:chat_app_flutter/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
  final TextEditingController dobCtl = TextEditingController();
  //
  late String _currentGender;
  DateFormat formatter = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    // init current gender
    _currentGender = loginController.gender[0];
  }
  //
  void getSignUp3() {
    Get.toNamed(AppRoutes.LOGIN3);
  }

  void getCreateAccount() {
    Get.toNamed(AppRoutes.CREATACCOUNT);
  }

  // used to open dataPicker
  Future<void> _openDatePicker() async{
    DateTime? selectedDate = await showDatePicker(
        context: context,
        firstDate: loginController.firstDate,
        lastDate: loginController.lastDate,
    );
    if(selectedDate != null){
      String formatedDate = formatter.format(selectedDate);
      dobCtl.text = formatedDate;
    }
  }

  // create radio button
  Widget addRadioButton(int index, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Radio(
          // title: Text(loginController.gender[index]),
          value: loginController.gender[index],
          groupValue: _currentGender,
          onChanged: (gender) {
            setState(() {
              _currentGender = gender!;
            });
          },
        ),
        Text(title),
      ],
    );
  }

  // send request to update user info
  void updateUserRequest() async {
    String firstName = firstNameCtl.text;
    String lastName = lastNameCtl.text;
    String phoneNumber = phoneNumberCtl.text;
    DateTime dob = formatter.parse(dobCtl.text);
    String gender = _currentGender.toUpperCase();
    // get user info
    UserInfo userInfo = ApisBase.currentUser;
    // update UserInfo
    userInfo.firstname = firstName;
    userInfo.lastname = lastName;
    userInfo.phoneNumber = phoneNumber;
    userInfo.dob = dob;
    userInfo.sex = gender;
    // send request
    loginController.updateUser(userInfo);
  }

  @override
  void dispose() {
    super.dispose();
    firstNameCtl.dispose();
    lastNameCtl.dispose();
    phoneNumberCtl.dispose();
    dobCtl.dispose();
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
                    // autofocus: true, // Tự động mở bàn phím khi vào trường này
                    controller: phoneNumberCtl,
                    decoration: const InputDecoration(
                      label: Text('Phone number'),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(height: 15,),
                // Container(
                //   alignment: Alignment.centerLeft,
                //   margin: EdgeInsets.fromLTRB(16, 13, 0, 0),
                //   child: const Text('Date of birth',
                //     style: TextStyle(
                //       color: Colors.black,
                //       fontWeight: FontWeight.w500,
                //       fontSize: 16,
                //     ),),
                // ),

                const SizedBox(height: 10,),
                // const Row(
                //   children: [
                //     Expanded(
                //       child: TextField(
                //         decoration: InputDecoration(
                //           border: OutlineInputBorder(),
                //           hintText: 'Day',
                //         ),
                //       ),
                //     ),
                //     SizedBox(width: 10,),
                //     Expanded(
                //       child: TextField(
                //         decoration: InputDecoration(
                //           border: OutlineInputBorder(),
                //           hintText: 'Month',
                //         ),
                //       ),
                //     ),
                //     SizedBox(width: 10,),
                //     Expanded(
                //       child: TextField(
                //         decoration: InputDecoration(
                //           border: OutlineInputBorder(),
                //           hintText: 'Year',
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                // DOB form: dd/MM/yyyy
                TextFormField(
                  controller: dobCtl,
                  onTap: _openDatePicker,
                  readOnly: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.calendar_today),
                    label: Text('Date of birth'),
                    border: OutlineInputBorder(),
                  ),
                ),
                // Choose gender
                Row(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    addRadioButton(0, loginController.gender[0]),
                    addRadioButton(1, loginController.gender[1]),
                    addRadioButton(2, loginController.gender[2]),
                  ],
                ),
                // Container(
                //   alignment: Alignment.centerLeft,
                //   margin: const EdgeInsets.fromLTRB(16, 13, 0, 0),
                //   child: const Text('Sex',
                //     style: TextStyle(
                //       color: Colors.black,
                //       fontWeight: FontWeight.w500,
                //       fontSize: 16,
                //     ),),
                // ),
                // const Row(
                //   children: [
                //     Expanded(
                //       child: TextField(
                //         decoration: InputDecoration(
                //           border: OutlineInputBorder(),
                //           hintText: 'Male',
                //         ),
                //       ),
                //     ),
                //     const SizedBox(width: 10,),
                //     Expanded(
                //       child: TextField(
                //         decoration: InputDecoration(
                //           border: OutlineInputBorder(),
                //           hintText: 'Female',
                //         ),
                //       ),
                //     ),
                //     SizedBox(width: 10,),
                //     Expanded(
                //       child: TextField(
                //         decoration: InputDecoration(
                //           border: OutlineInputBorder(),
                //           hintText: 'Other',
                //         ),
                //       ),
                //     ),
                //   ],
                // ),

                const SizedBox(height: 80,),

                ElevatedButton(
                  onPressed: () {
                    updateUserRequest();
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