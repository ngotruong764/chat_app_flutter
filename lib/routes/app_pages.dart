import 'package:chat_app_flutter/modules/application/binding/application_binding.dart';
import 'package:chat_app_flutter/modules/application/view/application_view.dart';
import 'package:chat_app_flutter/modules/chat/screen/chat_screen.dart';
import 'package:chat_app_flutter/modules/forgetPass/binding/forget_pass_binding.dart';
import 'package:chat_app_flutter/modules/forgetPass/controller/forget_pass_controller.dart';
import 'package:chat_app_flutter/modules/login/view/Login.dart';
import 'package:chat_app_flutter/modules/login/view/CreateAccount.dart';
import 'package:chat_app_flutter/modules/login/view/SignupOTP.dart';
import 'package:chat_app_flutter/modules/search/binding/search_binding.dart';
import 'package:chat_app_flutter/modules/search/view/search_screen.dart';
import 'package:chat_app_flutter/modules/settings/binding/settings_binding.dart';
import 'package:chat_app_flutter/modules/settings/view/settings_screen.dart';
import 'package:chat_app_flutter/modules/video_call/binding/video_call_binding.dart';
import 'package:chat_app_flutter/modules/video_call/view/test_receive_call_screen.dart';
import 'package:chat_app_flutter/modules/video_call/view/video_call_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../modules/forgetPass/view/forgot_pass_screen.dart';
import '../modules/login/view/InforUser.dart';
import '../modules/login/view/Signup3.dart';
import '../modules/splash_screen/SplashScreen.dart';
import 'app_routes.dart';


final kRoutePages = [
  GetPage(
    name: AppRoutes.SPLASH,
    page: () => const SplashScreen(),
  ),
  GetPage(
    name: AppRoutes.APPLICATION,
    page: () => const ApplicationView(),
    binding: ApplicationBinding(),
  ),
  GetPage(
    name: AppRoutes.SEARCH,
    page: () => const SearchScreen(),
    binding: SearchBinding(),
  ),
  GetPage(
    name: AppRoutes.CREATACCOUNT,
    page: () =>  const CreateAccount(),
  ),
  GetPage(
    name: AppRoutes.LOGINOTP,
    page: () =>  SignUpOTP(),
  ),
  GetPage(
    name: AppRoutes.INFORUSER,
    page: () =>   InforUser(),
  ),
  GetPage(
    name: AppRoutes.LOGIN3,
    page: () => const SignUp3(),
  ),
  GetPage(
      name: AppRoutes.LOGIN,
      page: () => Login(),
  ),
  // GetPage(
  //     name: AppRoutes.CHATBOX,
  //     page:() => ChatBox(userId: 0, name: '', message: '', imageUrl: '',)
  // ),
  GetPage(
    name: AppRoutes.CONVERSATIONS,
    page: () => const ChatScreen(),
    // binding: ChatBinding(),
  ),
  GetPage(
    name: AppRoutes.SETTINGS,
    page: () => const SettingsPage(),
    binding: SettingsBinding(),
  ),
  
  GetPage(
    name: AppRoutes.FOGGOTPASSWORD,
  page: () => const ForgetPassword(),
    binding: ForgetPassBinding(),
  ),
  GetPage(
    name: AppRoutes.VIDEO_CALL,
    page: () => const VideoCallScreen(),
    binding: VideoCallBinding(),
  ),
  GetPage(
    name: AppRoutes.VIDEO_CALL_FROM_APPLICATION,
    page: () => const VideoCallScreen(),
    binding: VideoCallBinding(),
  ),
  GetPage(
    name: AppRoutes.TEST_VIDEO_CALL,
    page: () => const TestReceiveCallScreen(),
  )

];