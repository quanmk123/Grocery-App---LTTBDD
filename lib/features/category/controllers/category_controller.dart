import 'package:get/get.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/product_repository.dart';

enum SortOption { none, priceLowToHigh, priceHighToLow, ratingHighest }

/// Category Controller
class CategoryController extends GetxController {
  final CategoryRepository _categoryRepo = CategoryRepository();
  final ProductRepository _productRepo = ProductRepository();

  final categories = <CategoryModel>[].obs;
  final products = <ProductModel>[].obs;
  final isLoading = false.obs;
  final selectedCategoryId = ''.obs;
  final selectedSort = SortOption.none.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    isLoading.value = true;
    categories.value = await _categoryRepo.getAllCategories();
    isLoading.value = false;
  }

  Future<void> loadProductsByCategory(String categoryId) async {
    isLoading.value = true;
    selectedCategoryId.value = categoryId;
    selectedSort.value = SortOption.none;
    products.value = await _productRepo.getProductsByCategory(categoryId);
    isLoading.value = false;
  }

  void sortProducts(SortOption option) {
    selectedSort.value = option;
    final sorted = List<ProductModel>.from(products);
    switch (option) {
      case SortOption.priceLowToHigh:
        sorted.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceHighToLow:
        sorted.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.ratingHighest:
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortOption.none:
        break;
    }
    products.value = sorted;
  }
}
