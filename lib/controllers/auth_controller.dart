import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../database/database_helper.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  final Rxn<UserModel> currentUser = Rxn<UserModel>();

  bool get isAdmin {
    return currentUser.value?.role == 'admin';
  }

  // حفظ نسخة دائمة من صورة المستخدم
  Future<String?> saveUserImage(String imagePath) async {
    try {
      final appDirectory = await getApplicationDocumentsDirectory();

      final imagesDirectory = Directory('${appDirectory.path}/user_images');

      if (!await imagesDirectory.exists()) {
        await imagesDirectory.create(recursive: true);
      }

      final originalFile = File(imagePath);

      if (!await originalFile.exists()) {
        return null;
      }

      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${originalFile.path.split('/').last}';

      final newPath = '${imagesDirectory.path}/$fileName';

      await originalFile.copy(newPath);

      return newPath;
    } catch (e) {
      return null;
    }
  }

  // تسجيل الدخول
  Future<bool> login(String username, String password, String? image) async {
    final result = await DatabaseHelper.login(username, password);

    if (result == null) {
      return false;
    }

    UserModel user = UserModel.fromMap(result);

    // إذا اختار المستخدم صورة جديدة
    if (image != null && image.isNotEmpty) {
      final savedImage = await saveUserImage(image);

      if (savedImage != null) {
        await DatabaseHelper.updateUserImage(user.id!, savedImage);

        user = UserModel(
          id: user.id,
          username: user.username,
          password: user.password,
          image: savedImage,
          role: user.role,
        );
      }
    }

    // تحميل المستخدم الحالي
    currentUser.value = user;

    update();

    return true;
  }

  void logout() {
    currentUser.value = null;
    update();
  }

  Future<void> changeProfileImage(String path) async {}

  Future<void> removeProfileImage() async {}
}
