import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goods_trace/app/models/category_model.dart';
import 'dart:io';
import 'package:goods_trace/app/viewmodels/theme_viewmodel.dart';
import 'package:goods_trace/app/core/theme/theme.dart';
import 'package:goods_trace/app/models/product_model.dart';
import 'package:goods_trace/app/viewmodels/products_viewmodel.dart';
import 'package:goods_trace/app/views/products/components_add_edit/category_dropdown.dart';
import 'package:goods_trace/app/views/products/components_add_edit/product_form_field.dart';
import 'package:goods_trace/app/views/products/components_add_edit/product_form_service.dart';
import 'package:goods_trace/app/views/products/components_add_edit/product_imagepicker.dart';

class AddEditProductBottomSheet extends StatefulWidget {
  final ProductModel? product;

  const AddEditProductBottomSheet({Key? key, this.product}) : super(key: key);

  @override
  State<AddEditProductBottomSheet> createState() =>
      _AddEditProductBottomSheetState();
}

class _AddEditProductBottomSheetState extends State<AddEditProductBottomSheet> {
  late final ProductsViewModel _viewModel;
  late final ThemeViewModel _themeViewModel;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  File? _selectedImage;
  String? _selectedCategory;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();

    if (!Get.isRegistered<ProductsViewModel>()) {
      Get.put(ProductsViewModel(), permanent: true);
    }

    if (!Get.isRegistered<ThemeViewModel>()) {
      Get.put(ThemeViewModel(), permanent: true);
    }

    _viewModel = Get.find<ProductsViewModel>();
    _themeViewModel = Get.find<ThemeViewModel>();

    _initializeFormValues();
  }

  void _initializeFormValues() {
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _descriptionController.text = widget.product!.description;
      _priceController.text = widget.product!.price.toString();
      _quantityController.text = widget.product!.quantity.toString();

      bool categoryExists = _viewModel.categories
          .any((category) => category.name == widget.product!.category);

      if (categoryExists) {
        _selectedCategory = widget.product!.category;
      } else {
        _viewModel.categories.add(CategoryModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: widget.product!.category));
        _selectedCategory = widget.product!.category;
      }
    } else {
      _selectedCategory = _viewModel.categories.isNotEmpty
          ? _viewModel.categories[0].name
          : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double maxHeight = MediaQuery.of(context).size.height * 0.7;

    return Obx(() {
      final isDarkMode = _themeViewModel.isDarkMode.value;

      return Container(
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkBackground : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: maxHeight,
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(isDarkMode),
                  const SizedBox(height: 24),
                  ProductImagePicker(
                    selectedImage: _selectedImage,
                    existingImageUrl: widget.product?.imageUrl,
                    isUploading: _isUploading,
                    onImageSelected: (file) {
                      setState(() {
                        _selectedImage = file;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  ProductFormField(
                    label: 'Name Product',
                    hintText: 'Enter your product name',
                    controller: _nameController,
                    prefixIcon: Icons.shopping_bag_outlined,
                    isRequired: true,
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 16),
                  ProductFormField(
                    label: 'Description',
                    hintText: 'Enter product description',
                    controller: _descriptionController,
                    maxLines: 3,
                    prefixIcon: Icons.description_outlined,
                    isRequired: true,
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 16),
                  ProductFormField(
                    label: 'Price',
                    hintText: 'Enter product price',
                    controller: _priceController,
                    prefixIcon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                    isRequired: true,
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 16),
                  ProductFormField(
                    label: 'Quantity',
                    hintText: 'Enter product quantity',
                    controller: _quantityController,
                    prefixIcon: Icons.inventory,
                    keyboardType: TextInputType.number,
                    isRequired: true,
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 16),
                  CategoryDropdown(
                    selectedCategory: _selectedCategory,
                    onCategoryChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 24),
                  _buildSaveButton(isDarkMode),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildHeader(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.product == null ? 'Create New Product' : 'Edit Product',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? AppColors.darkTextPrimary : Colors.black87,
          ),
        ),
        IconButton(
          icon: Icon(Icons.close,
              color: isDarkMode
                  ? AppColors.darkTextPrimary.withOpacity(0.7)
                  : Colors.black54),
          onPressed: () => Get.back(),
        ),
      ],
    );
  }

  Widget _buildSaveButton(bool isDarkMode) {
    return Center(
      child: ElevatedButton(
        onPressed: _isUploading ? null : _saveProduct,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE57373),
          disabledBackgroundColor: Colors.grey,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Text(
          _isUploading
              ? 'Saving...'
              : (widget.product == null ? 'CREATE' : 'SAVE'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _saveProduct() async {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final priceText = _priceController.text.trim();
    final quantityText = _quantityController.text.trim();

    final isValid = await ProductFormService.validateForm(
      name: name,
      description: description,
      priceText: priceText,
      quantityText: quantityText,
      selectedCategory: _selectedCategory,
    );

    if (!isValid) return;

    setState(() {
      _isUploading = true;
    });

    try {
      await ProductFormService.saveProduct(
        existingProduct: widget.product,
        name: name,
        description: description,
        priceText: priceText,
        quantityText: quantityText,
        selectedCategory: _selectedCategory!,
        selectedImage: _selectedImage,
        context: context,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }
}
