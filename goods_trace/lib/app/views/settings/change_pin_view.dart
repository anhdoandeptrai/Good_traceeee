import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goods_trace/app/viewmodels/theme_viewmodel.dart';
import '../../core/theme/theme.dart';
import '../../services/auth_service.dart';

class ChangePinView extends StatefulWidget {
  @override
  _ChangePinViewState createState() => _ChangePinViewState();
}

class _ChangePinViewState extends State<ChangePinView> {
  final TextEditingController currentPinController = TextEditingController();
  final TextEditingController newPinController = TextEditingController();
  final TextEditingController confirmPinController = TextEditingController();
  final RxBool isLoading = false.obs;
  bool isPinHidden = true;
  @override
  Widget build(BuildContext context) {
    final ThemeViewModel themeController = Get.find<ThemeViewModel>();
    final bool isDarkMode = themeController.isDarkMode.value;

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: Text(
          'Change PIN',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color:
                isDarkMode ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        backgroundColor: isDarkMode ? AppColors.darkBackground : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? AppColors.darkTextPrimary : Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                'Current PIN Code',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: currentPinController,
                style: TextStyle(
                  color: isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter your current PIN code',
                  hintStyle: TextStyle(
                    color: isDarkMode
                        ? AppColors.darkTextPrimary.withOpacity(0.5)
                        : AppColors.textPrimary.withOpacity(0.5),
                  ),
                  counterStyle: TextStyle(
                    color: isDarkMode
                        ? AppColors.darkTextPrimary.withOpacity(0.7)
                        : AppColors.textPrimary.withOpacity(0.7),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDarkMode
                          ? AppColors.darkPrimary
                          : AppColors.primary,
                      width: 2,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPinHidden ? Icons.visibility_off : Icons.visibility,
                      color: isDarkMode
                          ? AppColors.darkPrimary
                          : AppColors.primary,
                    ),
                    onPressed: () {
                      setState(() {
                        isPinHidden = !isPinHidden;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: isDarkMode
                      ? AppColors.darkBackground.withOpacity(0.3)
                      : Colors.grey[200],
                ),
                keyboardType: TextInputType.number,
                obscureText: isPinHidden,
                maxLength: 4,
              ),
              const SizedBox(height: 24),
              Text(
                'New PIN Code',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: newPinController,
                style: TextStyle(
                  color: isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter your new PIN code',
                  hintStyle: TextStyle(
                    color: isDarkMode
                        ? AppColors.darkTextPrimary.withOpacity(0.5)
                        : AppColors.textPrimary.withOpacity(0.5),
                  ),
                  counterStyle: TextStyle(
                    color: isDarkMode
                        ? AppColors.darkTextPrimary.withOpacity(0.7)
                        : AppColors.textPrimary.withOpacity(0.7),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDarkMode
                          ? AppColors.darkPrimary
                          : AppColors.primary,
                      width: 2,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPinHidden ? Icons.visibility_off : Icons.visibility,
                      color: isDarkMode
                          ? AppColors.darkPrimary
                          : AppColors.primary,
                    ),
                    onPressed: () {
                      setState(() {
                        isPinHidden = !isPinHidden;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: isDarkMode
                      ? AppColors.darkBackground.withOpacity(0.3)
                      : Colors.grey[200],
                ),
                keyboardType: TextInputType.number,
                obscureText: isPinHidden,
                maxLength: 4,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmPinController,
                style: TextStyle(
                  color: isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Re-enter your new PIN code',
                  hintStyle: TextStyle(
                    color: isDarkMode
                        ? AppColors.darkTextPrimary.withOpacity(0.5)
                        : AppColors.textPrimary.withOpacity(0.5),
                  ),
                  counterStyle: TextStyle(
                    color: isDarkMode
                        ? AppColors.darkTextPrimary.withOpacity(0.7)
                        : AppColors.textPrimary.withOpacity(0.7),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDarkMode
                          ? AppColors.darkPrimary
                          : AppColors.primary,
                      width: 2,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPinHidden ? Icons.visibility_off : Icons.visibility,
                      color: isDarkMode
                          ? AppColors.darkPrimary
                          : AppColors.primary,
                    ),
                    onPressed: () {
                      setState(() {
                        isPinHidden = !isPinHidden;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: isDarkMode
                      ? AppColors.darkBackground.withOpacity(0.3)
                      : Colors.grey[200],
                ),
                keyboardType: TextInputType.number,
                obscureText: isPinHidden,
                maxLength: 4,
              ),
              const SizedBox(height: 32),
              Obx(() => Center(
                    child: ElevatedButton(
                      onPressed: isLoading.value
                          ? null
                          : () async {
                              final currentPin =
                                  currentPinController.text.trim();
                              final newPin = newPinController.text.trim();
                              final confirmPin =
                                  confirmPinController.text.trim();

                              if (currentPin.isEmpty ||
                                  newPin.isEmpty ||
                                  confirmPin.isEmpty) {
                                Get.snackbar('Error', 'All fields are required',
                                    backgroundColor:
                                        Colors.red.withOpacity(0.8),
                                    colorText: Colors.white);
                                return;
                              }

                              if (newPin.length != 4 ||
                                  !RegExp(r'^\d{4}$').hasMatch(newPin)) {
                                Get.snackbar('Error', 'PIN must be 4 digits',
                                    backgroundColor:
                                        Color.fromARGB(255, 224, 94, 85)
                                            .withOpacity(0.8),
                                    colorText: Colors.white);
                                return;
                              }

                              if (newPin != confirmPin) {
                                Get.snackbar('Error', 'PINs do not match',
                                    backgroundColor:
                                        Color.fromARGB(255, 224, 94, 85)
                                            .withOpacity(0.8),
                                    colorText: Colors.white);
                                return;
                              }

                              if (currentPin != "1925") {
                                Get.snackbar(
                                    'Error', 'Current PIN is incorrect',
                                    backgroundColor:
                                        Color.fromARGB(255, 224, 94, 85)
                                            .withOpacity(0.8),
                                    colorText: Colors.white);
                                return;
                              }

                              isLoading.value = true;

                              try {
                                final success = await Get.find<AuthService>()
                                    .emergencyUpdateAdminPin(newPin);

                                isLoading.value = false;

                                if (success) {
                                  Get.back();
                                  Get.snackbar(
                                      'Success', 'PIN changed successfully',
                                      backgroundColor:
                                          AppColors.primary.withOpacity(0.8),
                                      colorText: Colors.white);
                                } else {
                                  Get.snackbar('Error', 'Failed to change PIN',
                                      backgroundColor:
                                          Color.fromARGB(255, 224, 94, 85)
                                              .withOpacity(0.8),
                                      colorText: Colors.white);
                                }
                              } catch (e) {
                                isLoading.value = false;
                                Get.snackbar('Error', 'Exception: $e',
                                    backgroundColor:
                                        Color.fromARGB(255, 224, 94, 85)
                                            .withOpacity(0.8),
                                    colorText: Colors.white);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode
                            ? AppColors.darkPrimary
                            : AppColors.primary,
                        foregroundColor:
                            isDarkMode ? Colors.black : Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: isDarkMode ? 8 : 2,
                      ),
                      child: isLoading.value
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: isDarkMode ? Colors.black : Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Update',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
