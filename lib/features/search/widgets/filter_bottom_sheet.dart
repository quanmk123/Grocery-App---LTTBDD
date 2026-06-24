import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/search_controller.dart' as sc;

class FilterBottomSheet extends StatefulWidget {
  final sc.SearchController controller;

  const FilterBottomSheet({super.key, required this.controller});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late double minPrice;
  late double maxPrice;
  String? selectedCategoryId;
  String? sortBy;

  @override
  void initState() {
    super.initState();
    minPrice = widget.controller.minPrice.value ?? 0;
    maxPrice = widget.controller.maxPrice.value ?? 500000;
    selectedCategoryId = widget.controller.selectedCategoryId.value;
    sortBy = widget.controller.sortBy.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bộ lọc',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Get.back(),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 10),

          // Content
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Khoảng giá'),
                  RangeSlider(
                    values: RangeValues(minPrice, maxPrice),
                    min: 0,
                    max: 1000000,
                    divisions: 100,
                    activeColor: AppColors.primary,
                    inactiveColor: AppColors.greyLight,
                    labels: RangeLabels(
                      '${minPrice.toInt()}đ',
                      '${maxPrice.toInt()}đ',
                    ),
                    onChanged: (values) {
                      setState(() {
                        minPrice = values.start;
                        maxPrice = values.end;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${minPrice.toInt()}đ', style: const TextStyle(color: AppColors.grey)),
                      Text('${maxPrice.toInt()}đ', style: const TextStyle(color: AppColors.grey)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _buildSectionTitle('Danh mục'),
                  const SizedBox(height: 10),
                  Obx(() {
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.controller.categories.map((cat) {
                        final isSelected = selectedCategoryId == cat.id;
                        return ChoiceChip(
                          label: Text(cat.name),
                          selected: isSelected,
                          selectedColor: AppColors.primarySurface,
                          labelStyle: TextStyle(
                            color: isSelected ? AppColors.primary : AppColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontFamily: 'Poppins',
                          ),
                          onSelected: (selected) {
                            setState(() {
                              selectedCategoryId = selected ? cat.id : null;
                            });
                          },
                        );
                      }).toList(),
                    );
                  }),
                  const SizedBox(height: 20),

                  _buildSectionTitle('Sắp xếp theo'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildSortChip('Mặc định', null),
                      _buildSortChip('Giá: Thấp đến Cao', 'price_asc'),
                      _buildSortChip('Giá: Cao đến Thấp', 'price_desc'),
                      _buildSortChip('Đánh giá cao', 'rating_desc'),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Bottom Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    widget.controller.resetFilter();
                    Get.back();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Thiết lập lại', style: TextStyle(color: AppColors.primary, fontFamily: 'Poppins')),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.controller.applyFilter(
                      min: minPrice,
                      max: maxPrice,
                      category: selectedCategoryId,
                      sort: sortBy,
                    );
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Áp dụng', style: TextStyle(fontFamily: 'Poppins')),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
      ),
    );
  }

  Widget _buildSortChip(String label, String? value) {
    final isSelected = sortBy == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.primarySurface,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontFamily: 'Poppins',
      ),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            sortBy = value;
          });
        }
      },
    );
  }
}
