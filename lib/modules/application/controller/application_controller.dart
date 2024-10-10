import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApplicationController extends GetxController{

  // init the page index
  RxInt page = 0.obs;
  // page controller
  late PageController pageController;

  // bottom bar list
  late List<BottomNavigationBarItem> bottomTabs;

  // handle bottom tab navigation
  void handleBottomTabNav(int index){
    print(page.value);
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
      BottomNavigationBarItem(
        icon: Icon(Icons.people),
        label: 'Contacts',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: 'Settings',
      ),
    ];
  }

  @override
  void onInit() {
    super.onInit();
    bottomTabs = _buildBottomTabs();
    pageController = PageController(initialPage: page.value);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }
}