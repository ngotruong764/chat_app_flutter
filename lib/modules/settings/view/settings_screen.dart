import 'dart:typed_data';

import 'package:chat_app_flutter/constants/constants.dart';
import 'package:chat_app_flutter/data/api/apis_base.dart';
import 'package:chat_app_flutter/model/user_info.dart';
import 'package:chat_app_flutter/modules/settings/controller/settings_controller.dart';
import 'package:chat_app_flutter/services/push_notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/api/apis_user_info.dart';
import '../../../routes/app_routes.dart';
import '../../login/view/Login.dart';
import 'user_profile_screen.dart';



class SettingsPage extends StatefulWidget {
   const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>{
  final currentUser = ApisBase.currentUser;
  late final SettingsController settingsController;

  @override
  void initState() {
    super.initState();
    // create instance of SettingsController
    settingsController = Get.put<SettingsController>(SettingsController());
  }

  @override
  void dispose() {
    super.dispose();
    // dispose instance of SettingsController
    // settingsController.dispose();
  }


  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Không cho phép đóng pop-up ngoài vùng
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Do you want logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () async{
                logOut();
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login())
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildSettingsItem(IconData icon, String title, String trailing, Color iconColor, BuildContext context, GestureTapCallback? onTap) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title),
      trailing: trailing.isNotEmpty ? Text(trailing, style: const TextStyle(color: Colors.grey)) : const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  // logout function
  void logOut() async {
    // get share preferences instance
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userInfo');
    // logout request
    await ApisUserinfo.logout(ApisBase.currentUser);
    // create empty user info
    ApisBase.currentUser = UserInfo();
    // delete device token
    PushNotificationsService.deleteDeviceToken();
    // direct to login page
    Get.offAllNamed(AppRoutes.LOGIN);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // user avatar
              _displayUserAvatar(),
              SizedBox(height: Get.height * 0.001,),
              // user name
              Text(
                ApisBase.currentUser.username ?? '',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: Get.height * 0.005,),
              // edit button
              SizedBox(
                width: Get.width * 0.5,
                child: ElevatedButton(
                  onPressed: _navigateToUserInfo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                    shadowColor: Colors.transparent,
                    elevation: 0.0,
                  ),
                  child: const Text(
                    'Edit profile',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    ),
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.03,),
              // building settings item
              buildSettingsItem(Icons.person, "Information", "", Colors.green, context, _navigateToUserInfo),
              // buildSettingsItem(Icons.nightlight_round, "Dark mode", "On", Colors.grey, context),
              buildSettingsItem(Icons.circle, "Active status", "On", Colors.green, context, () {}),
              buildSettingsItem(Icons.accessibility_new, "Accessibility", "", Colors.grey, context, () {}),
              // buildSettingsItem(Icons.privacy_tip, "Privacy & safety", "", Colors.blue, context),
              buildSettingsItem(Icons.supervised_user_circle, "Supervision", "", Colors.blue, context, () {}),
              // buildSettingsItem(Icons.person, "Avatar", "", Colors.purple, context, () {}),
              buildSettingsItem(Icons.notifications, "Notifications & sounds", "On", Colors.pink, context, () {}),
              buildSettingsItem(Icons.shopping_bag, "Orders", "", Colors.green, context, () {}),
              buildSettingsItem(Icons.photo, "Photos & media", "", Colors.purple, context, () {}),
          ListTile(
              leading: const Icon(Icons.logout, color: Colors.black),
              title: const Text("Logout"),
              trailing:  const Icon(Icons.chevron_right),
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (context) => _showLogoutDialog ())
                // );
                _showLogoutDialog(context);
              },
            ),
            ],

          ),
        ),
      ),

    );
  }

  /*
  * Method to display user avatar
  *   if user has an avatar --> display avatar
  *   else display default icon
  */
  Widget _displayUserAvatar() {
    return Obx(
            () => Stack(
          alignment: Alignment.center,
          children: <Widget>[
            if (Constants.USER_AVATAR.isNotEmpty) ...[
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                child: Image.memory(
                  Uint8List.fromList(Constants.USER_AVATAR),
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
    );
  }

  /*
  * Method to navigate to user profile
  */
  void _navigateToUserInfo() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const UserProfileScreen()));
  }
}

// class _SettingsPageState extends State<SettingsPage>{
//   final currentUser = ApisBase.currentUser;
//   late final SettingsController settingsController;
//
//   @override
//   void initState() {
//     super.initState();
//     // create instance of SettingsController
//     settingsController = Get.put<SettingsController>(SettingsController());
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     // dispose instance of SettingsController
//     settingsController.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text("Settings"),
//
//       ),
//
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Thông tin người dùng
//             Container(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   CircleAvatar(
//                     radius: 50,
//                     backgroundImage: NetworkImage(
//                       'https://randomuser.me/api/portraits/men/75.jpg',
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     '${currentUser.username}',
//                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             ),
//
//             ListTile(
//               leading: const Icon(Icons.security, color: Colors.blue),
//               title: const Text("Information"),
//               trailing:  const Icon(Icons.chevron_right),
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => UserProfileScreen ())
//                 );
//               },
//             ),
//
//
//
//
//
//             buildSettingsItem(Icons.nightlight_round, "Dark mode", "On", Colors.grey, context),
//             buildSettingsItem(Icons.circle, "Active status", "On", Colors.green, context),
//             buildSettingsItem(Icons.accessibility_new, "Accessibility", "", Colors.grey, context),
//             buildSettingsItem(Icons.privacy_tip, "Privacy & safety", "", Colors.blue, context),
//             buildSettingsItem(Icons.supervised_user_circle, "Supervision", "", Colors.blue, context),
//             buildSettingsItem(Icons.person, "Avatar", "", Colors.purple, context),
//             buildSettingsItem(Icons.notifications, "Notifications & sounds", "On", Colors.pink, context),
//             buildSettingsItem(Icons.shopping_bag, "Orders", "", Colors.green, context),
//             buildSettingsItem(Icons.photo, "Photos & media", "", Colors.purple, context),
//
//             ListTile(
//               leading: const Icon(Icons.logout, color: Colors.black),
//               title: const Text("Logout"),
//               trailing:  const Icon(Icons.chevron_right),
//               onTap: () {
//                 // Navigator.push(
//                 //     context,
//                 //     MaterialPageRoute(builder: (context) => _showLogoutDialog ())
//                 // );
//                 _showLogoutDialog(context);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> _showLogoutDialog(BuildContext context) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // Không cho phép đóng pop-up ngoài vùng
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Confirm Logout'),
//           content: const Text('Do you want logout?'),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: const Text('Logout'),
//               onPressed: () async{
//                 logOut();
//                 // Navigator.push(
//                 //     context,
//                 //     MaterialPageRoute(builder: (context) => Login())
//                 // );
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget buildSettingsItem(IconData icon, String title, String trailing, Color iconColor, BuildContext context) {
//     return ListTile(
//       leading: Icon(icon, color: iconColor),
//       title: Text(title),
//       trailing: trailing.isNotEmpty ? Text(trailing, style: const TextStyle(color: Colors.grey)) : const Icon(Icons.chevron_right),
//       onTap: () {
//       },
//     );
//   }
//
//   // logout function
//   void logOut() async {
//     // get share preferences instance
//     final prefs = await SharedPreferences.getInstance();
//     prefs.remove('userInfo');
//     // logout request
//     await ApisUserinfo.logout(ApisBase.currentUser);
//     // create empty user info
//     ApisBase.currentUser = UserInfo();
//     // delete device token
//     PushNotificationsService.deleteDeviceToken();
//     // direct to login page
//     Get.offAllNamed(AppRoutes.LOGIN);
//   }
// }
