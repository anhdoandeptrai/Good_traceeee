import 'package:get/get.dart';
import 'package:goods_trace/app/viewmodels/products_viewmodel.dart';
import 'package:goods_trace/app/viewmodels/user_viewmodel.dart';
import 'package:goods_trace/app/viewmodels/theme_viewmodel.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductsViewModel());
    Get.lazyPut(() => UserViewModel());
    Get.lazyPut(() => ThemeViewModel());
  }
}
