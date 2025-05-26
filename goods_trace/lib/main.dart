import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:goods_trace/app/core/theme/theme.dart';
import 'package:goods_trace/app/viewmodels/theme_viewmodel.dart';
import 'app/routes/app_routes.dart';
import 'app/routes/app_pages.dart';
import 'app/bindings/initial_binding.dart';
import 'firebase_options.dart';
import 'app/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(AuthService());

  Get.put(ThemeViewModel(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeViewModel>();

    return Obx(() => GetMaterialApp(
          title: 'Goods Trace',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.isDarkMode.value
              ? ThemeMode.dark
              : ThemeMode.light,
          initialRoute: AppRoutes.pinEntry,
          getPages: AppPages.routes,
          initialBinding: InitialBinding(),
          defaultTransition: Transition.fade,
          debugShowCheckedModeBanner: false,
        ));
  }
}
