import 'dart:convert';
import '../models/order_model.dart';
import '../models/cart_item_model.dart';
import '../models/address_model.dart';
import '../../core/storage/local_storage.dart';
import 'package:uuid/uuid.dart';

/// Order Repository - quản lý đơn hàng local
class OrderRepository {
  static const _uuid = Uuid();

  /// Load danh sách đơn hàng từ local storage
  List<OrderModel> loadOrders() {
    final json = LocalStorage.ordersJson;
    if (json == null || json.isEmpty) return [];
    try {
      final list = jsonDecode(json) as List;
      return list.map((e) => OrderModel.fromJson(e)).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Mới nhất trước
    } catch (_) {
      return [];
    }
  }

  /// Lưu danh sách đơn hàng
  Future<void> _saveOrders(List<OrderModel> orders) async {
    final json = jsonEncode(orders.map((e) => e.toJson()).toList());
    await LocalStorage.saveOrders(json);
  }

  /// Tạo đơn hàng mới từ cart
  Future<OrderModel> createOrder({
    required String userId,
    required List<CartItemModel> items,
    required AddressModel address,
    required DeliveryMethod deliveryMethod,
    required double discount,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate

    final subtotal = items.fold<double>(0, (sum, i) => sum + i.total);
    final shippingFee = deliveryMethod.fee;
    final total = subtotal + shippingFee - discount;

    final order = OrderModel(
      id: 'ORD${_uuid.v4().substring(0, 8).toUpperCase()}',
      userId: userId,
      items: List.from(items),
      address: address,
      deliveryMethod: deliveryMethod,
      paymentMethod: 'COD',
      subtotal: subtotal,
      shippingFee: shippingFee,
      discount: discount,
      total: total,
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
    );

    final orders = loadOrders();
    orders.insert(0, order);
    await _saveOrders(orders);

    return order;
  }

  /// Cập nhật trạng thái đơn hàng
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    final orders = loadOrders();
    final index = orders.indexWhere((o) => o.id == orderId);
    if (index >= 0) {
      orders[index].status = status;
      await _saveOrders(orders);
    }
  }

  /// Hủy đơn hàng
  Future<void> cancelOrder(String orderId) async {
    await updateOrderStatus(orderId, OrderStatus.cancelled);
  }

  /// Lấy đơn hàng theo id
  OrderModel? getOrderById(String orderId) {
    final orders = loadOrders();
    try {
      return orders.firstWhere((o) => o.id == orderId);
    } catch (_) {
      return null;
    }
  }
}
