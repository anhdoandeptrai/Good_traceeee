import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goods_trace/app/services/auth_service.dart';
import '../../core/theme/theme.dart';
import '../../viewmodels/user_viewmodel.dart';
import '../../viewmodels/theme_viewmodel.dart';
import '../../routes/app_routes.dart';

class PinEntryView extends StatefulWidget {
  @override
  _PinEntryViewState createState() => _PinEntryViewState();
}

class _PinEntryViewState extends State<PinEntryView> {
  final List<TextEditingController> _controllers =
      List.generate(4, (index) => TextEditingController());
  final UserViewModel _userViewModel = Get.find<UserViewModel>();
  late final ThemeViewModel _themeViewModel;
  bool _isHidden = true;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<ThemeViewModel>()) {
      Get.put(ThemeViewModel());
    }
    _themeViewModel = Get.find<ThemeViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDarkMode = _themeViewModel.isDarkMode.value;

      return Scaffold(
        backgroundColor:
            isDarkMode ? AppColors.darkBackground : AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/logo.png',
                        width: 120,
                        height: 120,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Please enter PIN',
                        style: isDarkMode
                            ? AppTextStyles.darkH2
                            : AppTextStyles.h2,
                      ),
                      const SizedBox(height: 16),
                      _buildPinInput(isDarkMode),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => _showForgotPinDialog(isDarkMode),
                        child: Text(
                          'Forgot PIN?',
                          style: (isDarkMode
                                  ? AppTextStyles.darkBodyLarge
                                  : AppTextStyles.bodyLarge)
                              .copyWith(
                            decoration: TextDecoration.underline,
                            color: isDarkMode
                                ? AppColors.darkPrimary
                                : AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'copyright © 2025 Tekvizon Software Co. Ltd.',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      'All rights reserved.',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildPinInput(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Container(
          width: 50,
          height: 70,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(
                color: isDarkMode ? Colors.grey.shade600 : Colors.grey,
                width: 2),
            borderRadius: BorderRadius.circular(12),
            color: isDarkMode
                ? AppColors.darkBackground.withOpacity(0.8)
                : Colors.white,
          ),
          child: Center(
            child: TextField(
              controller: _controllers[index],
              keyboardType: TextInputType.number,
              obscureText: _isHidden,
              textAlign: TextAlign.center,
              maxLength: 1,
              style: (isDarkMode
                      ? AppTextStyles.darkBodyLarge
                      : AppTextStyles.bodyLarge)
                  .copyWith(fontSize: 24),
              decoration: InputDecoration(
                border: InputBorder.none,
                counterText: '',
                focusedBorder: isDarkMode
                    ? UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.darkPrimary, width: 2))
                    : null,
              ),
              onChanged: (value) {
                if (value.isNotEmpty && index < 3) {
                  FocusScope.of(context).nextFocus();
                } else if (value.isEmpty && index > 0) {
                  FocusScope.of(context).previousFocus();
                }
                if (_controllers
                    .every((controller) => controller.text.isNotEmpty)) {
                  setState(() => _isHidden = false);
                  _verifyPin();
                }
              },
            ),
          ),
        );
      }),
    );
  }

  void _verifyPin() async {
    final pin = _controllers.map((controller) => controller.text).join();

    if (pin.length != 4) {
      Get.snackbar(
        'Error',
        'PIN must be exactly 4 digits',
        backgroundColor: AppColors.primary,
        colorText: AppColors.buttonText,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final hashedPin = AuthService().hashPin(pin);
      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('pin', isEqualTo: hashedPin)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final userDoc = query.docs.first;
        final userData = userDoc.data();
        final isAdmin = userData['isAdmin'] ?? false;

        _userViewModel.isAdmin.value = isAdmin;

        if (isAdmin) {
          Get.snackbar('Success', 'Logged in as Admin',
              backgroundColor: AppColors.primary,
              colorText: AppColors.buttonText);
        } else {
          Get.snackbar('Success', 'Logged in as Regular User',
              backgroundColor: AppColors.primary,
              colorText: AppColors.buttonText);
        }

        Get.offAllNamed(AppRoutes.products);
      } else {
        Get.snackbar('Error', 'Invalid PIN',
            backgroundColor: Color.fromARGB(255, 224, 94, 85),
            colorText: AppColors.buttonText,
            snackPosition: SnackPosition.TOP);
        setState(() => _isHidden = true);
        _controllers.forEach((controller) => controller.clear());
      }
    } catch (e) {
      print('Error verifying PIN: $e');
      Get.snackbar('Error', 'An error occurred while verifying the PIN',
          backgroundColor: Color.fromARGB(255, 224, 94, 85),
          colorText: AppColors.buttonText,
          snackPosition: SnackPosition.TOP);
    }
  }

  void _showForgotPinDialog(bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              isDarkMode ? AppColors.darkBackground : AppColors.background,
          title: Text(
            'Forgot PIN',
            style: isDarkMode ? AppTextStyles.darkH2 : AppTextStyles.h2,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.person,
                    color:
                        isDarkMode ? AppColors.darkPrimary : AppColors.primary),
                title: Text('User PIN',
                    style: isDarkMode
                        ? AppTextStyles.darkBodyLarge
                        : AppTextStyles.bodyLarge),
                subtitle: Text('Your PIN is: 0611',
                    style: TextStyle(
                        color: isDarkMode
                            ? Colors.grey.shade400
                            : Colors.grey.shade700)),
                onTap: () {
                  Navigator.of(context).pop();
                  Get.snackbar(
                    'User PIN',
                    'Your PIN is: 0611',
                    backgroundColor:
                        isDarkMode ? AppColors.darkPrimary : AppColors.primary,
                    colorText: AppColors.buttonText,
                  );
                },
              ),
              Divider(
                  color: isDarkMode ? AppColors.darkPrimary : AppColors.primary,
                  thickness: 1),
              ListTile(
                leading: Icon(Icons.admin_panel_settings,
                    color:
                        isDarkMode ? AppColors.darkPrimary : AppColors.primary),
                title: Text('Admin PIN',
                    style: isDarkMode
                        ? AppTextStyles.darkBodyLarge
                        : AppTextStyles.bodyLarge),
                subtitle: Text('Please contact the store to reset your PIN.',
                    style: TextStyle(
                        color: isDarkMode
                            ? Colors.grey.shade400
                            : Colors.grey.shade700)),
                onTap: () {
                  Navigator.of(context).pop();
                  Get.snackbar(
                    'Admin PIN',
                    'Please contact the store to reset your PIN.',
                    backgroundColor:
                        isDarkMode ? AppColors.darkPrimary : AppColors.primary,
                    colorText: AppColors.buttonText,
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(
                    color:
                        isDarkMode ? AppColors.darkPrimary : AppColors.primary),
              ),
            ),
          ],
        );
      },
    );
  }
}
