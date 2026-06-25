import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/category_model.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../../../shared/widgets/product_card.dart';
import '../../category/controllers/category_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../favorite/controllers/favorite_controller.dart';

/// Product List Screen - danh sách sản phẩm theo danh mục
class ProductListScreen extends GetView<CategoryController> {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final category = Get.arguments as CategoryModel?;
    if (category != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.selectedCategoryId.value != category.id) {
          controller.loadProductsByCategory(category.id);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(category?.name ?? 'Sản phẩm'),
        centerTitle: true,
        actions: [
          // Sort button
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () => _showSortDialog(context),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        if (controller.products.isEmpty) {
          return const EmptyStateWidget(
            emoji: '🔍',
            title: 'Không có sản phẩm',
            description: 'Danh mục này chưa có sản phẩm nào',
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.68,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final p = controller.products[index];
            final favoriteController = Get.find<FavoriteController>();
            final cartController = Get.find<CartController>();
            return Obx(() => ProductCard(
                  product: p,
                  isFavorite: favoriteController.isFavorite(p.id),
                  onFavoriteTap: () => favoriteController.toggleFavorite(p),
                  onAddCartTap: () => cartController.addToCart(p, 1),
                ));
          },
        );
      }),
    );
  }

  void _showSortDialog(BuildContext context) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sắp xếp theo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 12),
            _buildSortOption('Mặc định', SortOption.none),
            _buildSortOption('Giá tăng dần', SortOption.priceLowToHigh),
            _buildSortOption('Giá giảm dần', SortOption.priceHighToLow),
            _buildSortOption('Đánh giá cao nhất', SortOption.ratingHighest),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String label, SortOption option) {
    return Obx(() => ListTile(
          title: Text(label, style: const TextStyle(fontFamily: 'Poppins')),
          trailing: controller.selectedSort.value == option
              ? const Icon(Icons.check, color: AppColors.primary)
              : null,
          onTap: () {
            controller.sortProducts(option);
            Get.back();
          },
        ));
  }
}
