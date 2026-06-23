import 'cart_item_model.dart';
import 'address_model.dart';

/// Order Status Enum
enum OrderStatus {
  pending,
  confirmed,
  preparing,
  shipping,
  delivered,
  completed,
  cancelled,
}

extension OrderStatusExtension on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'Chờ xác nhận';
      case OrderStatus.confirmed:
        return 'Đã xác nhận';
      case OrderStatus.preparing:
        return 'Đang chuẩn bị';
      case OrderStatus.shipping:
        return 'Đang giao';
      case OrderStatus.delivered:
        return 'Đã giao';
      case OrderStatus.completed:
        return 'Hoàn thành';
      case OrderStatus.cancelled:
        return 'Đã hủy';
    }
  }

  String get value {
    return name; // pending, confirmed, etc.
  }

  static OrderStatus fromString(String value) {
    return OrderStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => OrderStatus.pending,
    );
  }
}

/// Delivery Method Enum
enum DeliveryMethod { standard, fast }

extension DeliveryMethodExtension on DeliveryMethod {
  String get label {
    switch (this) {
      case DeliveryMethod.standard:
        return 'Giao hàng tiêu chuẩn';
      case DeliveryMethod.fast:
        return 'Giao hàng nhanh';
    }
  }

  double get fee {
    switch (this) {
      case DeliveryMethod.standard:
        return 15000;
      case DeliveryMethod.fast:
        return 35000;
    }
  }
}

/// Order Model
class OrderModel {
  final String id;
  final String userId;
  final List<CartItemModel> items;
  final AddressModel address;
  final DeliveryMethod deliveryMethod;
  final String paymentMethod; // COD
  final double subtotal;
  final double shippingFee;
  final double discount;
  final double total;
  OrderStatus status;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.address,
    required this.deliveryMethod,
    required this.paymentMethod,
    required this.subtotal,
    required this.shippingFee,
    required this.discount,
    required this.total,
    required this.status,
    required this.createdAt,
  });

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      items: (json['items'] as List)
          .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      address: AddressModel.fromJson(json['address'] as Map<String, dynamic>),
      deliveryMethod: json['deliveryMethod'] == 'fast'
          ? DeliveryMethod.fast
          : DeliveryMethod.standard,
      paymentMethod: json['paymentMethod'] as String? ?? 'COD',
      subtotal: (json['subtotal'] as num).toDouble(),
      shippingFee: (json['shippingFee'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      status: OrderStatusExtension.fromString(json['status'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((e) => e.toJson()).toList(),
      'address': address.toJson(),
      'deliveryMethod': deliveryMethod.name,
      'paymentMethod': paymentMethod,
      'subtotal': subtotal,
      'shippingFee': shippingFee,
      'discount': discount,
      'total': total,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  OrderModel copyWith({
    String? id,
    String? userId,
    List<CartItemModel>? items,
    AddressModel? address,
    DeliveryMethod? deliveryMethod,
    String? paymentMethod,
    double? subtotal,
    double? shippingFee,
    double? discount,
    double? total,
    OrderStatus? status,
    DateTime? createdAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      address: address ?? this.address,
      deliveryMethod: deliveryMethod ?? this.deliveryMethod,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      subtotal: subtotal ?? this.subtotal,
      shippingFee: shippingFee ?? this.shippingFee,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
