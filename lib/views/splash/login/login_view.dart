import 'dart:io';

import 'package:final_project1/controllers/auth_controller.dart';
import 'package:final_project1/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

//import '../../controllers/auth_controller.dart';
//import '../../routes/app_routes.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthController authController =
      Get.find<AuthController>();

  String? selectedImage;

  bool obscurePassword = true;

  Future<void> pickImage() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        selectedImage = image.path;
      });
    }
  }

  Future<void> login() async {
    if (usernameController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      Get.snackbar(
        'تنبيه',
        'أدخل اسم المستخدم وكلمة المرور',
      );

      return;
    }

    final success = await authController.login(
      usernameController.text.trim(),
      passwordController.text.trim(),
      selectedImage,
    );

    if (success) {
      Get.offNamed(AppRoutes.home);
    } else {
      Get.snackbar(
        'خطأ',
        'اسم المستخدم أو كلمة المرور غير صحيحة',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2E7D3),

      appBar: AppBar(
        title: const Text('تسجيل الدخول'),
        centerTitle: true,
        backgroundColor: const Color(0xFF68743B),
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),

        child: Column(
          children: [
            const SizedBox(height: 20),

            GestureDetector(
              onTap: pickImage,

              child: CircleAvatar(
                radius: 65,

                backgroundColor:
                    const Color(0xFF68743B),

                backgroundImage:
                    selectedImage != null
                        ? FileImage(
                            File(selectedImage!),
                          )
                        : null,

                child: selectedImage == null
                    ? const Icon(
                        Icons.person,
                        size: 70,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),

            const SizedBox(height: 10),

            TextButton(
              onPressed: pickImage,
              child: const Text(
                'تصفح صورة المستخدم',
              ),
            ),

            const SizedBox(height: 25),

            TextField(
              controller: usernameController,

              decoration: InputDecoration(
                labelText: 'اسم المستخدم',
                prefixIcon:
                    const Icon(Icons.person),

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: passwordController,
              obscureText: obscurePassword,

              decoration: InputDecoration(
                labelText: 'كلمة المرور',
                prefixIcon:
                    const Icon(Icons.lock),

                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscurePassword =
                          !obscurePassword;
                    });
                  },

                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                ),

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: login,

                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF68743B),

                  foregroundColor: Colors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                ),

                child: const Text(
                  'دخول',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}