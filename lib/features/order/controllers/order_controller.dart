import 'package:get/get.dart';
import '../../../data/models/order_model.dart';
import '../../../data/repositories/order_repository.dart';

/// Order Controller - quản lý đơn hàng
class OrderController extends GetxController {
  final OrderRepository _repo = OrderRepository();

  final orders = <OrderModel>[].obs;
  final isLoading = false.obs;
  final selectedOrder = Rxn<OrderModel>();

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  void loadOrders() {
    orders.value = _repo.loadOrders();
  }

  /// Lấy đơn hàng theo status
  List<OrderModel> getOrdersByStatus(OrderStatus? status) {
    if (status == null) return orders;
    if (status == OrderStatus.preparing) {
      return orders
          .where((o) =>
              o.status == OrderStatus.preparing ||
              o.status == OrderStatus.confirmed)
          .toList();
    }
    return orders.where((o) => o.status == status).toList();
  }

  /// Hủy đơn hàng
  Future<void> cancelOrder(String orderId) async {
    isLoading.value = true;
    try {
      await _repo.cancelOrder(orderId);
      loadOrders();
      Get.snackbar(
        'Thành công',
        'Đơn hàng đã được hủy thành công',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Cập nhật trạng thái đơn hàng (demo)
  Future<void> updateStatus(String orderId, OrderStatus status) async {
    await _repo.updateOrderStatus(orderId, status);
    loadOrders();
  }

  /// Lấy chi tiết đơn hàng
  OrderModel? getOrderById(String id) => _repo.getOrderById(id);
}
