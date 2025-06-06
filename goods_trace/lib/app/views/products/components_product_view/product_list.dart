import 'package:flutter/material.dart';
import 'package:goods_trace/app/models/product_model.dart';
import 'package:goods_trace/app/views/products/components_product_view/product_card.dart';

class ProductList extends StatelessWidget {
  final List<ProductModel> products;
  final bool isDarkMode;
  final Function(ProductModel) onProductTap;
  final Function(ProductModel) onEditProduct;
  final Function(ProductModel, bool) onDeleteProduct;

  const ProductList({
    Key? key,
    required this.products,
    required this.isDarkMode,
    required this.onProductTap,
    required this.onEditProduct,
    required this.onDeleteProduct,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          isDarkMode: isDarkMode,
          onTap: onProductTap,
          onEdit: onEditProduct,
          onDelete: onDeleteProduct,
        );
      },
    );
  }
}
