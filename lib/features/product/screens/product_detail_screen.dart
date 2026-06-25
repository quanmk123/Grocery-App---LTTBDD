import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_network_image.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../controllers/product_controller.dart';

/// Product Detail Screen
class ProductDetailScreen extends GetView<ProductController> {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final product = controller.product.value;
        if (product == null) {
          return const Center(
            child: Text('Không tìm thấy sản phẩm'),
          );
        }

        return Stack(
          children: [
            CustomScrollView(
              slivers: [
                // Image header
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  leading: IconButton(
                    icon: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                          )
                        ],
                      ),
                      child: const Icon(Icons.arrow_back, size: 20),
                    ),
                    onPressed: () => Get.back(),
                  ),
                  actions: [
                    // Favorite button
                    Obx(() => IconButton(
                          icon: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                )
                              ],
                            ),
                            child: Icon(
                              controller.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 20,
                              color: controller.isFavorite
                                  ? Colors.red
                                  : Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textPrimary,
                            ),
                          ),
                          onPressed: controller.toggleFavorite,
                        )),
                    const SizedBox(width: 8),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: AppNetworkImage(
                      imageUrl: product.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category tag
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primarySurface,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            product.categoryName,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Name
                        Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).textTheme.titleLarge?.color ?? AppColors.textPrimary,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Unit + Stock
                        Row(
                          children: [
                            Text(
                              product.unit,
                              style: const TextStyle(
                                color: AppColors.textHint,
                                fontSize: 13,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: product.isOutOfStock
                                    ? AppColors.error.withOpacity(0.1)
                                    : AppColors.success.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                product.isOutOfStock
                                    ? 'Hết hàng'
                                    : 'Còn ${product.stock} sản phẩm',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: product.isOutOfStock
                                      ? AppColors.error
                                      : AppColors.success,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Rating
                        Row(
                          children: [
                            RatingBar.builder(
                              initialRating: product.rating,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 18,
                              ignoreGestures: true,
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: AppColors.yellow,
                              ),
                              onRatingUpdate: (_) {},
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${Formatters.formatRating(product.rating)} (${Formatters.formatNumber(product.reviewCount)} đánh giá)',
                              style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8) ?? AppColors.textSecondary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Price section
                        Row(
                          children: [
                            Text(
                              Formatters.formatCurrency(product.price),
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            if (product.oldPrice != null) ...[
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Formatters.formatCurrency(
                                        product.oldPrice!),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: AppColors.textHint,
                                      fontFamily: 'Poppins',
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  if (product.discount != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.orange,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        '-${product.discount}%',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Divider
                        const Divider(height: 1),
                        const SizedBox(height: 20),

                        // Description
                        Text(
                          'Mô tả sản phẩm',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                            color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8) ?? AppColors.textSecondary,
                            height: 1.6,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 120), // space for bottom bar
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Bottom: Quantity + Add to Cart
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Quantity selector
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Số lượng',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textHint,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Obx(() => QuantitySelector(
                              quantity: controller.quantity.value,
                              maxQuantity: product.stock > 0 ? product.stock : 1,
                              onChanged: (val) {
                                controller.quantity.value = val;
                              },
                            )),
                      ],
                    ),
                    const SizedBox(width: 16),
                    // Add to Cart button
                    Expanded(
                      child: Obx(() => AppButton(
                            text: product.isOutOfStock
                                ? 'Hết hàng'
                                : 'Thêm vào giỏ hàng',
                            isLoading: controller.isLoading.value,
                            onPressed: product.isOutOfStock
                                ? null
                                : controller.addToCart,
                            icon: product.isOutOfStock
                                ? null
                                : Icons.shopping_cart_outlined,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
