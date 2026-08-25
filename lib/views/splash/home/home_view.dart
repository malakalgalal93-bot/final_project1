import 'dart:io';

import 'package:final_project1/controllers/auth_controller.dart';
import 'package:final_project1/views/ad/admin_view.dart';
import 'package:final_project1/views/car/cart_view.dart';
import 'package:final_project1/views/desserts/desserts_view.dart';
import 'package:final_project1/views/drinks/drinks_view.dart';
import 'package:final_project1/views/food/food_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';

import '../food/food_view.dart';
import '../drinks/drinks_view.dart';
import '../desserts/desserts_view.dart';
import '../cart/cart_view.dart';
import '../admin/admin_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    final user = authController.currentUser.value;

    return Scaffold(
      backgroundColor: const Color(0xFFF2E7D3),

      // =========================
      // AppBar
      // =========================
      appBar: AppBar(
        backgroundColor: const Color(0xFF68743B),
        foregroundColor: Colors.white,

        title: Row(
          children: [
            // صورة المستخدم
            CircleAvatar(
              radius: 25,

              backgroundColor: Colors.white,

              backgroundImage: user?.image != null && user!.image!.isNotEmpty
                  ? FileImage(File(user.image!))
                  : null,

              child: user?.image == null || user!.image!.isEmpty
                  ? const Icon(Icons.person, size: 30, color: Color(0xFF68743B))
                  : null,
            ),

            const SizedBox(width: 12),

            // اسم المستخدم
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  user?.username ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Text(
                  'توصيل خدمات المطاعم',
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),

      // =========================
      // Body
      // =========================
      body: Padding(
        padding: const EdgeInsets.all(18),

        child: GridView.count(
          crossAxisCount: 2,

          crossAxisSpacing: 18,
          mainAxisSpacing: 18,

          childAspectRatio: 0.95,

          children: [
            // =========================
            // الأطعمة
            // =========================
            _categoryCard(
              image: 'assets/images/food.jpg',
              title: 'الأطعمة',

              onTap: () {
                Get.to(() => const FoodView());
              },
            ),

            // =========================
            // المشروبات
            // =========================
            _categoryCard(
              image: 'assets/images/drinks.jpg',
              title: 'المشروبات',

              onTap: () {
                Get.to(() => const DrinksView());
              },
            ),

            // =========================
            // الحلويات
            // =========================
            _categoryCard(
              image: 'assets/images/desserts.jpg',
              title: 'الحلويات',

              onTap: () {
                Get.to(() => const DessertsView());
              },
            ),

            // =========================
            // سلة الطلبات
            // =========================
            _categoryCard(
              image: 'assets/images/cart.jpg',
              title: 'سلة الطلبات',

              onTap: () {
                Get.to(() => const CartView());
              },
            ),

            // =========================
            // إدارة الوجبات
            // تظهر للأدمن فقط
            // =========================
            if (authController.isAdmin)
              _categoryCard(
                image: 'assets/images/admin.jpg',
                title: 'إدارة الوجبات',

                onTap: () {
                  Get.to(() => const AdminView());
                },
              ),
          ],
        ),
      ),

      // =========================
      // Bottom Navigation
      // =========================
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,

        backgroundColor: Colors.white,

        selectedItemColor: const Color(0xFF68743B),

        unselectedItemColor: Colors.grey,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: 'قائمة الطعام',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.local_drink),
            label: 'المشروبات',
          ),

          BottomNavigationBarItem(icon: Icon(Icons.cake), label: 'الحلويات'),

          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'سلة الطلبات',
          ),
        ],

        onTap: (index) {
          // قائمة الطعام
          if (index == 0) {
            Get.to(() => const FoodView());
          }

          // المشروبات
          if (index == 1) {
            Get.to(() => const DrinksView());
          }

          // الحلويات
          if (index == 2) {
            Get.to(() => const DessertsView());
          }

          // سلة الطلبات
          if (index == 3) {
            Get.to(() => const CartView());
          }
        },
      ),
    );
  }

  // ==========================================
  // بطاقة التصنيف
  // ==========================================

  Widget _categoryCard({
    required String image,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(25),

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(25),

          border: Border.all(color: const Color(0xFF68743B), width: 1.5),
        ),

        child: Column(
          children: [
            // =========================
            // الصورة
            // =========================
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),

                  child: Image.asset(
                    image,

                    width: double.infinity,

                    fit: BoxFit.cover,

                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Color(0xFF68743B),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // =========================
            // اسم التصنيف
            // =========================
            Padding(
              padding: const EdgeInsets.only(bottom: 15),

              child: Text(
                title,

                style: const TextStyle(
                  fontSize: 19,

                  fontWeight: FontWeight.bold,

                  color: Color(0xFF68743B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
