
import 'package:chat_app_flutter/modules/login/Signup1.dart';
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
    page: () => SignUp1(),
  )
];