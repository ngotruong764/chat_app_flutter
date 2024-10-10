import 'package:chat_app_flutter/modules/application/controller/application_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../chat/ListConversations.dart';

class ApplicationView extends GetView<ApplicationController>{
  const ApplicationView({super.key});

  Widget buildPageView(){
    return PageView(
      controller: controller.pageController,
      onPageChanged: controller.onPageChange,
      scrollDirection: Axis.horizontal,
      children: const [
        Conversations(),
        Conversations(),
        Conversations(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildPageView(),
      bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            onTap: controller.handleBottomTabNav,
            items: controller.bottomTabs,
            currentIndex: controller.page.value,
          ),
      ),
    );
  }

}