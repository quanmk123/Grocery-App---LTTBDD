import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/routes/app_routes.dart';

/// Profile Controller
class ProfileController extends GetxController {
  final AuthRepository _repo = AuthRepository();

  final currentUser = Rxn<UserModel>();
  final isDarkMode = false.obs;
  final notificationsEnabled = true.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUser();
    final mode = LocalStorage.themeMode;
    if (mode == 2) {
      isDarkMode.value = true;
    } else {
      isDarkMode.value = false;
    }
  }

  void loadUser() {
    currentUser.value = _repo.getCurrentUser();
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
  }) async {
    isLoading.value = true;
    try {
      await _repo.updateProfile(name: name, phone: phone);
      loadUser();
      Get.snackbar('Thành công', 'Cập nhật thông tin thành công!',
          snackPosition: SnackPosition.TOP);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    isLoading.value = true;
    try {
      final success = await _repo.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      if (success) {
        Get.back();
        Get.snackbar('Thành công', 'Đổi mật khẩu thành công!',
            snackPosition: SnackPosition.TOP);
      } else {
        Get.snackbar('Lỗi', 'Mật khẩu hiện tại không đúng!',
            snackPosition: SnackPosition.TOP);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void toggleTheme() async {
    isDarkMode.toggle();
    await LocalStorage.saveThemeMode(isDarkMode.value ? 2 : 1);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleNotifications() => notificationsEnabled.toggle();

  Future<void> logout() async {
    await _repo.logout();
    Get.offAllNamed(AppRoutes.login);
    Get.snackbar('', '👋 Đã đăng xuất thành công',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2));
  }
}
