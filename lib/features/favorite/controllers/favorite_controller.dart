import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/favorite_repository.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/storage/local_storage.dart';

/// Favorite Controller
class FavoriteController extends GetxController {
  final FavoriteRepository _repo = FavoriteRepository();

  final favoriteIds = <String>[].obs;
  final favoriteProducts = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  void loadFavorites() {
    favoriteIds.value = _repo.loadFavoriteIds();
    favoriteProducts.value = _repo.getFavoriteProducts(favoriteIds);
  }

  bool isFavorite(String productId) => favoriteIds.contains(productId);

  Future<void> toggleFavorite(ProductModel product) async {
    if (!LocalStorage.isLoggedIn) {
      Get.toNamed(AppRoutes.login);
      Get.snackbar('Thông báo', 'Vui lòng đăng nhập để thêm vào yêu thích!',
          snackPosition: SnackPosition.TOP);
      return;
    }
    favoriteIds.value =
        await _repo.toggleFavorite(List.from(favoriteIds), product.id);
    favoriteProducts.value = _repo.getFavoriteProducts(favoriteIds);

    final isFav = favoriteIds.contains(product.id);
    Get.snackbar(
      '',
      isFav ? '❤️ Đã thêm vào yêu thích!' : '💔 Đã xóa khỏi yêu thích!',
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.only(top: 45, left: 16, right: 16),
      duration: const Duration(seconds: 2),
    );
  }
}
