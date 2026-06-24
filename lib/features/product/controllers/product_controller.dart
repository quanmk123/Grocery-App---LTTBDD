import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/favorite_repository.dart';
import '../../../data/repositories/product_repository.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/storage/local_storage.dart';

/// Product Controller - chi tiết sản phẩm
class ProductController extends GetxController {
  final FavoriteRepository _favoriteRepo = FavoriteRepository();

  final product = Rxn<ProductModel>();
  final isLoading = false.obs;
  final quantity = 1.obs;
  final favoriteIds = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Load product từ argument
    final arg = Get.arguments;
    if (arg is ProductModel) {
      product.value = arg;
    }
    favoriteIds.value = _favoriteRepo.loadFavoriteIds();
  }

  Future<void> refreshData() async {
    if (product.value != null) {
      final repo = ProductRepository();
      final updatedProduct = await repo.getProductById(product.value!.id);
      if (updatedProduct != null) {
        product.value = updatedProduct;
      }
    }
  }

  bool get isFavorite =>
      product.value != null && favoriteIds.contains(product.value!.id);

  void increaseQuantity() {
    if (product.value != null && quantity.value < product.value!.stock) {
      quantity.value++;
    } else {
      Get.snackbar('Thông báo', 'Đã đạt giới hạn tồn kho!',
          snackPosition: SnackPosition.TOP);
    }
  }

  void decreaseQuantity() {
    if (quantity.value > 1) quantity.value--;
  }

  Future<void> addToCart() async {
    if (!LocalStorage.isLoggedIn) {
      Get.toNamed(AppRoutes.login);
      Get.snackbar('Thông báo', 'Vui lòng đăng nhập để thêm vào giỏ hàng!', snackPosition: SnackPosition.TOP);
      return;
    }
    if (product.value == null) return;
    if (product.value!.isOutOfStock) return;

    try {
      final cartController = Get.find<CartController>();
      await cartController.addToCart(product.value!, quantity.value);
    } catch (e) {
      Get.snackbar('Lỗi', e.toString(), snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> toggleFavorite() async {
    if (!LocalStorage.isLoggedIn) {
      Get.toNamed(AppRoutes.login);
      Get.snackbar('Thông báo', 'Vui lòng đăng nhập để thêm vào yêu thích!', snackPosition: SnackPosition.TOP);
      return;
    }
    if (product.value == null) return;
    favoriteIds.value = await _favoriteRepo.toggleFavorite(
        List.from(favoriteIds), product.value!.id);
    product.value = product.value!.copyWith(isFavorite: isFavorite);

    Get.snackbar(
      '',
      isFavorite ? '❤️ Đã thêm vào yêu thích!' : '💔 Đã xóa khỏi yêu thích!',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }
}
