import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';
import '../../core/storage/local_storage.dart';

/// Splash Controller - kiểm tra trạng thái app và điều hướng
class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    // Delay 2 giây cho splash screen
    await Future.delayed(const Duration(seconds: 2));

    if (!LocalStorage.isOnboardingSeen) {
      // Chưa xem onboarding
      Get.offAllNamed(AppRoutes.onboarding);
    } else if (!LocalStorage.isLoggedIn) {
      // Đã xem onboarding nhưng chưa login
      Get.offAllNamed(AppRoutes.login);
    } else {
      // Đã login, vào Home
      Get.offAllNamed(AppRoutes.main);
    }
  }
}
