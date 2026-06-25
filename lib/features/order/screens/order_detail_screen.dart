import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/order_model.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/dialogs/confirm_dialog.dart';
import '../controllers/order_controller.dart';

/// Order Detail Screen
class OrderDetailScreen extends GetView<OrderController> {
  const OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final order = Get.arguments as OrderModel?;
    if (order == null) {
      return const Scaffold(
        body: Center(child: Text('Không tìm thấy đơn hàng')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết đơn hàng'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Status Card
            _buildStatusCard(context, order),
            const SizedBox(height: 16),

            // Delivery address
            _buildSection(context, 'Địa chỉ giao hàng', Icons.location_on_outlined,
                _buildAddressInfo(context, order)),
            const SizedBox(height: 16),

            // Products
            _buildSection(context, 'Sản phẩm (${order.totalItems})',
                Icons.shopping_bag_outlined, _buildProducts(context, order)),
            const SizedBox(height: 16),

            // Payment info
            _buildSection(context,
                'Thông tin thanh toán', Icons.payment_outlined, _buildPayment(context, order)),
            const SizedBox(height: 16),

            // Price summary
            _buildSection(context,
                'Chi tiết đơn hàng', Icons.receipt_outlined, _buildPriceSummary(context, order)),
            const SizedBox(height: 24),

            // Action buttons
            Obx(() {
              final currentOrder = controller.orders.firstWhereOrNull(
                      (o) => o.id == order.id) ??
                  order;
              return _buildActionButtons(currentOrder);
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, OrderModel order) {
    Color statusColor;
    switch (order.status) {
      case OrderStatus.pending: statusColor = AppColors.statusPending; break;
      case OrderStatus.confirmed: statusColor = AppColors.statusConfirmed; break;
      case OrderStatus.preparing: statusColor = AppColors.statusPreparing; break;
      case OrderStatus.shipping: statusColor = AppColors.statusShipping; break;
      case OrderStatus.delivered: statusColor = AppColors.statusDelivered; break;
      case OrderStatus.completed: statusColor = AppColors.statusCompleted; break;
      case OrderStatus.cancelled: statusColor = AppColors.statusCancelled; break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              order.status.label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: statusColor,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            Formatters.formatDateTime(order.createdAt),
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textHint,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  List<OrderStatus> _getNextStatuses(OrderStatus current) {
    switch (current) {
      case OrderStatus.pending:
        return [OrderStatus.confirmed, OrderStatus.cancelled];
      case OrderStatus.confirmed:
        return [OrderStatus.preparing];
      case OrderStatus.preparing:
        return [OrderStatus.shipping];
      case OrderStatus.shipping:
        return [OrderStatus.delivered];
      case OrderStatus.delivered:
        return [OrderStatus.completed];
      default:
        return [];
    }
  }

  Widget _buildSection(BuildContext context, String title, IconData icon, Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor,
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
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, fontFamily: 'Poppins', color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textPrimary),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(padding: const EdgeInsets.all(16), child: child),
        ],
      ),
    );
  }

  Widget _buildAddressInfo(BuildContext context, OrderModel order) {
    final a = order.address;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          a.fullName,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'Poppins', color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textPrimary),
        ),
        const SizedBox(height: 4),
        Text(a.phone,
            style: TextStyle(fontSize: 13, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8) ?? AppColors.textSecondary, fontFamily: 'Poppins')),
        const SizedBox(height: 4),
        Text(a.fullAddress,
            style: TextStyle(fontSize: 13, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8) ?? AppColors.textSecondary, fontFamily: 'Poppins', height: 1.5)),
      ],
    );
  }

  Widget _buildProducts(BuildContext context, OrderModel order) {
    return Column(
      children: order.items.map((item) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Text(
              '${item.quantity}x',
              style: TextStyle(fontSize: 13, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6) ?? AppColors.textHint, fontFamily: 'Poppins'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                item.productName,
                style: TextStyle(fontSize: 13, fontFamily: 'Poppins', color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textPrimary),
              ),
            ),
            Text(
              Formatters.formatCurrency(item.total),
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Poppins', color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textPrimary),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildPayment(BuildContext context, OrderModel order) {
    return Column(
      children: [
        _infoRow(context, 'Phương thức giao hàng', order.deliveryMethod.label),
        const SizedBox(height: 8),
        _infoRow(context, 'Phương thức thanh toán', 'COD - Tiền mặt'),
      ],
    );
  }

  Widget _buildPriceSummary(BuildContext context, OrderModel order) {
    return Column(
      children: [
        _infoRow(context, 'Tạm tính', Formatters.formatCurrency(order.subtotal)),
        const SizedBox(height: 8),
        _infoRow(context, 'Phí vận chuyển', Formatters.formatCurrency(order.shippingFee)),
        if (order.discount > 0) ...[
          const SizedBox(height: 8),
          _infoRow(context, 'Giảm giá', '-${Formatters.formatCurrency(order.discount)}',
              valueColor: AppColors.success),
        ],
        const Divider(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tổng cộng', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Poppins', color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textPrimary)),
            Text(
              Formatters.formatCurrency(order.total),
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary, fontFamily: 'Poppins'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(OrderModel order) {
    final canCancel = order.status == OrderStatus.pending;
    return Column(
      children: [
        if (canCancel)
          AppButton(
            text: 'Hủy đơn hàng',
            isOutlined: true,
            icon: Icons.cancel_outlined,
            onPressed: () {
              ConfirmDialog.show(
                title: 'Hủy đơn hàng?',
                message: 'Bạn có chắc chắn muốn hủy đơn hàng ${order.id}?',
                confirmText: 'Hủy đơn',
                icon: Icons.cancel_outlined,
                onConfirm: () {
                  controller.cancelOrder(order.id);
                  Get.back();
                },
              );
            },
          ),
      ],
    );
  }

  Widget _infoRow(BuildContext context, String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(fontSize: 13, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8) ?? AppColors.textSecondary, fontFamily: 'Poppins')),
        Flexible(
          child: Text(value,
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textPrimary,
                  fontFamily: 'Poppins')),
        ),
      ],
    );
  }
}
