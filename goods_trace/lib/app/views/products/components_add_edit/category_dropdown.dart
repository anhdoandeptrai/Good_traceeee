import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goods_trace/app/core/theme/theme.dart';
import 'package:goods_trace/app/viewmodels/products_viewmodel.dart';

class CategoryDropdown extends StatelessWidget {
  final String? selectedCategory;
  final Function(String?) onCategoryChanged;
  final bool isDarkMode;

  const CategoryDropdown({
    Key? key,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _viewModel = Get.find<ProductsViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Category',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? AppColors.darkTextPrimary : Colors.black87,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '*',
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[800] : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
              width: 1.5,
            ),
          ),
          child: DropdownButtonFormField<String?>(
            value: selectedCategory,
            items: _viewModel.categories
                .map(
                  (category) => DropdownMenuItem<String?>(
                    value: category.name,
                    child: Text(
                      category.name,
                      style: TextStyle(
                        color: isDarkMode
                            ? AppColors.darkTextPrimary
                            : Colors.black87,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: onCategoryChanged,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.category_outlined,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: InputBorder.none,
            ),
            hint: Text(
              'Choose product category',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[400],
                fontSize: 14,
              ),
            ),
            style: TextStyle(
              color: isDarkMode ? AppColors.darkTextPrimary : Colors.black87,
              fontSize: 16,
            ),
            icon: Icon(
              Icons.arrow_drop_down,
              color: isDarkMode ? Colors.grey[400] : Colors.grey,
            ),
            isExpanded: true,
            dropdownColor: isDarkMode ? AppColors.darkBackground : Colors.white,
          ),
        ),
      ],
    );
  }
}
