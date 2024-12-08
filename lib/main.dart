import 'dart:convert';

import 'package:chat_app_flutter/firebase_options.dart';
import 'package:chat_app_flutter/routes/app_pages.dart';
import 'package:chat_app_flutter/routes/app_routes.dart';
import 'package:chat_app_flutter/services/push_notifications_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/api/apis_user_info.dart';
import 'model/user_info.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  // initialize firebase app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  PushNotificationsService.notificationSetUpInterface();
  PushNotificationsService.display(message);
}

// setting up theme
var kColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 160, 197, 243));
// color scheme optimized for dark mode
var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark, //tell flutter optimize for dark mode
  seedColor: const Color.fromARGB(255, 5, 99, 125),
);

var initialRoute = AppRoutes.LOGIN;

// init
Future<void> init() async {
  // get SharedPreferences instance
  final prefs = await SharedPreferences.getInstance();
  // get 'userInfo'
  final String? userPrefs = prefs.getString('userInfo');
  // if user info != null means app is login
  if (userPrefs != null) {
    // read the userInfo
    Map<String, dynamic> userMap = jsonDecode(userPrefs) as Map<
        String,
        dynamic>;
    // Get device token
    // await PushNotificationsService.getDeviceToken();
    //
    UserInfo userInfo = UserInfo.fromJson(userMap);
    // userInfo.deviceToken = Constants.DEVICE_TOKEN;
    // login request
    UserInfo? loginUser = await ApisUserinfo.login(userInfo: userInfo);
    // if login user is not null --> direct to application
    if (loginUser != null) {
      initialRoute = AppRoutes.APPLICATION;
    }
  }
}

void main() async{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  PushNotificationsService.notificationSetUpInterface();

  // Request notification permission
  await PushNotificationsService.notificationRequestPermission();

  // Handle foreground mode message
  PushNotificationsService.handleForegroundNotification();

  // Handler background & terminate mode message
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await init();
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Talkie',
      // setting theme for dark mode
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
      ),
      theme: ThemeData(
        colorScheme: kColorScheme,
        useMaterial3: true,
      ),
      // initialRoute: AppRoutes.SPLASH,
      initialRoute: initialRoute,
      getPages: kRoutePages,
    );
  }
}



//tets