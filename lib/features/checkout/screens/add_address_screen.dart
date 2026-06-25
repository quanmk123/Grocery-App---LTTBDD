import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/address_model.dart';
import '../../../shared/widgets/app_button.dart';
import '../controllers/checkout_controller.dart';
import 'package:uuid/uuid.dart';

/// Add Address Screen
class AddAddressScreen extends GetView<CheckoutController> {
  const AddAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final AddressModel? existingAddress = Get.arguments as AddressModel?;
    final isEditing = existingAddress != null;

    final nameCtrl = TextEditingController(text: existingAddress?.fullName ?? '');
    final phoneCtrl = TextEditingController(text: existingAddress?.phone ?? '');
    final cityCtrl = TextEditingController(text: existingAddress?.city ?? '');
    final districtCtrl = TextEditingController(text: existingAddress?.district ?? '');
    final wardCtrl = TextEditingController(text: existingAddress?.ward ?? '');
    final detailCtrl = TextEditingController(text: existingAddress?.detailAddress ?? '');
    final isDefault = (existingAddress?.isDefault ?? false).obs;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Sửa địa chỉ' : 'Thêm địa chỉ mới'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Họ và tên *',
                  prefixIcon: Icon(Icons.person_outline, color: AppColors.grey),
                ),
                validator: Validators.validateName,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Số điện thoại *',
                  prefixIcon: Icon(Icons.phone_outlined, color: AppColors.grey),
                ),
                validator: Validators.validatePhone,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: cityCtrl,
                decoration: const InputDecoration(
                  labelText: 'Tỉnh/Thành phố *',
                  prefixIcon: Icon(Icons.location_city_outlined, color: AppColors.grey),
                ),
                validator: (v) => Validators.validateRequired(v, fieldName: 'Tỉnh/Thành phố'),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: districtCtrl,
                decoration: const InputDecoration(
                  labelText: 'Quận/Huyện *',
                  prefixIcon: Icon(Icons.map_outlined, color: AppColors.grey),
                ),
                validator: (v) => Validators.validateRequired(v, fieldName: 'Quận/Huyện'),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: wardCtrl,
                decoration: const InputDecoration(
                  labelText: 'Phường/Xã *',
                  prefixIcon: Icon(Icons.place_outlined, color: AppColors.grey),
                ),
                validator: (v) => Validators.validateRequired(v, fieldName: 'Phường/Xã'),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: detailCtrl,
                decoration: const InputDecoration(
                  labelText: 'Địa chỉ chi tiết *',
                  hintText: 'Số nhà, tên đường...',
                  prefixIcon: Icon(Icons.home_outlined, color: AppColors.grey),
                ),
                validator: Validators.validateAddress,
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              Obx(() => CheckboxListTile(
                    value: isDefault.value,
                    onChanged: (val) => isDefault.value = val ?? false,
                    title: const Text(
                      'Đặt làm địa chỉ mặc định',
                      style: TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                    ),
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                  )),
              const SizedBox(height: 24),
              AppButton(
                text: 'Lưu địa chỉ',
                icon: Icons.save_outlined,
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final addr = AddressModel(
                      id: isEditing ? existingAddress.id : const Uuid().v4(),
                      fullName: nameCtrl.text.trim(),
                      phone: phoneCtrl.text.trim(),
                      city: cityCtrl.text.trim(),
                      district: districtCtrl.text.trim(),
                      ward: wardCtrl.text.trim(),
                      detailAddress: detailCtrl.text.trim(),
                      isDefault: isDefault.value,
                    );
                    if (isEditing) {
                      controller.updateAddress(addr);
                    } else {
                      controller.addAddress(addr);
                    }
                  }
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
