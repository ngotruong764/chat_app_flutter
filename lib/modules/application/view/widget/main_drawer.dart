import 'package:chat_app_flutter/data/api/apis_base.dart';
import 'package:chat_app_flutter/data/api/apis_user_info.dart';
import 'package:chat_app_flutter/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  void logOut() async{
    // get share preferences instance
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userInfo');
    // logout request
    ApisUserinfo.logout(ApisBase.currentUser);
    // direct to login page
    Get.offAllNamed(AppRoutes.LOGIN);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(height: 200,),
          ListTile(
            title: const Text('Logout'),
            leading: const Icon(Icons.logout),
            onTap: logOut,
          )
        ],
      ),
    );
  }
}
