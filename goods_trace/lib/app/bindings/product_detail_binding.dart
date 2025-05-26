import 'package:get/get.dart';
import '../viewmodels/user_viewmodel.dart';

class ProductDetailBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<UserViewModel>()) {
      Get.put(UserViewModel(), permanent: true);
    }
  }
}
