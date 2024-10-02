import 'package:flutter/material.dart';




class SignUp1 extends StatelessWidget {
  const SignUp1({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            alignment: Alignment.center,
            child: const Text(
              "Create new account",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          // const SizedBox(height: 130),
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
          // const SizedBox(height: 30),
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
          // const SizedBox(height: 30),
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
          // const SizedBox(height: 30),
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

          // const SizedBox(height: 20,),
          ElevatedButton(
            onPressed: () {},
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
            child: Text('Do you have a account?'),
          ),
          // ... more widgets



        ],
      ),
    );
  }
}