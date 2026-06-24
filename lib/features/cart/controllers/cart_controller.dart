import 'package:flutter/material.dart';
import '../../home/controllers/main_controller.dart';
import 'package:get/get.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/cart_repository.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/storage/local_storage.dart';
/// Cart Controller - quản lý giỏ hàng
class CartController extends GetxController {
  final CartRepository _repo = CartRepository();

  final cartItems = <CartItemModel>[].obs;
  final isLoading = false.obs;
  final discount = 0.0.obs; // có thể dùng voucher sau

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  void loadCart() {
    cartItems.value = _repo.loadCart();
  }

  int get totalItems => cartItems.fold(0, (sum, i) => sum + i.quantity);

  double get subtotal => cartItems.fold(0.0, (sum, i) => sum + i.total);

  double get shippingFee => subtotal > 0 ? 15000 : 0;

  double get total => subtotal + shippingFee - discount.value;

  bool get isEmpty => cartItems.isEmpty;

  /// Thêm sản phẩm vào giỏ hàng
  Future<void> addToCart(ProductModel product, int quantity) async {
    if (!LocalStorage.isLoggedIn) {
      Get.toNamed(AppRoutes.login);
      Get.snackbar('Thông báo', 'Vui lòng đăng nhập để thêm vào giỏ hàng!', snackPosition: SnackPosition.TOP);
      return;
    }
    try {
      final result = await _repo.addToCart(
        List.from(cartItems),
        product,
        quantity,
      );
      cartItems.value = result;
      Get.snackbar(
        '',
        '🛒 Đã thêm ${product.name} vào giỏ hàng!',
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
        onTap: (snack) {
          if (Get.isRegistered<MainController>()) {
            Get.find<MainController>().changeTab(2);
            Get.closeCurrentSnackbar();
            Get.until((route) => route.settings.name == AppRoutes.main);
          }
        },
      );
    } catch (e) {
      Get.snackbar('Lỗi', e.toString(), snackPosition: SnackPosition.TOP);
      rethrow;
    }
  }

  /// Tăng số lượng
  Future<void> increaseQuantity(String productId) async {
    final item = cartItems.firstWhereOrNull((i) => i.productId == productId);
    if (item == null) return;
    if (item.quantity >= item.stock) {
      Get.snackbar('Thông báo', 'Đã đạt giới hạn tồn kho!',
          snackPosition: SnackPosition.TOP);
      return;
    }
    await updateQuantity(productId, item.quantity + 1);
  }

  /// Giảm số lượng
  Future<void> decreaseQuantity(String productId) async {
    final item = cartItems.firstWhereOrNull((i) => i.productId == productId);
    if (item == null) return;
    if (item.quantity <= 1) {
      // Nếu quantity = 1, xóa khỏi cart
      removeFromCart(productId);
      return;
    }
    await updateQuantity(productId, item.quantity - 1);
  }

  /// Cập nhật số lượng
  Future<void> updateQuantity(String productId, int newQuantity) async {
    try {
      final result = await _repo.updateQuantity(
        List.from(cartItems),
        productId,
        newQuantity,
      );
      cartItems.value = result;
    } catch (e) {
      Get.snackbar('Lỗi', e.toString(), snackPosition: SnackPosition.TOP);
    }
  }

  /// Xóa sản phẩm khỏi giỏ hàng
  Future<void> removeFromCart(String productId) async {
    final result = await _repo.removeFromCart(
      List.from(cartItems),
      productId,
    );
    cartItems.value = result;
    Get.snackbar(
      '',
      '🗑️ Đã xóa sản phẩm khỏi giỏ hàng',
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  /// Xóa toàn bộ giỏ hàng
  Future<void> clearCart() async {
    await _repo.clearCart();
    cartItems.clear();
  }
}
