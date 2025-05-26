import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goods_trace/app/core/theme/theme.dart';
import 'package:goods_trace/app/views/home/main_view.dart';

class ProductsBottomNavigation extends StatelessWidget {
  final bool isDarkMode;

  const ProductsBottomNavigation({
    Key? key,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          Expanded(
            child: InkWell(
              onTap: () {},
              child: Container(
                height: 60,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home,
                        color: isDarkMode
                            ? AppColors.darkPrimary
                            : AppColors.primary),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),

          Container(
            height: 50,
            width: 1.5,
            color: isDarkMode ? Colors.grey[700] : Colors.grey,
          ),

          Expanded(
            child: InkWell(
              onTap: () {
                Get.offAll(() => MainView(initialTab: 1));
              },
              child: Container(
                height: 60,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.settings,
                        color: isDarkMode
                            ? AppColors.darkTextPrimary.withOpacity(0.6)
                            : AppColors.textPrimary.withOpacity(0.6)),
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
