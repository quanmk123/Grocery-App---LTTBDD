import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';

/// Empty State Widget - hiển thị khi không có dữ liệu
class EmptyStateWidget extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;
  final String? buttonText;
  final VoidCallback? onButtonTap;

  const EmptyStateWidget({
    super.key,
    required this.emoji,
    required this.title,
    required this.description,
    this.buttonText,
    this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Emoji icon lớn
            Text(
              emoji,
              style: const TextStyle(fontSize: 72),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7) ?? AppColors.textSecondary,
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
            if (buttonText != null && onButtonTap != null) ...[
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: onButtonTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  buttonText!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Loading Overlay Widget
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }
}

/// Section Header Widget
class SectionHeader extends StatelessWidget {
  final String title;
  final String? seeAllText;
  final VoidCallback? onSeeAll;

  const SectionHeader({
    super.key,
    required this.title,
    this.seeAllText,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          if (seeAllText != null && onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(60, 32),
              ),
              child: Text(
                seeAllText!,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Quantity Selector Widget
class QuantitySelector extends StatelessWidget {
  final int quantity;
  final int minQuantity;
  final int maxQuantity;
  final ValueChanged<int> onChanged;
  final double size;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.minQuantity = 1,
    this.maxQuantity = 99,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyLight),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrease button
          _buildButton(
            icon: Icons.remove,
            onTap: quantity > minQuantity
                ? () => onChanged(quantity - 1)
                : null,
          ),
          // Quantity display
          GestureDetector(
            onTap: () => _showQuantityDialog(context),
            child: SizedBox(
              width: size,
              child: Text(
                '$quantity',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
          // Increase button
          _buildButton(
            icon: Icons.add,
            onTap: quantity < maxQuantity
                ? () => onChanged(quantity + 1)
                : null,
          ),
        ],
      ),
    );
  }

  Future<void> _showQuantityDialog(BuildContext context) async {
    final TextEditingController textController = TextEditingController(text: quantity.toString());
    
    final int? result = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nhập số lượng', style: TextStyle(fontFamily: 'Poppins', fontSize: 18)),
          content: TextField(
            controller: textController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            autofocus: true,
            onSubmitted: (value) {
              final parsed = int.tryParse(value);
              if (parsed != null) Navigator.pop(context, parsed);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy', style: TextStyle(color: AppColors.grey, fontFamily: 'Poppins')),
            ),
            ElevatedButton(
              onPressed: () {
                final value = int.tryParse(textController.text);
                if (value != null) {
                  Navigator.pop(context, value);
                } else {
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('Xác nhận', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
            ),
          ],
        );
      },
    );

    textController.dispose();

    if (result != null) {
      int newQuantity = result;
      bool showMaxWarning = false;
      bool showMinWarning = false;

      if (newQuantity < minQuantity) {
        newQuantity = minQuantity;
        showMinWarning = true;
      }
      if (newQuantity > maxQuantity) {
        newQuantity = maxQuantity;
        showMaxWarning = true;
      }

      if (newQuantity != quantity) {
        onChanged(newQuantity);
      }

      // Đợi một chút để Dialog đóng hoàn toàn trước khi hiện Snackbar để tránh lỗi overlay
      await Future.delayed(const Duration(milliseconds: 300));
      
      if (showMaxWarning) {
        Get.snackbar(
          'Thông báo',
          'Số lượng tối đa có thể mua là $maxQuantity',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.error,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else if (showMinWarning) {
        Get.snackbar(
          'Thông báo',
          'Số lượng tối thiểu là $minQuantity',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.error,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    }
  }

  Widget _buildButton({
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: onTap != null
              ? AppColors.primarySurface
              : AppColors.greyExtraLight,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Icon(
          icon,
          size: 18,
          color: onTap != null ? AppColors.primary : AppColors.grey,
        ),
      ),
    );
  }
}
