import 'package:final_project1/controllers/auth_controller.dart';
import 'package:final_project1/controllers/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import '../../controllers/auth_controller.dart';
// import '../../controllers/cart_controller.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() =>
      _CartViewState();
}

class _CartViewState extends State<CartView> {
  final cartController =
      Get.find<CartController>();

  final authController =
      Get.find<AuthController>();

  @override
  void initState() {
    super.initState();

    final userId =
        authController.currentUser.value!.id!;

    cartController.loadCart(userId);
  }

  @override
  Widget build(BuildContext context) {
    final userId =
        authController.currentUser.value!.id!;

    return Scaffold(
      backgroundColor:
          const Color(0xFFF2E7D3),

      appBar: AppBar(
        title: const Text(
          'سلة الطلبات',
        ),
        centerTitle: true,
        backgroundColor:
            const Color(0xFF68743B),
        foregroundColor: Colors.white,
      ),

      body: Obx(
        () {
          if (cartController.cartItems.isEmpty) {
            return const Center(
              child: Text(
                'السلة فارغة',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding:
                      const EdgeInsets.all(15),

                  itemCount:
                      cartController
                          .cartItems
                          .length,

                  itemBuilder:
                      (context, index) {
                    final item =
                        cartController
                            .cartItems[index];

                    return Card(
                      margin:
                          const EdgeInsets
                              .only(
                        bottom: 12,
                      ),

                      child: ListTile(
                        title: Text(
                          item.name,
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        subtitle: Text(
                          '${item.price} ريال × ${item.quantity}',
                        ),

                        trailing:
                            IconButton(
                          onPressed:
                              () async {
                            await cartController
                                .deleteItem(
                              item.id!,
                              userId,
                            );
                          },

                          icon:
                              const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              Container(
                padding:
                    const EdgeInsets.all(20),

                decoration:
                    const BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.vertical(
                    top: Radius.circular(25),
                  ),
                ),

                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,

                      children: [
                        const Text(
                          'الإجمالي',
                          style:
                              TextStyle(
                            fontSize: 20,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        Text(
                          '${cartController.total} ريال',
                          style:
                              const TextStyle(
                            fontSize: 20,
                            fontWeight:
                                FontWeight.bold,
                            color:
                                Color(
                              0xFF68743B,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    SizedBox(
                      width:
                          double.infinity,
                      height: 50,

                      child:
                          ElevatedButton(
                        onPressed: () async {
                          await cartController
                              .confirmOrder(
                            userId,
                          );

                          Get.snackbar(
                            'تم تأكيد الطلب',
                            'تم حفظ الطلب بنجاح',
                          );
                        },

                        style:
                            ElevatedButton
                                .styleFrom(
                          backgroundColor:
                              const Color(
                            0xFF68743B,
                          ),
                          foregroundColor:
                              Colors.white,
                        ),

                        child:
                            const Text(
                          'تأكيد الطلب',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}