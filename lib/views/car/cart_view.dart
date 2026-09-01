import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/cart_controller.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final CartController cartController = Get.find<CartController>();

  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();

    final userId = authController.currentUser.value!.id!;

    cartController.loadCart(userId);
  }

  @override
  Widget build(BuildContext context) {
    final userId = authController.currentUser.value!.id!;

    return Directionality(
      textDirection: TextDirection.rtl,

      child: Scaffold(
        backgroundColor: const Color(0xFFF2E7D3),

        appBar: AppBar(
          title: const Text('سلة الطلبات'),
          centerTitle: true,

          backgroundColor: const Color(0xFF68743B),

          foregroundColor: Colors.white,
        ),

        body: Obx(() {
          if (cartController.cartItems.isEmpty) {
            return const Center(
              child: Text('السلة فارغة', style: TextStyle(fontSize: 20)),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(15),

                  itemCount: cartController.cartItems.length,

                  itemBuilder: (context, index) {
                    final item = cartController.cartItems[index];

                    final hasImage =
                        item.image != null &&
                        item.image!.isNotEmpty &&
                        File(item.image!).existsSync();

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),

                      elevation: 2,

                      child: Padding(
                        padding: const EdgeInsets.all(10),

                        child: Row(
                          children: [
                            // =====================
                            // صورة المنتج
                            // =====================
                            Container(
                              width: 75,
                              height: 75,

                              decoration: BoxDecoration(
                                color: const Color(0xFFE8DDC7),

                                borderRadius: BorderRadius.circular(12),
                              ),

                              child: hasImage
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),

                                      child: Image.file(
                                        File(item.image!),

                                        width: 75,
                                        height: 75,

                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Icon(
                                      item.category == 'food'
                                          ? Icons.fastfood
                                          : item.category == 'drink'
                                          ? Icons.local_drink
                                          : Icons.cake,

                                      color: const Color(0xFF68743B),

                                      size: 38,
                                    ),
                            ),

                            const SizedBox(width: 12),

                            // =====================
                            // بيانات المنتج
                            // =====================
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    item.name,

                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Text(
                                    '${item.quantity} × ${item.price} ريال',

                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            ),

                            // =====================
                            // حذف
                            // =====================
                            IconButton(
                              onPressed: () async {
                                await cartController.deleteItem(
                                  item.id!,
                                  userId,
                                );
                              },

                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // =============================
              // الإجمالي وتأكيد الطلب
              // =============================
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 25),

                decoration: const BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),

                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        const Text(
                          'الإجمالي',

                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          '${cartController.total} ريال',

                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF68743B),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,

                      height: 55,

                      child: ElevatedButton(
                        onPressed: () async {
                          await cartController.confirmOrder(userId);

                          Get.snackbar('تم تأكيد الطلب', 'تم حفظ الطلب بنجاح');
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF68743B),

                          foregroundColor: Colors.white,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),

                        child: const Text(
                          'تأكيد الطلب',

                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
