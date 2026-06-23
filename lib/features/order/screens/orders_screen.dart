import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/order_model.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../controllers/order_controller.dart';

/// Orders Screen - danh sách đơn hàng
class OrdersScreen extends GetView<OrderController> {
  const OrdersScreen({super.key});

  static const List<Map<String, dynamic>> tabs = [
    {'label': 'Tất cả', 'status': null},
    {'label': 'Chờ xác nhận', 'status': OrderStatus.pending},
    {'label': 'Xác nhận', 'status': OrderStatus.confirmed},
    {'label': 'Chuẩn bị', 'status': OrderStatus.preparing},
    {'label': 'Đang giao', 'status': OrderStatus.shipping},
    {'label': 'Đã giao', 'status': OrderStatus.delivered},
    {'label': 'Đã hủy', 'status': OrderStatus.cancelled},
  ];

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadOrders();
    });
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: AppColors.greyBackground,
        appBar: AppBar(
          title: const Text('Đơn hàng'),
          centerTitle: true,
          backgroundColor: Colors.white,
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.grey,
            labelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
            tabs: tabs.map((t) => Tab(text: t['label'] as String)).toList(),
          ),
        ),
        body: TabBarView(
          children: tabs.map((t) {
            return Obx(() => _buildOrderList(
                  controller.getOrdersByStatus(t['status'] as OrderStatus?),
                ));
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildOrderList(List<OrderModel> orders) {
    if (orders.isEmpty) {
      return const EmptyStateWidget(
        emoji: '📋',
        title: 'Chưa có đơn hàng',
        description: 'Bạn chưa có đơn hàng nào trong mục này',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) => _buildOrderCard(orders[index]),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.orderDetail, arguments: order),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.id,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: AppColors.textPrimary,
                  ),
                ),
                _buildStatusChip(order.status),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 14, color: AppColors.grey),
                const SizedBox(width: 6),
                Text(
                  Formatters.formatDateTime(order.createdAt),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textHint,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            // Product summary
            Text(
              '${order.totalItems} sản phẩm: ${order.items.take(2).map((i) => i.productName).join(', ')}${order.items.length > 2 ? '...' : ''}',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontFamily: 'Poppins',
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tổng: ${Formatters.formatCurrency(order.total)}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    fontFamily: 'Poppins',
                  ),
                ),
                const Text(
                  'Xem chi tiết →',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.primary,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(OrderStatus status) {
    Color color;
    switch (status) {
      case OrderStatus.pending:
        color = AppColors.statusPending;
        break;
      case OrderStatus.confirmed:
        color = AppColors.statusConfirmed;
        break;
      case OrderStatus.preparing:
        color = AppColors.statusPreparing;
        break;
      case OrderStatus.shipping:
        color = AppColors.statusShipping;
        break;
      case OrderStatus.delivered:
        color = AppColors.statusDelivered;
        break;
      case OrderStatus.completed:
        color = AppColors.statusCompleted;
        break;
      case OrderStatus.cancelled:
        color = AppColors.statusCancelled;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}
