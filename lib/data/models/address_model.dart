/// Address Model
class AddressModel {
  final String id;
  final String fullName;
  final String phone;
  final String city;
  final String district;
  final String ward;
  final String detailAddress;
  bool isDefault;

  AddressModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.city,
    required this.district,
    required this.ward,
    required this.detailAddress,
    this.isDefault = false,
  });

  /// Full address string
  String get fullAddress => '$detailAddress, $ward, $district, $city';

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      phone: json['phone'] as String,
      city: json['city'] as String,
      district: json['district'] as String,
      ward: json['ward'] as String,
      detailAddress: json['detailAddress'] as String,
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'phone': phone,
      'city': city,
      'district': district,
      'ward': ward,
      'detailAddress': detailAddress,
      'isDefault': isDefault,
    };
  }

  AddressModel copyWith({
    String? id,
    String? fullName,
    String? phone,
    String? city,
    String? district,
    String? ward,
    String? detailAddress,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      district: district ?? this.district,
      ward: ward ?? this.ward,
      detailAddress: detailAddress ?? this.detailAddress,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
