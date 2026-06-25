import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../shared/dialogs/confirm_dialog.dart';
import '../../favorite/screens/favorite_screen.dart';
import '../controllers/profile_controller.dart';

/// Profile Screen
class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.loadUser();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              _buildHeader(),
              const SizedBox(height: 16),
              // Menu sections
              _buildSection(context, 'Tài khoản', Icons.person_outline, [
                _buildMenuItem(
                  context: context,
                  icon: Icons.edit_outlined,
                  title: 'Thông tin cá nhân',
                  onTap: () => Get.toNamed(AppRoutes.editProfile),
                ),
                _buildMenuItem(
                  context: context,
                  icon: Icons.lock_outline,
                  title: 'Đổi mật khẩu',
                  onTap: () => Get.toNamed(AppRoutes.changePassword),
                ),
                _buildMenuItem(
                  context: context,
                  icon: Icons.location_on_outlined,
                  title: 'Địa chỉ của tôi',
                  onTap: () => Get.toNamed(AppRoutes.address),
                ),
              ]),
              const SizedBox(height: 12),
              _buildSection(context, 'Mua sắm', Icons.shopping_bag_outlined, [
                _buildMenuItem(
                  context: context,
                  icon: Icons.receipt_long_outlined,
                  title: 'Đơn hàng của tôi',
                  onTap: () => Get.toNamed(AppRoutes.orders),
                ),
                _buildMenuItem(
                  context: context,
                  icon: Icons.favorite_outline,
                  title: 'Sản phẩm yêu thích',
                  onTap: () => Get.toNamed(AppRoutes.favorite),
                ),
              ]),
              const SizedBox(height: 12),
              _buildSection(context, 'Cài đặt', Icons.settings_outlined, [
                _buildMenuItemSwitch(
                  context: context,
                  icon: Icons.dark_mode_outlined,
                  title: 'Chế độ tối',
                  value: controller.isDarkMode,
                  onChanged: (_) => controller.toggleTheme(),
                ),
                _buildMenuItemSwitch(
                  context: context,
                  icon: Icons.notifications_outlined,
                  title: 'Thông báo',
                  value: controller.notificationsEnabled,
                  onChanged: (_) => controller.toggleNotifications(),
                ),
              ]),
              const SizedBox(height: 12),
              _buildSection(context, 'Hệ thống', Icons.more_horiz, [
                _buildMenuItem(
                  context: context,
                  icon: Icons.logout,
                  title: 'Đăng xuất',
                  iconColor: AppColors.error,
                  textColor: AppColors.error,
                  onTap: () => ConfirmDialog.show(
                    title: 'Đăng xuất?',
                    message: 'Bạn có chắc chắn muốn đăng xuất khỏi tài khoản?',
                    confirmText: 'Đăng xuất',
                    icon: Icons.logout,
                    onConfirm: controller.logout,
                  ),
                ),
              ]),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: Obx(() {
        final user = controller.currentUser.value;
        return Column(
          children: [
            // Avatar
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: const Center(
                child: Text('👤', style: TextStyle(fontSize: 40)),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              user?.name ?? 'Người dùng',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user?.email ?? '',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.8),
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user?.phone ?? '',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.8),
                fontFamily: 'Poppins',
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSection(BuildContext context, String title, IconData icon, List<Widget> items) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textHint,
                    fontFamily: 'Poppins',
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primary).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: iconColor ?? AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  color: textColor ?? Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            trailing ??
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: AppColors.grey,
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItemSwitch({
    required BuildContext context,
    required IconData icon,
    required String title,
    required RxBool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
          Obx(() => Switch(
                value: value.value,
                onChanged: onChanged,
                activeColor: AppColors.primary,
              )),
        ],
      ),
    );
  }
}
