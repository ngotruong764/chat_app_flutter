import 'dart:ui';

import 'package:get/get.dart';

class Constants {
  static late String? DEVICE_TOKEN;
  static RxList<int> USER_AVATAR = <int>[].obs;
  static int CURRENT_CONVERSATION_ID = -1;
  static String FIRST_CONVERSATION_MESSAGE = 'Starting conversation';
  static List<Color> GRADIENT_APP_BAR_COLORS = [const Color(0xFF1E90FF), const Color(0xFF00BFFF)];
}