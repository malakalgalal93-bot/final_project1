import 'package:get/get.dart';

import '../database/database_helper.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  final Rxn<UserModel> currentUser = Rxn<UserModel>();

  bool get isAdmin {
    return currentUser.value?.role == 'admin';
  }

  Future<bool> login(
    String username,
    String password,
    String? image,
  ) async {
    final result = await DatabaseHelper.login(
      username,
      password,
    );

    if (result == null) {
      return false;
    }

    currentUser.value = UserModel.fromMap(result);

    if (image != null && image.isNotEmpty) {
      await DatabaseHelper.updateUserImage(
        currentUser.value!.id!,
        image,
      );

      currentUser.value = UserModel(
        id: currentUser.value!.id,
        username: currentUser.value!.username,
        password: currentUser.value!.password,
        image: image,
        role: currentUser.value!.role,
      );
    }

    update();

    return true;
  }

  void logout() {
    currentUser.value = null;
    update();
  }
}