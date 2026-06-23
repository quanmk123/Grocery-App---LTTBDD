import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'core/themes/light_theme.dart';
import 'core/themes/dark_theme.dart';

/// App Widget - Entry point của ứng dụng
class GroceryApp extends StatelessWidget {
  const GroceryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Grocery App',
      debugShowCheckedModeBanner: false,

      // Themes
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: ThemeMode.light,

      // Routes
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,

      // Locale
      locale: const Locale('vi', 'VN'),
      fallbackLocale: const Locale('en', 'US'),

      // Default transition
      defaultTransition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 250),
    );
  }
}
