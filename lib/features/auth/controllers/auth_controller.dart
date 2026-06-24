import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../core/routes/app_routes.dart';

/// Auth Controller - xử lý login, register, forgot password
class AuthController extends GetxController {
  final AuthRepository _authRepo = AuthRepository();

  // --- Login controllers ---
  final loginFormKey = GlobalKey<FormState>();
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  // --- Register controllers ---
  final registerFormKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final registerEmailController = TextEditingController();
  final phoneController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final errorMessage = ''.obs;

  @override
  void onClose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    nameController.dispose();
    registerEmailController.dispose();
    phoneController.dispose();
    registerPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  /// Login với email và password
  Future<void> login({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final user = await _authRepo.login(email, password);
      if (user != null) {
        Get.offAllNamed(AppRoutes.main);
      } else {
        errorMessage.value = 'Email hoặc mật khẩu không đúng!';
      }
    } catch (e) {
      errorMessage.value = 'Có lỗi xảy ra. Vui lòng thử lại!';
    } finally {
      isLoading.value = false;
    }
  }

  /// Register
  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final success = await _authRepo.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );
      if (success) {
        Get.snackbar(
          'Thành công',
          'Đăng ký thành công! Vui lòng đăng nhập.',
          snackPosition: SnackPosition.TOP,
        );
        Get.offNamed(AppRoutes.login);
      } else {
        errorMessage.value = 'Email này đã được đăng ký. Vui lòng dùng email khác!';
      }
    } catch (e) {
      errorMessage.value = 'Có lỗi xảy ra. Vui lòng thử lại!';
    } finally {
      isLoading.value = false;
    }
  }

  /// Forgot password
  Future<void> forgotPassword(String email) async {
    isLoading.value = true;
    try {
      await _authRepo.forgotPassword(email);
      Get.back();
      Get.snackbar(
        'Đã gửi',
        'Hướng dẫn đặt lại mật khẩu đã được gửi đến email của bạn!',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void toggleObscurePassword() => obscurePassword.toggle();
  void toggleObscureConfirmPassword() => obscureConfirmPassword.toggle();
  void clearError() => errorMessage.value = '';
}
