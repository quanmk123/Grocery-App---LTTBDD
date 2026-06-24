import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../controllers/main_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../favorite/controllers/favorite_controller.dart';
import '../../category/controllers/category_controller.dart';
import '../../order/controllers/order_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CartController>(() => CartController());
    Get.lazyPut<FavoriteController>(() => FavoriteController());
    Get.lazyPut<CategoryController>(() => CategoryController());
    Get.lazyPut<OrderController>(() => OrderController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
