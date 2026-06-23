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
  Future<List<ProductModel>> searchProducts(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (query.trim().isEmpty) return [];
    final q = query.toLowerCase().trim();
    return MockData.products
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.categoryName.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q))
        .toList();
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
