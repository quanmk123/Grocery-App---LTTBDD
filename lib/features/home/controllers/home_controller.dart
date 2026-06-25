import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/category_model.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../data/repositories/favorite_repository.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/storage/local_storage.dart';

/// Home Controller - quản lý dữ liệu màn hình Home
class HomeController extends GetxController {
  final _productRepo = ProductRepository();
  final _categoryRepo = CategoryRepository();
  final _favoriteRepo = FavoriteRepository();
  final _cartController = Get.find<CartController>();
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

  int get cartCount => _cartController.totalItems;

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
    List<ProductModel> update(List<ProductModel> list) {
      return list
          .map((p) => p.copyWith(isFavorite: favoriteIds.contains(p.id)))
          .toList();
    }

    flashSaleProducts.value = update(flashSaleProducts);
    bestSellerProducts.value = update(bestSellerProducts);
    recommendedProducts.value = update(recommendedProducts);
    newProducts.value = update(newProducts);
  }

  bool isFavorite(String productId) => favoriteIds.contains(productId);

  /// Toggle yêu thích sản phẩm
  Future<void> toggleFavorite(ProductModel product) async {
    if (!LocalStorage.isLoggedIn) {
      Get.toNamed(AppRoutes.login);
      Get.snackbar('Thông báo', 'Vui lòng đăng nhập để thêm vào yêu thích!',
          snackPosition: SnackPosition.TOP);
      return;
    }
    final repo = FavoriteRepository();
    favoriteIds.value = await repo.toggleFavorite(
      List.from(favoriteIds),
      product.id,
    );

    // Refresh các list
    _updateFavoriteStatus();

    Get.snackbar(
      '',
      favoriteIds.contains(product.id)
          ? '❤️ Đã thêm vào yêu thích!'
          : '💔 Đã xóa khỏi yêu thích!',
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.only(top: 45, left: 16, right: 16),
      duration: const Duration(seconds: 1),
    );
  }

  /// Thêm sản phẩm vào giỏ hàng nhanh
  Future<void> quickAddToCart(ProductModel product) async {
    if (!LocalStorage.isLoggedIn) {
      Get.toNamed(AppRoutes.login);
      Get.snackbar('Thông báo', 'Vui lòng đăng nhập để thêm vào giỏ hàng!',
          snackPosition: SnackPosition.TOP);
      return;
    }
    if (product.isOutOfStock) return;
    try {
      await _cartController.addToCart(product, 1);
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
