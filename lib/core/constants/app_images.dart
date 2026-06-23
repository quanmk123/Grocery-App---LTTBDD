/// App image paths - sử dụng network images từ Unsplash/Picsum
/// Vì không có local assets, dùng placeholder URLs
class AppImages {
  AppImages._();

  // App Logo / Brand
  static const String logo = 'assets/images/logo.png';
  static const String splashBg = 'assets/images/splash_bg.png';

  // Onboarding - sử dụng emoji icons thay cho images
  static const String onboarding1 = 'assets/images/onboarding1.png';
  static const String onboarding2 = 'assets/images/onboarding2.png';
  static const String onboarding3 = 'assets/images/onboarding3.png';

  // Empty states
  static const String emptyCart = 'assets/images/empty_cart.png';
  static const String emptyFavorite = 'assets/images/empty_favorite.png';
  static const String emptyOrder = 'assets/images/empty_order.png';
  static const String emptySearch = 'assets/images/empty_search.png';

  // Placeholder product image URL từ Picsum Photos
  static String productPlaceholder(String id) =>
      'https://picsum.photos/seed/$id/300/300';

  // Placeholder category icons - dùng network
  static const String defaultAvatar =
      'https://ui-avatars.com/api/?name=User&background=2E7D32&color=fff&size=200';

  // Network product images by category
  static const Map<String, String> categoryImages = {
    'fruits':
        'https://images.unsplash.com/photo-1619566636858-adf3ef46400b?w=200',
    'vegetables':
        'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=200',
    'meat': 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=200',
    'seafood':
        'https://images.unsplash.com/photo-1559737558-2f5a35f4523b?w=200',
    'drinks':
        'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=200',
    'snacks':
        'https://images.unsplash.com/photo-1621939514649-280e2ee25f60?w=200',
    'dairy': 'https://images.unsplash.com/photo-1628088062854-d1870b4553da?w=200',
    'bakery':
        'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=200',
  };
}
