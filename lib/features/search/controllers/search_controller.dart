import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../core/storage/local_storage.dart';

/// Search Controller
class SearchController extends GetxController {
  final ProductRepository _repo = ProductRepository();

  final searchQuery = ''.obs;
  final searchResults = <ProductModel>[].obs;
  final recentSearches = <String>[].obs;
  final isSearching = false.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    recentSearches.value = LocalStorage.recentSearches;
    // Lắng nghe thay đổi query để search real-time
    debounce(searchQuery, _performSearch,
        time: const Duration(milliseconds: 400));
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      searchResults.clear();
      isSearching.value = false;
      return;
    }
    isLoading.value = true;
    isSearching.value = true;
    searchResults.value = await _repo.searchProducts(query);
    isLoading.value = false;
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void submitSearch(String query) async {
    if (query.trim().isEmpty) return;
    // Lưu vào recent searches
    final recent = List<String>.from(recentSearches);
    recent.remove(query);
    recent.insert(0, query);
    if (recent.length > 10) recent.removeLast();
    recentSearches.value = recent;
    await LocalStorage.saveRecentSearches(recent);
    searchQuery.value = query;
  }

  void clearSearch() {
    searchQuery.value = '';
    searchResults.clear();
    isSearching.value = false;
  }

  Future<void> clearRecentSearches() async {
    recentSearches.clear();
    await LocalStorage.saveRecentSearches([]);
  }

  void searchFromRecent(String query) {
    searchQuery.value = query;
    submitSearch(query);
  }
}
