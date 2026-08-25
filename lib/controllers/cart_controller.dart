import 'package:get/get.dart';

import '../database/database_helper.dart';
import '../models/cart_model.dart';

class CartController extends GetxController {
  final RxList<CartModel> cartItems = <CartModel>[].obs;

  Future<void> loadCart(int userId) async {
    final data = await DatabaseHelper.getCart(userId);

    cartItems.value = data
        .map((item) => CartModel.fromMap(item))
        .toList();
  }

  Future<void> addToCart(
    int userId,
    int productId,
  ) async {
    await DatabaseHelper.addToCart(
      userId,
      productId,
    );

    await loadCart(userId);
  }

  Future<void> deleteItem(
    int cartId,
    int userId,
  ) async {
    await DatabaseHelper.deleteCartItem(cartId);

    await loadCart(userId);
  }

  Future<void> confirmOrder(int userId) async {
    await DatabaseHelper.confirmOrder(userId);

    await loadCart(userId);
  }

  double get total {
    double result = 0;

    for (final item in cartItems) {
      result += item.price * item.quantity;
    }

    return result;
  }
}