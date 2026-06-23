import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/app_button.dart';
import '../controllers/auth_controller.dart';

/// Forgot Password Screen
class ForgotPasswordScreen extends GetView<AuthController> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Quên mật khẩu'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Illustration
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('🔐', style: TextStyle(fontSize: 56)),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Đặt lại mật khẩu',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Nhập email của bạn để nhận hướng dẫn đặt lại mật khẩu.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontFamily: 'Poppins',
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // Email field
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Nhập email của bạn',
                  prefixIcon:
                      Icon(Icons.email_outlined, color: AppColors.grey),
                ),
                validator: Validators.validateEmail,
              ),
              const SizedBox(height: 28),

              // Submit button
              Obx(() => AppButton(
                    text: 'Gửi hướng dẫn đặt lại',
                    isLoading: controller.isLoading.value,
                    icon: Icons.send_outlined,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        controller.forgotPassword(emailController.text);
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
