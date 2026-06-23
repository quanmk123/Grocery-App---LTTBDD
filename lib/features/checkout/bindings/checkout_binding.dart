import 'package:get/get.dart';
import '../controllers/checkout_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../order/controllers/order_controller.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckoutController>(() => CheckoutController());
    if (!Get.isRegistered<CartController>()) {
      Get.lazyPut<CartController>(() => CartController());
    }
    if (!Get.isRegistered<OrderController>()) {
      Get.lazyPut<OrderController>(() => OrderController());
    }
  }
}
