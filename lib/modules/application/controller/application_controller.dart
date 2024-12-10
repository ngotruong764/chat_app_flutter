import 'package:chat_app_flutter/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/api/apis_chat.dart';

class ApplicationController extends GetxController{

  // init the page index
  RxInt page = 0.obs;
  // page controller
  late PageController pageController;

  // bottom bar list
  late List<BottomNavigationBarItem> bottomTabs;

  // handle bottom tab navigation
  void handleBottomTabNav(int index){
    page.value = index;
    pageController.jumpToPage(page.value);
  }

  // handle page change
  void onPageChange(int index){
    page.value = index;
  }

  List<BottomNavigationBarItem> _buildBottomTabs() {
    return const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.chat),
        label: 'Chats',
      ),
      // BottomNavigationBarItem(
      //   icon: Icon(Icons.people),
      //   label: 'Contacts',
      // ),
      // BottomNavigationBarItem(
      //   icon: Icon(Icons.settings),
      //   label: 'Settings',
      // ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: 'Settings',
      ),
    ];
  }

  @override
  void onInit() async {
    super.onInit();
    bottomTabs = _buildBottomTabs();
    pageController = PageController(initialPage: page.value);
    // connect websocket
    await connectWebSocket();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  /*
  * Connect web socket
  */
  Future<void> connectWebSocket() async{
    ApisChat.connectSocket();
  }
}