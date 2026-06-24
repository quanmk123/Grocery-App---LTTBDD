import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grocery_app/core/utils/validators.dart';
import 'package:grocery_app/core/storage/local_storage.dart';
import 'package:grocery_app/data/models/product_model.dart';
import 'package:grocery_app/data/models/cart_item_model.dart';
import 'package:grocery_app/data/models/address_model.dart';
import 'package:grocery_app/data/models/order_model.dart';
import 'package:grocery_app/data/repositories/cart_repository.dart';
import 'package:grocery_app/data/repositories/order_repository.dart';
import 'package:grocery_app/data/repositories/auth_repository.dart';

/// Helper: tạo ProductModel giả cho test
ProductModel _makeProduct({
  String id = 'test_001',
  String name = 'Sản phẩm test',
  double price = 50000,
  int stock = 10,
}) {
  return ProductModel(
    id: id,
    name: name,
    image: 'https://example.com/img.png',
    price: price,
    description: 'Mô tả test',
    categoryId: 'cat_test',
    categoryName: 'Test',
    rating: 4.5,
    reviewCount: 100,
    stock: stock,
  );
}

/// Helper: tạo AddressModel giả cho test
AddressModel _makeAddress() {
  return AddressModel(
    id: 'addr_test',
    fullName: 'Nguyễn Test',
    phone: '0912345678',
    city: 'TP. HCM',
    district: 'Quận 1',
    ward: 'Phường Bến Nghé',
    detailAddress: '123 Đường Test',
    isDefault: true,
  );
}

void main() {
  // ==================== 1. Validators.validateEmail ====================
  group('Validators.validateEmail', () {
    test('trả về null khi email hợp lệ', () {
      expect(Validators.validateEmail('user@gmail.com'), isNull);
      expect(Validators.validateEmail('test.name@domain.co'), isNull);
    });

    test('trả về lỗi khi email rỗng', () {
      expect(Validators.validateEmail(null), isNotNull);
      expect(Validators.validateEmail(''), isNotNull);
      expect(Validators.validateEmail('   '), isNotNull);
    });

    test('trả về lỗi khi email không hợp lệ', () {
      expect(Validators.validateEmail('abc'), isNotNull);
      expect(Validators.validateEmail('abc@'), isNotNull);
      expect(Validators.validateEmail('@gmail.com'), isNotNull);
      expect(Validators.validateEmail('user@.com'), isNotNull);
    });
  });

  // ==================== 2. CartRepository.addToCart ====================
  group('CartRepository.addToCart', () {
    late CartRepository cartRepo;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await LocalStorage.init();
      cartRepo = CartRepository();
    });

    test('thêm sản phẩm mới vào giỏ hàng rỗng', () async {
      final product = _makeProduct();
      final result = await cartRepo.addToCart([], product, 2);

      expect(result.length, 1);
      expect(result.first.productId, 'test_001');
      expect(result.first.quantity, 2);
      expect(result.first.price, 50000);
    });

    test('tăng số lượng khi sản phẩm đã có trong giỏ', () async {
      final product = _makeProduct(stock: 10);
      final existingCart = [
        CartItemModel(
          productId: 'test_001',
          productName: 'Sản phẩm test',
          image: 'https://example.com/img.png',
          price: 50000,
          quantity: 3,
          stock: 10,
        ),
      ];

      final result = await cartRepo.addToCart(existingCart, product, 2);

      expect(result.length, 1);
      expect(result.first.quantity, 5); // 3 + 2
    });

    test('thêm sản phẩm khác không ảnh hưởng item cũ', () async {
      final product2 = _makeProduct(id: 'test_002', name: 'SP khác');
      final existingCart = [
        CartItemModel(
          productId: 'test_001',
          productName: 'Sản phẩm test',
          image: 'https://example.com/img.png',
          price: 50000,
          quantity: 1,
          stock: 10,
        ),
      ];

      final result = await cartRepo.addToCart(existingCart, product2, 1);

      expect(result.length, 2);
    });
  });

  // ==================== 3. Không cho số lượng vượt tồn kho ====================
  group('CartRepository - kiểm tra tồn kho', () {
    late CartRepository cartRepo;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await LocalStorage.init();
      cartRepo = CartRepository();
    });

    test('throw Exception khi thêm vượt tồn kho (sản phẩm đã có)', () async {
      final product = _makeProduct(stock: 5);
      final existingCart = [
        CartItemModel(
          productId: 'test_001',
          productName: 'Sản phẩm test',
          image: 'https://example.com/img.png',
          price: 50000,
          quantity: 4,
          stock: 5,
        ),
      ];

      // 4 + 3 = 7 > stock 5 → phải throw
      expect(
        () => cartRepo.addToCart(existingCart, product, 3),
        throwsA(isA<Exception>()),
      );
    });

    test('throw Exception khi updateQuantity vượt tồn kho', () async {
      final existingCart = [
        CartItemModel(
          productId: 'test_001',
          productName: 'Sản phẩm test',
          image: 'https://example.com/img.png',
          price: 50000,
          quantity: 3,
          stock: 5,
        ),
      ];

      // Cập nhật lên 10 > stock 5 → phải throw
      expect(
        () => cartRepo.updateQuantity(existingCart, 'test_001', 10),
        throwsA(isA<Exception>()),
      );
    });

    test('cho phép thêm khi không vượt tồn kho', () async {
      final product = _makeProduct(stock: 5);
      final existingCart = [
        CartItemModel(
          productId: 'test_001',
          productName: 'Sản phẩm test',
          image: 'https://example.com/img.png',
          price: 50000,
          quantity: 3,
          stock: 5,
        ),
      ];

      // 3 + 2 = 5 == stock → cho phép
      final result = await cartRepo.addToCart(existingCart, product, 2);
      expect(result.first.quantity, 5);
    });
  });

  // ==================== 4. Tạo đơn hàng COD ====================
  group('OrderRepository.createOrder', () {
    late OrderRepository orderRepo;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await LocalStorage.init();
      orderRepo = OrderRepository();
    });

    test('tạo đơn hàng COD thành công', () async {
      final items = [
        CartItemModel(
          productId: 'p001',
          productName: 'Táo Fuji',
          image: 'https://example.com/img.png',
          price: 45000,
          quantity: 2,
          stock: 50,
        ),
        CartItemModel(
          productId: 'p002',
          productName: 'Chuối',
          image: 'https://example.com/img2.png',
          price: 25000,
          quantity: 1,
          stock: 80,
        ),
      ];

      final order = await orderRepo.createOrder(
        userId: 'user_001',
        items: items,
        address: _makeAddress(),
        deliveryMethod: DeliveryMethod.standard,
        discount: 0,
      );

      // Kiểm tra thông tin đơn hàng
      expect(order.id, startsWith('ORD'));
      expect(order.userId, 'user_001');
      expect(order.paymentMethod, 'COD');
      expect(order.status, OrderStatus.pending);
      expect(order.items.length, 2);

      // Kiểm tra tính toán giá
      final expectedSubtotal = 45000.0 * 2 + 25000.0 * 1; // 115000
      expect(order.subtotal, expectedSubtotal);
      expect(order.shippingFee, DeliveryMethod.standard.fee);
      expect(order.total, expectedSubtotal + DeliveryMethod.standard.fee);
    });

    test('đơn hàng có discount được tính đúng', () async {
      final items = [
        CartItemModel(
          productId: 'p001',
          productName: 'Táo Fuji',
          image: 'https://example.com/img.png',
          price: 100000,
          quantity: 1,
          stock: 50,
        ),
      ];

      final order = await orderRepo.createOrder(
        userId: 'user_001',
        items: items,
        address: _makeAddress(),
        deliveryMethod: DeliveryMethod.fast,
        discount: 10000,
      );

      expect(order.subtotal, 100000);
      expect(order.shippingFee, DeliveryMethod.fast.fee);
      expect(order.discount, 10000);
      expect(order.total, 100000 + DeliveryMethod.fast.fee - 10000);
    });
  });

  // ==================== 5. Đăng nhập sai mật khẩu trả về null ====================
  group('AuthRepository.login', () {
    late AuthRepository authRepo;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await LocalStorage.init();
      authRepo = AuthRepository();
    });

    test('đăng nhập sai mật khẩu trả về null', () async {
      final user = await authRepo.login('user@gmail.com', 'wrong_password');
      expect(user, isNull);
    });

    test('đăng nhập sai email trả về null', () async {
      final user = await authRepo.login('nonexistent@gmail.com', '123456');
      expect(user, isNull);
    });

    test('đăng nhập đúng trả về UserModel', () async {
      final user = await authRepo.login('user@gmail.com', '123456');
      expect(user, isNotNull);
      expect(user!.email, 'user@gmail.com');
      expect(user.name, 'Nguyễn Văn An');
    });
  });
}
