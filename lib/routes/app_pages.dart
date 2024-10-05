
import 'package:chat_app_flutter/modules/login/view/Signup1.dart';
import 'package:chat_app_flutter/modules/login/view/SignupOTP.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../modules/login/view/Signup2.dart';
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
    name: AppRoutes.LOGIN,
    page: () =>  const SignUp1(),
  ),
  GetPage(
    name: AppRoutes.LOGINOTP,
    page: () =>  SignUpOTP(),
  ),
  GetPage(
    name: AppRoutes.LOGIN2,
    page: () =>  const SignUp2(),
  ),
  GetPage(
    name: AppRoutes.LOGIN3,
    page: () => const SignUp3(),
  )

];