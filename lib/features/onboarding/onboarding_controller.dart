import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';
import '../../core/storage/local_storage.dart';

/// Onboarding Data
class OnboardingPage {
  final String emoji;
  final String title;
  final String description;
  final Color bgColor;

  const OnboardingPage({
    required this.emoji,
    required this.title,
    required this.description,
    required this.bgColor,
  });
}

/// Onboarding Controller
class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;

  final pages = [
    const OnboardingPage(
      emoji: '🍎',
      title: 'Thực phẩm tươi sạch',
      description:
          'Lựa chọn từ hàng ngàn sản phẩm tươi sạch, đảm bảo chất lượng mỗi ngày cho gia đình bạn.',
      bgColor: Color(0xFFE8F5E9),
    ),
    const OnboardingPage(
      emoji: '🚀',
      title: 'Giao hàng nhanh chóng',
      description:
          'Đặt hàng ngay hôm nay, giao hàng tận nhà trong vòng 2 tiếng. Tiết kiệm thời gian mua sắm.',
      bgColor: Color(0xFFE3F2FD),
    ),
    const OnboardingPage(
      emoji: '💸',
      title: 'Thanh toán khi nhận hàng',
      description:
          'Hoàn toàn an tâm với phương thức thanh toán COD. Nhận hàng rồi mới trả tiền, không lo rủi ro.',
      bgColor: Color(0xFFFFF3E0),
    ),
  ];

  void nextPage() {
    if (currentPage.value < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void skipOnboarding() => _finishOnboarding();

  Future<void> _finishOnboarding() async {
    await LocalStorage.setOnboardingSeen(true);
    Get.offAllNamed(AppRoutes.main);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
