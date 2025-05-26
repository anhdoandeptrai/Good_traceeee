import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/theme.dart';
import '../../viewmodels/user_viewmodel.dart';
import '../../viewmodels/theme_viewmodel.dart';
import '../../models/product_model.dart';

void showProductDetail(BuildContext context, ProductModel product) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ProductDetailBottomSheet(product: product),
  );
}

class ProductDetailBottomSheet extends StatelessWidget {
  final ProductModel product;

  const ProductDetailBottomSheet({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomSheetHeight = screenHeight * 0.7;
    final ThemeViewModel themeViewModel = Get.find<ThemeViewModel>();

    return Obx(() {
      final isDarkMode = themeViewModel.isDarkMode.value;

      return Container(
        height: bottomSheetHeight,
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkBackground : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            _buildBottomSheetHeader(isDarkMode),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildProductImage(isDarkMode),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: _buildProductDetails(isDarkMode),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBottomSheetHeader(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkBackground : Colors.white,
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.2)
                : Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Product Details',
              style: isDarkMode
                  ? AppTextStyles.darkBodyLarge
                  : AppTextStyles.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.close,
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
            onPressed: () => Get.back(),
            padding: EdgeInsets.zero,
            iconSize: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(bool isDarkMode) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.grey[200],
      ),
      child: product.imageUrl != null && product.imageUrl!.isNotEmpty
          ? Image.network(
              product.imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Icon(
                    Icons.image_not_supported,
                    color: isDarkMode ? Colors.grey[600] : Colors.grey,
                    size: 80,
                  ),
                );
              },
            )
          : Center(
              child: Icon(
                Icons.image,
                color: isDarkMode ? Colors.grey[600] : Colors.grey,
                size: 80,
              ),
            ),
    );
  }

  Widget _buildProductDetails(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: isDarkMode ? AppTextStyles.darkH2 : AppTextStyles.h2,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.darkPrimary.withOpacity(0.2)
                    : AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                product.category,
                style: isDarkMode
                    ? AppTextStyles.darkBodyLarge
                    : AppTextStyles.bodyLarge,
              ),
            ),
            const Spacer(),
            Text(
              '${product.price} đ',
              style: (isDarkMode
                      ? AppTextStyles.darkBodyLarge
                      : AppTextStyles.bodyLarge)
                  .copyWith(
                color: isDarkMode ? AppColors.darkPrimary : AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 1,
          color: isDarkMode
              ? AppColors.darkBackground.withOpacity(0.9)
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description',
                  style: (isDarkMode
                          ? AppTextStyles.darkBodyLarge
                          : AppTextStyles.bodyLarge)
                      .copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.description,
                  style: isDarkMode
                      ? AppTextStyles.darkBodyLarge
                      : AppTextStyles.bodyLarge,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 1,
          color: isDarkMode
              ? AppColors.darkBackground.withOpacity(0.9)
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Detailed Information',
                  style: (isDarkMode
                          ? AppTextStyles.darkBodyLarge
                          : AppTextStyles.bodyLarge)
                      .copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Divider(
                  color:
                      isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                ),
                _buildInfoRow('Product ID', product.id, isDarkMode),
                _buildInfoRow(
                    'Quantity in Stock', '${product.quantity}', isDarkMode),
                _buildInfoRow(
                  'Created Date',
                  '${product.createdAt.day}/${product.createdAt.month}/${product.createdAt.year}',
                  isDarkMode,
                ),
                _buildInfoRow(
                  'Last Updated',
                  '${product.updatedAt.day}/${product.updatedAt.month}/${product.updatedAt.year}',
                  isDarkMode,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: (isDarkMode
                    ? AppTextStyles.darkBodyLarge
                    : AppTextStyles.bodyLarge)
                .copyWith(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[700]),
          ),
          Text(
            value,
            style: (isDarkMode
                    ? AppTextStyles.darkBodyLarge
                    : AppTextStyles.bodyLarge)
                .copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class ProductDetailView extends StatelessWidget {
  final dynamic product = Get.arguments;
  late final UserViewModel _userViewModel;

  ProductDetailView({Key? key}) : super(key: key) {
    if (!Get.isRegistered<UserViewModel>()) {
      _userViewModel = Get.put(UserViewModel(), permanent: true);
    } else {
      _userViewModel = Get.find<UserViewModel>();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: _buildProductDetails(),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: AppColors.primary),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
        background: product.imageUrl != null && product.imageUrl.isNotEmpty
            ? Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                      size: 80,
                    ),
                  );
                },
              )
            : Container(
                color: Colors.grey[200],
                child: const Icon(
                  Icons.image,
                  color: Colors.grey,
                  size: 80,
                ),
              ),
      ),
    );
  }

  Widget _buildProductDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name ?? 'No Name',
            style: AppTextStyles.h2,
          ),
          const SizedBox(height: 8),
          if (product.category != null && product.category.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                product.category,
                style: AppTextStyles.bodyLarge,
              ),
            ),
          const SizedBox(height: 16),
          if (product.description != null && product.description.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.description,
                  style: AppTextStyles.bodyLarge,
                ),
                const SizedBox(height: 16),
              ],
            ),
          const Divider(color: AppColors.primary),
          const SizedBox(height: 8),
          _buildInfoRow('Quantity', '${product.quantity ?? 0}'),
          if (product.price != null)
            _buildInfoRow('Price', '${product.price} đ'),
          if (product.createdAt != null)
            _buildInfoRow(
              'Created Date',
              '${product.createdAt.day}/${product.createdAt.month}/${product.createdAt.year}',
            ),
          if (product.updatedAt != null)
            _buildInfoRow(
              'Updated',
              '${product.updatedAt.day}/${product.updatedAt.month}/${product.updatedAt.year}',
            ),
          Obx(() => _userViewModel.isAdmin.value
              ? _buildInfoRow('ID', product.id ?? '')
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyLarge),
          Text(value, style: AppTextStyles.bodyLarge),
        ],
      ),
    );
  }
}
