import 'package:chat_app_flutter/modules/forgetPass/view/done_forget.dart';
import 'package:flutter/material.dart';

class EnterNewPass extends StatefulWidget {
  const EnterNewPass({super.key});

  State<EnterNewPass> createState() => _EnterNewPassState();
}

class _EnterNewPassState extends State<EnterNewPass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background_login.png'),
            fit: BoxFit.cover, // Căn chỉnh ảnh (cover, contain, fill...)
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 300,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20.0),
                  alignment: Alignment.centerLeft,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reset your password ',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 5,),
                      Text(
                            'Please choose a new password to finish signing in. ',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                      ),

                    ],
                  ),
                ),

                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: 380,
                  height: 50,
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.password), // Icon cho username
                      labelText: 'New password',
                      // hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 380,
                  height: 50,
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.password), // Icon cho username
                      labelText: 'Re-enter new password',
                      // hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                SizedBox(
                  width: 380,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UnForget(),
                          ),
                      );
                      // Hành động khi button được nhấn
                      print("Button pressed!");
                    },
                    child: const Text(
                      'Change password', // Nội dung văn bản của nút
                      style: TextStyle(
                        fontSize: 16, // Cỡ chữ
                        fontWeight: FontWeight.bold,
                        color: Colors.white// Đậm chữ
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Màu nền của button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0), // Bo góc button
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0), // Padding cho button
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
