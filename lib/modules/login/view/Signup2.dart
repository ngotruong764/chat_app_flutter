import 'package:chat_app_flutter/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUp2 extends StatelessWidget {
   SignUp2({super.key});

  void getSignUp3() {
    Get.toNamed(AppRoutes.LOGIN3);
  }

  void getSignUp1() {
    Get.toNamed(AppRoutes.LOGIN);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    getSignUp1();
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
              children: const [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'First name',
                    ),
                  ),
                ),
                SizedBox(
                  width: 22,
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Last name',
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15,),

            const SizedBox(
              width: double.infinity,
              height: 50,
              child: TextField(
                autofocus: true, // Tự động mở bàn phím khi vào trường này

                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Telephone number',
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

            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Day',
                    ),
                  ),
                ),
                const SizedBox(width: 10,),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Month',
                    ),
                  ),
                ),
                const SizedBox(width: 10,),
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
              margin: EdgeInsets.fromLTRB(16, 13, 0, 0),
              child: const Text('Sex',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),),
            ),

            Row(
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
                const SizedBox(width: 10,),
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
    );
  }
}