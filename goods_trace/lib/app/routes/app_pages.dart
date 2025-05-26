import 'package:get/get.dart';
import 'package:goods_trace/app/bindings/add_edit_product_binding.dart';
import 'package:goods_trace/app/bindings/product_binding.dart';
import 'package:goods_trace/app/views/auth/pin_entry_view.dart';
import 'package:goods_trace/app/views/products/add_edit_product_view.dart';
import 'package:goods_trace/app/views/products/product_detail_view.dart';
import 'package:goods_trace/app/views/products/products_view.dart';
import 'package:goods_trace/app/views/settings/change_pin_view.dart';

import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.pinEntry,
      page: () => PinEntryView(),
    ),
    GetPage(
      name: AppRoutes.products,
      page: () => ProductsView(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: AppRoutes.addProduct,
      page: () => AddEditProductBottomSheet(),
      binding: AddEditProductBinding(),
    ),
    GetPage(
      name: AppRoutes.productDetail,
      page: () => ProductDetailView(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: AppRoutes.changePin,
      page: () => ChangePinView(),
    ),
  ];
}
