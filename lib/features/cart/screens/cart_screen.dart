import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_network_image.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../../../shared/dialogs/confirm_dialog.dart';
import '../controllers/cart_controller.dart';

/// Cart Screen
class CartScreen extends GetView<CartController> {
  final VoidCallback? onHomeTap;

  const CartScreen({super.key, this.onHomeTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      appBar: AppBar(
        title: Obx(() => Text(
              'Giỏ hàng (${controller.totalItems})',
            )),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isEmpty) {
          return EmptyStateWidget(
            emoji: '🛒',
            title: 'Giỏ hàng trống',
            description: 'Bạn chưa có sản phẩm nào trong giỏ hàng',
            buttonText: 'Tiếp tục mua sắm',
            onButtonTap: onHomeTap ?? () => Get.back(),
          );
        }

        return Column(
          children: [
            // Cart items list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.cartItems.length,
                itemBuilder: (context, index) {
                  final item = controller.cartItems[index];
                  return _buildCartItem(item);
                },
              ),
            ),

            // Order summary + Checkout button
            _buildSummary(),
          ],
        );
      }),
    );
  }

  Widget _buildCartItem(item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          // Product image
          AppNetworkImage(
            imageUrl: item.image,
            width: 80,
            height: 80,
            borderRadius: BorderRadius.circular(12),
          ),
          const SizedBox(width: 12),

          // Product info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.unit,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textHint,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      Formatters.formatCurrency(item.price),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const Spacer(),
                    // Quantity controls
                    QuantitySelector(
                      quantity: item.quantity,
                      maxQuantity: item.stock,
                      onChanged: (val) {
                        if (val == 0) {
                          _confirmRemove(item.productId, item.productName);
                        } else {
                          controller.updateQuantity(item.productId, val);
                        }
                      },
                      size: 30,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Delete button
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _confirmRemove(item.productId, item.productName),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.delete_outline,
                color: AppColors.error,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmRemove(String productId, String productName) {
    ConfirmDialog.show(
      title: 'Xóa sản phẩm?',
      message: 'Bạn có chắc chắn muốn xóa "$productName" khỏi giỏ hàng?',
      confirmText: 'Xóa',
      confirmColor: AppColors.error,
      icon: Icons.delete_outline,
      onConfirm: () => controller.removeFromCart(productId),
    );
  }

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSummaryRow('Tạm tính', controller.subtotal),
          const SizedBox(height: 8),
          _buildSummaryRow('Phí vận chuyển', controller.shippingFee),
          if (controller.discount.value > 0) ...[
            const SizedBox(height: 8),
            _buildSummaryRow(
              'Giảm giá',
              -controller.discount.value,
              color: AppColors.success,
            ),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tổng cộng',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                ),
              ),
              Obx(() => Text(
                    Formatters.formatCurrency(controller.total),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      fontFamily: 'Poppins',
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 16),
          AppButton(
            text: 'Thanh toán',
            icon: Icons.payment_outlined,
            onPressed: () => Get.toNamed(AppRoutes.checkout),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            fontFamily: 'Poppins',
          ),
        ),
        Text(
          Formatters.formatCurrency(amount),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color ?? AppColors.textPrimary,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}
