import 'package:get/get.dart';

import '../database/database_helper.dart';
import '../models/product_model.dart';

class ProductController extends GetxController {
  final RxList<ProductModel> products = <ProductModel>[].obs;

  Future<void> loadProducts(String category) async {
    final data = await DatabaseHelper.getProducts(category);

    products.value = data
        .map((item) => ProductModel.fromMap(item))
        .toList();
  }

  Future<void> loadAllProducts() async {
    final data = await DatabaseHelper.getAllProducts();

    products.value = data
        .map((item) => ProductModel.fromMap(item))
        .toList();
  }

  Future<void> addProduct(ProductModel product) async {
    await DatabaseHelper.insertProduct(
      product.toMap(),
    );

    await loadAllProducts();
  }

  Future<void> updateProduct(ProductModel product) async {
    await DatabaseHelper.updateProduct(
      product.id!,
      product.toMap(),
    );

    await loadAllProducts();
  }

  Future<void> deleteProduct(int id) async {
    await DatabaseHelper.deleteProduct(id);

    await loadAllProducts();
  }
}