import 'package:get/get.dart';
import '../controllers/search_controller.dart' as sc;
import '../../cart/controllers/cart_controller.dart';
import '../../favorite/controllers/favorite_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<sc.SearchController>(() => sc.SearchController());
    if (!Get.isRegistered<CartController>()) {
      Get.lazyPut<CartController>(() => CartController());
    }
    if (!Get.isRegistered<FavoriteController>()) {
      Get.lazyPut<FavoriteController>(() => FavoriteController());
    }
  }
}
