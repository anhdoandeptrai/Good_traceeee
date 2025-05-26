import 'package:get/get.dart';
import '../viewmodels/products_viewmodel.dart';

class AddEditProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductsViewModel>(() => ProductsViewModel());
  }
}
