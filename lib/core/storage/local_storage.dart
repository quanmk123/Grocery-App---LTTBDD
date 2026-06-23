import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Local storage wrapper dùng SharedPreferences
class LocalStorage {
  static SharedPreferences? _prefs;

  // Keys
  static const String _keyOnboardingSeen = 'onboarding_seen';
  static const String _keyAuthToken = 'auth_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserPhone = 'user_phone';
  static const String _keyUserAvatar = 'user_avatar';
  static const String _keyCartItems = 'cart_items';
  static const String _keyFavoriteIds = 'favorite_ids';
  static const String _keyOrders = 'orders';
  static const String _keyAddresses = 'addresses';
  static const String _keyRecentSearches = 'recent_searches';
  static const String _keyThemeMode = 'theme_mode';

  /// Khởi tạo SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get _instance {
    if (_prefs == null) throw Exception('LocalStorage chưa được khởi tạo!');
    return _prefs!;
  }

  // ==================== Onboarding ====================

  static bool get isOnboardingSeen =>
      _instance.getBool(_keyOnboardingSeen) ?? false;

  static Future<void> setOnboardingSeen(bool value) async {
    await _instance.setBool(_keyOnboardingSeen, value);
  }

  // ==================== Auth Token ====================

  static String? get authToken => _instance.getString(_keyAuthToken);

  static bool get isLoggedIn =>
      authToken != null && authToken!.isNotEmpty;

  static Future<void> saveToken(String token) async {
    await _instance.setString(_keyAuthToken, token);
  }

  static Future<void> clearToken() async {
    await _instance.remove(_keyAuthToken);
  }

  // ==================== User Info ====================

  static Future<void> saveUserInfo({
    required String userId,
    required String name,
    required String email,
    required String phone,
    String? avatar,
  }) async {
    await _instance.setString(_keyUserId, userId);
    await _instance.setString(_keyUserName, name);
    await _instance.setString(_keyUserEmail, email);
    await _instance.setString(_keyUserPhone, phone);
    if (avatar != null) await _instance.setString(_keyUserAvatar, avatar);
  }

  static String? get userId => _instance.getString(_keyUserId);
  static String? get userName => _instance.getString(_keyUserName);
  static String? get userEmail => _instance.getString(_keyUserEmail);
  static String? get userPhone => _instance.getString(_keyUserPhone);
  static String? get userAvatar => _instance.getString(_keyUserAvatar);

  static Future<void> clearUserInfo() async {
    await _instance.remove(_keyUserId);
    await _instance.remove(_keyUserName);
    await _instance.remove(_keyUserEmail);
    await _instance.remove(_keyUserPhone);
    await _instance.remove(_keyUserAvatar);
  }

  // ==================== User Specific Keys Helpers ====================
  static String get _userCartKey => userId != null ? '${_keyCartItems}_$userId' : _keyCartItems;
  static String get _userFavoriteKey => userId != null ? '${_keyFavoriteIds}_$userId' : _keyFavoriteIds;
  static String get _userOrdersKey => userId != null ? '${_keyOrders}_$userId' : _keyOrders;
  static String get _userAddressesKey => userId != null ? '${_keyAddresses}_$userId' : _keyAddresses;

  // ==================== Cart ====================

  static String? get cartItemsJson => _instance.getString(_userCartKey);

  static Future<void> saveCartItems(String jsonStr) async {
    await _instance.setString(_userCartKey, jsonStr);
  }

  static Future<void> clearCartItems() async {
    await _instance.remove(_userCartKey);
  }

  // ==================== Favorites ====================

  static List<String> get favoriteIds =>
      _instance.getStringList(_userFavoriteKey) ?? [];

  static Future<void> saveFavoriteIds(List<String> ids) async {
    await _instance.setStringList(_userFavoriteKey, ids);
  }

  // ==================== Orders ====================

  static String? get ordersJson => _instance.getString(_userOrdersKey);

  static Future<void> saveOrders(String jsonStr) async {
    await _instance.setString(_userOrdersKey, jsonStr);
  }

  // ==================== Addresses ====================

  static String? get addressesJson => _instance.getString(_userAddressesKey);

  static Future<void> saveAddresses(String jsonStr) async {
    await _instance.setString(_userAddressesKey, jsonStr);
  }

  // ==================== Recent Searches ====================

  static List<String> get recentSearches =>
      _instance.getStringList(_keyRecentSearches) ?? [];

  static Future<void> saveRecentSearches(List<String> searches) async {
    await _instance.setStringList(_keyRecentSearches, searches);
  }

  // ==================== Theme ====================

  static int get themeMode => _instance.getInt(_keyThemeMode) ?? 0; // 0=system, 1=light, 2=dark

  static Future<void> saveThemeMode(int mode) async {
    await _instance.setInt(_keyThemeMode, mode);
  }

  // ==================== Registered Users ====================
  static const String _keyRegisteredUsers = 'registered_users';

  static List<String> get registeredUsers =>
      _instance.getStringList(_keyRegisteredUsers) ?? [];

  static Future<void> addRegisteredUser(String userJson) async {
    final list = List<String>.from(registeredUsers);
    list.add(userJson);
    await _instance.setStringList(_keyRegisteredUsers, list);
  }

  static Future<void> updateRegisteredUser(String email, String updatedUserJson) async {
    final list = List<String>.from(registeredUsers);
    for (int i = 0; i < list.length; i++) {
      try {
        final Map<String, dynamic> userMap = jsonDecode(list[i]);
        if (userMap['email'] == email.trim()) {
          list[i] = updatedUserJson;
          break;
        }
      } catch (_) {}
    }
    await _instance.setStringList(_keyRegisteredUsers, list);
  }

  // ==================== Clear All ====================

  /// Xóa toàn bộ dữ liệu khi logout (giữ lại dữ liệu cá nhân của từng user để đăng nhập lại vẫn thấy)
  static Future<void> clearOnLogout() async {
    await clearToken();
    await clearUserInfo();
    await _instance.remove(_keyCartItems); // Xóa giỏ hàng khách
    await _instance.remove(_keyFavoriteIds); // Xóa danh mục yêu thích khách
  }
}
