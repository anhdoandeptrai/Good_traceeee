import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goods_trace/app/core/theme/theme.dart';
import 'package:goods_trace/app/viewmodels/user_viewmodel.dart';
import 'package:goods_trace/app/viewmodels/theme_viewmodel.dart';
import 'package:goods_trace/app/views/products/add_edit_product_view.dart';
import 'package:goods_trace/app/views/products/products_view.dart';
import 'package:goods_trace/app/views/settings/settings_view.dart';

class MainView extends StatefulWidget {
  final int initialTab;

  const MainView({Key? key, this.initialTab = 0}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late int _selectedIndex;
  final UserViewModel _userViewModel = Get.find<UserViewModel>();
  final ThemeViewModel _themeViewModel = Get.find<ThemeViewModel>();

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTab;
  }

  final List<Widget> _pages = [
    ProductsView(hideNavBar: true),
    SettingsView(hideNavBar: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDarkMode = _themeViewModel.isDarkMode.value;

      return Scaffold(
        backgroundColor:
            isDarkMode ? AppColors.darkBackground : AppColors.background,
        body: _pages[_selectedIndex],
        floatingActionButton: _selectedIndex == 0 &&
                _userViewModel.isAdmin.value
            ? FloatingActionButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: Get.context!,
                    isScrollControlled: true,
                    backgroundColor:
                        isDarkMode ? AppColors.darkBackground : Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (context) {
                      return AddEditProductBottomSheet();
                    },
                  );
                },
                mini: true,
                backgroundColor:
                    isDarkMode ? AppColors.darkPrimary : AppColors.buttonText,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  Icons.add,
                  color: isDarkMode ? Colors.white : AppColors.primary,
                  size: 22,
                ),
              )
            : null,
        bottomNavigationBar: _buildBottomNavigationBar(isDarkMode),
      );
    });
  }

  Widget _buildBottomNavigationBar(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkBackground : AppColors.background,
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Home Tab
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
              },
              child: Container(
                height: 60,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.home,
                      color: _selectedIndex == 0
                          ? (isDarkMode
                              ? AppColors.darkPrimary
                              : AppColors.primary)
                          : (isDarkMode
                              ? AppColors.darkTextPrimary.withOpacity(0.6)
                              : AppColors.textPrimary.withOpacity(0.6)),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),
          ),

          Container(
            height: 50,
            width: 1.5,
            color: isDarkMode ? Colors.grey.shade800 : Colors.grey,
          ),

          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
              },
              child: Container(
                height: 60,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.settings,
                      color: _selectedIndex == 1
                          ? (isDarkMode
                              ? AppColors.darkPrimary
                              : AppColors.primary)
                          : (isDarkMode
                              ? AppColors.darkTextPrimary.withOpacity(0.6)
                              : AppColors.textPrimary.withOpacity(0.6)),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
