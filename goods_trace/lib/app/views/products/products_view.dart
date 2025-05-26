import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goods_trace/app/core/theme/theme.dart';
import 'package:goods_trace/app/models/product_model.dart';
import 'package:goods_trace/app/viewmodels/auth_viewmodel.dart';
import 'package:goods_trace/app/viewmodels/theme_viewmodel.dart';
import 'package:goods_trace/app/viewmodels/user_viewmodel.dart';
import 'package:goods_trace/app/views/products/add_edit_product_view.dart';
import 'package:goods_trace/app/views/products/product_detail_view.dart';
import 'package:goods_trace/app/views/products/components_product_view/product_list.dart';
import 'package:goods_trace/app/views/products/components_product_view/product_grid.dart';
import 'package:goods_trace/app/views/products/components_product_view/product_search_bar.dart';
import 'package:goods_trace/app/views/products/components_product_view/bottom_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../viewmodels/products_viewmodel.dart';

class ProductsView extends StatefulWidget {
  final bool hideNavBar;

  ProductsView({Key? key, this.hideNavBar = false}) : super(key: key);

  @override
  _ProductsViewState createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  late final ProductsViewModel _viewModel;
  late final ThemeViewModel _themeViewModel;

  @override
  void initState() {
    super.initState();

    if (!Get.isRegistered<ProductsViewModel>()) {
      Get.put(ProductsViewModel());
    }

    if (!Get.isRegistered<ThemeViewModel>()) {
      Get.put(ThemeViewModel(), permanent: true);
    }

    _themeViewModel = Get.find<ThemeViewModel>();
    _viewModel = Get.find<ProductsViewModel>();

    final authViewModel = Get.find<AuthViewModel>();
    debugPrint(
        'ProductsView - Checking admin role: isAdmin=${authViewModel.isAdmin.value}');

    checkAdminStatusFromPrefs();
  }

  Future<void> checkAdminStatusFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isAdmin = prefs.getBool('is_admin') ?? false;
      final userId = prefs.getString('user_id') ?? '';

      debugPrint('SharedPreferences - userId: $userId, isAdmin: $isAdmin');

      final authViewModel = Get.find<AuthViewModel>();
      if (isAdmin && authViewModel.isAdmin.value != true) {
        debugPrint('Correcting admin status from SharedPreferences');
        authViewModel.isAdmin.value = true;
      }
    } catch (e) {
      debugPrint('Error checking admin status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDarkMode = _themeViewModel.isDarkMode.value;

      return Scaffold(
        backgroundColor:
            isDarkMode ? AppColors.darkBackground : AppColors.background,
        appBar: AppBar(
          title: Text('Goods Trace',
              style: AppTextStyles.h1.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary)),
          backgroundColor:
              isDarkMode ? AppColors.darkBackground : AppColors.background,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh,
                  color:
                      isDarkMode ? AppColors.darkPrimary : AppColors.primary),
              onPressed: () => _viewModel.loadProducts(),
              tooltip: 'Reload products',
            ),
            IconButton(
              icon: Icon(
                _viewModel.isFullScreen.value
                    ? Icons.fullscreen_exit
                    : Icons.fullscreen,
                color: isDarkMode ? AppColors.darkPrimary : AppColors.primary,
              ),
              onPressed: () {
                _viewModel.toggleFullScreen();
                _viewModel.updateItemsPerRow(context);
                _applyScreenSizeMode(context);
              },
              tooltip: 'Toggle fullscreen mode',
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Padding(
            padding: _viewModel.isFullScreen.value
                ? const EdgeInsets.symmetric(horizontal: 40.0)
                : EdgeInsets.zero,
            child: Column(
              children: [
                ProductSearchBar(
                  isDarkMode: isDarkMode,
                  onSearchChanged: (value) =>
                      _viewModel.searchQuery.value = value,
                  searchQuery: _viewModel.searchQuery.value,
                ),
                Expanded(child: _buildProductList(isDarkMode)),
              ],
            ),
          ),
        ),
        floatingActionButton:
            !widget.hideNavBar ? _buildFloatingActionButton(isDarkMode) : null,
        bottomNavigationBar: !widget.hideNavBar
            ? ProductsBottomNavigation(isDarkMode: isDarkMode)
            : null,
      );
    });
  }

  Widget _buildProductList(bool isDarkMode) {
    return Obx(() {
      if (_viewModel.isLoading.value) {
        return Center(
            child: CircularProgressIndicator(
                color: isDarkMode ? AppColors.darkPrimary : AppColors.primary));
      }

      if (_viewModel.filteredProducts.isEmpty) {
        return Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              'No products found',
              style: AppTextStyles.bodyLarge.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary),
            ),
          ),
        );
      }

      return Container(
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.darkBackground.withOpacity(0.95)
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
          boxShadow: isDarkMode
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: _viewModel.isFullScreen.value && _viewModel.itemsPerRow.value > 1
            ? ProductGrid(
                products: _viewModel.filteredProducts,
                isDarkMode: isDarkMode,
                itemsPerRow: _viewModel.itemsPerRow.value,
                onProductTap: _navigateToProductDetail,
                onEditProduct: _editProduct,
                onDeleteProduct: _deleteProduct,
              )
            : ProductList(
                products: _viewModel.filteredProducts,
                isDarkMode: isDarkMode,
                onProductTap: _navigateToProductDetail,
                onEditProduct: _editProduct,
                onDeleteProduct: _deleteProduct,
              ),
      );
    });
  }

  Widget _buildFloatingActionButton(bool isDarkMode) {
    final UserViewModel _userViewModel = Get.find<UserViewModel>();

    return Obx(() => _userViewModel.isAdmin.value
        ? FloatingActionButton(
            onPressed: _addProduct,
            mini: true,
            backgroundColor:
                isDarkMode ? AppColors.darkPrimary : AppColors.buttonText,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              Icons.add,
              color: isDarkMode ? AppColors.darkBackground : AppColors.primary,
              size: 40,
            ),
          )
        : const SizedBox());
  }

  void _addProduct() {
    final UserViewModel _userViewModel = Get.find<UserViewModel>();

    if (!_userViewModel.isAdmin.value) {
      Get.snackbar(
        'Permission Denied',
        'You need admin privileges to add products',
        backgroundColor: Color.fromARGB(255, 224, 94, 85).withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return AddEditProductBottomSheet();
      },
    );
  }

  void _editProduct(ProductModel product) {
    final UserViewModel _userViewModel = Get.find<UserViewModel>();

    if (!_userViewModel.isAdmin.value) {
      Get.snackbar(
        'Permission Denied',
        'You need admin privileges to edit products',
        backgroundColor: Color.fromARGB(255, 224, 94, 85).withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return AddEditProductBottomSheet(product: product);
      },
    );
  }

  void _deleteProduct(ProductModel product, bool isDarkMode) {
    final UserViewModel _userViewModel = Get.find<UserViewModel>();

    if (!_userViewModel.isAdmin.value) {
      Get.snackbar(
        'Permission Denied',
        'You need admin privileges to delete products',
        backgroundColor: Color.fromARGB(255, 224, 94, 85).withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    Get.dialog(
      AlertDialog(
        backgroundColor: isDarkMode ? AppColors.darkBackground : Colors.white,
        title: Text('Confirm Delete',
            style: AppTextStyles.h2.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary)),
        content: Text(
          'Do you want to delete ${product.name}?',
          style: AppTextStyles.bodyLarge.copyWith(
              color: isDarkMode
                  ? AppColors.darkTextPrimary
                  : AppColors.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('No',
                style: AppTextStyles.bodyLarge.copyWith(
                    color: isDarkMode
                        ? AppColors.darkPrimary
                        : AppColors.primary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isDarkMode ? AppColors.darkPrimary : AppColors.primary,
            ),
            onPressed: () {
              Get.back();
              _viewModel.deleteProduct(product.id);
            },
            child: Text('Yes',
                style: AppTextStyles.bodyLarge.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _navigateToProductDetail(ProductModel product) {
    showProductDetail(Get.context!, product);
  }

  void _applyScreenSizeMode(BuildContext context) {
    }
}
