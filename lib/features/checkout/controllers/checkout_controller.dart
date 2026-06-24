import 'package:get/get.dart';
import '../../../data/models/address_model.dart';
import '../../../data/models/order_model.dart';
import '../../../data/repositories/address_repository.dart';
import '../../../data/repositories/order_repository.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/routes/app_routes.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../order/controllers/order_controller.dart';
import '../../../data/repositories/product_repository.dart';
import '../../home/controllers/home_controller.dart';
import '../../product/controllers/product_controller.dart';

/// Checkout Controller
class CheckoutController extends GetxController {
  final AddressRepository _addressRepo = AddressRepository();
  final OrderRepository _orderRepo = OrderRepository();

  final addresses = <AddressModel>[].obs;
  final selectedAddress = Rxn<AddressModel>();
  final selectedDelivery = DeliveryMethod.standard.obs;
  final isLoading = false.obs;
  final discount = 0.0.obs;
  final createdOrder = Rxn<OrderModel>();

  @override
  void onInit() {
    super.onInit();
    loadAddresses();
  }

  void loadAddresses() {
    addresses.value = _addressRepo.loadAddresses();
    selectedAddress.value = _addressRepo.getDefaultAddress(addresses);
  }

  void selectDeliveryMethod(DeliveryMethod method) {
    selectedDelivery.value = method;
  }

  void selectAddress(AddressModel addr) {
    selectedAddress.value = addr;
    Get.back();
  }

  double get shippingFee => selectedDelivery.value.fee;

  /// Tạo đơn hàng
  Future<void> placeOrder() async {
    if (selectedAddress.value == null) {
      Get.snackbar('Lỗi', 'Vui lòng chọn địa chỉ giao hàng!',
          snackPosition: SnackPosition.TOP);
      return;
    }

    isLoading.value = true;
    try {
      final cartController = Get.find<CartController>();

      if (cartController.cartItems.isEmpty) {
        Get.snackbar('Lỗi', 'Giỏ hàng đang trống!',
            snackPosition: SnackPosition.TOP);
        isLoading.value = false;
        return;
      }

      final userId = LocalStorage.userId ?? 'guest';

      final order = await _orderRepo.createOrder(
        userId: userId,
        items: List.from(cartController.cartItems),
        address: selectedAddress.value!,
        deliveryMethod: selectedDelivery.value,
        discount: discount.value,
      );

      createdOrder.value = order;

      // Trừ số lượng tồn kho
      final productRepo = ProductRepository();
      for (final item in cartController.cartItems) {
        await productRepo.updateStock(item.productId, item.quantity);
      }

      // Xóa giỏ hàng sau khi đặt thành công
      await cartController.clearCart();

      // Reload orders
      if (Get.isRegistered<OrderController>()) {
        Get.find<OrderController>().loadOrders();
      }
      
      // Reload product/home data
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().refreshData();
      }
      if (Get.isRegistered<ProductController>()) {
        Get.find<ProductController>().refreshData();
      }

      // Chuyển sang Order Success
      Get.offAllNamed(AppRoutes.orderSuccess, arguments: order);
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể đặt hàng. Vui lòng thử lại!',
          snackPosition: SnackPosition.TOP);
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== Address Management ====================

  Future<void> addAddress(AddressModel address) async {
    addresses.value = await _addressRepo.addAddress(
      List.from(addresses),
      address,
    );
    selectedAddress.value = _addressRepo.getDefaultAddress(addresses);
    Get.back();
    Get.snackbar('Thành công', 'Đã thêm địa chỉ mới!',
        snackPosition: SnackPosition.TOP);
  }

  Future<void> updateAddress(AddressModel address) async {
    addresses.value = await _addressRepo.updateAddress(
      List.from(addresses),
      address,
    );
    selectedAddress.value = _addressRepo.getDefaultAddress(addresses);
    Get.back();
    Get.snackbar('Thành công', 'Đã cập nhật địa chỉ!',
        snackPosition: SnackPosition.TOP);
  }

  Future<void> deleteAddress(String addressId) async {
    addresses.value = await _addressRepo.deleteAddress(
      List.from(addresses),
      addressId,
    );
    selectedAddress.value = _addressRepo.getDefaultAddress(addresses);
  }

  Future<void> setDefaultAddress(String addressId) async {
    addresses.value = await _addressRepo.setDefault(
      List.from(addresses),
      addressId,
    );
    selectedAddress.value = _addressRepo.getDefaultAddress(addresses);
  }
}
