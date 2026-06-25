import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/product_model.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/formatters.dart';
import 'app_network_image.dart';

/// Product Card - hiển thị trong danh sách sản phẩm
class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onAddCartTap;
  final bool isFavorite;

  const ProductCard({
    super.key,
    required this.product,
    this.onFavoriteTap,
    this.onAddCartTap,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.productDetail, arguments: product),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Stack(
              children: [
                // Image
                AppNetworkImage(
                  imageUrl: product.image,
                  height: 130,
                  width: double.infinity,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                // Discount badge
                if (product.hasDiscount)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.orange,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '-${product.discount}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                // Out of stock overlay
                if (product.isOutOfStock)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Hết hàng',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                  ),
                // Favorite button
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 16,
                        color: isFavorite ? Colors.red : AppColors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Product Info
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textPrimary,
                      fontFamily: 'Poppins',
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Unit
                  Text(
                    product.unit,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textHint,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Rating
                  Row(
                    children: [
                      const Icon(Icons.star, size: 12, color: AppColors.yellow),
                      const SizedBox(width: 2),
                      Text(
                        Formatters.formatRating(product.rating),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${product.reviewCount})',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textHint,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Price + Add Cart
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Formatters.formatCurrency(product.price),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          if (product.oldPrice != null)
                            Text(
                              Formatters.formatCurrency(product.oldPrice!),
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textHint,
                                fontFamily: 'Poppins',
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                      // Add to Cart button
                      GestureDetector(
                        onTap: product.isOutOfStock ? null : onAddCartTap,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: product.isOutOfStock
                                ? AppColors.greyLight
                                : AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Product Card Horizontal - hiển thị trong danh sách ngang
class ProductCardHorizontal extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onAddCartTap;
  final bool isFavorite;

  const ProductCardHorizontal({
    super.key,
    required this.product,
    this.onFavoriteTap,
    this.onAddCartTap,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.productDetail, arguments: product),
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AppNetworkImage(
                  imageUrl: product.image,
                  height: 120,
                  width: double.infinity,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                if (product.hasDiscount)
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.orange,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        '-${product.discount}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 14,
                        color: isFavorite ? Colors.red : AppColors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Formatters.formatCurrency(product.price),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      GestureDetector(
                        onTap: product.isOutOfStock ? null : onAddCartTap,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: product.isOutOfStock
                                ? AppColors.greyLight
                                : AppColors.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
