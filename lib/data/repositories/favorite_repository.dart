import '../models/product_model.dart';
import '../datasource/mock/mock_data.dart';
import '../../core/storage/local_storage.dart';

/// Favorite Repository - quản lý danh sách yêu thích
class FavoriteRepository {
  /// Load danh sách yêu thích từ local storage
  List<String> loadFavoriteIds() {
    return LocalStorage.favoriteIds;
  }

  /// Toggle favorite (thêm hoặc xóa)
  Future<List<String>> toggleFavorite(
    List<String> currentIds,
    String productId,
  ) async {
    final ids = List<String>.from(currentIds);
    if (ids.contains(productId)) {
      ids.remove(productId);
    } else {
      ids.add(productId);
    }
    await LocalStorage.saveFavoriteIds(ids);
    return ids;
  }

  /// Lấy danh sách sản phẩm yêu thích
  List<ProductModel> getFavoriteProducts(List<String> favoriteIds) {
    return MockData.products
        .where((p) => favoriteIds.contains(p.id))
        .map((p) {
          p.isFavorite = true;
          return p;
        })
        .toList();
  }

  /// Kiểm tra sản phẩm có trong yêu thích không
  bool isFavorite(List<String> favoriteIds, String productId) {
    return favoriteIds.contains(productId);
  }
}
