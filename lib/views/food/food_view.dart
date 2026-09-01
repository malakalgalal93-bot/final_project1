import 'dart:io';

import 'package:final_project1/controllers/auth_controller.dart';
import 'package:final_project1/controllers/cart_controller.dart';
import 'package:final_project1/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import '../../controllers/auth_controller.dart';
// import '../../controllers/cart_controller.dart';
// import '../../controllers/product_controller.dart';

class FoodView extends StatefulWidget {
  const FoodView({super.key});

  @override
  State<FoodView> createState() => _FoodViewState();
}

class _FoodViewState extends State<FoodView> {
  final ProductController productController = Get.find<ProductController>();

  final CartController cartController = Get.find<CartController>();

  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();

    productController.loadProducts('food');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2E7D3),

      appBar: AppBar(
        title: const Text('قائمة الطعام'),
        centerTitle: true,
        backgroundColor: const Color(0xFF68743B),
        foregroundColor: Colors.white,
      ),

      body: Obx(() {
        if (productController.products.isEmpty) {
          return const Center(child: Text('لا توجد وجبات'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(15),

          itemCount: productController.products.length,

          itemBuilder: (context, index) {
            final product = productController.products[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 15),

              child: Padding(
                padding: const EdgeInsets.all(12),

                child: Row(
                  children: [
                    Container(
                      width: 90,
                      height: 90,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xFFE8DDC7),
                      ),

                      child: product.image != null && product.image!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(
                                File(product.image!),
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.fastfood,
                              size: 45,
                              color: Color(0xFF68743B),
                            ),
                    ),

                    const SizedBox(width: 12),

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

                          Text(
                            product.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 5),

                          Text(
                            '${product.price} ريال',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF68743B),
                            ),
                          ),

                          const SizedBox(height: 8),

                          ElevatedButton(
                            onPressed: () async {
                              await cartController.addToCart(
                                authController.currentUser.value!.id!,
                                product.id!,
                              );

                              Get.snackbar(
                                'تم',
                                'تمت إضافة ${product.name} إلى السلة',
                              );
                            },

                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF68743B),
                              foregroundColor: Colors.white,
                            ),

                            child: const Text('إضافة إلى السلة'),
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
    );
  }
}
