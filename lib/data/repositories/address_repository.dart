import 'dart:convert';
import '../models/address_model.dart';
import '../../core/storage/local_storage.dart';
import '../datasource/mock/mock_data.dart';
import 'package:uuid/uuid.dart';

/// Address Repository
class AddressRepository {
  static const _uuid = Uuid();

  /// Load addresses từ local storage
  List<AddressModel> loadAddresses() {
    final json = LocalStorage.addressesJson;
    if (json == null || json.isEmpty) {
      // Trả về địa chỉ mặc định lần đầu
      return [MockData.defaultAddress];
    }
    try {
      final list = jsonDecode(json) as List;
      return list.map((e) => AddressModel.fromJson(e)).toList();
    } catch (_) {
      return [MockData.defaultAddress];
    }
  }

  /// Lưu addresses
  Future<void> _saveAddresses(List<AddressModel> addresses) async {
    final json = jsonEncode(addresses.map((e) => e.toJson()).toList());
    await LocalStorage.saveAddresses(json);
  }

  /// Thêm địa chỉ mới
  Future<List<AddressModel>> addAddress(
    List<AddressModel> current,
    AddressModel address,
  ) async {
    var addresses = List<AddressModel>.from(current);
    final newAddr = address.copyWith(id: _uuid.v4());

    if (newAddr.isDefault) {
      // Bỏ default cũ
      addresses = addresses.map((a) => a.copyWith(isDefault: false)).toList();
    }

    addresses.add(newAddr);
    await _saveAddresses(addresses);
    return addresses;
  }

  /// Cập nhật địa chỉ
  Future<List<AddressModel>> updateAddress(
    List<AddressModel> current,
    AddressModel address,
  ) async {
    var addresses = List<AddressModel>.from(current);
    
    if (address.isDefault) {
      // Bỏ default cũ
      addresses = addresses.map((a) => a.copyWith(isDefault: false)).toList();
    }

    final index = addresses.indexWhere((a) => a.id == address.id);
    if (index != -1) {
      addresses[index] = address;
    }
    
    await _saveAddresses(addresses);
    return addresses;
  }

  /// Xóa địa chỉ
  Future<List<AddressModel>> deleteAddress(
    List<AddressModel> current,
    String addressId,
  ) async {
    final addresses = current.where((a) => a.id != addressId).toList();
    await _saveAddresses(addresses);
    return addresses;
  }

  /// Set địa chỉ mặc định
  Future<List<AddressModel>> setDefault(
    List<AddressModel> current,
    String addressId,
  ) async {
    final addresses = current
        .map((a) => a.copyWith(isDefault: a.id == addressId))
        .toList();
    await _saveAddresses(addresses);
    return addresses;
  }

  /// Lấy địa chỉ mặc định
  AddressModel? getDefaultAddress(List<AddressModel> addresses) {
    try {
      return addresses.firstWhere((a) => a.isDefault);
    } catch (_) {
      return addresses.isNotEmpty ? addresses.first : null;
    }
  }
}
