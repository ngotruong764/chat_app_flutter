import 'dart:convert';
import 'package:flutter/material.dart';

class User {
  final String avatar;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String sex;
  final String phoneNumber;


  User({
    required this.avatar,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.sex,
    required this.phoneNumber,


  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      avatar: json['avatar'],
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      sex: json['sex'],
      phoneNumber: json['phone_number'],
      email: json['email'],
    );
  }
}

Future<User> fetchUserData() async {
  await Future.delayed(Duration(seconds: 2));
  return User(
    avatar: 'https://example.com/avatar.jpg',
    username: 'huy_tran',
    firstName: 'Tran',
    lastName: 'Huy',
    email: 'tranngochuy2611@gmail.com',
    sex: 'Male',
    phoneNumber: '0123456789',

  );
}

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _sexController;
  late TextEditingController _phoneNumberController;


  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _sexController = TextEditingController();
    _phoneNumberController = TextEditingController();

    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      User user = await fetchUserData();
      _usernameController.text = user.username;
      _firstNameController.text = user.firstName;
      _lastNameController.text = user.lastName;
      _sexController.text = user.sex;
      _emailController.text = user.email;
      _phoneNumberController.text = user.phoneNumber;
      setState(() {});
    } catch (e) {
      // Xử lý lỗi nếu API call thất bại
      print('Error: $e');
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _sexController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Profile')),
      body: FutureBuilder<User>(
        future: fetchUserData(),
        // Không cần `_getUserData()` nếu không sử dụng State
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            User user = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(user.avatar),
                      ),
                      SizedBox(width: 20),
                      Column(
                        children: [
                          Text(
                            '${user.firstName} ${user.lastName}',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '@${user.username}',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      )
                    ],
                  ),

                  SizedBox(height: 25),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            label: Text("First name"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 22,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            label: Text('Last name'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  Container(
                    child: Align(
                      alignment: Alignment.center,
                      child: TextField(
                        controller: _sexController,
                        decoration: InputDecoration(
                          labelText: 'Sex', // Hiển thị label
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  Container(
                    child: Align(
                      alignment: Alignment.center,
                        child: TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'User Name', // Hiển thị label
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    // ),
                  ),

                  SizedBox(height: 20),

                  Container(
                    child: Align(
                      alignment: Alignment.center,
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email', // Hiển thị label
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),




                  Container(
                    child: Align(
                      alignment: Alignment.center,
                      child: TextField(
                        controller: _phoneNumberController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number', // Hiển thị label
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ),


                  // User info
                ],
              ),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

