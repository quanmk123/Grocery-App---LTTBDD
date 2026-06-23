import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../../../shared/widgets/product_card.dart';
import '../../../shared/widgets/app_network_image.dart';
import '../controllers/home_controller.dart';

/// Home Screen - màn hình chính
class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          return RefreshIndicator(
            onRefresh: controller.refreshData,
            color: AppColors.primary,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeader(context)),
                SliverToBoxAdapter(child: _buildSearchBar()),
                SliverToBoxAdapter(child: _buildBanners()),
                SliverToBoxAdapter(child: _buildCategories()),
                SliverToBoxAdapter(child: _buildFlashSale()),
                SliverToBoxAdapter(child: _buildBestSeller()),
                SliverToBoxAdapter(child: _buildRecommended()),
                SliverToBoxAdapter(child: _buildNewProducts()),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.greeting,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontFamily: 'Poppins',
                  ),
                ),
                Obx(() => Text(
                      controller.userName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    )),
              ],
            ),
          ),
          // Notification bell
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.greyExtraLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.textPrimary,
              size: 24,
            ),
          ),
          const SizedBox(width: 10),
          // Avatar
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text('👤', style: TextStyle(fontSize: 22)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.search),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: AppColors.grey, size: 22),
            const SizedBox(width: 10),
            const Text(
              'Tìm kiếm sản phẩm...',
              style: TextStyle(
                color: AppColors.textHint,
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.tune, color: AppColors.primary, size: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanners() {
    return Obx(() {
      if (controller.banners.isEmpty) return const SizedBox.shrink();
      return SizedBox(
        height: 185,
        child: PageView.builder(
          padEnds: false,
          controller: PageController(viewportFraction: 0.92),
          itemCount: controller.banners.length,
          itemBuilder: (context, index) {
            final banner = controller.banners[index];
            return _buildBannerCard(banner);
          },
        ),
      );
    });
  }

  Widget _buildBannerCard(Map<String, dynamic> banner) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 8, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background Image
            AppNetworkImage(
              imageUrl: banner['image'] as String?,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            // Gradient Overlay for readability
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withOpacity(0.75),
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.orange,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      '🔥 FLASH SALE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    banner['title'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    banner['subtitle'] as String,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 13,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Mua ngay →',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Obx(() {
      if (controller.categories.isEmpty) return const SizedBox.shrink();
      return Column(
        children: [
          const SizedBox(height: 20),
          SectionHeader(
            title: 'Danh mục',
            seeAllText: 'Xem tất cả',
            onSeeAll: () {},
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.categories.length,
              itemBuilder: (context, index) {
                final cat = controller.categories[index];
                return GestureDetector(
                  onTap: () => Get.toNamed(
                    AppRoutes.productList,
                    arguments: cat,
                  ),
                  child: Container(
                    width: 75,
                    margin: const EdgeInsets.only(right: 12),
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              cat.emoji,
                              style: const TextStyle(fontSize: 28),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          cat.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 11,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildFlashSale() {
    return Obx(() {
      if (controller.flashSaleProducts.isEmpty) return const SizedBox.shrink();
      return Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.orange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '🔥 Flash Sale',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Xem tất cả',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 13,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.flashSaleProducts.length,
              itemBuilder: (context, index) {
                final p = controller.flashSaleProducts[index];
                return Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 12),
                  child: ProductCardHorizontal(
                    product: p,
                    isFavorite: controller.isFavorite(p.id),
                    onFavoriteTap: () => controller.toggleFavorite(p),
                    onAddCartTap: () => controller.quickAddToCart(p),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildBestSeller() {
    return Obx(() {
      if (controller.bestSellerProducts.isEmpty) return const SizedBox.shrink();
      return Column(
        children: [
          const SizedBox(height: 20),
          SectionHeader(
            title: 'Bán chạy nhất ⭐',
            seeAllText: 'Xem tất cả',
            onSeeAll: () {},
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.bestSellerProducts.length,
              itemBuilder: (context, index) {
                final p = controller.bestSellerProducts[index];
                return Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 12),
                  child: ProductCardHorizontal(
                    product: p,
                    isFavorite: controller.isFavorite(p.id),
                    onFavoriteTap: () => controller.toggleFavorite(p),
                    onAddCartTap: () => controller.quickAddToCart(p),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildRecommended() {
    return Obx(() {
      if (controller.recommendedProducts.isEmpty) return const SizedBox.shrink();
      return Column(
        children: [
          const SizedBox(height: 20),
          SectionHeader(
            title: 'Gợi ý cho bạn 💚',
            seeAllText: 'Xem tất cả',
            onSeeAll: () {},
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: controller.recommendedProducts.length > 6
                  ? 6
                  : controller.recommendedProducts.length,
              itemBuilder: (context, index) {
                final p = controller.recommendedProducts[index];
                return ProductCard(
                  product: p,
                  isFavorite: controller.isFavorite(p.id),
                  onFavoriteTap: () => controller.toggleFavorite(p),
                  onAddCartTap: () => controller.quickAddToCart(p),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildNewProducts() {
    return Obx(() {
      if (controller.newProducts.isEmpty) return const SizedBox.shrink();
      return Column(
        children: [
          const SizedBox(height: 20),
          SectionHeader(
            title: 'Hàng mới về 🆕',
            seeAllText: 'Xem tất cả',
            onSeeAll: () {},
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.newProducts.length,
              itemBuilder: (context, index) {
                final p = controller.newProducts[index];
                return Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 12),
                  child: ProductCardHorizontal(
                    product: p,
                    isFavorite: controller.isFavorite(p.id),
                    onFavoriteTap: () => controller.toggleFavorite(p),
                    onAddCartTap: () => controller.quickAddToCart(p),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
