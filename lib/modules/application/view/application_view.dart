import 'package:chat_app_flutter/modules/application/controller/application_controller.dart';
import 'package:chat_app_flutter/modules/settings/view/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../chat/screen/chat_screen.dart';

class ApplicationView extends GetView<ApplicationController>{
  const ApplicationView({super.key});

  Widget buildPageView(){
    return PageView(
      controller: controller.pageController,
      onPageChanged: controller.onPageChange,
      scrollDirection: Axis.horizontal,

      children: const [
        ChatScreen(),
        // const Login(),
        // const ChatScreen(),
        SettingsPage(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: const MainDrawer(),
      // appBar: AppBar(),
      body: buildPageView(),
      bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            onTap: controller.handleBottomTabNav,
            items: controller.bottomTabs,
            currentIndex: controller.page.value,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blue,
          ),
      ),
    );
  }

}