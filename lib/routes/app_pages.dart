
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../modules/splash_screen/SplashScreen.dart';
import 'app_routes.dart';

const INITIAL = AppRoutes.SPLASH;

final kRoutePages = [
  GetPage(
    name: AppRoutes.SPLASH,
    page: () => const SplashScreen(),
  ),
];