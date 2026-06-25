import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../../../shared/widgets/app_network_image.dart';
import '../controllers/category_controller.dart';

/// Category Screen - hiển thị danh sách danh mục
class CategoryScreen extends GetView<CategoryController> {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh mục'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        if (controller.categories.isEmpty) {
          return const EmptyStateWidget(
            emoji: '📦',
            title: 'Chưa có danh mục',
            description: 'Danh mục sẽ được cập nhật sớm',
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.9,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final cat = controller.categories[index];
            return _CategoryCardWidget(cat: cat);
          },
        );
      }),
    );
  }
}

class _CategoryCardWidget extends StatelessWidget {
  final dynamic cat;

  const _CategoryCardWidget({required this.cat});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        AppRoutes.productList,
        arguments: cat,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Image with Emoji overlay
            Expanded(
              child: Stack(
                children: [
                  AppNetworkImage(
                    imageUrl: cat.image,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        cat.emoji,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cat.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${cat.productCount} sản phẩm',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textHint,
                      fontFamily: 'Poppins',
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
}
