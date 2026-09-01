import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
//عمليه زمنيه عند تشغيل الشاشه
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}
                                                //splash screen
class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
  // تيمر استخدمنا من مكتبه دارت async
    Timer(  
      const Duration(seconds: 3), //ينتظر 3ثواني بعدين ينتقل للصفحه الثاني
      () {
        Get.offNamed(AppRoutes.login);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2E7D3),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.restaurant_menu,
              size: 100,
              color: Color(0xFF68743B),
            ),

            const SizedBox(height: 25),

            const Text(
              'توصيل خدمات المطاعم',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF68743B),
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'نوصّل لك طلبك بسهولة وسرعة',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF665D4D),
              ),
            ),

            const SizedBox(height: 50),

            const CircularProgressIndicator(
              color: Color(0xFF68743B),
            ),
          ],
        ),
      ),
    );
  }
}