import 'package:chat_app_flutter/routes/app_pages.dart';
import 'package:chat_app_flutter/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

// setting up theme
var kColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 160, 197, 243));
// color scheme optimized for dark mode
var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark, //tell flutter optimize for dark mode
  seedColor: const Color.fromARGB(255, 5, 99, 125),
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // setting theme for dark mode
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
      ),
      theme: ThemeData(
        colorScheme: kColorScheme,
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.SPLASH,
      getPages: kRoutePages,
    );
  }
}
