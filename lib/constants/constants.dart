import 'dart:ui';

import 'package:get/get.dart';

abstract class Constants {
  // App
  static const String APP_NAME = 'Talkie';

  static late String? DEVICE_TOKEN;
  static RxList<int> USER_AVATAR = <int>[].obs;
  static int CURRENT_CONVERSATION_ID = -1;
  static String FIRST_CONVERSATION_MESSAGE = 'Starting conversation';
  static List<Color> GRADIENT_APP_BAR_COLORS = [
    const Color(0xFF1E90FF),
    const Color(0xFF00BFFF)
  ];
  static Color CHAT_BOX_COLOR = const Color(0xFFF0ECF4);

  // Video Call
  static String VIDEO_CALL = 'Video-Call';
  static const String AGREE_CALL = 'Agree';
  static const String DECLINE_CALL = 'Decline';
}
