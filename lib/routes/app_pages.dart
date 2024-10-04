
import 'package:chat_app_flutter/modules/login/Signup1.dart';
import 'package:chat_app_flutter/modules/login/Signup2.dart';
import 'package:chat_app_flutter/modules/login/Signup3.dart';
import 'package:chat_app_flutter/modules/login/SignupOTP.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../modules/splash_screen/SplashScreen.dart';
import 'app_routes.dart';

const INITIAL = AppRoutes.SPLASH;

final kRoutePages = [
  GetPage(
    name: AppRoutes.SPLASH,
    page: () => const SplashScreen(),
  ),
  GetPage(
    name: AppRoutes.LOGIN,
    page: () =>  SignUp1(),
  ),
  GetPage(
    name: AppRoutes.LOGINOTP,
    page: () =>  SignUpOTP(),
  ),
  GetPage(
    name: AppRoutes.LOGIN2,
    page: () =>  SignUp2(),
  ),
  GetPage(
    name: AppRoutes.LOGIN3,
    page: () => const SignUp3(),
  )

];