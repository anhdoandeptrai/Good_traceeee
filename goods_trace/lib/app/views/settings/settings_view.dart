import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goods_trace/app/core/theme/theme.dart';
import 'package:goods_trace/app/routes/app_routes.dart';
import 'package:goods_trace/app/viewmodels/user_viewmodel.dart';
import 'package:goods_trace/app/viewmodels/theme_viewmodel.dart';
import 'package:goods_trace/app/views/home/main_view.dart';
import 'package:goods_trace/app/views/settings/change_pin_view.dart';

class SettingsView extends StatelessWidget {
  final UserViewModel _userViewModel = Get.find<UserViewModel>();
  final ThemeViewModel _themeViewModel = Get.put(ThemeViewModel());
  final bool hideNavBar;

  SettingsView({Key? key, this.hideNavBar = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDarkMode = _themeViewModel.isDarkMode.value;

      return Scaffold(
        backgroundColor:
            isDarkMode ? AppColors.darkBackground : AppColors.background,
        appBar: AppBar(
          title: Text(
            'Settings',
            style: AppTextStyles.h1.copyWith(
              color: isDarkMode
                  ? AppColors.darkTextPrimary
                  : AppColors.textPrimary,
            ),
          ),
          backgroundColor:
              isDarkMode ? AppColors.darkBackground : AppColors.background,
          elevation: 0,
          automaticallyImplyLeading: !hideNavBar,
          leading: !hideNavBar
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color:
                        isDarkMode ? AppColors.darkPrimary : AppColors.primary,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                )
              : null,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUserInfo(isDarkMode),
                    const SizedBox(height: 24),
                    _buildThemeSettings(),
                    Obx(() => _userViewModel.isAdmin.value
                        ? Column(
                            children: [
                              const SizedBox(height: 16),
                              _buildSecuritySettings(isDarkMode),
                            ],
                          )
                        : const SizedBox()),
                    const SizedBox(height: 16),
                    _buildLogoutButton(isDarkMode),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            _buildFooter(isDarkMode),
          ],
        ),
        bottomNavigationBar:
            !hideNavBar ? _buildBottomNavigationBar(isDarkMode) : null,
      );
    });
  }

  Widget _buildUserInfo(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.darkPrimary.withOpacity(0.1)
            : AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Obx(() => Row(
            children: [
              CircleAvatar(
                backgroundColor:
                    isDarkMode ? AppColors.darkPrimary : AppColors.primary,
                radius: 30,
                child: Icon(
                  _userViewModel.isAdmin.value
                      ? Icons.admin_panel_settings
                      : Icons.person,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _userViewModel.currentUser.value?.name ??
                          (_userViewModel.isAdmin.value ? 'Admin' : 'User'),
                      style: AppTextStyles.h2.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppColors.darkPrimary
                            : AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _userViewModel.isAdmin.value ? 'Admin' : 'User',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildThemeSettings() {
    final ThemeViewModel themeController = Get.find<ThemeViewModel>();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      color: themeController.isDarkMode.value
          ? AppColors.darkBackground.withOpacity(0.9)
          : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appearance',
              style: AppTextStyles.h2.copyWith(
                color: themeController.isDarkMode.value
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => SwitchListTile(
                  title: Text(
                    'Dark Mode',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: themeController.isDarkMode.value
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    'Switch between light and dark theme',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: themeController.isDarkMode.value
                          ? AppColors.darkTextPrimary.withOpacity(0.7)
                          : AppColors.textPrimary.withOpacity(0.7),
                    ),
                  ),
                  value: themeController.isDarkMode.value,
                  activeColor: AppColors.primary,
                  onChanged: (value) => themeController.toggleTheme(),
                  secondary: Icon(
                    themeController.isDarkMode.value
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: AppColors.primary,
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildSecuritySettings(bool isDarkMode) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      color:
          isDarkMode ? AppColors.darkBackground.withOpacity(0.9) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Security',
              style: AppTextStyles.h2.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.pin, color: AppColors.primary),
              title: Text(
                'Change PIN',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              subtitle: Text(
                'Update your security PIN',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextPrimary.withOpacity(0.7)
                      : AppColors.textPrimary.withOpacity(0.7),
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Get.to(() => ChangePinView());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(bool isDarkMode) {
    return Center(
      child: ElevatedButton.icon(
        icon: Icon(
          Icons.logout,
          color: Colors.white,
        ),
        label: Text(
          'Logout',
          style: AppTextStyles.bodyLarge.copyWith(
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isDarkMode ? AppColors.darkPrimary : AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: isDarkMode ? 4 : 2,
        ),
        onPressed: () => _showLogoutConfirmation(isDarkMode),
      ),
    );
  }

  Widget _buildFooter(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'copyright © 2025 Tekvizon Software Co. Ltd.',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: isDarkMode
                    ? AppColors.darkTextPrimary.withOpacity(0.6)
                    : Colors.grey.shade600,
              ),
            ),
            Text(
              'All rights reserved.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode
                    ? AppColors.darkTextPrimary.withOpacity(0.6)
                    : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkBackground : AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                Get.offAll(() => MainView(initialTab: 0),
                    transition: Transition.fadeIn);
              },
              child: Container(
                height: 60,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home,
                        color: isDarkMode
                            ? AppColors.darkTextPrimary.withOpacity(0.6)
                            : AppColors.textPrimary.withOpacity(0.6)),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 50,
            width: 1.5,
            color: Colors.grey,
          ),
          Expanded(
            child: InkWell(
              onTap: () {},
              child: Container(
                height: 60,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.settings,
                        color: isDarkMode
                            ? AppColors.darkPrimary
                            : AppColors.primary),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(bool isDarkMode) {
    Get.dialog(
      AlertDialog(
        backgroundColor: isDarkMode ? AppColors.darkBackground : Colors.white,
        title: Text(
          'Confirm Logout',
          style: AppTextStyles.h2.copyWith(
            color:
                isDarkMode ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Do you want to logout?',
          style: AppTextStyles.bodyLarge.copyWith(
            color: isDarkMode
                ? AppColors.darkTextPrimary.withOpacity(0.9)
                : AppColors.textPrimary,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'No',
              style: AppTextStyles.bodyLarge.copyWith(
                color: isDarkMode ? AppColors.darkPrimary : AppColors.primary,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isDarkMode ? AppColors.darkPrimary : AppColors.primary,
              foregroundColor: isDarkMode ? Colors.black : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Get.back();
              _userViewModel.logout();
              Get.offAllNamed(AppRoutes.pinEntry);
            },
            child: Text('Yes',
                style: AppTextStyles.bodyLarge.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
