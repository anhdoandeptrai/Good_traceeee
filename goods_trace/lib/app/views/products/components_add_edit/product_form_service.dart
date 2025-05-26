import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goods_trace/app/models/product_model.dart';
import 'package:goods_trace/app/services/image_service.dart';
import 'package:goods_trace/app/viewmodels/products_viewmodel.dart';
import 'package:goods_trace/app/core/theme/theme.dart';

class ProductFormService {
  static Future<bool> validateForm({
    required String name,
    required String description,
    required String priceText,
    required String quantityText,
    required String? selectedCategory,
  }) {
    if (name.isEmpty ||
        description.isEmpty ||
        priceText.isEmpty ||
        quantityText.isEmpty ||
        selectedCategory == null) {
      Get.snackbar(
        'Error',
        'Please fill in all required fields',
        backgroundColor: Color.fromARGB(255, 224, 94, 85).withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return Future.value(false);
    }

    final price = double.tryParse(priceText);
    final quantity = int.tryParse(quantityText);

    if (price == null || quantity == null) {
      Get.snackbar(
        'Error',
        'Price and quantity must be valid numbers',
        backgroundColor: Color.fromARGB(255, 224, 94, 85).withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return Future.value(false);
    }

    return Future.value(true);
  }

  static Future<bool> saveProduct({
    required ProductModel? existingProduct,
    required String name,
    required String description,
    required String priceText,
    required String quantityText,
    required String selectedCategory,
    required File? selectedImage,
    required BuildContext context,
  }) async {
    final _viewModel = Get.find<ProductsViewModel>();
    final price = double.tryParse(priceText) ?? 0.0;
    final quantity = int.tryParse(quantityText) ?? 0;

    try {
      String? imageUrl = existingProduct?.imageUrl;
      if (selectedImage != null) {
        imageUrl = await ImageService.uploadImageToImgBB(selectedImage);
      }

      final newProduct = ProductModel(
        id: existingProduct?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        description: description,
        price: price,
        category: selectedCategory,
        imageUrl: imageUrl,
        quantity: quantity,
        createdAt: existingProduct?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (existingProduct == null) {
        await _viewModel.addProduct(newProduct);
      } else {
        await _viewModel.updateProduct(newProduct);
      }

      Navigator.of(context).pop();

      Future.delayed(const Duration(milliseconds: 300), () {
        Get.snackbar(
          'Success',
          existingProduct == null
              ? 'Product created successfully'
              : 'Product updated successfully',
          backgroundColor: AppColors.primary.withOpacity(0.8),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      });

      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save product: ${e.toString()}',
        backgroundColor: Color.fromARGB(255, 224, 94, 85).withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }
  }
}
