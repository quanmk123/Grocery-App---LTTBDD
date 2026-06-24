import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/category_model.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../core/storage/local_storage.dart';
import '../widgets/filter_bottom_sheet.dart';

/// Search Controller
class SearchController extends GetxController {
  final ProductRepository _repo = ProductRepository();
  final CategoryRepository _categoryRepo = CategoryRepository();

  final textController = TextEditingController();

  final searchQuery = ''.obs;
  final searchResults = <ProductModel>[].obs;
  final recentSearches = <String>[].obs;
  final categories = <CategoryModel>[].obs;
  
  final isSearching = false.obs;
  final isLoading = false.obs;

  // Filters
  final minPrice = Rxn<double>();
  final maxPrice = Rxn<double>();
  final selectedCategoryId = Rxn<String>();
  final sortBy = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    recentSearches.value = LocalStorage.recentSearches;
    _loadCategories();
    // Lắng nghe thay đổi query để search real-time
    debounce(searchQuery, _performSearch,
        time: const Duration(milliseconds: 400));
    
    // Check if openFilter argument is passed
    if (Get.arguments != null && Get.arguments['openFilter'] == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.bottomSheet(
          FilterBottomSheet(controller: this),
          isScrollControlled: true,
        );
      });
    }
  }

  Future<void> _loadCategories() async {
    categories.value = await _categoryRepo.getAllCategories();
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty && minPrice.value == null && maxPrice.value == null && selectedCategoryId.value == null) {
      searchResults.clear();
      isSearching.value = false;
      return;
    }
    isLoading.value = true;
    isSearching.value = true;
    searchResults.value = await _repo.searchProducts(
      query,
      minPrice: minPrice.value,
      maxPrice: maxPrice.value,
      categoryId: selectedCategoryId.value,
      sortBy: sortBy.value,
    );
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
    textController.clear();
    searchQuery.value = '';
    searchResults.clear();
    isSearching.value = false;
  }

  Future<void> clearRecentSearches() async {
    recentSearches.clear();
    await LocalStorage.saveRecentSearches([]);
  }

  void searchFromRecent(String query) {
    textController.text = query;
    searchQuery.value = query;
    submitSearch(query);
  }

  void applyFilter({
    double? min,
    double? max,
    String? category,
    String? sort,
  }) {
    minPrice.value = min;
    maxPrice.value = max;
    selectedCategoryId.value = category;
    sortBy.value = sort;
    
    _performSearch(searchQuery.value);
  }

  void resetFilter() {
    minPrice.value = null;
    maxPrice.value = null;
    selectedCategoryId.value = null;
    sortBy.value = null;
    
    _performSearch(searchQuery.value);
  }
}
