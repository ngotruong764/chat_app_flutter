
import 'package:chat_app_flutter/modules/application/binding/application_binding.dart';
import 'package:chat_app_flutter/modules/application/view/application_view.dart';
import 'package:chat_app_flutter/modules/chat/ChatBox.dart';
import 'package:chat_app_flutter/modules/chat/ListConversations.dart';
import 'package:chat_app_flutter/modules/login/view/Login.dart';
import 'package:chat_app_flutter/modules/login/view/CreateAccount.dart';
import 'package:chat_app_flutter/modules/login/view/SignupOTP.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../modules/login/view/InforUser.dart';
import '../modules/login/view/Signup3.dart';
import '../modules/splash_screen/SplashScreen.dart';
import 'app_routes.dart';

const INITIAL = AppRoutes.SPLASH;

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
  GetPage(
      name: AppRoutes.CHATBOX,
      page:() => ChatBox()
  ),
  GetPage(
    name: AppRoutes.CONVERSATIONS,
    page: () => Conversations(),
  )
];