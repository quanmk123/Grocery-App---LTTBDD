import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import '../../../core/constants/app_colors.dart';
import 'home_screen.dart';
import '../../category/screens/category_screen.dart';
import '../../cart/screens/cart_screen.dart';
import '../../order/screens/orders_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/storage/local_storage.dart';
import '../controllers/main_controller.dart';

/// Main Screen - Bottom Navigation Bar
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MainController _controller = Get.find<MainController>();

  late final List<Widget> _screens = [
    HomeScreen(onProfileTap: () {
      if (!LocalStorage.isLoggedIn) {
        Get.toNamed(AppRoutes.login);
        Get.snackbar('Thông báo', 'Vui lòng đăng nhập để xem thông tin này!', snackPosition: SnackPosition.TOP);
        return;
      }
      _controller.changeTab(4);
    }),
    const CategoryScreen(),
    CartScreen(onHomeTap: () {
      _controller.changeTab(0);
    }),
    const OrdersScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
        index: _controller.currentIndex.value,
        children: _screens,
      )),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor ?? Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_rounded, Icons.home_outlined, 'Trang chủ'),
              _buildNavItem(1, Icons.grid_view_rounded, Icons.grid_view_outlined, 'Danh mục'),
              _buildCartNavItem(),
              _buildNavItem(3, Icons.receipt_long_rounded, Icons.receipt_long_outlined, 'Đơn hàng'),
              _buildNavItem(4, Icons.person_rounded, Icons.person_outlined, 'Tôi'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData activeIcon, IconData inactiveIcon, String label) {
    return Obx(() {
      final isActive = _controller.currentIndex.value == index;
      return GestureDetector(
        onTap: () {
          if (!LocalStorage.isLoggedIn && (index == 2 || index == 3 || index == 4)) {
            Get.toNamed(AppRoutes.login);
            Get.snackbar('Thông báo', 'Vui lòng đăng nhập để xem thông tin này!', snackPosition: SnackPosition.TOP);
            return;
          }
          _controller.changeTab(index);
        },
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primarySurface : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive ? activeIcon : inactiveIcon,
                color: isActive ? AppColors.primary : AppColors.grey,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? AppColors.primary : AppColors.grey,
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCartNavItem() {
    final cartController = Get.find<CartController>();
    return Obx(() {
      final isActive = _controller.currentIndex.value == 2;
      final count = cartController.totalItems;
      return GestureDetector(
        onTap: () {
          if (!LocalStorage.isLoggedIn) {
            Get.toNamed(AppRoutes.login);
            Get.snackbar('Thông báo', 'Vui lòng đăng nhập để xem thông tin này!', snackPosition: SnackPosition.TOP);
            return;
          }
          _controller.changeTab(2);
        },
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primarySurface : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              badges.Badge(
                showBadge: count > 0,
                badgeContent: Text(
                  count > 99 ? '99+' : '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontFamily: 'Poppins',
                  ),
                ),
                badgeStyle: const badges.BadgeStyle(
                  badgeColor: AppColors.error,
                  padding: EdgeInsets.all(4),
                ),
                child: Icon(
                  isActive ? Icons.shopping_cart_rounded : Icons.shopping_cart_outlined,
                  color: isActive ? AppColors.primary : AppColors.grey,
                  size: 24,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Giỏ hàng',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive ? AppColors.primary : AppColors.grey,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
