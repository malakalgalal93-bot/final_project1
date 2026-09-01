import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/product_controller.dart';

class DrinksView extends StatefulWidget {
  const DrinksView({super.key});

  @override
  State<DrinksView> createState() => _DrinksViewState();
}

class _DrinksViewState extends State<DrinksView> {
  final ProductController productController = Get.find<ProductController>();

  final CartController cartController = Get.find<CartController>();

  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();

    productController.loadProducts('drink');
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,

      child: Scaffold(
        backgroundColor: const Color(0xFFF2E7D3),

        appBar: AppBar(
          title: const Text('قائمة المشروبات'),
          centerTitle: true,
          backgroundColor: const Color(0xFF68743B),
          foregroundColor: Colors.white,
        ),

        body: Obx(() {
          if (productController.products.isEmpty) {
            return const Center(
              child: Text('لا توجد مشروبات', style: TextStyle(fontSize: 18)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: productController.products.length,

            itemBuilder: (context, index) {
              final product = productController.products[index];

              final hasImage =
                  product.image != null &&
                  product.image!.isNotEmpty &&
                  File(product.image!).existsSync();

              return Card(
                margin: const EdgeInsets.only(bottom: 15),

                elevation: 2,

                child: Padding(
                  padding: const EdgeInsets.all(12),

                  child: Row(
                    children: [
                      // صورة المشروب
                      Container(
                        width: 90,
                        height: 90,

                        decoration: BoxDecoration(
                          color: const Color(0xFFE8DDC7),
                          borderRadius: BorderRadius.circular(15),
                        ),

                        child: hasImage
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(15),

                                child: Image.file(
                                  File(product.image!),
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(
                                Icons.local_drink,
                                size: 45,
                                color: Color(0xFF68743B),
                              ),
                      ),

                      const SizedBox(width: 12),

                      // معلومات المشروب
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              product.name,

                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              product.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 5),

                            Text(
                              '${product.price} ريال',

                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF68743B),
                              ),
                            ),

                            const SizedBox(height: 8),

                            ElevatedButton(
                              onPressed: () async {
                                final userId =
                                    authController.currentUser.value!.id!;

                                await cartController.addToCart(
                                  userId,
                                  product.id!,
                                );

                                Get.snackbar(
                                  'تمت الإضافة',
                                  'تمت إضافة ${product.name} إلى السلة',
                                );
                              },

                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF68743B),

                                foregroundColor: Colors.white,
                              ),

                              child: const Text('إضافة'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
