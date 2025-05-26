import 'package:flutter/material.dart';
import 'package:goods_trace/app/core/theme/theme.dart';
import 'package:goods_trace/app/views/products/components_product_view/category_filter.dart';

class ProductSearchBar extends StatelessWidget {
  final bool isDarkMode;
  final Function(String) onSearchChanged;
  final String searchQuery;

  const ProductSearchBar({
    Key? key,
    required this.isDarkMode,
    required this.onSearchChanged,
    required this.searchQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.darkBackground.withOpacity(0.7)
            : Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        style: AppTextStyles.bodyLarge.copyWith(
            color:
                isDarkMode ? AppColors.darkTextPrimary : AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: 'Search products',
          hintStyle: AppTextStyles.bodyLarge.copyWith(
              color: isDarkMode
                  ? AppColors.darkTextPrimary.withOpacity(0.5)
                  : AppColors.textPrimary.withOpacity(0.5)),
          suffixIcon: Icon(Icons.search,
              color: isDarkMode ? AppColors.darkPrimary : AppColors.primary),
          prefixIcon: CategoryFilterButton(isDarkMode: isDarkMode),
          filled: true,
          fillColor: isDarkMode
              ? AppColors.darkBackground.withOpacity(0.7)
              : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: onSearchChanged,
      ),
    );
  }
}
