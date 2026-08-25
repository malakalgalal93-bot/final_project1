import 'package:final_project1/controllers/auth_controller.dart';
import 'package:final_project1/controllers/cart_controller.dart';
import 'package:final_project1/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import '../../controllers/auth_controller.dart';
// import '../../controllers/cart_controller.dart';
// import '../../controllers/product_controller.dart';

class DrinksView extends StatefulWidget {
  const DrinksView({super.key});

  @override
  State<DrinksView> createState() => _DrinksViewState();
}

class _DrinksViewState extends State<DrinksView> {
  final productController =
      Get.find<ProductController>();

  final cartController =
      Get.find<CartController>();

  final authController =
      Get.find<AuthController>();

  @override
  void initState() {
    super.initState();

    productController.loadProducts('drink');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF2E7D3),

      appBar: AppBar(
        title: const Text('قائمة المشروبات'),
        centerTitle: true,
        backgroundColor:
            const Color(0xFF68743B),
        foregroundColor: Colors.white,
      ),

      body: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.all(15),

          itemCount:
              productController.products.length,

          itemBuilder: (context, index) {
            final product =
                productController.products[index];

            return Card(
              margin:
                  const EdgeInsets.only(bottom: 15),

              child: ListTile(
                contentPadding:
                    const EdgeInsets.all(12),

                leading: const CircleAvatar(
                  radius: 35,
                  backgroundColor:
                      Color(0xFFE8DDC7),
                  child: Icon(
                    Icons.local_drink,
                    color: Color(0xFF68743B),
                    size: 35,
                  ),
                ),

                title: Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                subtitle: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(product.description),
                    Text(
                      '${product.price} ريال',
                      style: const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        color:
                            Color(0xFF68743B),
                      ),
                    ),
                  ],
                ),

                trailing: ElevatedButton(
                  onPressed: () async {
                    await cartController.addToCart(
                      authController
                          .currentUser
                          .value!
                          .id!,
                      product.id!,
                    );

                    Get.snackbar(
                      'تم',
                      'تمت الإضافة إلى السلة',
                    );
                  },

                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF68743B),
                    foregroundColor:
                        Colors.white,
                  ),

                  child: const Text(
                    'إضافة',
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}