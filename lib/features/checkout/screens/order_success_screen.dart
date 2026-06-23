import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/order_model.dart';
import '../../../shared/widgets/app_button.dart';

/// Order Success Screen
class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final order = Get.arguments as OrderModel?;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success animation/icon
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 600),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Title
              const Text(
                'Đặt hàng thành công! 🎉',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Poppins',
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Đơn hàng của bạn đã được đặt thành công.\nChúng tôi sẽ xử lý ngay!',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontFamily: 'Poppins',
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Order info card
              if (order != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.greyExtraLight,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _infoRow('Mã đơn hàng', order.id),
                      const SizedBox(height: 12),
                      _infoRow(
                          'Tổng tiền',
                          Formatters.formatCurrency(order.total),
                          valueColor: AppColors.primary),
                      const SizedBox(height: 12),
                      _infoRow('Thanh toán', 'COD - Tiền mặt khi nhận hàng'),
                      const SizedBox(height: 12),
                      _infoRow('Trạng thái', 'Chờ xác nhận',
                          valueColor: AppColors.statusPending),
                    ],
                  ),
                ),
              const SizedBox(height: 40),

              // Buttons
              AppButton(
                text: 'Xem đơn hàng',
                icon: Icons.receipt_long_outlined,
                onPressed: () {
                  Get.offAllNamed(AppRoutes.main);
                  // Navigate to orders tab
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (order != null) {
                      Get.toNamed(AppRoutes.orderDetail, arguments: order);
                    }
                  });
                },
              ),
              const SizedBox(height: 12),
              AppButton(
                text: 'Tiếp tục mua sắm',
                isOutlined: true,
                onPressed: () => Get.offAllNamed(AppRoutes.main),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            fontFamily: 'Poppins',
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.textPrimary,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }
}
