// lib/app/bindings/product_binding.dart
import 'package:get/get.dart';
import 'package:goods_trace/app/viewmodels/user_viewmodel.dart';
import '../viewmodels/products_viewmodel.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductsViewModel>(() => ProductsViewModel());
    // Get.lazyPut<ProductDetailViewModel>(() => ProductDetailViewModel());
    if (!Get.isRegistered<UserViewModel>()) {
      Get.put(UserViewModel(), permanent: true);
    }
  }
}
