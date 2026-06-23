import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/favorite_repository.dart';

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
    favoriteIds.value =
        await _repo.toggleFavorite(List.from(favoriteIds), product.id);
    favoriteProducts.value = _repo.getFavoriteProducts(favoriteIds);

    final isFav = favoriteIds.contains(product.id);
    Get.snackbar(
      '',
      isFav ? '❤️ Đã thêm vào yêu thích!' : '💔 Đã xóa khỏi yêu thích!',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }
}
