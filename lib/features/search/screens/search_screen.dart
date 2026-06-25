import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../../../shared/widgets/product_card.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../favorite/controllers/favorite_controller.dart';
import '../controllers/search_controller.dart' as sc;
import '../widgets/filter_bottom_sheet.dart';

/// Search Screen
class SearchScreen extends GetView<sc.SearchController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textController = controller.textController;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: textController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Tìm kiếm sản phẩm...',
            border: InputBorder.none,
            hintStyle: const TextStyle(
              color: AppColors.textHint,
              fontFamily: 'Poppins',
            ),
            suffixIcon: Obx(() => controller.searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: AppColors.grey),
                    onPressed: () {
                      textController.clear();
                      controller.clearSearch();
                    },
                  )
                : const SizedBox.shrink()),
          ),
          onChanged: controller.onSearchChanged,
          onSubmitted: controller.submitSearch,
          textInputAction: TextInputAction.search,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: AppColors.primary),
            onPressed: () {
              Get.bottomSheet(
                FilterBottomSheet(controller: controller),
                isScrollControlled: true,
              );
            },
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Hủy',
              style: TextStyle(
                color: AppColors.primary,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        // Loading state
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        // Empty query - show recent searches
        if (!controller.isSearching.value) {
          return _buildRecentSearches(context);
        }

        // No results
        if (controller.searchResults.isEmpty) {
          return EmptyStateWidget(
            emoji: '🔍',
            title: 'Không tìm thấy kết quả',
            description:
                'Không có sản phẩm nào phù hợp với "${controller.searchQuery.value}"',
            buttonText: 'Xóa tìm kiếm',
            onButtonTap: () {
              textController.clear();
              controller.clearSearch();
            },
          );
        }

        // Search results
        return _buildResults();
      }),
    );
  }

  Widget _buildRecentSearches(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Popular searches
          const Text(
            '🔥 Tìm kiếm phổ biến',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Táo', 'Chuối', 'Cam', 'Cà rốt',
              'Bông cải', 'Cá hồi', 'Sữa', 'Trứng',
              'Bánh mì', 'Tôm',
            ].map((term) => GestureDetector(
              onTap: () => controller.searchFromRecent(term),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.greyLight),
                ),
                child: Text(
                  term,
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            )).toList(),
          ),

          // Recent searches
          Obx(() {
            if (controller.recentSearches.isEmpty) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tìm kiếm gần đây',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    TextButton(
                      onPressed: controller.clearRecentSearches,
                      child: const Text(
                        'Xóa tất cả',
                        style: TextStyle(
                          color: AppColors.error,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),
                ...controller.recentSearches.map((search) => ListTile(
                      dense: true,
                      leading: const Icon(Icons.history, color: AppColors.grey, size: 20),
                      title: Text(
                        search,
                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
                      ),
                      trailing: const Icon(Icons.north_west, color: AppColors.grey, size: 18),
                      onTap: () => controller.searchFromRecent(search),
                      contentPadding: EdgeInsets.zero,
                    )),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildResults() {
    final cartController = Get.find<CartController>();
    final favoriteController = Get.find<FavoriteController>();
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.68,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: controller.searchResults.length,
      itemBuilder: (context, index) {
        final p = controller.searchResults[index];
        return Obx(() => ProductCard(
              product: p,
              isFavorite: favoriteController.isFavorite(p.id),
              onFavoriteTap: () => favoriteController.toggleFavorite(p),
              onAddCartTap: () => cartController.addToCart(p, 1),
            ));
      },
    );
  }
}
