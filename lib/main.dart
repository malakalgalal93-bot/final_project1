import 'package:final_project1/views/splash/home/home_view.dart';
import 'package:final_project1/views/splash/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/auth_controller.dart';
import 'controllers/cart_controller.dart';
import 'controllers/product_controller.dart';
import 'routes/app_routes.dart';

import 'views/splash/splash_view.dart';
//import 'views/login/login_view.dart';
//import 'views/home/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(AuthController());
  Get.put(ProductController());
  Get.put(CartController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: const Locale('ar'),
      textDirection: TextDirection.rtl,
      debugShowCheckedModeBanner: false,
      title: 'توصيل خدمات المطاعم',

      initialRoute: AppRoutes.splash,
//ربط اسم المسار بالواجهه الفعلية
      getPages: [
        GetPage(name: AppRoutes.splash, page: () => const SplashView()),

        GetPage(name: AppRoutes.login, page: () => const LoginView()),

        GetPage(name: AppRoutes.home, page: () => const HomeView()),
      ],
    );
  }
}
