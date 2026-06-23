import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/category_model.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../data/repositories/favorite_repository.dart';
import '../../../data/repositories/cart_repository.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';

/// Home Controller - quản lý dữ liệu màn hình Home
class HomeController extends GetxController {
  final _productRepo = ProductRepository();
  final _categoryRepo = CategoryRepository();
  final _favoriteRepo = FavoriteRepository();
  final _cartRepo = CartRepository();
  final _authRepo = AuthRepository();

  final isLoading = true.obs;
  final categories = <CategoryModel>[].obs;
  final banners = <Map<String, dynamic>>[].obs;
  final flashSaleProducts = <ProductModel>[].obs;
  final bestSellerProducts = <ProductModel>[].obs;
  final recommendedProducts = <ProductModel>[].obs;
  final newProducts = <ProductModel>[].obs;
  final favoriteIds = <String>[].obs;
  final cartItems = <dynamic>[].obs;
  final currentUser = Rxn<UserModel>();

  int get cartCount => _cartRepo.loadCart()
      .fold(0, (sum, item) => sum + item.quantity);

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUser();
    _loadData();
  }

  void _loadCurrentUser() {
    currentUser.value = _authRepo.getCurrentUser();
  }

  Future<void> _loadData() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([
        _categoryRepo.getAllCategories(),
        _productRepo.getBanners(),
        _productRepo.getFlashSaleProducts(),
        _productRepo.getBestSellerProducts(),
        _productRepo.getRecommendedProducts(),
        _productRepo.getNewProducts(),
      ]);

      categories.value = results[0] as List<CategoryModel>;
      banners.value = results[1] as List<Map<String, dynamic>>;
      flashSaleProducts.value = results[2] as List<ProductModel>;
      bestSellerProducts.value = results[3] as List<ProductModel>;
      recommendedProducts.value = results[4] as List<ProductModel>;
      newProducts.value = results[5] as List<ProductModel>;

      // Load favorites
      favoriteIds.value = _favoriteRepo.loadFavoriteIds();

      // Cập nhật isFavorite cho products
      _updateFavoriteStatus();
    } finally {
      isLoading.value = false;
    }
  }

  void _updateFavoriteStatus() {
    void update(List<ProductModel> list) {
      for (var p in list) {
        p.isFavorite = favoriteIds.contains(p.id);
      }
    }

    update(flashSaleProducts);
    update(bestSellerProducts);
    update(recommendedProducts);
    update(newProducts);
  }

  bool isFavorite(String productId) => favoriteIds.contains(productId);

  /// Toggle yêu thích sản phẩm
  Future<void> toggleFavorite(ProductModel product) async {
    final repo = FavoriteRepository();
    favoriteIds.value = await repo.toggleFavorite(
      List.from(favoriteIds),
      product.id,
    );
    product.isFavorite = favoriteIds.contains(product.id);

    // Refresh các list
    _updateFavoriteStatus();
    flashSaleProducts.refresh();
    bestSellerProducts.refresh();
    recommendedProducts.refresh();
    newProducts.refresh();

    Get.snackbar(
      '',
      product.isFavorite ? '❤️ Đã thêm vào yêu thích!' : '💔 Đã xóa khỏi yêu thích!',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  /// Thêm sản phẩm vào giỏ hàng nhanh
  Future<void> quickAddToCart(ProductModel product) async {
    if (product.isOutOfStock) return;
    try {
      final currentCart = _cartRepo.loadCart();
      await _cartRepo.addToCart(currentCart, product, 1);
      Get.snackbar(
        '',
        '🛒 Đã thêm ${product.name} vào giỏ hàng!',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar('Lỗi', e.toString(), snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> refreshData() async => _loadData();

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Chào buổi sáng';
    if (hour < 18) return 'Chào buổi chiều';
    return 'Chào buổi tối';
  }

  String get userName => currentUser.value?.name.split(' ').last ?? 'bạn';
}
