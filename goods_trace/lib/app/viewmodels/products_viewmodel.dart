import 'package:get/get.dart';
import 'package:goods_trace/app/viewmodels/user_viewmodel.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../services/firebase_service.dart';
import 'package:flutter/material.dart';

class ProductsViewModel extends GetxController {
  RxBool isLoading = false.obs;
  RxList<ProductModel> products = <ProductModel>[].obs;
  RxList<ProductModel> filteredProducts = <ProductModel>[].obs;
  RxString searchQuery = ''.obs;
  RxString selectedCategory = ''.obs;
  final RxInt itemsPerRow = 1.obs;
  final RxBool isFullScreen = false.obs;

  final FirebaseService _firebaseService = FirebaseService();

  RxList<CategoryModel> categories = <CategoryModel>[
    CategoryModel(id: '1', name: 'Electronics'),
    CategoryModel(id: '2', name: 'Fashion'),
    CategoryModel(id: '3', name: 'Food'),
    CategoryModel(id: '4', name: 'Home Appliances'),
    CategoryModel(id: '5', name: 'Beauty'),
    CategoryModel(id: '6', name: 'Books'),
    CategoryModel(id: '7', name: 'Sports'),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
    debounce(searchQuery, (_) => filterProducts(),
        time: const Duration(milliseconds: 500));
  }

  Future<void> loadProducts() async {
    try {
      isLoading.value = true;
      print('Loading products from Firestore');

      final snapshot =
          await _firebaseService.firestore.collection('products').get();

      print('Firestore response: ${snapshot.docs.length} products');

      if (snapshot.docs.isNotEmpty) {
        products.value = snapshot.docs
            .map((doc) => ProductModel.fromJson(doc.data()))
            .toList();
      } else {
        print('No products found in Firestore');
        products.value = [];
      }

      filterProducts();
    } catch (e) {
      print('Error loading products: $e');
      products.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  void filterProducts() {
    List<ProductModel> filtered = [...products];

    if (selectedCategory.value.isNotEmpty) {
      filtered = filtered
          .where((product) => product.category == selectedCategory.value)
          .toList();
    }

    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered
          .where((product) =>
              product.name.toLowerCase().contains(query) ||
              product.description.toLowerCase().contains(query))
          .toList();
    }

    filteredProducts.value = filtered;
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    filterProducts();
  }

  Future<void> addProduct(ProductModel product) async {
    if (!Get.find<UserViewModel>().isAdmin.value) {
      throw Exception('Permission denied: Only admins can add products');
    }

    try {
      isLoading.value = true;

      await _firebaseService.firestore
          .collection('products')
          .doc(product.id)
          .set(product.toJson());

      await loadProducts();
    } catch (e) {
      print('Error adding product: $e');
      throw e;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    if (!Get.find<UserViewModel>().isAdmin.value) {
      throw Exception('Permission denied: Only admins can update products');
    }

    try {
      isLoading.value = true;

      await _firebaseService.firestore
          .collection('products')
          .doc(product.id)
          .update(product.toJson());

      await loadProducts();
    } catch (e) {
      print('Error updating product: $e');
      throw e;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProduct(String id) async {
    if (id.isEmpty) {
      print('Error: Cannot delete product with empty ID');
      return;
    }

    if (!Get.find<UserViewModel>().isAdmin.value) {
      throw Exception('Permission denied: Only admins can delete products');
    }

    try {
      isLoading.value = true;

      await _firebaseService.firestore.collection('products').doc(id).delete();

      await loadProducts();
    } catch (e) {
      print('Error deleting product: $e');
      throw e;
    } finally {
      isLoading.value = false;
    }
  }

  void updateItemsPerRow(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (isFullScreen.value) {
      if (screenWidth > 1200) {
        itemsPerRow.value = 4;
      } else if (screenWidth > 900) {
        itemsPerRow.value = 3;
      } else if (screenWidth > 600) {
        itemsPerRow.value = 2;
      } else {
        itemsPerRow.value = 1;
      }
    } else {
      itemsPerRow.value = 1;
    }
  }

  void toggleFullScreen() {
    isFullScreen.toggle();
  }
}
