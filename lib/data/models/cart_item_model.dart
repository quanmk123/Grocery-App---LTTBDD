/// Cart Item Model
class CartItemModel {
  final String productId;
  final String productName;
  final String image;
  final double price;
  int quantity;
  final int stock;
  final String unit;

  CartItemModel({
    required this.productId,
    required this.productName,
    required this.image,
    required this.price,
    required this.quantity,
    required this.stock,
    this.unit = 'kg',
  });

  /// Tính tổng tiền của item
  double get total => price * quantity;

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      image: json['image'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      stock: json['stock'] as int,
      unit: json['unit'] as String? ?? 'kg',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'image': image,
      'price': price,
      'quantity': quantity,
      'stock': stock,
      'unit': unit,
    };
  }

  CartItemModel copyWith({
    String? productId,
    String? productName,
    String? image,
    double? price,
    int? quantity,
    int? stock,
    String? unit,
  }) {
    return CartItemModel(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      image: image ?? this.image,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      stock: stock ?? this.stock,
      unit: unit ?? this.unit,
    );
  }
}
