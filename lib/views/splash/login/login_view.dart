import 'dart:io';

import 'package:final_project1/controllers/auth_controller.dart';
import 'package:final_project1/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

// import '../../controllers/auth_controller.dart';
// import '../../routes/app_routes.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() =>
      _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final usernameController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  final AuthController authController =
      Get.find<AuthController>();

  String? selectedImage;

  bool obscurePassword = true;

  // اختيار الصورة
  Future<void> pickImage() async {
    final picker = ImagePicker();

    final XFile? image =
        await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        selectedImage = image.path;
      });
    }
  }

  // تسجيل الدخول
  Future<void> login() async {
    if (usernameController.text
        .trim()
        .isEmpty) {
      Get.snackbar(
        'تنبيه',
        'أدخل اسم المستخدم',
      );

      return;
    }

    if (passwordController.text
        .trim()
        .isEmpty) {
      Get.snackbar(
        'تنبيه',
        'أدخل كلمة المرور',
      );

      return;
    }

    final success =
        await authController.login(
      usernameController.text.trim(),
      passwordController.text.trim(),
      selectedImage,
    );

    if (success) {
      Get.offNamed(
        AppRoutes.home,
      );
    } else {
      Get.snackbar(
        'خطأ',
        'اسم المستخدم أو كلمة المرور غير صحيحة',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          TextDirection.rtl,

      child: Scaffold(
        backgroundColor:
            const Color(0xFFF2E7D3),

        appBar: AppBar(
          title: const Text(
            'تسجيل الدخول',
          ),

          centerTitle: true,

          backgroundColor:
              const Color(0xFF68743B),

          foregroundColor:
              Colors.white,
        ),

        body: SingleChildScrollView(
          padding:
              const EdgeInsets.all(25),

          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),

              // =====================
              // صورة المستخدم
              // =====================
              GestureDetector(
                onTap: pickImage,

                child: Container(
                  width: 130,
                  height: 130,

                  decoration:
                      BoxDecoration(
                    shape: BoxShape.circle,

                    color:
                        const Color(
                      0xFF68743B,
                    ),

                    border: Border.all(
                      color:
                          Colors.white,
                      width: 4,
                    ),
                  ),

                  child:
                      selectedImage != null &&
                              File(
                                selectedImage!,
                              ).existsSync()
                          ? ClipOval(
                              child:
                                  Image.file(
                                File(
                                  selectedImage!,
                                ),

                                width: 130,
                                height: 130,

                                fit: BoxFit
                                    .cover,
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              size: 75,
                              color:
                                  Colors.white,
                            ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              TextButton.icon(
                onPressed:
                    pickImage,

                icon: const Icon(
                  Icons.photo_library,
                ),

                label: const Text(
                  'اختيار صورة المستخدم',
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              // =====================
              // اسم المستخدم
              // =====================
              TextField(
                controller:
                    usernameController,

                textDirection:
                    TextDirection.rtl,

                decoration:
                    InputDecoration(
                  labelText:
                      'اسم المستخدم',

                  prefixIcon:
                      const Icon(
                    Icons.person,
                  ),

                  filled: true,

                  fillColor:
                      Colors.white,

                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                      15,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 15,
              ),

              // =====================
              // كلمة المرور
              // =====================
              TextField(
                controller:
                    passwordController,

                obscureText:
                    obscurePassword,

                textDirection:
                    TextDirection.rtl,

                decoration:
                    InputDecoration(
                  labelText:
                      'كلمة المرور',

                  prefixIcon:
                      const Icon(
                    Icons.lock,
                  ),

                  suffixIcon:
                      IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword =
                            !obscurePassword;
                      });
                    },

                    icon: Icon(
                      obscurePassword
                          ? Icons
                              .visibility
                          : Icons
                              .visibility_off,
                    ),
                  ),

                  filled: true,

                  fillColor:
                      Colors.white,

                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                      15,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              // =====================
              // زر الدخول
              // =====================
              SizedBox(
                width:
                    double.infinity,

                height: 55,

                child:
                    ElevatedButton(
                  onPressed: login,

                  style:
                      ElevatedButton
                          .styleFrom(
                    backgroundColor:
                        const Color(
                      0xFF68743B,
                    ),

                    foregroundColor:
                        Colors.white,

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                        15,
                      ),
                    ),
                  ),

                  child: const Text(
                    'دخول',

                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();

    super.dispose();
  }
}