import 'dart:convert';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import '../../core/storage/local_storage.dart';

/// Cart Repository - quản lý giỏ hàng local
class CartRepository {
  /// Load cart từ local storage
  List<CartItemModel> loadCart() {
    final json = LocalStorage.cartItemsJson;
    if (json == null || json.isEmpty) return [];
    try {
      final list = jsonDecode(json) as List;
      return list.map((e) => CartItemModel.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  /// Lưu cart vào local storage
  Future<void> _saveCart(List<CartItemModel> items) async {
    final json = jsonEncode(items.map((e) => e.toJson()).toList());
    await LocalStorage.saveCartItems(json);
  }

  /// Thêm sản phẩm vào cart
  Future<List<CartItemModel>> addToCart(
    List<CartItemModel> currentCart,
    ProductModel product,
    int quantity,
  ) async {
    final cart = List<CartItemModel>.from(currentCart);
    final existingIndex = cart.indexWhere((i) => i.productId == product.id);

    if (existingIndex >= 0) {
      // Nếu sản phẩm đã có trong cart, tăng số lượng
      final existing = cart[existingIndex];
      final newQty = existing.quantity + quantity;
      if (newQty > product.stock) {
        throw Exception('Số lượng vượt quá tồn kho!');
      }
      cart[existingIndex] = existing.copyWith(quantity: newQty);
    } else {
      // Thêm mới vào cart
      cart.add(CartItemModel(
        productId: product.id,
        productName: product.name,
        image: product.image,
        price: product.price,
        quantity: quantity,
        stock: product.stock,
        unit: product.unit,
      ));
    }

    await _saveCart(cart);
    return cart;
  }

  /// Cập nhật số lượng sản phẩm
  Future<List<CartItemModel>> updateQuantity(
    List<CartItemModel> currentCart,
    String productId,
    int newQuantity,
  ) async {
    final cart = List<CartItemModel>.from(currentCart);
    final index = cart.indexWhere((i) => i.productId == productId);
    if (index < 0) return cart;

    if (newQuantity <= 0) {
      cart.removeAt(index);
    } else if (newQuantity > cart[index].stock) {
      throw Exception('Số lượng vượt quá tồn kho!');
    } else {
      cart[index] = cart[index].copyWith(quantity: newQuantity);
    }

    await _saveCart(cart);
    return cart;
  }

  /// Xóa sản phẩm khỏi cart
  Future<List<CartItemModel>> removeFromCart(
    List<CartItemModel> currentCart,
    String productId,
  ) async {
    final cart = currentCart.where((i) => i.productId != productId).toList();
    await _saveCart(cart);
    return cart;
  }

  /// Xóa toàn bộ giỏ hàng
  Future<void> clearCart() async {
    await LocalStorage.clearCartItems();
  }
}
