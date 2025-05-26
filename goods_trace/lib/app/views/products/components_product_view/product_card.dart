import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goods_trace/app/core/theme/theme.dart';
import 'package:goods_trace/app/models/product_model.dart';
import 'package:goods_trace/app/viewmodels/user_viewmodel.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final bool isDarkMode;
  final Function(ProductModel) onTap;
  final Function(ProductModel) onEdit;
  final Function(ProductModel, bool) onDelete;

  const ProductCard({
    Key? key,
    required this.product,
    required this.isDarkMode,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserViewModel _userViewModel = Get.find<UserViewModel>();
    Color stockColor = product.quantity == 0
        ? Colors.red
        : product.quantity < 30
            ? Colors.orange
            : Colors.green;

    return InkWell(
      onTap: () => onTap(product),
      borderRadius: BorderRadius.circular(16),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        color: isDarkMode
            ? AppColors.darkBackground.withOpacity(0.9)
            : AppColors.background,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[700] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  image: product.imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(product.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: product.imageUrl == null
                    ? Icon(Icons.image,
                        color: isDarkMode ? Colors.grey[500] : Colors.grey,
                        size: 40)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: AppTextStyles.h2.copyWith(
                          color: isDarkMode
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.quantity == 0
                          ? 'Out of stock'
                          : 'In stock: ${product.quantity}',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: stockColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Obx(() => _userViewModel.isAdmin.value
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete,
                              color:
                                  isDarkMode ? Colors.grey[400] : Colors.grey,
                              size: 20),
                          onPressed: () => onDelete(product, isDarkMode),
                        ),
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDarkMode
                                ? AppColors.darkPrimary
                                : AppColors.primary,
                            boxShadow: [
                              BoxShadow(
                                color: (isDarkMode
                                        ? AppColors.darkPrimary
                                        : AppColors.primary)
                                    .withOpacity(0.3),
                                spreadRadius: 0.5,
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.edit,
                                color: Colors.white, size: 16),
                            constraints: const BoxConstraints.tightFor(
                                width: 20, height: 20),
                            padding: EdgeInsets.zero,
                            splashRadius: 10,
                            onPressed: () => onEdit(product),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}
