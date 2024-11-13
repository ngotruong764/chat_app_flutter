import 'package:chat_app_flutter/data/api/apis_base.dart';
import 'package:chat_app_flutter/model/user_info.dart';
import 'package:chat_app_flutter/modules/Settings/Profile.dart';
import 'package:chat_app_flutter/modules/chat/screen/chat_screen.dart';
import 'package:chat_app_flutter/modules/login/view/Login.dart';
import 'package:flutter/material.dart';



class SettingsPage extends StatelessWidget {
   SettingsPage({super.key});

  final currentUser = ApisBase.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Settings"),

      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // Thông tin người dùng
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://randomuser.me/api/portraits/men/75.jpg',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${currentUser.username}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.security, color: Colors.blue),
              title: const Text("Information"),
              trailing:  const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfileScreen ())
              );
                },
            ),





            buildSettingsItem(Icons.nightlight_round, "Dark mode", "On", Colors.grey, context),
            buildSettingsItem(Icons.circle, "Active status", "On", Colors.green, context),
            buildSettingsItem(Icons.accessibility_new, "Accessibility", "", Colors.grey, context),
            buildSettingsItem(Icons.privacy_tip, "Privacy & safety", "", Colors.blue, context),
            buildSettingsItem(Icons.supervised_user_circle, "Supervision", "", Colors.blue, context),
            buildSettingsItem(Icons.person, "Avatar", "", Colors.purple, context),
            buildSettingsItem(Icons.notifications, "Notifications & sounds", "On", Colors.pink, context),
            buildSettingsItem(Icons.shopping_bag, "Orders", "", Colors.green, context),
            buildSettingsItem(Icons.photo, "Photos & media", "", Colors.purple, context),

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
    );
  }

   Future<void> _showLogoutDialog(BuildContext context) async {
     return showDialog<void>(
       context: context,
       barrierDismissible: false, // Không cho phép đóng pop-up ngoài vùng
       builder: (BuildContext context) {
         return AlertDialog(
           title: Text('Confirm Logout'),
           content: Text('Do you want logout?'),
           actions: <Widget>[
             TextButton(
               child: Text('Cancel'),
               onPressed: () {
                 Navigator.of(context).pop();
               },
             ),
             TextButton(
               child: Text('Logout'),
               onPressed: () {
                 Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context) => Login())
                 );
                 print("Logout successful!");
               },
             ),
           ],
         );
       },
     );
   }

  Widget buildSettingsItem(IconData icon, String title, String trailing, Color iconColor, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title),
      trailing: trailing.isNotEmpty ? Text(trailing, style: const TextStyle(color: Colors.grey)) : const Icon(Icons.chevron_right),
      onTap: () {
      },
    );
  }
}
