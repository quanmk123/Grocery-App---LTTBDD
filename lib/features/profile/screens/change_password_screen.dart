import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/app_button.dart';
import '../controllers/profile_controller.dart';

/// Change Password Screen
class ChangePasswordScreen extends GetView<ProfileController> {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final currentPwCtrl = TextEditingController();
    final newPwCtrl = TextEditingController();
    final confirmPwCtrl = TextEditingController();
    final obscureCurrent = true.obs;
    final obscureNew = true.obs;
    final obscureConfirm = true.obs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đổi mật khẩu'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Current password
              Obx(() => TextFormField(
                    controller: currentPwCtrl,
                    obscureText: obscureCurrent.value,
                    decoration: InputDecoration(
                      labelText: 'Mật khẩu hiện tại',
                      prefixIcon: const Icon(Icons.lock_outline, color: AppColors.grey),
                      suffixIcon: IconButton(
                        icon: Icon(obscureCurrent.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                            color: AppColors.grey),
                        onPressed: () => obscureCurrent.toggle(),
                      ),
                    ),
                    validator: Validators.validatePassword,
                  )),
              const SizedBox(height: 16),
              // New password
              Obx(() => TextFormField(
                    controller: newPwCtrl,
                    obscureText: obscureNew.value,
                    decoration: InputDecoration(
                      labelText: 'Mật khẩu mới',
                      prefixIcon: const Icon(Icons.lock_outline, color: AppColors.grey),
                      suffixIcon: IconButton(
                        icon: Icon(obscureNew.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                            color: AppColors.grey),
                        onPressed: () => obscureNew.toggle(),
                      ),
                    ),
                    validator: Validators.validatePassword,
                  )),
              const SizedBox(height: 16),
              // Confirm password
              Obx(() => TextFormField(
                    controller: confirmPwCtrl,
                    obscureText: obscureConfirm.value,
                    decoration: InputDecoration(
                      labelText: 'Xác nhận mật khẩu mới',
                      prefixIcon: const Icon(Icons.lock_outline, color: AppColors.grey),
                      suffixIcon: IconButton(
                        icon: Icon(obscureConfirm.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                            color: AppColors.grey),
                        onPressed: () => obscureConfirm.toggle(),
                      ),
                    ),
                    validator: (v) =>
                        Validators.validateConfirmPassword(v, newPwCtrl.text),
                  )),
              const SizedBox(height: 32),
              Obx(() => AppButton(
                    text: 'Đổi mật khẩu',
                    isLoading: controller.isLoading.value,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        controller.changePassword(
                          currentPassword: currentPwCtrl.text,
                          newPassword: newPwCtrl.text,
                        );
                      }
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
