import 'package:get/get.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/splash/splash_binding.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/onboarding/onboarding_binding.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/bindings/auth_binding.dart';
import '../../features/home/screens/main_screen.dart';
import '../../features/home/bindings/main_binding.dart';
import '../../features/product/screens/product_detail_screen.dart';
import '../../features/product/screens/product_list_screen.dart';
import '../../features/product/bindings/product_binding.dart';
import '../../features/search/screens/search_screen.dart';
import '../../features/search/bindings/search_binding.dart';
import '../../features/checkout/screens/checkout_screen.dart';
import '../../features/checkout/screens/order_success_screen.dart';
import '../../features/checkout/screens/address_screen.dart';
import '../../features/checkout/screens/add_address_screen.dart';
import '../../features/checkout/bindings/checkout_binding.dart';
import '../../features/order/screens/orders_screen.dart';
import '../../features/order/screens/order_detail_screen.dart';
import '../../features/order/bindings/order_binding.dart';
import '../../features/profile/screens/change_password_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/profile/bindings/profile_binding.dart';
import '../../features/favorite/screens/favorite_screen.dart';
import '../../features/favorite/bindings/favorite_binding.dart';
import 'app_routes.dart';

/// App pages - định nghĩa tất cả màn hình và bindings
class AppPages {
  AppPages._();

  static final List<GetPage> pages = [
    // Splash
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),

    // Onboarding
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
      binding: OnboardingBinding(),
      transition: Transition.fadeIn,
    ),

    // Auth
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),

    // Main (Bottom Nav)
    GetPage(
      name: AppRoutes.main,
      page: () => const MainScreen(),
      binding: MainBinding(),
      transition: Transition.fadeIn,
    ),

    // Product
    GetPage(
      name: AppRoutes.productDetail,
      page: () => const ProductDetailScreen(),
      binding: ProductBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.productList,
      page: () => const ProductListScreen(),
      binding: ProductBinding(),
      transition: Transition.rightToLeft,
    ),

    // Search
    GetPage(
      name: AppRoutes.search,
      page: () => const SearchScreen(),
      binding: SearchBinding(),
      transition: Transition.rightToLeft,
    ),
    // Favorite
    GetPage(
      name: AppRoutes.favorite,
      page: () => const FavoriteScreen(),
      binding: FavoriteBinding(),
      transition: Transition.rightToLeft,
    ),

    // Checkout
    GetPage(
      name: AppRoutes.checkout,
      page: () => const CheckoutScreen(),
      binding: CheckoutBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.orderSuccess,
      page: () => const OrderSuccessScreen(),
      binding: CheckoutBinding(),
      transition: Transition.zoom,
    ),
    GetPage(
      name: AppRoutes.address,
      page: () => const AddressScreen(),
      binding: CheckoutBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.addAddress,
      page: () => const AddAddressScreen(),
      binding: CheckoutBinding(),
      transition: Transition.rightToLeft,
    ),

    // Orders
    GetPage(
      name: AppRoutes.orders,
      page: () => const OrdersScreen(),
      binding: OrderBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.orderDetail,
      page: () => const OrderDetailScreen(),
      binding: OrderBinding(),
      transition: Transition.rightToLeft,
    ),

    // Profile
    GetPage(
      name: AppRoutes.changePassword,
      page: () => const ChangePasswordScreen(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfileScreen(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
