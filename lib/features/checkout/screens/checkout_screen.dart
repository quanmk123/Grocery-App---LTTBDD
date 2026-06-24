import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/order_model.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/dialogs/confirm_dialog.dart';
import '../../cart/controllers/cart_controller.dart';
import '../controllers/checkout_controller.dart';

/// Checkout Screen
class CheckoutScreen extends GetView<CheckoutController> {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      appBar: AppBar(
        title: const Text('Thanh toán'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Delivery Address
            _buildSection(
              title: 'Địa chỉ giao hàng',
              icon: Icons.location_on_outlined,
              child: _buildAddressSection(),
            ),
            const SizedBox(height: 16),

            // Order Summary
            _buildSection(
              title: 'Sản phẩm (${cartController.totalItems})',
              icon: Icons.shopping_bag_outlined,
              child: _buildOrderItems(cartController),
            ),
            const SizedBox(height: 16),

            // Delivery Method
            _buildSection(
              title: 'Phương thức giao hàng',
              icon: Icons.local_shipping_outlined,
              child: _buildDeliveryMethods(),
            ),
            const SizedBox(height: 16),

            // Payment Method
            _buildSection(
              title: 'Phương thức thanh toán',
              icon: Icons.payment_outlined,
              child: _buildPaymentMethod(),
            ),
            const SizedBox(height: 16),

            // Price Summary
            _buildSection(
              title: 'Chi tiết thanh toán',
              icon: Icons.receipt_outlined,
              child: _buildPriceSummary(cartController),
            ),
            const SizedBox(height: 24),

            // Confirm button
            Obx(() => AppButton(
                  text: 'Đặt hàng ngay',
                  isLoading: controller.isLoading.value,
                  icon: Icons.check_circle_outline,
                  onPressed: () {
                    ConfirmDialog.show(
                      title: 'Xác nhận đặt hàng',
                      message: 'Bạn có chắc chắn muốn tiến hành đặt hàng không?',
                      confirmText: 'Đặt hàng',
                      confirmColor: AppColors.primary,
                      icon: Icons.shopping_bag_outlined,
                      onConfirm: controller.placeOrder,
                    );
                  },
                )),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    return Obx(() {
      final address = controller.selectedAddress.value;
      if (address == null) {
        return GestureDetector(
          onTap: () => Get.toNamed(AppRoutes.address),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.primary,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(Icons.add, color: AppColors.primary),
                SizedBox(width: 8),
                Text(
                  'Thêm địa chỉ giao hàng',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.home_outlined, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address.fullName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  address.phone,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  address.fullAddress,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontFamily: 'Poppins',
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => Get.toNamed(AppRoutes.address),
            child: const Text(
              'Thay đổi',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 13,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildOrderItems(CartController cartController) {
    return Column(
      children: cartController.cartItems
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Text(
                      '${item.quantity}x',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textHint,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.productName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    Text(
                      Formatters.formatCurrency(item.total),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildDeliveryMethods() {
    return Obx(() => Column(
          children: [
            _buildDeliveryOption(
              method: DeliveryMethod.standard,
              title: 'Giao hàng tiêu chuẩn',
              subtitle: '3-5 ngày làm việc',
              icon: '📦',
            ),
            const SizedBox(height: 8),
            _buildDeliveryOption(
              method: DeliveryMethod.fast,
              title: 'Giao hàng nhanh',
              subtitle: '1-2 ngày làm việc',
              icon: '⚡',
            ),
          ],
        ));
  }

  Widget _buildDeliveryOption({
    required DeliveryMethod method,
    required String title,
    required String subtitle,
    required String icon,
  }) {
    final isSelected = controller.selectedDelivery.value == method;
    return GestureDetector(
      onTap: () => controller.selectDeliveryMethod(method),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primarySurface : AppColors.greyExtraLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.greyLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textHint,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            Text(
              Formatters.formatCurrency(method.fee),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary),
      ),
      child: const Row(
        children: [
          Text('💵', style: TextStyle(fontSize: 24)),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'COD - Thanh toán khi nhận hàng',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  'Thanh toán bằng tiền mặt khi nhận hàng',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textHint,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle, color: AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildPriceSummary(CartController cartController) {
    return Obx(() => Column(
          children: [
            _priceRow('Tạm tính', cartController.subtotal),
            const SizedBox(height: 8),
            _priceRow('Phí vận chuyển', controller.shippingFee),
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
                Text(
                  Formatters.formatCurrency(
                      cartController.subtotal + controller.shippingFee),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget _priceRow(String label, double amount) {
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
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}
