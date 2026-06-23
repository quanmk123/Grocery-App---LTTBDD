import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_colors.dart';

/// Widget hiển thị ảnh từ network với loading shimmer và error placeholder
class AppNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? errorWidget;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    final Widget child;
    
    if (imageUrl != null && imageUrl!.startsWith('assets/')) {
      child = Image.asset(
        imageUrl!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            errorWidget ?? _buildErrorPlaceholder(),
      );
    } else if (kIsWeb) {
      child = imageUrl != null && imageUrl!.isNotEmpty
          ? Image.network(
              imageUrl!,
              width: width,
              height: height,
              fit: fit,
              errorBuilder: (context, error, stackTrace) =>
                  errorWidget ?? _buildErrorPlaceholder(),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return _buildShimmer();
              },
            )
          : (errorWidget ?? _buildErrorPlaceholder());
    } else {
      child = imageUrl != null && imageUrl!.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: imageUrl!,
              width: width,
              height: height,
              fit: fit,
              placeholder: (context, url) => _buildShimmer(),
              errorWidget: (context, url, error) =>
                  errorWidget ?? _buildErrorPlaceholder(),
            )
          : (errorWidget ?? _buildErrorPlaceholder());
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: child);
    }
    return child;
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        color: Colors.white,
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: AppColors.greyExtraLight,
      child: const Icon(
        Icons.shopping_basket_outlined,
        color: AppColors.greyLight,
        size: 36,
      ),
    );
  }
}
