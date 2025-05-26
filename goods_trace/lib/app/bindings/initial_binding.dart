import 'package:get/get.dart';
import '../viewmodels/user_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthViewModel(), permanent: true);
    Get.put(UserViewModel(), permanent: true);
  }
}
