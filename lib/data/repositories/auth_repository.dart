import 'dart:convert';
import '../models/user_model.dart';
import '../datasource/mock/mock_data.dart';
import '../../core/storage/local_storage.dart';

/// Auth Repository - xử lý login, register, logout
class AuthRepository {
  AuthRepository() {
    _loadPersistedUsers();
  }

  void _loadPersistedUsers() {
    try {
      final persisted = LocalStorage.registeredUsers;
      for (final userJson in persisted) {
        final Map<String, dynamic> userMap = Map<String, dynamic>.from(
          jsonDecode(userJson)
        );
        final Map<String, String> userStrMap = userMap.map(
          (key, value) => MapEntry(key, value.toString())
        );
        final exists = MockData.mockUsers.any((u) => u['email'] == userStrMap['email']);
        if (!exists) {
          MockData.mockUsers.add(userStrMap);
        }
      }
    } catch (e) {
      // Ignore
    }
  }

  /// Mock login - kiểm tra email + password với mock users
  Future<UserModel?> login(String email, String password) async {
    _loadPersistedUsers();
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network

    final user = MockData.mockUsers.firstWhere(
      (u) => u['email'] == email.trim() && u['password'] == password,
      orElse: () => {},
    );

    if (user.isEmpty) return null;

    final userModel = MockData.getUserModel(user);

    // Lưu token và user info vào local storage
    await LocalStorage.saveToken(userModel.token);
    await LocalStorage.saveUserInfo(
      userId: userModel.id,
      name: userModel.name,
      email: userModel.email,
      phone: userModel.phone,
      avatar: userModel.avatar,
    );

    return userModel;
  }

  /// Mock register - luôn thành công nếu pass validate
  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _loadPersistedUsers();
    await Future.delayed(const Duration(milliseconds: 1000));

    // Kiểm tra email đã tồn tại chưa
    final existing = MockData.mockUsers.any(
      (u) => u['email'] == email.trim(),
    );
    if (existing) return false;

    final newUser = {
      'id': 'user_${DateTime.now().millisecondsSinceEpoch}',
      'name': name,
      'email': email.trim(),
      'phone': phone,
      'password': password,
      'token': 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
    };

    MockData.mockUsers.add(newUser);
    await LocalStorage.addRegisteredUser(jsonEncode(newUser));

    return true;
  }

  /// Lấy current user từ local storage
  UserModel? getCurrentUser() {
    if (!LocalStorage.isLoggedIn) return null;

    final userId = LocalStorage.userId;
    final name = LocalStorage.userName;
    final email = LocalStorage.userEmail;
    final phone = LocalStorage.userPhone;
    final avatar = LocalStorage.userAvatar;
    final token = LocalStorage.authToken;

    if (userId == null || name == null || email == null) return null;

    return UserModel(
      id: userId,
      name: name,
      email: email,
      phone: phone ?? '',
      avatar: avatar,
      token: token ?? '',
    );
  }

  /// Logout
  Future<void> logout() async {
    await LocalStorage.clearOnLogout();
  }

  /// Mock forgot password - luôn trả về true
  Future<bool> forgotPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return true;
  }

  /// Mock change password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _loadPersistedUsers();
    await Future.delayed(const Duration(milliseconds: 600));
    // Kiểm tra với mock users
    final token = LocalStorage.authToken;
    final index = MockData.mockUsers.indexWhere((u) => u['token'] == token);
    if (index == -1) return false;

    final user = MockData.mockUsers[index];
    if (user['password'] != currentPassword) return false;

    // Cập nhật mật khẩu mới trong bộ nhớ
    user['password'] = newPassword;
    MockData.mockUsers[index] = user;

    // Cập nhật lưu trữ bền vững nếu là tài khoản đã đăng ký qua LocalStorage
    final email = user['email'] ?? '';
    if (email.isNotEmpty) {
      await LocalStorage.updateRegisteredUser(email, jsonEncode(user));
    }

    return true;
  }

  /// Update profile
  Future<bool> updateProfile({
    required String name,
    required String phone,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    await LocalStorage.saveUserInfo(
      userId: LocalStorage.userId ?? '',
      name: name,
      email: LocalStorage.userEmail ?? '',
      phone: phone,
      avatar: LocalStorage.userAvatar,
    );
    return true;
  }
}
