import '../models/product_model.dart';
import '../models/category_model.dart';
import '../datasource/mock/mock_data.dart';

/// Product Repository - lấy danh sách sản phẩm từ mock data
class ProductRepository {
  /// Lấy tất cả sản phẩm
  Future<List<ProductModel>> getAllProducts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(MockData.products);
  }

  /// Cập nhật số lượng tồn kho (sau khi mua)
  Future<void> updateStock(String productId, int quantityToSubtract) async {
    final index = MockData.products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      final currentStock = MockData.products[index].stock;
      final newStock = currentStock - quantityToSubtract;
      MockData.products[index] = MockData.products[index].copyWith(
        stock: newStock > 0 ? newStock : 0,
      );
    }
  }

  /// Lấy sản phẩm theo category
  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.products
        .where((p) => p.categoryId == categoryId)
        .toList();
  }

  /// Lấy sản phẩm flash sale
  Future<List<ProductModel>> getFlashSaleProducts() async {
    return MockData.products.where((p) => p.isFlashSale).toList();
  }

  /// Lấy sản phẩm best seller
  Future<List<ProductModel>> getBestSellerProducts() async {
    return MockData.products.where((p) => p.isBestSeller).toList();
  }

  /// Lấy sản phẩm được gợi ý
  Future<List<ProductModel>> getRecommendedProducts() async {
    return MockData.products.where((p) => p.isRecommended).toList();
  }

  /// Lấy sản phẩm mới
  Future<List<ProductModel>> getNewProducts() async {
    return MockData.products.where((p) => p.isNew).toList();
  }

  /// Lấy chi tiết sản phẩm theo id
  Future<ProductModel?> getProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return MockData.products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Tìm kiếm sản phẩm theo từ khóa
  Future<List<ProductModel>> searchProducts(
    String query, {
    double? minPrice,
    double? maxPrice,
    String? categoryId,
    String? sortBy, // 'price_asc', 'price_desc', 'rating_desc'
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Nếu query rỗng và không có filter nào, trả về rỗng (hoặc tất cả, tùy logic. Hiện tại trả về rỗng theo code cũ)
    if (query.trim().isEmpty && minPrice == null && maxPrice == null && categoryId == null) {
      return [];
    }

    final q = query.toLowerCase().trim();
    
    var results = MockData.products.where((p) {
      // 1. Text match
      bool matchesQuery = true;
      if (q.isNotEmpty) {
        matchesQuery = p.name.toLowerCase().contains(q) ||
            p.categoryName.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q);
      }

      // 2. Category match
      bool matchesCategory = true;
      if (categoryId != null && categoryId.isNotEmpty) {
        matchesCategory = p.categoryId == categoryId;
      }

      // 3. Price match
      bool matchesPrice = true;
      if (minPrice != null) {
        matchesPrice = matchesPrice && (p.price >= minPrice);
      }
      if (maxPrice != null) {
        matchesPrice = matchesPrice && (p.price <= maxPrice);
      }

      return matchesQuery && matchesCategory && matchesPrice;
    }).toList();

    // 4. Sorting
    if (sortBy != null) {
      switch (sortBy) {
        case 'price_asc':
          results.sort((a, b) => a.price.compareTo(b.price));
          break;
        case 'price_desc':
          results.sort((a, b) => b.price.compareTo(a.price));
          break;
        case 'rating_desc':
          results.sort((a, b) => b.rating.compareTo(a.rating));
          break;
      }
    }

    return results;
  }

  /// Lấy banners
  Future<List<Map<String, dynamic>>> getBanners() async {
    return MockData.banners;
  }
}

/// Category Repository
class CategoryRepository {
  Future<List<CategoryModel>> getAllCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(MockData.categories);
  }

  Future<CategoryModel?> getCategoryById(String id) async {
    try {
      return MockData.categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
