import 'package:flutter/material.dart';

class SignUp3 extends StatelessWidget {
  const SignUp3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 160),
            child: Image.asset('assets/images/task.png'),
          ),
          Container(
            child: const Text(
              "Sigup Successfull",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 50,
              ),
            ),
          )
        ],
      ),
    );
  }
}
