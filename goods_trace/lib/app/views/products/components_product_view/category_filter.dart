import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goods_trace/app/core/theme/theme.dart';
import 'package:goods_trace/app/viewmodels/products_viewmodel.dart';

class CategoryFilterButton extends StatelessWidget {
  final bool isDarkMode;

  const CategoryFilterButton({
    Key? key,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _viewModel = Get.find<ProductsViewModel>();

    return PopupMenuButton<String>(
      icon: Icon(Icons.menu,
          color: isDarkMode ? AppColors.darkPrimary : AppColors.primary),
      tooltip: 'Filter by category',
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: isDarkMode ? AppColors.darkBackground : Colors.white,
      elevation: 8,
      offset: const Offset(0, 40),
      onSelected: (value) {
        if (value == 'all') {
          _viewModel.filterByCategory('');
        } else {
          _viewModel.filterByCategory(value);
        }

        Get.snackbar(
          'Filter Applied',
          'Showing products in category: ${value == 'all' ? 'All' : value}',
          backgroundColor: isDarkMode
              ? AppColors.darkPrimary.withOpacity(0.9)
              : AppColors.primary.withOpacity(0.9),
          colorText: Colors.white,
          duration: const Duration(seconds: 1),
          snackPosition: SnackPosition.TOP,
        );
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Categories',
                style: AppTextStyles.h2.copyWith(
                    color:
                        isDarkMode ? AppColors.darkPrimary : AppColors.primary),
              ),
              Divider(
                  color: isDarkMode ? AppColors.darkPrimary : AppColors.primary,
                  thickness: 1),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'all',
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: _viewModel.selectedCategory.value.isEmpty
                      ? (isDarkMode ? AppColors.darkPrimary : AppColors.primary)
                          .withOpacity(0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(Icons.dashboard,
                    color:
                        isDarkMode ? AppColors.darkPrimary : AppColors.primary),
              ),
              const SizedBox(width: 12),
              Text(
                'All Products',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                  fontWeight: _viewModel.selectedCategory.value.isEmpty
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              if (_viewModel.selectedCategory.value.isEmpty)
                const Spacer(flex: 1),
              if (_viewModel.selectedCategory.value.isEmpty)
                Icon(Icons.check_circle,
                    color:
                        isDarkMode ? AppColors.darkPrimary : AppColors.primary,
                    size: 16),
            ],
          ),
        ),
        ..._viewModel.categories.map(
          (category) => PopupMenuItem<String>(
            value: category.name,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: _viewModel.selectedCategory.value == category.name
                        ? (isDarkMode
                                ? AppColors.darkPrimary
                                : AppColors.primary)
                            .withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Icon(Icons.category,
                      color: isDarkMode
                          ? AppColors.darkPrimary
                          : AppColors.primary),
                ),
                const SizedBox(width: 12),
                Text(
                  category.name,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                    fontWeight:
                        _viewModel.selectedCategory.value == category.name
                            ? FontWeight.bold
                            : FontWeight.normal,
                  ),
                ),
                if (_viewModel.selectedCategory.value == category.name)
                  const Spacer(flex: 1),
                if (_viewModel.selectedCategory.value == category.name)
                  Icon(Icons.check_circle,
                      color: isDarkMode
                          ? AppColors.darkPrimary
                          : AppColors.primary,
                      size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
