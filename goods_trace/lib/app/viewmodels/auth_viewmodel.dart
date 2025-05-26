import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../routes/app_routes.dart';
import '../models/user_model.dart';

class AuthViewModel extends GetxController {
  final AuthService _authService = AuthService();
  final _usersCollection = FirebaseFirestore.instance.collection('users');
  RxBool isLoading = false.obs;
  Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  RxBool isLoggedIn = false.obs;
  RxBool isAdmin = false.obs;

  @override
  void onInit() {
    super.onInit();

    isLoggedIn.value = true;
    isAdmin.value = true;
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    isLoading.value = true;
    final user = await _authService.getCurrentUser();
    if (user != null) {
      currentUser.value = user;
      isLoggedIn.value = true;
      isAdmin.value = user.isAdmin;
    }
    isLoading.value = false;
  }

  Future<bool> loginWithPin(String pin) async {
    try {
      isLoading.value = true;
      final user = await _authService.signInWithPin(pin);
      if (user != null) {
        currentUser.value = user;
        isLoggedIn.value = true;
        isAdmin.value = user.isAdmin;
        isLoading.value = false;
        navigateBasedOnRole();
        return true;
      }
      isLoading.value = false;
      return false;
    } catch (e) {
      print('Error logging in: $e');
      isLoading.value = false;
      return false;
    }
  }

  void navigateBasedOnRole() {
    if (isAdmin.value) {
      Get.offAllNamed(AppRoutes.products);
    } else {
      Get.offAllNamed(AppRoutes.products);
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    await _authService.logout();
    currentUser.value = null;
    isLoggedIn.value = false;
    isAdmin.value = false;
    isLoading.value = false;
    Get.offAllNamed(AppRoutes.pinEntry);
  }

  Future<bool> changePin(String newPin) async {
    try {
      isLoading.value = true;

      // Skip isAdmin check for now
      print("Starting PIN change process for: $newPin");

      // Call service directly
      final result = await _authService.changePin(newPin);

      // Update local reference
      if (result) {
        print("PIN updated successfully");
        // If we have a currentUser, update its reference too
        if (currentUser.value != null) {
          print("Updating currentUser reference");
          // Try to fetch fresh user data
          final updatedUser = await _authService.getCurrentUser();
          if (updatedUser != null) {
            currentUser.value = updatedUser;
          }
        }

        final hashedNewPin = _authService.hashPin(newPin);
        await _usersCollection.doc('admin').update({
          'pin': hashedNewPin,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      isLoading.value = false;
      return result;
    } catch (e) {
      print('Error in changePin ViewModel: $e');
      isLoading.value = false;
      return false;
    }
  }
}
