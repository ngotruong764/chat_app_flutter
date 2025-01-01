import 'dart:convert';
import 'dart:typed_data';

import 'package:chat_app_flutter/data/api/apis_base.dart';
import 'package:chat_app_flutter/helper/helper.dart';
import 'package:chat_app_flutter/model/user_info.dart';
import 'package:chat_app_flutter/modules/settings/controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constants/constants.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final UserInfo currentUser = ApisBase.currentUser;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  RxList<int> userAvatar = <int>[].obs;
  final SettingsController settingsController = Get.put(SettingsController());
  late String _currentGender;
  bool isUpdated = false;
  String profilePicturePath = '';
  RxBool isLoading = false.obs;


  @override
  void initState() {
    super.initState();
    userAvatar.value = Constants.USER_AVATAR;
    _firstNameController.text = currentUser.firstname ?? '';
    _lastNameController.text = currentUser.lastname ?? '';
    _usernameController.text = currentUser.username ?? '';
    _emailController.text = currentUser.email ?? '';
    _phoneNumberController.text = currentUser.phoneNumber ?? '';
    _currentGender = (currentUser.sex != null ? currentUser.sex!.capitalizeFirst :  'Male')!;
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _sexController.dispose();
    _phoneNumberController.dispose();
    settingsController.dispose();
  }

  /*
  * Method to display user avatar
  *   if user has an avatar --> display avatar
  *   else display default icon
  */
  Widget _displayUserAvatar() {
    return GestureDetector(
      onTap: _selectImage,
      child: Obx(
        () => Stack(
          alignment: Alignment.center,
          children: <Widget>[
            if (userAvatar.isNotEmpty) ...[
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  child: Image.memory(
                    Uint8List.fromList(userAvatar),
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                  ),
                )
            ] else ...[
                const Icon(
                  Icons.account_circle_rounded,
                  size: 110,
                  color: Colors.grey,
                ),
            ],
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.blue,
                ),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    // convert img to bytes
    if(image != null){
      userAvatar.value = await Helper.encodeAnImgToBytes(image);
      // set profile picture path
      profilePicturePath = image.path;
      List<String> pathList = profilePicturePath.split('/');
      pathList.last = '${pathList.last.split('.')[0]}-${DateTime.now().microsecondsSinceEpoch}.${pathList.last.split('.')[1]}';
      profilePicturePath = pathList.last;
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = Get.height;
    final width = Get.width;
    return Scaffold(
      appBar: AppBar(
          // leading: ,
          title: const Text('User Profile')
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Avatar
                  _displayUserAvatar(),
                  SizedBox(width:width * 0.025),
                  // first name + last name
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${currentUser.firstname} ${currentUser.lastname}',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      // user name
                      Text(
                        '@${currentUser.username}',
                        style: const TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: height * 0.025),
              Row(
                children: [
                  // first name
                  Expanded(
                    child: TextField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        label: const Text("First name"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.04,
                  ),
                  // last name
                  Expanded(
                    child: TextField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        label: const Text('Last name'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.02),
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
              SizedBox(height: height * 0.02),
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
              SizedBox(height: height * 0.02),
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
              SizedBox(height: height * 0.02),
              Row(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  addRadioButton(0, settingsController.gender[0]),
                  addRadioButton(1, settingsController.gender[1]),
                  addRadioButton(2, settingsController.gender[2]),
                ],
              ),
              SizedBox(height: height * 0.025),
              Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: _updateUserInfo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                    shadowColor: Colors.transparent,
                    elevation: 0.0,
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  Widget addRadioButton(int index, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Radio(
          value: settingsController.gender[index],
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

  /*
  * Method to update User info
  */
  void _updateUserInfo() async {
    // get current user info
    UserInfo userInfo = ApisBase.currentUser;

    // get params
    userInfo.firstname = _firstNameController.text.trim();
    userInfo.lastname = _lastNameController.text.trim();
    userInfo.username = _usernameController.text.trim();
    userInfo.email = _emailController.text.trim();
    userInfo.phoneNumber = _phoneNumberController.text.trim();
    userInfo.sex = _currentGender.toUpperCase();
    userInfo.profilePicture = profilePicturePath;
    if(userAvatar.isNotEmpty){
      userInfo.profilePictureBase64 = base64Encode(userAvatar);
    }

    // update user
    UserInfo? updatedUser =  await settingsController.updateUser(userInfo);

    // update img
    if(updatedUser != null){
      Constants.USER_AVATAR.value = userAvatar;
    }
  }


}

