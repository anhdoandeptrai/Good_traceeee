import 'package:get/get.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'package:goods_trace/app/viewmodels/products_viewmodel.dart';
import 'package:goods_trace/app/viewmodels/user_viewmodel.dart';
import 'package:goods_trace/app/viewmodels/theme_viewmodel.dart';

import '../services/auth_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthService>(AuthService(), permanent: true);

    Get.lazyPut<AuthViewModel>(() => AuthViewModel());
    Get.put(UserViewModel(), permanent: true);
    Get.put(ProductsViewModel());
    Get.put(ThemeViewModel());
  }
}
